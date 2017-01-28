""
" @section Introduction, intro
" @library
" Implements common functionality used by bazel-related plugins.  For more
" details about Build file structure/terminology, see:
" https://bazel.build/versions/master/docs/build-ref.html


""
" @private
" Returns the root path for Bazel workspace. {path} is the absolute path.
"
" I.e., if you are in directory: /Users/$USER/myproject/foo/bar/biff
" And there is a WORKSPACE file at: /Users/$USER/myproject/WORKSPACE
" Return /home/$USER/myproject. If no workspace can be found, return ''
function! bazel#lib#GetBazelRootPath(path) abort
  let l:path = s:AbsoluteDirectoryPath(a:path)
  if empty(l:path)
    return l:path
  endif
  let l:components = maktaba#path#Split(path)
  let l:working = ''
  let l:workspace_path = ''
  for l:comp in l:components
    let l:working = maktaba#path#Join([l:working, l:comp])
    let l:test_path = maktaba#path#Join([l:working, 'WORKSPACE'])
    if filereadable(l:test_path)
      let l:workspace_path = l:test_path
      break
    endif
  endfor
  return l:workspace_path
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
  if !isdirectory(l:path)
    let l:path = fnamemodify(l:path, ':h')
  endif
  return maktaba#path#Join([l:path, ''])
endfunction
