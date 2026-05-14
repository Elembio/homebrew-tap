# typed: false
# frozen_string_literal: true

class Elembio < Formula
  desc "CLI for the Element Biosciences Cloud API"
  homepage "https://www.elembio.io"
  version "0.6.0"
  license "BSD-3-Clause"

  S3_BASE = "https://elembio-cloud-downloads.s3.us-west-2.amazonaws.com/elembio-cli/releases"

  on_macos do
    on_arm do
      url "#{S3_BASE}/#{version}/elembio-#{version}-darwin-arm64"
      sha256 "6e49540bb377dfd7628e4a1ec52e4b6720354033b4050cde5edc1cf1b4ba32ee"
    end
    on_intel do
      url "#{S3_BASE}/#{version}/elembio-#{version}-darwin-amd64"
      sha256 "95ed88e526fe3316b77b87d5a34e9186f42a0979805f4c7b542f873c35eacd63"
    end
  end

  on_linux do
    on_arm do
      url "#{S3_BASE}/#{version}/elembio-#{version}-linux-arm64"
      sha256 "7d232d936b264a263657755eb1e31f2390eebf12a3e8ebf407cfd095184f92ae"
    end
    on_intel do
      url "#{S3_BASE}/#{version}/elembio-#{version}-linux-amd64"
      sha256 "cd2c8ba4509dc518ed958eef08a1d5669075a1647826eddfae432374355f910b"
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
