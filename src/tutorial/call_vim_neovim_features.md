# Call Vim/Neovim Features

To invoke Vim/Neovim functions from the Denops plugin,
you can use the denops instance passed as an argument to the `main` function.
Let's register the echo API as a Vim command. Change the `main.ts` file as follows:

```typescript
import { Denops } from "https://deno.land/x/denops_std@v1.0.0-beta.2/mod.ts";
import { execute } from "https://deno.land/x/denops_std@v1.0.0-beta.2/helper/mod.ts";
import { ensureString } from "https://deno.land/x/unknownutil@v0.1.1/mod.ts";

export async function main(denops: Denops): Promise<void> {
  denops.dispatcher = {
    async echo(text: unknown): Promise<unknown> {
      ensureString(text);
      return await Promise.resolve(text);
    },
  };

  await execute(
    denops,
    `command! -nargs=1 HelloWorldEcho echomsg denops#request('${denops.name}', 'echo', [<q-args>])`,
  );
};
```

The `execute()` function executes a multi-line string passed to it as a Vim script.
`denops.name` is the name of the plugin being executed.
Now that the `HelloWorldEcho` command is registered, restart Vim and run the following command.

```vim
:HelloWorldEcho Hello Vim!
```

If you get a `Hello Vim!` message like the following, it works.

![](https://storage.googleapis.com/zenn-user-upload/zcf4whdc44sa9k5a9s9gwk7gykyy)

See <https://doc.deno.land/https/deno.land/x/denops_std/mod.ts#Denops> for more information about the API of `denops`.
