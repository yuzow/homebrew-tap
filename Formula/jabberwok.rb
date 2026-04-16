class Jabberwok < Formula
  desc "A macOS speech-to-text service that transcribes your voice wherever your cursor is"
  homepage "https://github.com/yuzow/jabberwok"
  version "0.1.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/yuzow/jabberwok/releases/download/v0.1.3/jabberwok-aarch64-apple-darwin.tar.gz"
    sha256 "21560ae80f8677c7d0bad281c9bb905b4dfa7275c00e2efa840fb5b1e7a42490"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "jabberwok" if OS.mac? && Hardware::CPU.arm?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
