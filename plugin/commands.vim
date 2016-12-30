""
" @section Introduction, intro
" This plugin allows you to execute bazel from vim.

let [s:plugin, s:enter] = maktaba#plugin#Enter(expand('<sfile>:p'))
if !s:enter
  finish
endif


""
" @usage [command] [target_or_flag...]
" Invokes bazel in the foreground, leaving output visible with a "Press ENTER"
" prompt until explicitly dismissed.
"
" If 'autowrite' or 'autowriteall' is enabled, all buffers are written before
" bazel is invoked.
"
" Supports tab completion.
command -nargs=* -complete=customlist,bazel#CompletionList Bazel
    \ call bazel#Run([<f-args>])
