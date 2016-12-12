vim-bazel is a plugin for invoking bazel and interacting with bazel artifacts.

For details, see the executable documentation in the `vroom/` directory or the
helpfiles in the `doc/` directory. The helpfiles are also available via
`:help bazel` if bazel is installed (and helptags have been generated).

DISCLAIMER: This is not an official Google product.

# Commands

Use `:Bazel {command} [argument...]` to invoke bazel.

# Usage example

```vim
:Bazel build //some/package:sometarget
```
```text
INFO: Found 1 target...
Target //pkg/api:go_default_library up-to-date:
  bazel-bin/pkg/api/go_default_library.a
INFO: Elapsed time: 19.443s, Critical Path: 13.79s

Press ENTER or type command to continue
```

# Installation

This example uses [vim-plug](https://github.com/junegunn/vim-plug), whose
plugin-adding command is `Plug`.

.vimrc:
```vim
" Add maktaba and bazel to the runtimepath.
" (The latter must be installed before it can be used.)
Plug 'google/vim-maktaba'
Plug 'bazelbuild/vim-bazel'
```

Start vim and run
```vim
:PlugInstall
```
