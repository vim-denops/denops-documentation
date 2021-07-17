# Preparation

In general, all Vim plugins must exist in `runtimepath` of Vim,
and since the Denops plugin is a Vim plugin,
it must exist in the `runtimepath` as well.
For this reason, you need to add the following line to your `.vimrc` file:

```vim
set runtimepath^=~/dps-helloworld
```

Next, run Denops in debug mode to enable type checking at Deno startup.
To do this, add the following line to your `.vimrc` file:

```vim
let g:denops#debug = 1
```

<div class="warning">

  Warning: Please deactivate debug mode after development has finished,
  as it can cause performance problems.

</div>
