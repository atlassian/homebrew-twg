class Twg < Formula
  require "fileutils"
  require "json"

  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.8.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.3/twg-0.8.3-darwin-arm64.tar.gz"
      sha256 "48675b9383af88a764c64c2470e3382ffe5ebe70c5509ccc8244a85b6348de9d"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.3/twg-0.8.3-darwin-x64.tar.gz"
      sha256 "5b20ddfef6e5584a948fe864b8cd6359ca8ec54041422eae32a8792c8cfec8cd"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.3/twg-0.8.3-linux-arm64.tar.gz"
      sha256 "2e8c336cc9d19ec52fff4cdf006066d550c31462aa3543d139952bf02271c39e"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.3/twg-0.8.3-linux-x64.tar.gz"
      sha256 "74c1c19973ca130e4ddec219035e8eb1fbf33bcf1d38ffad2186b31165c780cd"
    end
  end

  def install
    bin.install "twg"
  end

  def post_install
    config_dir = File.join(Dir.home, ".twg")
    FileUtils.mkdir_p(config_dir)
    File.write(
      File.join(config_dir, "install.json"),
      JSON.pretty_generate(
        {
          installMethod: "brew",
          installChannel: "stable",
          installDir: bin.to_s,
          binaryPath: (opt_bin/"twg").to_s,
          installedVersion: version.to_s
        }
      ) + "\n"
    )
  end

  def caveats
    <<~EOS
      Next steps:
        twg skills install --global --yes
        twg login

      Updates:
        brew upgrade twg
    EOS
  end

  test do
    output = shell_output("#{bin}/twg doctor -o json")
    assert_match "\"command\": \"doctor.get\"", output
    assert_match version.to_s, output
  end
end
