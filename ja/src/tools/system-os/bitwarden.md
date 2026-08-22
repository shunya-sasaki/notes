# Bitwarden

## Bitwarden security manager

### Setup

#### Account setting

#### Install CLI

_flake.nix_

```nix
{pkgs, ...}

...

home.packages = with pkgs; [
  ...
  bws 
];
```

### Usage

#### Create a secret

```sh
bws secret create <KEY> <VALUE> <PROJECT_ID>
```

#### Read a secret

シークレットは UUID を指定して読み取れます。

```sh
bws secret read <SECRET_UUID>
```

シークレットを一覧として読み取ることもできます。

```sh
bws secret list
```

デフォルトの出力形式は JSON ですが、YAML や ENV などの
他の形式を指定することもできます。

```sh
bws secret list --output env
```

```
```
