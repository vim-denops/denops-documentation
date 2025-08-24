# Managing Dependencies with Import Maps

In the previous examples, we used direct URL imports like
`jsr:@denops/std@^8.0.0`. While this works, the recommended approach for Denops
plugins (v8.0.0+) is to use import maps with `deno.jsonc` for cleaner and more
maintainable dependency management.

## Why Use Import Maps?

The main reason to use import maps is to avoid conflicts between multiple Denops
plugins. Each Denops plugin must have a unique directory name under `denops/`,
but root-level configuration files could potentially conflict:

```
# Multiple plugins installed:
~/.vim/pack/plugins/start/plugin-a/
├── deno.jsonc              # Could conflict
└── denops/plugin-a/        # Always unique

~/.vim/pack/plugins/start/plugin-b/
├── deno.jsonc              # Could conflict  
└── denops/plugin-b/        # Always unique
```

Some plugin managers have a "merge" feature that combines plugin directories,
but even without merging, placing configuration files in plugin-specific
directories (`denops/plugin-name/`) ensures no conflicts can occur regardless of
how plugins are installed or managed.

## Setting Up Your Plugin Structure

Update your `denops-helloworld` structure to include configuration files:

```
denops-helloworld/
├── deno.jsonc                    # Development configuration
├── denops/
│   └── denops-helloworld/
│       ├── deno.jsonc           # Runtime dependencies
│       └── main.ts
└── plugin/
    └── denops-helloworld.vim
```

### Root deno.jsonc (Development)

Create a `deno.jsonc` in your repository root for workspace configuration:

```json
{
  "workspace": [
    "./denops/denops-helloworld"
  ]
}
```

This enables Deno commands like `deno fmt`, `deno lint`, and `deno test` to work
from your project root and discover your plugin's configuration.

### Plugin deno.jsonc (Runtime)

Create `denops/denops-helloworld/deno.jsonc` for runtime dependencies:

```json
{
  "imports": {
    "@denops/std": "jsr:@denops/std@^8.0.0",
    "@core/unknownutil": "jsr:@core/unknownutil@^4.3.0"
  }
}
```

## Updating Your Code

With import maps configured, update your imports from:

```typescript
import type { Entrypoint } from "jsr:@denops/std@^8.0.0";
import { assert, is } from "jsr:@core/unknownutil@^4.3.0";
```

To cleaner versions:

```typescript
import type { Entrypoint } from "@denops/std";
import { assert, is } from "@core/unknownutil";
```

## Alternative: import_map.json

Denops also supports `import_map.json(c)` files, but they require more verbose
configuration due to the
[Import Maps Standard](https://github.com/WICG/import-maps):

```json
// denops/denops-helloworld/import_map.json
{
  "imports": {
    "@denops/std": "jsr:@denops/std@^8.0.0",
    "@denops/std/": "jsr:/@denops/std@^8.0.0/" // Required for submodules
  }
}
```

We recommend using `deno.jsonc` as it's less verbose and integrates better with
Deno tooling. For more details about the differences, see the
[Deno documentation](https://docs.deno.com/runtime/fundamentals/modules/#differentiating-between-imports-or-importmap-in-deno.json-and---import-map-option).

> [!IMPORTANT]
>
> Import map features require Denops v8.0.0 or later. For older versions,
> continue using direct URL imports.

## Benefits

1. **Cleaner imports**: No more long URLs in your code
2. **Version management**: Update dependencies in one place
3. **Better IDE support**: Auto-completion and type checking work seamlessly
4. **No conflicts**: Each plugin manages its own dependencies
5. **Development tools**: Format and lint your code from the project root
