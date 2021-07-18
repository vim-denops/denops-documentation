# Preparing Deno and Denops

First of all, whichever you want to either use or develop Denops plugins, you have to install tools; [Deno][] and [Denops][denops.vim] in addition to your vim.

[denops.vim]: https://github.com/vim-denops/denops.vim
[deno]: https://deno.land/

## Installing Deno

Deno can be installed to follow the instructions in the [Deno document](https://deno.land/#installation).
In addition, you can check if Deno has been installed successfully by [the command](https://deno.land/#getting-started):

```sh
deno run https://deno.land/std/examples/welcome.ts
```

If you have already installed Deno, upgrade it to the latest version.

```sh
deno upgrade
```

## Installing Denops

It is necessary for using Denops to install as a vim plugin [denops.vim][].
For example, when you use [vim-plug][] as a vim plugin manager, add the following command to your `.vimrc` and execute `:PlugInstall` on vim to install Denops.

```vim
Plug 'vim-denops/denops.vim'
```

[vim-plug]: https://github.com/junegunn/vim-plug

If you prefer another vim plugin manager, you can find instructions for it on the [Install](../install.md) page.

Thus Deno and Denops are available in your environment.
