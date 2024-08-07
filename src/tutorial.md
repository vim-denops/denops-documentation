# Tutorial

This article is a tutorial on developing Denops plugins.

## Environment

In this tutorial, we use the following software and version as of writing.

- [denops.vim v7.0.0](https://github.com/vim-denops/denops.vim/releases/tag/v7.0.0)
  (2024-07-27)
- [denops_std v7.0.0](https://github.com/vim-denops/deno-denops-std/releases/tag/v7.0.0)
  (2024-07-27)

[vim-jp]: https://vim-jp.org/
[denops.vim]: https://github.com/vim-denops/denops.vim
[deno]: https://deno.land/

## Glossary

| Term          | Meaning                                                                    |
| ------------- | -------------------------------------------------------------------------- |
| Vim           | Vim or Neovim.                                                             |
| Vim plugin    | Vim plugin or Neovim plugin.                                               |
| [Deno]        | A JavaScript and TypeScript runtime.                                       |
| Denops        | An ecosystem for vim plugins based on Deno runtime.                        |
| Denops plugin | A vim plugin that works on both Vim and Neovim and is written with Denops. |
| [denops.vim]  | The name of the vim plugin to introduce Denops into vim.                   |
