# Explanation of the Getting Started

In this section, we'll provide detailed information about the Getting Started.
If you find it too detailed, feel free to skip this section and move on to the
next chapter, especially if your goal is to start developing a Denops plugin
promptly.

## What is Denops?

Denops claims to be an ecosystem for developing Vim / Neovim (hereafter, when we
refer to Vim without restriction, we also include Neovim) plugins using Deno,
but, in reality, it is a Vim plugin with the following features:

- Detection and registration of Denops plugins
- Launching and connecting to Deno processes
- Calling Deno process-side functions from Vim via RPC (Remote Procedure Call)
- Calling Vim features from Deno process-side via RPC

By utilizing this plugin, you can control Vim from code written in TypeScript
(Denops plugins).

> [!NOTE]
>
> [RPC (Remote Procedure Call)](https://en.wikipedia.org/wiki/Remote_procedure_call)
> is used, and while Vim uses a
> [JSON-based custom specification](https://vim-jp.org/vimdoc-en/channel.html#channel-use),
> Neovim uses [MessagePack-RPC](https://github.com/msgpack-rpc/msgpack-rpc) (a
> slightly modified specification). However, Denops abstracts away these
> differences, so Denops plugin developers don't need to be aware of the RPC
> specification differences between Vim and Neovim.

## What is a Vim Plugin?

When Vim starts, it searches for files named `plugin/*.vim` in directories
specified in `runtimepath`. Additionally, if a function like `foo#bar#hoge()` is
called, it searches for files named `autoload/foo/bar.vim` in the `runtimepath`
and reads the file, calling the `foo#bar#hoge()` function defined within.

A Vim plugin is a set of predefined features provided to users, utilizing the
functionality mentioned above. Typically, an entry point is defined in
`plugin/{plugin_name}.vim`, and detailed features are implemented in
`autoload/{plugin_name}.vim` or `autoload/{plugin_name}/*.vim`. For example,
here is the directory structure for a Vim plugin named `hello`:

```
vim-hello
├── autoload
│    └── hello.vim # Defines the function `hello#hello()`
└── plugin
     └── hello.vim # Defines the `Hello` command
```

> [!NOTE]
>
> For more detailed information on creating Vim plugins, refer to
> `:help write-plugin`.

## What is a Denops Plugin?

When Denops is installed, in addition to Vim plugins, files named
`denops/*/main.ts` are also searched when Vim starts. If a corresponding file is
found, Denops registers the parent directory name (`foo` in the case of
`denops/foo/main.ts`) as the plugin name. Then, it imports the corresponding
file as a TypeScript module and calls the function named `main`.

A Denops plugin, similar to a Vim plugin, provides a set of features written in
TypeScript to users. Since Denops plugins typically include both TypeScript and
Vim script code, the directory structure looks like an extension of the Vim
plugin structure with an added `denops` directory. For example, here is the
directory structure for a Denops plugin named `hello`:

```
denops-hello
├── autoload
│    └── hello.vim # Tasks better written in Vim script (may not exist)
├── denops
│    └── hello
│           └── main.ts # Entry point for the Denops plugin (mandatory)
└── plugin
     └── hello.vim # Entry point written in Vim script (optional)
```

In the Getting Started, we created a file named
`denops/denops-getting-started/main.ts` and added its parent directory
(`denops-getting-started`) to `runtimepath`. There were no `autoload` or
`plugin` directories because we didn't provide an entry point that Vim could
easily call.

## Understanding the Code in Getting Started

In the Getting Started, we wrote the following code in the `main.ts` file:

```typescript
import type { Entrypoint } from "jsr:@denops/std@^7.0.0";

export const main: Entrypoint = (denops) => {
  denops.dispatcher = {
    async hello() {
      await denops.cmd(`echo "Hello, Denops!"`);
    },
  };
};
```

Let's break down this code step by step.

### About Imports

```typescript
import type { Entrypoint } from "jsr:@denops/std@^7.0.0";
```

The first line imports the `Entrypoint` type from the [@denops/std] standard
library. You can find detailed information about the library by checking the
URL: `https://jsr.io/@denops/std@7.0.0` (replace `jsr:` to `https://jsr.io/`).
We fixed the version in the import URL, so it's recommended to check for details
and update to the latest version URL.

Note that we use `import type` syntax, which is part of TypeScript's
[Type-Only Imports and Export](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-8.html).
This syntax can be written as `import { type Entrypoint }` with the same
meaning. Using `import { Entrypoint }` for a type-only import is also valid.

> [!NOTE]
>
> Denops plugins are dynamically imported, so there might be differences in
> Denops versions between development and usage. Therefore, to minimize
> differences between Denops versions, only type information is exposed. The
> implementation can be found in
> [`denops/@denops-private/denops.ts`](https://github.com/vim-denops/denops.vim/blob/main/denops/%40denops-private/denops.ts),
> but it is not publicly exposed for the reasons mentioned above.
>
> This type information is provided by [@denops/core], and [@denops/std] simply
> re-exports the type information from [@denops/core]. However, [@denops/core]
> is intended to be referenced only by [denops.vim] and [@denops/std], so Denops
> plugin developers don't need to use it directly.

### About Entry Point

```typescript
export const main: Entrypoint = (denops) => {
  // Omitted...
};
```

The above code exports the `main` function. The `main` function is called by
Denops, and it takes the
[Denops instance](https://jsr.io/@denops/core/doc/~/Denops) (`denops`) as an
argument. Denops plugins use this `denops` to add user-defined APIs or call
Vim's features.

### About User-Defined APIs

```typescript
denops.dispatcher = {
  async hello() {
    // Omitted...
  },
};
```

The code above adds a user-defined API named `hello` to `denops.dispatcher`.
`denops.dispatcher` is defined as follows, and each method takes `unknown` types
for both arguments and return values:

```typescript
interface Dispatcher {
  [key: string]: (...args: unknown[]) => unknown;
}
```

By defining methods in `denops.dispatcher`, you can freely define APIs. Since
the methods registered in `denops.dispatcher` are always called with `await`,
you can make them asynchronous by returning a `Promise`.

The methods defined in `denops.dispatcher` can be called from Vim using the
following functions:

| Function               | Description                                                                      |
| ---------------------- | -------------------------------------------------------------------------------- |
| `denops#request`       | Synchronously calls a user-defined API and returns the result.                   |
| `denops#request_async` | Asynchronously calls a user-defined API and passes the result to callbacks.      |
| `denops#notify`        | Calls a user-defined API without waiting for completion and discards the result. |

At the end of the Getting Started, we used
`denops#request('denops-getting-started', 'hello', [])` to call the user-defined
API named `hello` in `denops-getting-started` plugin.

### About Calling Vim's features

```typescript
await denops.cmd(`echo "Hello, Denops!"`);
```

With the received `denops`, you can call Vim functions, execute Vim commands, or
evaluate Vim expressions. In the example above, the `hello` API internally uses
`denops.cmd` to execute the `echo` command in Vim. The `denops` object provides
several methods:

| Method     | Description                                                                                                |
| ---------- | ---------------------------------------------------------------------------------------------------------- |
| `call`     | Calls a Vim function and returns the result.                                                               |
| `batch`    | Calls multiple Vim functions in bulk and returns the results in bulk.                                      |
| `cmd`      | Executes a Vim command. If `ctx` is provided, it is expanded as local variables.                           |
| `eval`     | Evaluate a Vim expression and returns the result. If `ctx` is provided, it is expanded as local variables. |
| `dispatch` | Calls a user-defined API of another Denops plugin and returns the result.                                  |

Although `denops` provides low-level interfaces, [@denops/std] combines these
low-level interfaces to offer higher-level interfaces. Therefore, it's
recommended to use [@denops/std] to call Vim's features in actual plugin
development.

For example, use
[`function` module](https://jsr.io/@denops/std@7.0.0/doc/function/~) to call
Vim's function instead of `denops.call` like:

```typescript
import * as fn from "jsr:@denops/std@^7.0.0/function";

// Bad (result1 is `unknown`)
const result1 = await denops.call("expand", "%");

// Good (result2 is `string`)
const result2 = await fn.expand(denops, "%");
```

If developers use `function` module instead, they can benefit from features like
auto-completion and type checking provided by LSP (Language Server Protocol).

## Next Steps

In the next step, follow the tutorial to learn how to develop a minimum Denops
plugin.

- [Tutorial (Hello World)](../tutorial/helloworld/README.md)
- [Tutorial (Maze)](../tutorial/maze/README.md)
- [API reference](https://jsr.io/@denops/std)

[denops.vim]: https://github.com/vim-denops/denops.vim
[@denops/std]: https://jsr.io/@denops/std
[@denops/core]: https://jsr.io/@denops/core
