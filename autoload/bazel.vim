let s:PLUGIN = maktaba#plugin#Get('bazel')

if !exists('s:bash_completion_path')
  let s:bash_completion_path = '/etc/bash_completion.d/bazel'
endif

""
" Write all changed buffers if 'autowrite' or 'autowriteall' is enabled.
" This is used before issuing bazel shell commands to avoid building stale
" versions of the code. The 'autowrite' and 'autowriteall' options control the
" behavior of |:make|, so it's natural for |:Bazel| to respect them as well.
function! s:Autowrite() abort
  if &autowrite || &autowriteall
    wall
  endif
endfunction

""
" Executes a bazel command with {arguments}.
function! bazel#Run(arguments) abort
  call s:PLUGIN.logger.Info(
      \ 'Invoking bazel with arguments "%s"', string(a:arguments))
  call s:Autowrite()
  if a:arguments[0] == "build"
    set errorformat=ERROR:\ %f:%l:%c:%m
    set errorformat+=%f:%l:%c:%m

    " Ignore build output lines starting with INFO:, Loading:, or [
    set errorformat+=%-GINFO:\ %.%#
    set errorformat+=%-GLoading:\ %.%#
    set errorformat+=%-G[%.%#

    execute "set makeprg=bazel\\ build\\" substitute(join(a:arguments[1:100]), ' ', '\\ ', 'g')
    make
  else
    let l:syscall = maktaba#syscall#Create(['bazel'] + a:arguments)
    call l:syscall.CallForeground(1, 0)
  endif
  " Note: Intentionally doesn't check v:shell_error.
  " Errors are printed on console by bazel, and visible until explicitly
  " dismissed because we use CallForeground in pause mode.
endfunction

""
" Completions for the :Bazel command. Completions are extracted from the bash
" bazel completion function.
function! bazel#CompletionList(unused_arg, line, pos) abort
  " The bash complete script does not truly support autocompleting within a
  " word, return nothing here rather than returning bad suggestions.
  if a:pos + 1 < strlen(a:line)
    return []
  endif

  let l:cmd = substitute(a:line[0:a:pos], '\v\w+', 'bazel', '')

  let l:comp_words = split(l:cmd, '\v\s+')
  if l:cmd =~# '\v\s$'
    call add(l:comp_words, '')
  endif
  let l:comp_line = join(l:comp_words)

  " Note: Bashisms below are intentional. We invoke this via bash explicitly,
  " and it should work correctly even if &shell is actually not bash-compatible.

  " Extracts the bash completion command, should be something like:
  " _bazel__complete
  let l:complete_wrapper_command = ' $(complete -p ' . l:comp_words[0] .
      \ ' | sed "s/.*-F \\([^ ]*\\) .*/\\1/")'

  " Build a list of all the arguments that have to be passed in to autocomplete.
  let l:comp_arguments = {
      \ 'COMP_LINE' : '"' .l:comp_line . '"',
      \ 'COMP_WORDS' : '(' . l:comp_line . ')',
      \ 'COMP_CWORD' : string(len(l:comp_words) - 1),
      \ 'COMP_POINT' : string(strlen(l:comp_line)),
      \ }
  let l:comp_arguments_string =
      \ join(map(items(l:comp_arguments), 'v:val[0] . "=" . v:val[1]'))

  " Build the command to run with bash
  let l:shell_script = shellescape(printf(
      \ 'source %s; export %s; %s && echo ${COMPREPLY[*]}',
      \ s:bash_completion_path,
      \ l:comp_arguments_string,
      \ l:complete_wrapper_command))

  let l:bash_command = 'bash -norc -i -c ' . l:shell_script
  try
    let l:result = maktaba#syscall#Create(l:bash_command).Call()
  catch /ERROR(ShellError):/
    " On errors, return no suggestions.
    return []
  endtry

  let l:bash_suggestions = split(l:result.stdout)
  " The bash complete not include anything before the colon, add it.
  let l:word_prefix = substitute(l:comp_words[-1], '\v[^:]+$', '', '')
  return map(l:bash_suggestions, 'l:word_prefix . v:val')
endfunction

function! bazel#SetBashCompletionPath(path) abort
  let s:bash_completion_path = maktaba#ensure#IsString(a:path)
endfunction
