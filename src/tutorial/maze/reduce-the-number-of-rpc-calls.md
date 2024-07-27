# Reducing the Number of RPC Calls

As Denops employs RPC to interact with Vim, the volume of RPC calls
significantly influences the plugin's performance. In this section, we aim to
enhance performance by reducing the number of RPC calls using the `batch` module
from `@denops/std`. Let's revise the `main.ts` file as follows:

```typescript:denops/denops-maze/main.ts
import type { Entrypoint } from "jsr:@denops/std@7.0.0";
import { batch, collect } from "jsr:@denops/std@7.0.0/batch";
import * as buffer from "jsr:@denops/std@7.0.0/buffer";
import * as fn from "jsr:@denops/std@7.0.0/function";
import * as op from "jsr:@denops/std@7.0.0/option";
import { Maze } from "npm:@thewizardbear/maze_generator@0.4.0";

export const main: Entrypoint = (denops) => {
  denops.dispatcher = {
    async maze() {
      const { bufnr, winnr } = await buffer.open(denops, "maze://");

      const [winWidth, winHeight] = await collect(denops, (denops) => [
        fn.winwidth(denops, winnr),
        fn.winheight(denops, winnr),
      ]);
      const maze = new Maze({
        xSize: winWidth / 3,
        ySize: winHeight / 3,
      }).generate();
      const content = maze.getString();

      await batch(denops, async (denops) => {
        await buffer.replace(denops, bufnr, content.split(/\r?\n/g));
        await buffer.concrete(denops, bufnr);
        await op.bufhidden.setLocal(denops, "wipe");
        await op.modifiable.setLocal(denops, false);
      });
    },
  };
};
```

In this code, we use the `collect` function to gather window size values and the
`batch` function to execute multiple commands in a single RPC. This optimization
significantly reduces the number of RPC calls, thereby improving the plugin's
performance.

The `collect` function is designed for collecting multiple values in a single
RPC, offering the following features:

- Execution of `denops.call` or `denops.eval` within the `collect` is delayed
  and executed in a single RPC with the results.
- The result of `denops.call` or `denops.eval` in the `collect` is always falsy,
  indicating that branching (if, switch, etc.) is not allowed.
- Execution of `denops.redraw` or `denops.cmd` in the `collect` is not allowed.
- Execution of `batch` or `collect` in the `collect` is not allowed, indicating
  that nesting is not allowed.

In short, only the following operations are allowed in the `collect`:

- `denops.call` or `denops.eval` that returns a value.
- Functions in the `function` module that return a value.
- Functions in the `option` module that return a value.
- Functions in the `variable` module that return a value.

The `batch` function is designed for executing multiple commands in a single
RPC, offering the following features:

- Execution of `denops.call`, `denops.cmd`, or `denops.eval` in the `batch` is
  delayed and executed in a single RPC without the results.
- The result of `denops.call` or `denops.eval` in the `batch` is always falsy,
  indicating that branching (if, switch, etc.) is not allowed.
- Execution of `denops.redraw` is accumulated and only executed once at the end
  of the `batch`.
- Execution of `batch` in the `batch` is allowed, indicating that nesting is
  allowed.
- Execution of `collect` in the `batch` is not allowed, indicating that nesting
  is not allowed.

In short, only the following operations are allowed in the `batch`:

- `denops.call`, `denops.cmd`, or `denops.eval` (without the results).
- Functions in the `function` module (without the results).
- Functions in the `option` module (without the results).
- Functions in the `variable` module (without the results).
- Functions in other modules that do not call `collect` internally.

In the previous code, the number of RPC calls was more than 7, but after using
`batch` and `collect`, the number of RPC calls is reduced to 3. Although this is
a small plugin, the performance improvement may not be noticeable. However, in a
larger plugin, the performance improvement will be significant.

Restart Vim, rerun the `:Maze` command, and confirm that the plugin works
properly with `batch` and `collect`.

## Next Steps

In the next step, read API references or real-world plugins

- [API reference](https://jsr.io/@denops/std)
- [lambdalisue/gin.vim](https://github.com/lambdalisue/gin.vim)
- [vim-skk/skkeleton](https://github.com/vim-skk/skkeleton)
- [Shougo/ddu.vim](https://github.com/Shougo/ddu.vim)
- [Find one from the `vim-denops` topic](https://github.com/topics/vim-denops)
