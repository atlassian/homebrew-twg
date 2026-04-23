class Twg < Formula
  require "fileutils"
  require "json"

  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.8.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.6/twg-0.8.6-darwin-arm64.tar.gz"
      sha256 "c338f2526414117b7719860367d9bd1db2c831ffcb9f85fec89b4cf8862e81e6"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.6/twg-0.8.6-darwin-x64.tar.gz"
      sha256 "5f8bb92ea32f98abfcac95adebfee58ba17915b3aef1100bce115801ed3d7b0c"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.6/twg-0.8.6-linux-arm64.tar.gz"
      sha256 "63bf708ee5268ade8170e6ff9eb509706517b1ff4cc273458833c8daf3dc7a65"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.6/twg-0.8.6-linux-x64.tar.gz"
      sha256 "52415225e9f11feafe0b585465ae9b8bae65d626024cbac5ea42f11589e1dec5"
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
