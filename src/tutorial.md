# Tutorial

This article is a tutorial on developing Denops plugins.

## Environment

In this tutorial, we use the following software and version as of writing.
* [denops.vim v1.0.0-beta.4](https://github.com/vim-denops/denops.vim/releases/tag/v1.0.0-beta.4) (2021-07-11)
* [denops_std v1.0.0-beta.2](https://github.com/vim-denops/deno-denops-std/releases/tag/v1.0.0-beta.2) (2021-07-11)

[vim-jp]: https://vim-jp.org/
[denops.vim]: https://github.com/vim-denops/denops.vim
[deno]: https://deno.land/

## Glossary

| Term                  | Meaning                                                                     |
| --------------------- | --------------------------------------------------------------------------- |
| vim                   | Vim or NeoVim.                                                          |
| vim plugin            | Vim plugin or NeoVim plugin.                                            |
| [Deno][]              | A JavaScript and TypeScript runtime.                                        |
| [Denops][denops.vim]  | An ecosystem for vim plugins based on Deno runtime.                         |
| Denops plugin         | A vim plugin that works on both Vim and NeoVim and is written with Denops.  |
| [denops.vim][]        | The Name of the vim plugin to introduce Denops into vim.                      |

## Preparation

First of all, whichever you want to either use or develop Denops plugins, you have to install tools; [Deno][] and [Denops][denops.vim] in addition to your vim.

### Installing Deno

Deno can be installed to follow the instructions in the [Deno document](https://deno.land/#installation).
In addition, you can check if Deno has been installed successfully by [the command](https://deno.land/#getting-started):

```sh
deno run https://deno.land/std/examples/welcome.ts
```

If you have already installed Deno, update it to the latest version.

```sh
deno upgrade
```

### Installing Denops
It is necessary for using Denops to install as a vim plugin [denops.vim][].
For example, when you use [vim-plug][] as a vim plugin manager, add the following command to your `.vimrc` and execute `:PlugInstall` on vim to install Denops.

```vim
Plug 'vim-denops/denops.vim'
```

[vim-plug]: https://github.com/junegunn/vim-plug

If you prefer another vim plugin manager, you can find instructions for it on the [Install](./install.md) page.

Thus Deno and Denops are available in your environment.

## Developing Your First Plugin

Now you are ready to write a Denops plugin.
It would be better to start by developing a small plugin.
So we will name the plugin `helloworld` and place it under `~/dps-helloworld`.

### Vim Configuration

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

:::message
Running Denops in debug mode has a performance problem.
Once your development goes well, it would be better for you to disable the debug mode.
:::

### Making a Plugin Directory Tree

Next, you have to make a directory `~/dps-helloworld` to store plugin codes and change the current working directory to it.
If you use Windows, you should find and use equivalent commands.

```sh
mkdir ~/dps-helloworld
cd ~/dps-helloworld
```

Then make a minimum directory tree and a code file required by Denops at least:

```sh
mkdir -p denops/helloworld
touch denops/helloworld/main.ts
```

Finally, you will get a directory tree like:

```
dps-helloworld
└── denops
    └── helloworld
        └── main.ts
```


This directory tree is a basis for developing a Denops plugin; Denops loads `denops/*/main.ts` on `runtimepath` automatically after your vim starts up.

### Adding a Skelton of Denops Plugin

Once a Denops plugin is loaded, Denops calls the `main` function exported from `main.ts` of the plugin code.
So initially you can write `main.ts` like:

```ts:main.ts
import { Denops } from "https://deno.land/x/denops_std@v1.0.0-beta.2/mod.ts";

export async function main(denops: Denops): Promise<void> {
  // Plugin program starts from here
  console.log("Hello Denops!");
};
```

An argument `denops` is passed to the `main` function; where `denops` is an instance of `Denops` class exported from [denops-std][].

Then you restart vim, and you can see a message `[denops] Hello Denops!` on the vim window.

![](https://storage.googleapis.com/zenn-user-upload/y8fyu6tap3tapjbxtltni6jynq8y)

[denops-std]: https://deno.land/x/denops_std

:::message
If you are too lazy to restart vim, you can simply run `:call denops#server#restart()` on vim to reload Denops only.
:::

### Adding an API

Each Denops plugin registers one or more functions as APIs to Denops.
First, try to write an `echo()` function that returns a given string and register it as an API.
You can rewrite `main.ts` as follows:

```ts:main.ts
import { Denops } from "https://deno.land/x/denops_std@v1.0.0-beta.2/mod.ts";
import { ensureString } from "https://deno.land/x/unknownutil@v0.1.1/mod.ts";

export async function main(denops: Denops): Promise<void> {
  denops.dispatcher = {
    async echo(text: unknown): Promise<unknown> {
      // assure `text` is string type.
      ensureString(text);
      return await Promise.resolve(text);
    },
  };
};
```

:::message
You can register a function that satisfies the following as an API:
- All of its arguments must be `unknown`.
- The type of return value must be either `Promise<unknown>` or `Promise<void>`.

:::

Thus an `echo` API is registered to the `helloworld` plugin.
To call an API, you can use a vim command of the form `denops#request({plugin}, {func}, {args})`.
So you can use the `echo` API to execute the command below after restarting vim:

```vim
:echo denops#request('helloworld', 'echo', ["Hello Denops!"])
```

If it goes well, you will see `Hello Denops!`.

![](https://storage.googleapis.com/zenn-user-upload/2fyw9gsjs0mhxa132q2dkrz2yle3)

If a non-string argument is passed to the `echo` API, such as `denops#request('helloworld', 'echo', [123])`, Denops will raise an error:

![](https://storage.googleapis.com/zenn-user-upload/ykf75d9whbfjjntdk93jxcfmilsc)

### Calling Vim/NeoVim Features

If you want to use a vim feature from your Denops plugin, you can call it via the `denops` instance passed to the plugin's `main` function.
You can rewrite `main.ts` like below to register the `echo` API as a Vim command:

```ts:main.ts
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

The helper function `execute()` receives a multiline string and executes it as a Vim script; where `denops.name` represents the name of the running plugin.
Once vim is restarted, the HelloWorldEcho command will be registered.
Then you can run:

```vim
:HelloWorldEcho Hello Vim!
```

If the plugin has been registered successfully, you will see `Hello Vim!` as a result.

![](https://storage.googleapis.com/zenn-user-upload/zcf4whdc44sa9k5a9s9gwk7gykyy)

If you want to learn more details on `denops` API, you can refer to [denops-std API document](https://doc.deno.land/https/deno.land/x/denops_std/mod.ts#Denops).

### Developing More Applicative Plugin

Now you have learned the basics of developing Denpos plugins in the previous sections.
Then it would be best if you tried to create a more functional plugin.

So let me ask you, out of the blue, have you ever itched to solve mazes while programming?
I never have.
In any case, there may be people who love solving mazes and can't get enough of it.
So let's try to develop a Denops plugin that can generate and display a maze in vim at any time.

Of course, it would be nice to start by coding a maze generation algorithm.
However, you are now with Deno so that you can use a third-party library [maze_generator](https://deno.land/x/maze_generator@v0.4.0) for your convenience.
First, you should define a `Maze` command similarly to `HelloWorldEcho`; `Maze` generates a maze and outputs it with `console.log()`.

```ts:main.ts
import { Denops } from "https://deno.land/x/denops_std@v1.0.0-beta.2/mod.ts";
import { Maze } from "https://deno.land/x/maze_generator@v0.4.0/mod.js";

export async function main(denops: Denops): Promise<void> {
  denops.dispatcher = {
    async maze(): Promise<void> {
      const maze = new Maze({}).generate();
      const content = maze.getString();
      console.log(content);
    },
  };

  await denops.cmd(`command! Maze call denops#request('${denops.name}', 'maze', [])`);
};
```

Restarting Vim, and you will see a maze by commands:

```vim
:Maze
:mes
```

![](https://storage.googleapis.com/zenn-user-upload/dv98sl6ml57ppy0e4r50nol0gry6)

Well done! But it is a little boring... So let's try to modify the code to make the maze output to a buffer.

```ts:main.ts
import { Denops } from "https://deno.land/x/denops_std@v1.0.0-beta.2/mod.ts";
import { Maze } from "https://deno.land/x/maze_generator@v0.4.0/mod.js";

export async function main(denops: Denops): Promise<void> {
  denops.dispatcher = {
    async maze(): Promise<void> {
      const maze = new Maze({}).generate();
      const content = maze.getString();
      await denops.cmd("enew");
      await denops.call("setline", 1, content.split(/\n/));
    },
  };

  await denops.cmd(`command! Maze call denops#request('${denops.name}', 'maze', [])`);
};
```

In this code, `denops.cmd()` calls an `enew` command of vim to open a new buffer in the current window and then `denops.call()` calls `setline()` to write the maze to the buffer.
Restart Vim, rerun the commands, and then you can see:

![](https://storage.googleapis.com/zenn-user-upload/ch1xyqz7i3k06c9bt33xokjee1pp)

Awesome!
Even if it looks like enough, you can improve your code a bit more.
Here is an example of a modification that command other than `enew` can be passed to the plugin, a maze can be generated in the current display area, etc,:

```ts:main.ts
import { Denops } from "https://deno.land/x/denops_std@v1.0.0-beta.2/mod.ts";
import { execute } from "https://deno.land/x/denops_std@v1.0.0-beta.2/helper/mod.ts";
import { Maze } from "https://deno.land/x/maze_generator@v0.4.0/mod.js";
import { ensureString } from "https://deno.land/x/unknownutil@v0.1.1/mod.ts";

export async function main(denops: Denops): Promise<void> {
  denops.dispatcher = {
    async maze(opener: unknown): Promise<void> {
      ensureString(opener);
      const [xSize, ySize] = (await denops.eval("[&columns, &lines]")) as [
        number,
        number
      ];
      const maze = new Maze({
        xSize: xSize / 3,
        ySize: ySize / 3,
      }).generate();
      const content = maze.getString();
      await denops.cmd(opener || "new");
      await denops.call("setline", 1, content.split(/\r?\n/g));
      await execute(denops, `
        setlocal bufhidden=wipe buftype=nofile
        setlocal nobackup noswapfile
        setlocal nomodified nomodifiable
      `);
    },
  };

  await denops.cmd(`command! -nargs=? -bar Maze call denops#request('${denops.name}', 'maze', [<q-args>])`);
};
```

:::message
Much more module dependencies make it harder for us to manage them.
Denops manages modules by using Denops itself and its core modules: `deps.ts` and `deps_test.ts`; and Denops uses [udd](https://github.com/hayd/deno-udd) as a module update manager.
:::

Now you can see a small maze shown on the window.

![](https://storage.googleapis.com/zenn-user-upload/nkd2tk0nwcwn0ww60ncbed4n3lwc)

## Developing Your Next Plugins

How do you feel about Denops plugin development?
I think you could understand that you can create Vim/Neovim plugins with Denops so easily.
Denops is a fantastic portable ecosystem for Vim/NeoVim plugins, though it is going under development.
If you are interested in creating Denops plugins, this tutorial and the following documents will help you.

- [denops-std API Document](https://doc.deno.land/https/deno.land/x/denops_std/mod.ts)
- [denops Sample Project](https://github.com/vim-denops/denops-helloworld.vim)
- [denops Developer's Channel (vim-jp Slack)](https://vim-jp.slack.com/archives/C01N4L5362D)

We are looking forward to your feedback and contributions to our development. 🙇
