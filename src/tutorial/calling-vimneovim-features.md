# Calling Vim/Neovim Features

If you want to use a vim feature from your Denops plugin, you can call it via
the `denops` instance passed to the plugin's `main` function. You can rewrite
`main.ts` like below to register the `echo` API as a vim command:

```ts:main.ts
import { Denops } from "https://deno.land/x/denops_std@v1.0.0/mod.ts";
import { execute } from "https://deno.land/x/denops_std@v1.0.0/helper/mod.ts";
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

The helper function `execute()` receives a multiline string and executes it as a
Vim script, where `denops.name` represents the name of the running plugin
itself. Once vim is restarted, the `HelloWorldEcho` command will be registered.
Then you can run:

```vim
:HelloWorldEcho Hello Vim!
```

If the plugin has been registered successfully, you will see `Hello Vim!` as a
result.

![](../img/calling-vimneovim-features-1.png)

If you want to learn more details on `denops` API, you can refer to
[denops-std API document](https://doc.deno.land/https/deno.land/x/denops_std/mod.ts#Denops).
