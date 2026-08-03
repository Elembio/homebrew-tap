# typed: false
# frozen_string_literal: true

class Elembio < Formula
  desc "CLI for the Element Biosciences Cloud API"
  homepage "https://www.elembio.io"
  version "1.1.1"
  license "BSD-3-Clause"

  S3_BASE = "https://elembio-cloud-downloads.s3.us-west-2.amazonaws.com/elembio-cli/releases"

  on_macos do
    on_arm do
      url "#{S3_BASE}/#{version}/elembio-#{version}-darwin-arm64"
      sha256 "7fc6cebb875ecf9a3587449e808cacbada006124630805bc3d9d385a03419b8a"
    end
    on_intel do
      url "#{S3_BASE}/#{version}/elembio-#{version}-darwin-amd64"
      sha256 "c8ed123f1cdd385adfe5e44763c130c27d692172fb3c6872eb4f7ae7ba160bcb"
    end
  end

  on_linux do
    on_arm do
      url "#{S3_BASE}/#{version}/elembio-#{version}-linux-arm64"
      sha256 "0932245e781200bb98e2b6220e2d38926f4b65ff2a5cc8a1d12f63315872e8d3"
    end
    on_intel do
      url "#{S3_BASE}/#{version}/elembio-#{version}-linux-amd64"
      sha256 "6be0821eaeb74f45fba98cd6a0bb59b0d697db10181de2a15dfe236af65903e2"
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
