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

You can read a secret by its UUID:

```sh
bws secret read <SECRET_UUID>
```

You can also read secrets as a list:

```sh
bws secret list
```

The default output format is JSON, but you can specify other formats
such as YAML or ENV.

```sh
bws secret list --output env
```

```
```
