class Twg < Formula
  require "fileutils"
  require "json"

  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.7.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.7/twg-0.7.7-darwin-arm64.tar.gz"
      sha256 "a772fc4873a5aabf8185eb49e550d443f452aa24f948e1194053c4e88fc16f91"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.7/twg-0.7.7-darwin-x64.tar.gz"
      sha256 "17584358170a62f7ab19d13d09157be67fda88110affa4a0a98cdbaef4343c83"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.7/twg-0.7.7-linux-arm64.tar.gz"
      sha256 "3aa9e4b799a59b85f40c08820fbe92718452fe63161fd51345fe89a08108070f"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.7/twg-0.7.7-linux-x64.tar.gz"
      sha256 "1a7a1b0ecf4944a76f6cc06c431826a0afd1a6f0e35b756df02668513f1caeaa"
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
