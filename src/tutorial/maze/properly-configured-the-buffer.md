# Properly Configure the Buffer

In the previous section, we didn't configure the buffer options, so the buffer
remains modifiable and persists after being closed. In this section, we will
configure the buffer options to make the buffer non-modifiable and remove the
buffer after closure. Open the `main.ts` file and modify the `maze` method as
follows:

```typescript,title=denops/denops-maze/main.ts
import type { Entrypoint } from "@denops/std";
import * as buffer from "@denops/std/buffer";
import * as fn from "@denops/std/function";
import * as op from "@denops/std/option";
import { Maze } from "maze_generator";

export const main: Entrypoint = (denops) => {
  denops.dispatcher = {
    async maze() {
      const { bufnr, winnr } = await buffer.open(denops, "maze://");

      const winWidth = await fn.winwidth(denops, winnr);
      const winHeight = await fn.winheight(denops, winnr);
      const maze = new Maze({
        xSize: winWidth / 3,
        ySize: winHeight / 3,
      }).generate();
      const content = maze.getString();

      await buffer.replace(denops, bufnr, content.split(/\r?\n/g));
      await buffer.concrete(denops, bufnr);

      await op.bufhidden.setLocal(denops, "wipe");
      await op.modifiable.setLocal(denops, false);
    },
  };
};
```

In this code, we use `op.bufhidden.setLocal` to set the `bufhidden` option to
`wipe` so that the buffer is wiped out when it is closed. Additionally, we use
`op.modifiable.setLocal` to set the `modifiable` option to `false` to make the
buffer non-modifiable. Note that since we use `buffer.replace` to replace the
content of the buffer, there is no need to explicitly set the `modifiable`
option to `true` before replacing the content.

Restart Vim, rerun the `:Maze` command, and confirm that the buffer is not
modifiable.
