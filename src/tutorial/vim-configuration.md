# Vim Configuration

Vim plugins have to be located under a path in `runtimepath` on your vim configuration.
Denops plugins also have to be placed in `runtimepath` because they are also vim plugins.
To add the plugin path to your `.vimrc`, you write:

```vim
set runtimepath^=~/dps-helloworld
```

The other setting to add to your `.vimrc` is to make Denops launch in debug mode to enable type checkings at startup of Deno:

```vim
let g:denops#debug = 1
```

Note that running Denops in debug mode has a performance problem.
Once your development goes well, it would be better for you to disable the debug mode.
