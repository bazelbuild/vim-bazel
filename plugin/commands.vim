let [s:plugin, s:enter] = maktaba#plugin#Enter(expand('<sfile>:p'))
if !s:enter
  finish
endif


""
" @usage [command] [target_or_flag...]
" Supports tab completion.
command -nargs=* -complete=customlist,bazel#CompletionList Bazel
    \ call bazel#Run([<f-args>])
