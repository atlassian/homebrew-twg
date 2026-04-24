class Twg < Formula
  require "fileutils"
  require "json"

  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.8.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.8/twg-0.8.8-darwin-arm64.tar.gz"
      sha256 "4489b52ddcb9dfa8eedd61dabdda105f74b0a2aa7d3c1dd624bed13aa3c2fa25"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.8/twg-0.8.8-darwin-x64.tar.gz"
      sha256 "0f6f81d3c02dc04777879ad17cfad46148e0f58953f2443c72f6ec0d5de6f254"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.8/twg-0.8.8-linux-arm64.tar.gz"
      sha256 "84129e85f7b67421e6ce69f8ad71b7ff1874922f71c8c157d0745c17dd03c04c"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.8/twg-0.8.8-linux-x64.tar.gz"
      sha256 "743ca0c0ab389c7b3529395fe3ac3c707c5ca7338e3d18374200ccb6712d8d36"
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
