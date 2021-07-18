## Requirements

Denops require the followings

- [Vim][Vim] >= 8.1.2424 or [Neovim][Neovim] >= 0.4.4
- [Deno][Deno] >= 1.11.0

Make sure `deno` command is executable from your Vim/Neovim by:

```
:echo exepath('deno')
```

It would show an executable path of `deno` command. If nothing is shown, make
sure the `$PATH` is correct in your Vim/Neovim.

Use `g:denops#deno` if you'd like to specify deno executable manually like:

```vim
let g:denops#deno = '/opt/deno/bin/deno'
```

[vim]: https://www.vim.org/
[neovim]: https://neovim.io/
[deno]: https://deno.land/

## Install

Denops must be installed in a `runtimepath`, like a general Vim plugin. Install
it with your favorite Vim plugin managers like:

### By [vim-plug][vim-plug]

Add `vim-denops/denops.vim` like:

```
Plug 'vim-denops/denops.vim'
```

Then execute `:PlugInstall` to install.

[vim-plug]: https://github.com/junegunn/vim-plug

### By [minpac][minpac]

Add `vim-denops/denops.vim` like:

```
call minpac#add('vim-denops/denops.vim')
```

Then execute `:call minpac#update()` to install.

[minpac]: https://github.com/k-takata/minpac

### By [dein.vim][dein.vim]

Add `vim-denops/denops.vim` like:

```
call dein#add('vim-denops/denops.vim')
```

Then execute `:call dein#install()` to install.

[dein.vim]: https://github.com/Shougo/dein.vim

## Check health

Denops support `:checkheath` (Neovim) or `:CheckHealth` (Vim with
[vim-healthcheck][vim-healthcheck]) to check denops health like:

```
health#denops#check
========================================================================
  - INFO: Supported Deno version: `1.11.0`
  - INFO: Detected Deno version: `1.11.5`
  - OK: Deno version check: passed
  - INFO: Supported Neovim version: `0.4.4`
  - INFO: Detected Neovim version: `0.5.0`
  - OK: Neovim version check: passed
  - INFO: Denops status: `running`
  - OK: Denops status check: passed
```

Execute those commands to investigate why denops does not work.

[vim-healthcheck]: https://github.com/rhysd/vim-healthcheck
