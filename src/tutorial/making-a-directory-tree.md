# Making a Plugin Directory Tree

Next, you have to make a directory `~/dps-helloworld` to store plugin codes and
change the current working directory to it. If you use Windows, you should find
and use equivalent commands.

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

This directory tree is a basis for developing a Denops plugin; Denops loads
`denops/*/main.ts` on `runtimepath` automatically after your vim starts up.
