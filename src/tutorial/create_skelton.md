# Create Skeleton

The Deno plugin calls the `main` function exported in `main.ts`.
The value `denops`, passed as an argument to the `main` function,
is an instance of the `Denops` class exported by [denops-std](https://deno.land/x/denops_std).
Let's rewrite the `main.ts` as follows:


```typescript
import { Denops } from "https://deno.land/x/denops_std@v1.0.0-beta.2/mod.ts";

export async function main(denops: Denops): Promise<void> {
  // Write the procedure of the plugin here
  console.log("Hello Denops!");
};
```

Once you have finished writing, restart Vim, and you will see `[denops] Hello Denops!`.

![](https://storage.googleapis.com/zenn-user-upload/y8fyu6tap3tapjbxtltni6jynq8y)

<div class="warning">

  Hint: If you prefer not to restart Vim, you can restart Denops with `:call denops#server#restart()`.

</div>
