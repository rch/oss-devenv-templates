# devenv-templates

A collection of development environment configurations based on Nix flakes and [devenv](https://devenv.sh)

## Usage

You can use any of the subfolders in the repository as a flake template:

### Python

```sh
nix flake init --template github:dileep-kishore/devenv-templates#python
```

### Jupyter

```sh
nix flake init --template github:dileep-kishore/devenv-templates#jupyter
```

> [!NOTE]
> This was copied over from `https://github.com/tweag/jupyenv`. It might be better to run `nix flake init --template github:tweag/jupyenv`

## References

- [Reza Khanipour's flake templates](https://github.com/shahinism/devenv-templates/blob/main/python/flake.nix)
- [Jupyenv](https://github.com/tweag/jupyenv)
