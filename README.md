# Denops Documentation

[![Test](https://github.com/vim-denops/denops-documentation/actions/workflows/test.yml/badge.svg)](https://github.com/vim-denops/denops-documentation/actions/workflows/test.yml)
[![Documentation](https://img.shields.io/badge/denops-Documentation-yellow.svg)](https://vim-denops.github.io/denops-documentation/)

This is an official documentation of [denops.vim][denops.vim], an ecosystem of
Vim/Neovim which allows developers to write plugins in [Deno][Deno].

[denops.vim]: https://github.com/vim-denops/denops.vim
[deno]: https://deno.land

Visit https://vim-denops.github.io/denops-documentation to see the content.

## Contribution

Any contributions are welcome 👍

To contribute, install the latest versions of the followings in your environment

- [Rust](https://www.rust-lang.org/tools/install)
- [Deno](https://deno.land/)

Then, install [mdBook](https://github.com/rust-lang/mdBook) and its plugins in
`.tools` directory by

```
make tools
```

Once required tools are installed, execute the following command to generate
static files in [`./docs`](./docs) from markdown files in [`./src`](./src).

```
make gen
```

Note that all markdown files are formatted with
[Deno's code formatter](https://deno.land/manual/tools/formatter) and checked by
CI thus make sure to format codes by the following command

```
make fmt
```

## See also

- Semi-official documentation written in Japanese (日本語)<br>
  [Deno で Vim/Neovim のプラグインを書く
  (denops.vim)](https://zenn.dev/lambdalisue/articles/b4a31fba0b1ce95104c9)

## License

The code follows MIT license written in [LICENSE](./LICENSE). Contributors need
to agree that any modifications sent in this repository follow the license.
