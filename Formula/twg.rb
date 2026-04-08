class Twg < Formula
  require "fileutils"
  require "json"

  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.7.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.6/twg-0.7.6-darwin-arm64.tar.gz"
      sha256 "c20aca9820a1619beadee7446de4796c02b109566c36a4cf0c9ded23a98afacb"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.6/twg-0.7.6-darwin-x64.tar.gz"
      sha256 "e0260a6df15b1897d6208a0dc25e53e7979cac7a59edeb34655c9b669a864cba"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.6/twg-0.7.6-linux-arm64.tar.gz"
      sha256 "7fa7611ae3f1aa9c2880a6c56879710f65da934d662640c532f947fb99c8e602"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.6/twg-0.7.6-linux-x64.tar.gz"
      sha256 "67a20d57f3a0f2d0bf138ef7f306373314186b9de6a70a56f7728d67f3a3116d"
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
