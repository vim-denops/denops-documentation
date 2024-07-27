# Installation

## Prerequisites

Denops requires [Deno] to be installed on your system. Please refer to
[Deno's official manual](https://docs.deno.com/runtime/manual#install-deno) for
installation instructions.

After installing Deno, ensure that the `deno` command is accessible from your
Vim.

```vim
:echo execpath("deno")
```

It should display the path to the `deno` command. If it prints an empty string,
add the path to the `deno` command to your `PATH` environment variable.

> [!TIP]
>
> If you prefer not to modify the `PATH` environment variable, you can set the
> executable path to the `g:denops#deno` variable in your `vimrc` file like
> this:
>
> ```vim
> let g:denops#deno = "/path/to/deno"
> ```

[Deno]: https://deno.land/

## Installation

Denops itself is a Vim plugin and can be installed using a Vim plugin manager,
similar to other Vim plugins.

##### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'vim-denops/denops.vim'
```

##### [Jetpack.vim](https://github.com/tani/vim-jetpack)

```vim
Jetpack 'vim-denops/denops.vim'
```

##### [dein.vim](https://github.com/Shougo/dein.vim)

```vim
call dein#add('vim-denops/denops.vim')
```

##### [minpac](https://github.com/k-takata/minpac)

```vim
call minpac#add('vim-denops/denops.vim')
```

##### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
require("lazy").setup({
  "vim-denops/denops.vim",
  -- ...
})
```

## Health Check

Denops provides a health checker to confirm that Denops is installed correctly.
You can check the health of Denops by running the `:checkhealth` command
(Neovim) or `:CheckHealth` (Vim with [vim-healthcheck]).

```
==============================================================================
denops: health#denops#check

- Supported Deno version: `1.45.0`
- Detected Deno version: `1.45.4`
- OK Deno version check: passed
- Supported Neovim version: `0.10.0`
- Detected Neovim version: `0.10.0`
- OK Neovim version check: passed
- Denops status: `running`
- OK Denops status check: passed
```

[vim-healthcheck]: https://github.com/rhysd/vim-healthcheck
