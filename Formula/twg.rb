class Twg < Formula
  require "fileutils"
  require "json"

  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.8.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.5/twg-0.8.5-darwin-arm64.tar.gz"
      sha256 "30797b65427e64aa7e893f9aa424c2767203d2d1d8118e047d7542d8b7eda784"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.5/twg-0.8.5-darwin-x64.tar.gz"
      sha256 "6f1bddd8810ef6c71789a8462749c07c84f087feaf25dbe7bd7a491eaf51a1ee"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.5/twg-0.8.5-linux-arm64.tar.gz"
      sha256 "7835d939eb9ec613f9dd9e3504671516e1d0e99d21b48691d0dbe812f4380570"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.5/twg-0.8.5-linux-x64.tar.gz"
      sha256 "f6abb7d59fd188b4888170288595042d16bec9f3ab5af57c21fb2baea499628a"
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
