# Utilizing Denops Standard library

In the previous section, we created a plugin that outputs a maze to a buffer.
However, the plugin has the following problems:

- The maze does not fit the window size. The maze may be too large for it
- The buffer is modifiable so that the content may accidentally be modified
- When user execute `:edit` command, the maze is disappeared

Additionally, we used `denops.cmd` or `denops.call` to execute Vim commands and
functions directly. However, it was a bit painful to use those because we must
know the definitions of the commands and functions. No auto-completion, no type
checking, etc.

In this section, we introduce Denops standard library (`denops_std`) to solves
all above problems. The plugin will output the maze to non-file like buffer that
is non-modifiable and the content is remained even if user execute `:edit`
command.

First, modify the `denops/denops-helloworld/main.ts` file as follows:

```typescript:denops/denops-helloworld/main.ts
import type { Denops } from "https://deno.land/x/denops_std@v6.0.0/mod.ts";
import * as buffer from "https://deno.land/x/denops_std@v6.0.0/buffer/mod.ts";
import * as fn from "https://deno.land/x/denops_std@v6.0.0/function/mod.ts";
import * as op from "https://deno.land/x/denops_std@v6.0.0/option/mod.ts";
import { Maze } from "https://deno.land/x/maze_generator@v0.4.0/mod.js";

export function main(denops: Denops): void {
  denops.dispatcher = {
    async maze() {
      // Get the current window size
      const winWidth = await fn.winwidth(denops, 0);
      const winHeight = await fn.winheight(denops, 0);

      // Create a maze that fits the current window size
      const maze = new Maze({
        xSize: winWidth / 3,
        ySize: winHeight / 3,
      }).generate();
      const content = maze.getString();

      // Open a 'maze://' buffer with specified opener
      const { bufnr } = await buffer.open(denops, "maze://");

      // Replace the buffer content with the maze
      await buffer.replace(denops, bufnr, content.split(/\r?\n/g));

      // Concrete (fix) the buffer content
      await buffer.concrete(denops, bufnr);

      // Set the buffer options
      await op.bufhidden.setLocal(denops, "wipe");
      await op.modifiable.setLocal(denops, false);
    },
  };
}
```

Let's break down this code step by step.

### Get the current window size

```typescript
// Get the current window size
const winWidth = await fn.winwidth(denops, 0);
const winHeight = await fn.winheight(denops, 0);
```

This code call Vim's `winwidth` and `winheight` functions to get the current
window size. While `function` module (alised to `fn`) of `denops_std` provides a
set of functions that are available on both Vim and Neovim, LSP can provide
auto-completion and type checking for the functions.

> [!NOTE]
>
> The `function` module of the `denops_std` library provides a set of functions
> that are available on both Vim and Neovim. If you'd like to use Vim or Neovim
> only functions, use the `vim` or `nvim` module under the `function` module
> instead.
>
> See the
> [function module of denops_std API document](https://doc.deno.land/https/deno.land/x/denops_std/function/mod.ts)
> for more details.

### Open a 'maze://' buffer with specified opener

```typescript
const { bufnr } = await buffer.open(denops, "maze://");
```
