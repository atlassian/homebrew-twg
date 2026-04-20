class Twg < Formula
  require "fileutils"
  require "json"

  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.8.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.2/twg-0.8.2-darwin-arm64.tar.gz"
      sha256 "d0fcf5717720e99459829cba9a32a124861770d26f8fd97a79c62b49fa296f21"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.2/twg-0.8.2-darwin-x64.tar.gz"
      sha256 "71f53327952c0968f36cf976f41774e4bdaee3060c4b4dda0baa6c2f8cdd20aa"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.2/twg-0.8.2-linux-arm64.tar.gz"
      sha256 "dffd0a77e2a6d40a14c2c2a5d8e9d815add969f2c6c9a890033a6de9bf9a6992"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.2/twg-0.8.2-linux-x64.tar.gz"
      sha256 "cc6e3f72b017a9edcd21d8c17b199c78b67ff4b4646f8ef28bdda996353f3005"
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
