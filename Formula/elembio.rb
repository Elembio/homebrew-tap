# typed: false
# frozen_string_literal: true

class Elembio < Formula
  desc "CLI for the Element Biosciences Cloud API"
  homepage "https://www.elembio.io"
  version "1.1.0"
  license "BSD-3-Clause"

  S3_BASE = "https://elembio-cloud-downloads.s3.us-west-2.amazonaws.com/elembio-cli/releases"

  on_macos do
    on_arm do
      url "#{S3_BASE}/#{version}/elembio-#{version}-darwin-arm64"
      sha256 "b1ef1ca232a45014167be97568e5483f0ced254152f873fba3b8cce2f3eb46b5"
    end
    on_intel do
      url "#{S3_BASE}/#{version}/elembio-#{version}-darwin-amd64"
      sha256 "31ae80b9190d40e87b578dcf1d2361eae7d916b33caf4531b68860aba7cffb45"
    end
  end

  on_linux do
    on_arm do
      url "#{S3_BASE}/#{version}/elembio-#{version}-linux-arm64"
      sha256 "47a3032e84c283b275572f4740d621fdbd1235c184a1291380cfa1a7b5ea8c82"
    end
    on_intel do
      url "#{S3_BASE}/#{version}/elembio-#{version}-linux-amd64"
      sha256 "0c2bd3c25d8147db410ee4d8bd2bb5acbc66886176ddb177fc6887f783fcde6e"
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
