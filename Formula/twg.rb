class Twg < Formula
  require "fileutils"
  require "json"

  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.8.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.0/twg-0.8.0-darwin-arm64.tar.gz"
      sha256 "a6d4a75315532b81f4401f3035879a1f362bf46094b9b152445b7aafede2f6cb"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.0/twg-0.8.0-darwin-x64.tar.gz"
      sha256 "4631e98312e5a2df8637e2c5c1c94167a9b357a24b9619c57c35681e8dcff664"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.0/twg-0.8.0-linux-arm64.tar.gz"
      sha256 "de424e057e4dcfb897240f5f8ac4d06e039b40af51f3c677f25aa303ccf99423"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.0/twg-0.8.0-linux-x64.tar.gz"
      sha256 "88ba19d72b46f5f9b9d33e8736c03a86453f28ab49531d1649122ac65fc71a8c"
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
