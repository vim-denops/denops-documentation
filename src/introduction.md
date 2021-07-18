# Denops

<p align="center">
  <img src="https://user-images.githubusercontent.com/3132889/113470275-51e30a00-948f-11eb-81bb-812986d131d5.png">
</p>

[Denops][Denops] is an ecosystem of Vim/Neovim which allows developers to write
plugins in [Deno][Deno]. It has the following features:

- Same code can be used in both Vim and Neovim
- Can be installed as a Vim plugin
- Deno uses V8 engine which is much faster than Vim script
- User don't need to manage library dependencies
- Denops runs as a separate process, so Vim won't freeze
- Each plugin work on its own thread, so that there is less chance of
  interference

[deno]: https://deno.land
[denops]: https://github.com/vim-denops/denops.vim
