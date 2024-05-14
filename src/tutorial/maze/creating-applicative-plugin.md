# How to create an applicative plugin

In the previous section, we created a plugin that outputs a maze to a buffer.
However, who wants to see a maze in a buffer that is too small or too large for
it? It would be better to see a maze that fits the current window size.

In this section, we will modify the plugin to make the generated maze fit the
current window size. So, let's create a production ready enterprise edition of
the maze plugin that will satisfy your crazy addictive maze solver friend.

First, modify `plugin/denops-maze.vim` to accept the `Maze` command with an
optional argument.

```vim:plugin/denops-maze.vim
if exists('g:loaded_denops_maze')
  finish
endif
let g:loaded_denops_maze = 1

" Function called once the plugin is loaded
function! s:init() abort
  command! -nargs=? Maze call denops#request('denops-maze', 'maze', [<q-args>])
endfunction

augroup denops_maze
  autocmd!
  autocmd User DenopsPluginPost:denops-maze call s:init()
augroup END
```

Then, modify the `main.ts` file to accept the optional argument for a custom
opener, generate a maze that fits the current window size, configure the buffer
options to make it non-file readonly buffer, etc.

```ts:denops/denops-maze/main.ts
import type { Entrypoint } from "https://deno.land/x/denops_std@v6.5.0/mod.ts";
import { batch, collect } from "https://deno.land/x/denops_std@v6.5.0/batch/mod.ts";
import * as fn from "https://deno.land/x/denops_std@v6.5.0/function/mod.ts";
import * as op from "https://deno.land/x/denops_std@v6.5.0/option/mod.ts";
import { Maze } from "https://deno.land/x/maze_generator@v0.4.0/mod.js";
import { assert, is } from "https://deno.land/x/unknownutil@v3.18.1/mod.ts";

export const main: Entrypoint = (denops) => {
  denops.dispatcher = {
    async maze(opener) {
      assert(opener, is.String);
      const [xSize, ySize] = await collect(denops, (denops) => [
        op.columns.get(denops),
        op.lines.get(denops),
      ]);
      const maze = new Maze({
        xSize: xSize / 3,
        ySize: ySize / 3,
      }).generate();
      const content = maze.getString();
      await batch(denops, (denops) => {
        await denops.cmd(opener || "new");
        await op.modifiable.setLocal(denops, true);
        await fn.setline(denops, 1, content.split(/\r?\n/g));
        await op.bufhidden.setLocal(denops, "wipe");
        await op.buftype.setLocal(denops, "nofile");
        await op.swapfile.setLocal(denops, false);
        await op.modifiable.setLocal(denops, false);
        await op.modified.setLocal(denops, false);
      });
    },
  };
};
```

In above code, we utilize the following denops_std modules:

- `batch` and `collect` functions in a `batch` module to execute multiple
  commands in a single RPC
- `function` module to call Vim's functions
- `option` module to get and set Vim's options

See the
[denops_std API document](https://doc.deno.land/https/deno.land/x/denops_std/mod.ts)
for more details about each modules.

That's it. Now you can see a smaller maze shown on the window with `:Maze`
command.

![](../img/developing-more-applicative-plugin-3.png)
