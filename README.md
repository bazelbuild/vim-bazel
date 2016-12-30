vim-bazel is a plugin for invoking bazel and interacting with bazel artifacts.

It's currently in early development (see [Development status](#development-status)).

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

# Development status

[![Travis Build Status](https://travis-ci.org/bazelbuild/vim-bazel.svg?branch=master)](https://travis-ci.org/bazelbuild/vim-bazel)

Major missing features:

 * Import build errors into vim (#1)
 * Asynchronous build support (#2)

See the full list of open issues at
https://github.com/bazelbuild/vim-bazel/issues.

# FAQ

## `:Bazel` vs. X

### Why not just use `:!bazel`?

The `:Bazel` command is currently a thin wrapper around `:!bazel` that supports
tab completion. Upcoming improvements will offer many more features that vim's
built-in shell support won't be able to offer.

### Why not just use `:make`?

It doesn't add significant benefits for bazel usage in practice.

You can configure vim's built-in `:make` command to invoke "bazel build" with
`:set makeprg=bazel\ build`. The key benefit of vim's `:make` command is that it
can import errors from the build tool as entries in vim's quickfix list, but
limitations in vim's errorformat setting make it tricky or impossible to
actually cleanly parse bazel's output for a given build.

It also doesn't add any benefit related to other bazel functionality like "test"
and "query" commands.

### How does it compare to dispatch.vim?

dispatch.vim's `:Make` command has the same limitations as `:make`, above, just
with some asynchronous execution strategies.

You can use
```vim
:Start -wait=always bazel {command}
```
to shell out to bazel via dispatch.vim, which works just like `:!bazel`
(mentioned above) but with dispatch.vim's asynchronous execution. Doesn't block
vim while executing long builds, but doesn't offer tab completion.

### How does it compare to Neomake?

Neomake doesn't seem to add significant benefits for bazel usage in practice.

Like `:make`, it doesn't support bazel's specific functionality very well and
the quickfix support is tricky or impossible to configure properly.
