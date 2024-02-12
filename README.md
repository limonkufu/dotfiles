# dotfiles

## Usage

1. Copy your SSH Keys
1. Install Homebrew and git following official [docs](https://brew.sh/)

    ``` bash
    brew install git
    ```

1. Install [chezmoi](https://www.chezmoi.io/)

    ``` bash
    sh -c "$(curl -fsLS get.chezmoi.io)"
    ```

    > [!NOTE]
    > We are not using `--init` flag with chezmoi to have more control over the setup process

1. Login to applications

## TODO

- [ ] Add more documentation on customisation
- [ ] Setup fonts
- [ ] Migrate to chezmoi's `run_` syntax instead of `setup.sh` files
- [ ] (internal) Document this in PKB
