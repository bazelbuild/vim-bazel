" Common path functionality used by bazel-related plugins.  For more details
" about Build file structure/terminology, see:
" https://bazel.build/versions/master/docs/build-ref.html

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
    throw maktaba#error#BadValue('Empty path')
  endif
  " Search upward for WORKSPACE.
  let l:file = findfile('WORKSPACE', l:path . ';')
  if !empty(l:file)
    " Get the absolute path and strip 'WORKSPACE'
    return fnamemodify(l:file, ':p:h')
  else
    throw maktaba#error#NotFound('No workspace found')
  endif
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
