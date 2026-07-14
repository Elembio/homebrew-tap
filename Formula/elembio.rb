# typed: false
# frozen_string_literal: true

class Elembio < Formula
  desc "CLI for the Element Biosciences Cloud API"
  homepage "https://www.elembio.io"
  version "0.10.0"
  license "BSD-3-Clause"

  S3_BASE = "https://elembio-cloud-downloads.s3.us-west-2.amazonaws.com/elembio-cli/releases"

  on_macos do
    on_arm do
      url "#{S3_BASE}/#{version}/elembio-#{version}-darwin-arm64"
      sha256 "1c8b1f0a9cdbfde9dacd5b631acd708c908fda0f936eade45eccfe1b121ff4fe"
    end
    on_intel do
      url "#{S3_BASE}/#{version}/elembio-#{version}-darwin-amd64"
      sha256 "fb00e71d3189ee08c1cfc4b582738aab7a5ab9a7563e1f60438721489f83d3df"
    end
  end

  on_linux do
    on_arm do
      url "#{S3_BASE}/#{version}/elembio-#{version}-linux-arm64"
      sha256 "858a51ae4f6b6d4d01301247938d92806e53f95485155673c732bc0fec591768"
    end
    on_intel do
      url "#{S3_BASE}/#{version}/elembio-#{version}-linux-amd64"
      sha256 "20c46c4b79ce923ee12a5540479d56eb685da680dbfe724f3936255b8d5c13ba"
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
