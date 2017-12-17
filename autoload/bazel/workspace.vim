""
" @section Introduction, intro
" @library
" Implements common path functionality used by bazel-related plugins.  For
" more details about Build file structure/terminology, see:
" https://bazel.build/versions/master/docs/build-ref.html

""
" @private
" Returns the root path for a Bazel workspace file (given the current working
" directory). {path} is the absolute path.
function! bazel#workspace#GetBazelRootForCwd() abort
  return bazel#workspace#GetBazelRootPath(getcwd())
endfunction


""
" @private
" Returns the root path for Bazel workspace. {path} is the absolute path.
"
" I.e., if you are in directory: /Users/$USER/myproject/foo/bar/biff
" And there is a WORKSPACE file at: /Users/$USER/myproject/WORKSPACE
" Return /home/$USER/myproject. If no workspace can be found, return ''
function! bazel#workspace#GetBazelRootPath(path) abort
  let l:path = s:AbsoluteDirectoryPath(a:path)
  if empty(l:path)
    return l:path
  endif
  let l:file = findfile('WORKSPACE', '.;')
  if !empty(l:file)
    return fnamemodify(l:file, ':p')
  endif
  return ''
endfunction


" Returns the absolute directory for a path.
function! s:AbsoluteDirectoryPath(path) abort
  if empty(a:path)
    " Never expand '' to CWD
    return ''
  endif
  let l:path = fnamemodify(a:path, ':p')
  if !maktaba#path#IsAbsolute(l:path)
    " If the path is not absolute at this point, we should not intend to
    " interpolate it.
    return ''
  endif
  return maktaba#path#AsDir(l:path)
endfunction
