# typed: false
# frozen_string_literal: true

class Elembio < Formula
  desc "CLI for the Element Biosciences Cloud API"
  homepage "https://www.elembio.io"
  version "0.2.2"
  license "Proprietary"

  S3_BASE = "https://elembio-cloud-downloads.s3.us-west-2.amazonaws.com/elembio-cli/releases"

  on_macos do
    on_arm do
      url "#{S3_BASE}/#{version}/elembio-#{version}-darwin-arm64"
      sha256 "754f0be97686573ad263106219f49a1c3d9f0c860b5d402d33fbbd2b6c3ef35d"
    end
    on_intel do
      url "#{S3_BASE}/#{version}/elembio-#{version}-darwin-amd64"
      sha256 "3eb3e7c030621074e4f056b63db7c7d5ade70e84f8f837121810815203929c10"
    end
  end

  on_linux do
    on_arm do
      url "#{S3_BASE}/#{version}/elembio-#{version}-linux-arm64"
      sha256 "c365f21be6821406aa21445eb7f73f40530cd63051aaeef3e73b0e3172cc5016"
    end
    on_intel do
      url "#{S3_BASE}/#{version}/elembio-#{version}-linux-amd64"
      sha256 "812e9b9d470d06e076774c4eacc21dd6b70ce3795079adf98208ec5c0a7a5f12"
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
