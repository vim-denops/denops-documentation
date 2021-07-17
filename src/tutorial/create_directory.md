# Create Directory

First, create `~/dps-helloworld` directory, and then change the working directory to `~/dps-helloworld`.
If you are using Windows, change the command as necessary.

```bash
mkdir ~/dps-helloworld
cd ~/dps-helloworld
```

Next, create the minimum required directory structure using the following command:

```bash
mkdir -p denops/helloworld
touch denops/helloworld/main.ts
```

The following directory structure should be fine.

```
dps-helloworld
└── denops
    └── helloworld
        └── main.ts
```

Denops will automatically load `denops/*/main.ts` in `runtimepath`.
Therefore, the above is the basic structure to create a Denops plugin.
