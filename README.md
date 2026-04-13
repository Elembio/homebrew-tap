# Homebrew Tap for Element Biosciences CLI

## Install

```bash
brew tap elembio/tap
brew install elembio
```

## Upgrade

```bash
brew update
brew upgrade elembio
```

## Uninstall

```bash
brew uninstall elembio
brew untap elembio/tap
```

## For Maintainers

### Updating the formula after a release

Run the update script from this repo:

```bash
./scripts/update-formula.sh
```

The script fetches `latest.json` from S3, downloads each platform binary to compute SHA256 checksums, and rewrites `Formula/elembio.rb`. Then commit and push:

```bash
git add Formula/elembio.rb
git commit -m "Update elembio to <version>"
git push origin main
```
