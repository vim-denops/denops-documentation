# Add Application Interfaces

In Denops, each plugin registers its API as a function.
Let's register the `echo()` function that returns a given string as an API.
Rewrite the `main.ts` as follows:

```typescript:main.ts
import { Denops } from "https://deno.land/x/denops_std@v1.0.0-beta.2/mod.ts";
import { ensureString } from "https://deno.land/x/unknownutil@v0.1.1/mod.ts";

export async function main(denops: Denops): Promise<void> {
  denops.dispatcher = {
    async echo(text: unknown): Promise<unknown> {
      // Ensure the `text` argument has type `string`
      ensureString(text);
      return await Promise.resolve(text);
    },
  };
};
```

<div class="warning">

  Warning: In `denops.dispatcher`, you can only register functions
  whose arguments are all of unknown type
  and whose return value is `Promise<unknown>` or `Promise<void>` as API.

</div>

This registers the `echo` API to the `helloworld` plugin.
To invoke this API, use the Vim function `denops#request({plugin}, {func}, {args})`.
Restart Vim and run the following command:

```vim
:echo denops#request('helloworld', 'echo', ["Hello Denops!"])
```

If you see `Hello Denops!`, everything is successful!

![](https://storage.googleapis.com/zenn-user-upload/2fyw9gsjs0mhxa132q2dkrz2yle3)

Note that if you give a non-string value, such as `denops#request('helloworld', 'echo', [123])`,
you will find an error as follows:

![](https://storage.googleapis.com/zenn-user-upload/ykf75d9whbfjjntdk93jxcfmilsc)
