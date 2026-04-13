#!/usr/bin/env bash
#
# Update the Homebrew formula to the latest release.
#
# Usage:
#   ./scripts/update-formula.sh
#
set -euo pipefail

S3_BASE="https://elembio-cloud-downloads.s3.us-west-2.amazonaws.com/elembio-cli/releases"
LATEST_URL="${S3_BASE}/latest.json"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FORMULA="${SCRIPT_DIR}/../Formula/elembio.rb"

if [ ! -f "$FORMULA" ]; then
  echo "Error: formula not found at ${FORMULA}" >&2
  exit 1
fi

echo "Fetching ${LATEST_URL} ..."
LATEST=$(curl -fsSL "$LATEST_URL")
VERSION=$(echo "$LATEST" | jq -r '.version')

if [ -z "$VERSION" ] || [ "$VERSION" = "null" ]; then
  echo "Error: could not parse version from latest.json" >&2
  exit 1
fi

echo "Latest version: ${VERSION}"

sha_for() {
  local platform="$1"
  local url
  url=$(echo "$LATEST" | jq -r --arg p "$platform" '.builds[$p]')
  if [ -z "$url" ] || [ "$url" = "null" ]; then
    echo "Warning: no build URL for ${platform}, skipping" >&2
    echo "MISSING"
    return
  fi
  echo "  Downloading ${platform} for SHA256..." >&2
  local sha
  sha=$(curl -fsSL "$url" | shasum -a 256 | awk '{print $1}')
  echo "    ${platform}: ${sha}" >&2
  echo "$sha"
}

SHA_DARWIN_ARM64=$(sha_for darwin-arm64)
SHA_DARWIN_AMD64=$(sha_for darwin-amd64)
SHA_LINUX_ARM64=$(sha_for linux-arm64)
SHA_LINUX_AMD64=$(sha_for linux-amd64)

cat > "$FORMULA" <<RUBY
# typed: false
# frozen_string_literal: true

class Elembio < Formula
  desc "CLI for the Element Biosciences Cloud API"
  homepage "https://www.elembio.io"
  version "${VERSION}"
  license "Proprietary"

  S3_BASE = "https://elembio-cloud-downloads.s3.us-west-2.amazonaws.com/elembio-cli/releases"

  on_macos do
    on_arm do
      url "#{S3_BASE}/#{version}/elembio-#{version}-darwin-arm64"
      sha256 "${SHA_DARWIN_ARM64}"
    end
    on_intel do
      url "#{S3_BASE}/#{version}/elembio-#{version}-darwin-amd64"
      sha256 "${SHA_DARWIN_AMD64}"
    end
  end

  on_linux do
    on_arm do
      url "#{S3_BASE}/#{version}/elembio-#{version}-linux-arm64"
      sha256 "${SHA_LINUX_ARM64}"
    end
    on_intel do
      url "#{S3_BASE}/#{version}/elembio-#{version}-linux-amd64"
      sha256 "${SHA_LINUX_AMD64}"
    end
  end

  def install
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "elembio-#{version}-#{os}-#{arch}" => "elembio"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/elembio version")
  end
end
RUBY

echo ""
echo "Formula updated to ${VERSION}."
echo ""
echo "Next steps:"
echo "  cd $(cd "${SCRIPT_DIR}/.." && pwd)"
echo "  git add Formula/elembio.rb"
echo "  git commit -m \"Update elembio to ${VERSION}\""
echo "  git push origin main"
