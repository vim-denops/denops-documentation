# Introduction

<div style="text-align: center;">
<img src="https://user-images.githubusercontent.com/3132889/113470275-51e30a00-948f-11eb-81bb-812986d131d5.png" width="300" alt="Denops Mascot">
</div>

**[Denops]**
([/ˈdiːnoʊps/](http://ipa-reader.xyz/?text=%CB%88di%CB%90no%CA%8Aps), pronounced
as `dee-nops`) is an ecosystem designed for developing plugins for [Vim] and
[Neovim] using [Deno] (a [TypeScript] / [JavaScript] runtime).

Denops and Denops plugins (Vim plugins powered by Denops) offer the following
features:

- **Installable as a Vim plugin**:<br>Denops follows the standard Vim plugin
  architecture. Users can install Denops itself and Denops plugins using a Vim
  plugin manager, just like any other Vim plugins.
- **Unified codebase for Vim and Neovim**:<br>Denops provides a unified API for
  both Vim and Neovim. You can write a plugin that functions on both Vim and
  Neovim with a single codebase.
- **Modern dependency management**:<br>Deno's built-in dependency system with
  import maps provides clean, maintainable dependency management. The workspace
  configuration ensures each plugin's dependencies are isolated, preventing
  conflicts when multiple Denops plugins are installed together.
- **Simple and efficient code**:<br>Deno utilizes the V8 engine, significantly
  faster than Vim script. You can write a plugin with straightforward code,
  without the need for complex optimizations solely for performance.
- **Risk-free execution**:<br>Denops plugins run in a separate process from Vim
  / Neovim. Even if a plugin freezes, Vim / Neovim remains unaffected.

Check out [vim-denops](https://github.com/topics/vim-denops) GitHub Topics to
discover Vim plugins using Denops.

Denops is primarily developed and maintained by the [vim-denops] organization
(separated from the [vim-jp] organization). For questions, you can use
[GitHub Discussions](https://github.com/orgs/vim-denops/discussions) (English),
or visit the [#tech-denops](https://vim-jp.slack.com/archives/C01N4L5362D)
channel on
[Slack workspace for vim-jp](https://join.slack.com/t/vim-jp/shared_invite/zt-zcifn2id-e6EsDjIKEzx~UlF~hE2Njg)
(Japanese).

[Denops]: https://github.com/vim-denops/denops.vim
[Vim]: https://www.vim.org/
[Neovim]: https://neovim.io/
[TypeScript]: https://www.typescriptlang.org/
[JavaScript]: https://developer.mozilla.org/en-US/docs/Web/JavaScript
[Deno]: https://deno.land/
[vim-jp]: https://github.com/vim-jp
[vim-denops]: https://github.com/vim-denops
