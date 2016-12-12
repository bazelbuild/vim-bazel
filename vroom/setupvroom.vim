" Copyright 2015 Google Inc. All rights reserved.
"
" Licensed under the Apache License, Version 2.0 (the "License");
" you may not use this file except in compliance with the License.
" You may obtain a copy of the License at
"
"     http://www.apache.org/licenses/LICENSE-2.0
"
" Unless required by applicable law or agreed to in writing, software
" distributed under the License is distributed on an "AS IS" BASIS,
" WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
" See the License for the specific language governing permissions and
" limitations under the License.

" This file is used from vroom scripts to bootstrap the bazel plugin and
" configure it to work properly under vroom.

" Codereview does not support compatible mode.
set nocompatible

" Install maktaba from local dir.
let s:repo = expand('<sfile>:p:h:h')
let s:search_dir = fnamemodify(s:repo, ':h')
" We'd like to use maktaba#path#Join, but maktaba doesn't exist yet.
let s:slash = exists('+shellslash') && !&shellslash ? '\' : '/'
for s:plugin_dirname in ['maktaba', 'vim-maktaba']
  let s:bootstrap_path = join([s:search_dir, s:plugin_dirname, 'bootstrap.vim'],
      \ s:slash)
  if filereadable(s:bootstrap_path)
    execute 'source' s:bootstrap_path
    break
  endif
endfor

" Install the bazel plugin.
call maktaba#plugin#GetOrInstall(s:repo)

" Install Glaive from local dir.
for s:plugin_dirname in ['glaive', 'vim-glaive']
  let s:bootstrap_path =
      \ maktaba#path#Join([s:search_dir, s:plugin_dirname, 'bootstrap.vim'])
  if filereadable(s:bootstrap_path)
    execute 'source' s:bootstrap_path
    break
  endif
endfor

" Force plugin/ files to load since vroom installs the plugin after
" |load-plugins| time.
call maktaba#plugin#Get('bazel').Load()

" Support vroom's fake shell executable and don't try to override it to sh.
call maktaba#syscall#SetUsableShellRegex('\v<shell\.vroomfaker$')
