---
title: "Deno で Vim/Neovim のプラグインを書く (denops.vim)"
emoji: "🐜"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["vim", "neovim", "deno", "denops"]
published: true
---

:::message
対象バージョン：

[denops.vim v1.0.0-beta.4](https://github.com/vim-denops/denops.vim/releases/tag/v1.0.0-beta.4) (2021.07.11)
[denops_std v1.0.0-beta.2](https://github.com/vim-denops/deno-denops-std/releases/tag/v1.0.0-beta.2) (2021.07.11)
:::

:::message
ベータリリースに伴い、アルファ版を含む過去のバージョンに対するドキュメントは削除しました。
過去のバージョンの情報を見たい方は [lambdalisue/zenn-articles](https://github.com/lambdalisue/zenn-articles/blob/master/articles/b4a31fba0b1ce95104c9.md) から参照してください。
:::

どうも、最近 Rust と Deno にハマってるありすえです。

今日は [vim-jp][] で開発を開始した [denops.vim][] の紹介と denops.vim を利用したプラグイン作成のチュートリアルを書きたいと思います。

[vim-jp]: https://vim-jp.org/
[denops.vim]: https://github.com/vim-denops/denops.vim

# denops.vim とは

denops.vim は JavaScript/TypeScript のランタイムである [Deno][] を利用して Vim/Neovim 双方で動作するプラグインを作るためのエコシステムです。以下のような特徴があります。

- Vim / Neovim で同一コードを利用可能
- Vim プラグインとしてインストールが可能
- Vim script と比較してエンジンが爆速なのでゴリ押しが可能
- ユーザーによるライブラリの依存管理が不要
- プラグインが別プロセスとして動作するため Vim が固まりにくい
- プラグイン毎にスレッドが分かれているため相互干渉が起こりにくい

[deno]: https://deno.land/

# 用語集

| 用語              | 意味                                                                    |
| ----------------- | ----------------------------------------------------------------------- |
| Denops            | Deno をランタイムとして利用した Vim/Neovim のプラグインエコシステムです |
| Denops プラグイン | Denops を用いて書かれた Vim/Neovim 双方で動作するプラグインを表します   |

# Denops のインストール

Denops プラグインを利用するためには Denops 自体をインストールする必要があります。
これは Denops プラグインを利用するだけのユーザーも行う必要があります。

## 0. Deno のインストール

https://deno.land/#installation を参考に Deno をインストールしてください。
Getting Started の以下のコマンドを実行して結果が帰ってくれば成功です。

```sh
deno run https://deno.land/std/examples/welcome.ts
```

なお、既にインストール済みであれば、以下のコマンドで最新版にアップデートしてください。

```sh
deno upgrade
```

## 1. Denops のインストール

通常の Vim プラグインとして [denops.vim][] をインストールしてください。
例えば [vim-plug][] を利用している場合には `.vimrc` に以下のように記載してから `:PlugInstall` を実行します。

```vim
Plug 'vim-denops/denops.vim'
```

[vim-plug]: https://github.com/junegunn/vim-plug

# 開発チュートリアル

ここから小さな Denops プラグインを実際に作ってみます。プラグイン名は `helloworld` でプラグインディレクトリはホーム直下の `dps-helloworld` と仮定します。

## 0. プラグイン開発前準備

Vim プラグインは Vim の `runtimepath` に存在している必要があります。Denops プラグインも Vim プラグインであるため、同様に `runtimepath` に存在する必要があります。そのため、以下を `.vimrc` に追記してください。

```vim
set runtimepath^=~/dps-helloworld
```

次に Deno の起動時型チェックなどを有効にするため Denops をデバッグモードで動作させます。
以下を `.vimrc` に追記してください。

```vim
let g:denops#debug = 1
```

:::message
デバッグモードはパフォーマンス的な問題があります。開発が落ち着いたらデバッグモードを解除してください。
:::

## 1. プラグインディレクトリ構造の作成

まず以下のコマンドで `~/dps-helloworld` を作成し、作業ディレクトリを変更します。
Windows を利用している方は、適時コマンドを読み替えてください。

```sh
mkdir ~/dps-helloworld
cd ~/dps-helloworld
```

次に以下のコマンドで必要最低限のディレクトリ構造を作成します。

```sh
mkdir -p denops/helloworld
touch denops/helloworld/main.ts
```

最終的に以下のようなディレクトリ構造になっていれば OK です。

```
dps-helloworld
└── denops
    └── helloworld
        └── main.ts
```

Denops は自動的に `runtimepath` 内の `denops/*/main.ts` を読み込みます。
そのため上記のような構造が Denops プラグインの基本型となります。

## 2. 骨組みの追加

Denops プラグインは `main.ts` がエクスポートする `main` 関数を呼び出します。なお、渡される `denops` という値は [denops-std][] がエクスポートしている `Denops` クラスのインスタンスです。したがって `main.ts` の内容を以下のように書き換えてください。

```ts:main.ts
import { Denops } from "https://deno.land/x/denops_std@v1.0.0-beta.2/mod.ts";

export async function main(denops: Denops): Promise<void> {
  // ここにプラグインの処理を記載する
  console.log("Hello Denops!");
};
```

この状態で一度 Vim を再起動すると起動時に `[denops] Hello Denops!` が表示されます。

![](https://storage.googleapis.com/zenn-user-upload/y8fyu6tap3tapjbxtltni6jynq8y)

[denops-std]: https://deno.land/x/denops_std

:::message
Vim を再起動するのが面倒な方は `:call denops#server#restart()` として Denops を再起動するのが良いです。
:::

## 3. API の追加

Denops では各プラグインが API を関数として登録します。まず、与えられた文字列を返却する `echo()` 関数を API として登録してみましょう。`main.ts` を以下のように書き直してください。

```ts:main.ts
import { Denops } from "https://deno.land/x/denops_std@v1.0.0-beta.2/mod.ts";
import { ensureString } from "https://deno.land/x/unknownutil@v0.1.1/mod.ts";

export async function main(denops: Denops): Promise<void> {
  denops.dispatcher = {
    async echo(text: unknown): Promise<unknown> {
      // `text` が string 型であることを保証する
      ensureString(text);
      return await Promise.resolve(text);
    },
  };
};
```

:::message
引数が全て `unknown` 型で戻り値が `Promise<unknown>` もしくは `Promise<void>` な関数のみ API として登録可能です。
:::

これで `echo` という API が `helloworld` というプラグインに登録されます。この API を呼び出すには `denops#request({plugin}, {func}, {args})` を利用します。Vim を再起動後以下のコマンドを実行してみてください。

```vim
:echo denops#request('helloworld', 'echo', ["Hello Denops!"])
```

これにより `Hello Denops!` が表示されれば成功です。

![](https://storage.googleapis.com/zenn-user-upload/2fyw9gsjs0mhxa132q2dkrz2yle3)

なお `denops#request('helloworld', 'echo', [123])` のように、文字列以外を与えると以下のようにエラーを吐きます。

![](https://storage.googleapis.com/zenn-user-upload/ykf75d9whbfjjntdk93jxcfmilsc)

## 4. Vim 機能の呼び出し

Denops プラグインから Vim の機能を呼び出すには渡される `denops` インスタンスを利用します。
先ほどの `echo` API を Vim のコマンドとして登録してみるので、以下のように `main.ts` を変更してください。

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

`execute()` は渡された複数行文字列を Vim script として実行します。また `denops.name` は実行中のプラグイン名を表します。これにより `HelloWorldEcho` コマンドが登録されるので Vim を再起動後以下のコマンドを実行してください。

```vim
:HelloWorldEcho Hello Vim!
```

これにより以下のように `Hello Vim!` が表示されれば成功です。

![](https://storage.googleapis.com/zenn-user-upload/zcf4whdc44sa9k5a9s9gwk7gykyy)

なお `denops` の詳細 API は https://doc.deno.land/https/deno.land/x/denops_std/mod.ts#Denops を参照してください。

## 5. 実用的なプラグインの開発

ここまでで、基本的なプラグインの作り方は説明したので、次は実用的なプラグインを作ってみます。

突然ですが、皆様はプログラミングしているときに突然迷路を解きたくなったことはありませんか？
僕はありません。
ただ、世の中には迷路が好きで好きでたまらない人もいるはずなので Vim からいつでも迷路を生成して表示できるプラグインを作ってみます。

迷路生成アルゴリズムから自作しても良いのですが、せっかく Deno を利用しているのでサードパーティの迷路生成ライブラリである [maze_generator](https://deno.land/x/maze_generator@v0.4.0) を使います。
まず `HelloWorldEcho` コマンドと同様にして `Maze` コマンドを定義し、内部では迷路を生成して `console.log()` で出力します。

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

Vim を再起動し以下のコマンドで出力を確認すると迷路が生成できているのがわかります。

```vim
:Maze
:mes
```

![](https://storage.googleapis.com/zenn-user-upload/dv98sl6ml57ppy0e4r50nol0gry6)

これで完成でもいいのですが、少し味気がないのでバッファに出力してみましょう。以下のようにプログラムを書き換えてください。

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

上記では `denops.cmd()` で Vim の `enew` コマンドを呼び出し新規バッファを現在の Window で開いた後 `denops.call()` で `setline()` 関数を呼ぶことでバッファに迷路を書き込んでいます。
これを実行すると以下のようになります。

![](https://storage.googleapis.com/zenn-user-upload/ch1xyqz7i3k06c9bt33xokjee1pp)

良い感じですね。
これで終わりでもいいですが、せっかくなので `enew` 以外のコマンドを外部から与えられるようにしたり、現在の表示領域から迷路を生成したりなどいろいろ改良を加えて以下のようにしてみました。

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
依存モジュールが増えてくると管理が煩雑になります。
Denops 本体及び関連モジュール `deps.ts` および `deps_test.ts` で一括管理した上で [udd](https://github.com/hayd/deno-udd) というアップデートマネージャーでアップデート管理しています。
:::

ちゃんと小さな迷路ができてますね。

![](https://storage.googleapis.com/zenn-user-upload/nkd2tk0nwcwn0ww60ncbed4n3lwc)

## おわりに

どうでしょう？Denops を利用すると、かなり簡単に Vim/Neovim で動くプラグインが作れると思いませんか？
まだまだ開発中ですが Vim/Neovim 双方で効率的に動くポータビリティが高いエコシステムになっていると思います。
よければ、このチュートリアルと以下のドキュメントを参考に Denops プラグインを作ってみてください。

- [denops-std API ドキュメント](https://doc.deno.land/https/deno.land/x/denops_std/mod.ts)
- [denops サンプルプロジェクト](https://github.com/vim-denops/denops-helloworld.vim)
- [denops 開発チャネル (vim-jp Slack)](https://vim-jp.slack.com/archives/C01N4L5362D)

皆様のフィードバックをお待ちしております 🙇

# ポエム：開発動機

今 Vim/Neovim の関係は大きな変貌期にいます。

Vim 側は Vim script の欠点を補った新しい言語である Vim 9 script の開発を進めており Neovim 側は Vim script を完全に捨てて Lua に移行しようとしています。

このように Vim/Neovim の乖離が大きく広がっており、双方で動作するプラグインを書くのが非常に難しくなってきている状態です。

そんな中 [coc.nvim][] はランタイムに Node.js を採用し Vim/Neovim のプラグイン機構の **外** で独自のエコシステムを展開することで Vim/Neovim 双方をサポートすることを可能にしています。

しかし coc.nvim が採用している Node.js は依存管理が複雑なため、プラグインとして利用するにはビルドが必要だったりと、エコシステムとして使い勝手が良いものではありません。

そのため依存管理を内包し、バイナリ一つがあれば動作する Deno をベースにすれば Vim/Neovim 双方で動作し、開発も簡単なエコシステムができるのではないか？と思い開発に踏み切りました。

[coc.nvim]: https://github.com/neoclide/coc.nvim
