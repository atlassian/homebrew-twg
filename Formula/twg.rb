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
      sha256 "cebc7396d1485e17559d63cf67d43267b1050d20d15ee24b95d2d5db78682b01"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.7/twg-0.7.7-darwin-x64.tar.gz"
      sha256 "ff9ac55c42ad60a7efa5e62b9dea121bf64be2742c154270f732c376e523ef9e"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.7/twg-0.7.7-linux-arm64.tar.gz"
      sha256 "88dd2cf1db45af10151d317253ef52a03f0200b180dc7a91810421457e4e6fdf"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.7/twg-0.7.7-linux-x64.tar.gz"
      sha256 "e5e558791ca9c7d073b0afd4d95bf857190a36dc0b67fec6b0b398f8f597e05e"
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
