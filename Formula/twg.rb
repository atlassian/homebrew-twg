class Twg < Formula
  require "fileutils"
  require "json"

  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.8.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.4/twg-0.8.4-darwin-arm64.tar.gz"
      sha256 "2a0849086073547f14fae5c18da848f2945c98b62d02477381151f4ef928cf8b"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.4/twg-0.8.4-darwin-x64.tar.gz"
      sha256 "f384f64f64a4eea1a12ce83da55c96b83fb957681e7a0dbd30699ff0924d0ef9"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.4/twg-0.8.4-linux-arm64.tar.gz"
      sha256 "dc9e7222a653543a364fa3cfb63332afb91dc263280af4837b243cb60080337e"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.4/twg-0.8.4-linux-x64.tar.gz"
      sha256 "511e7bf85d3af424e6ebf728b15ec567912a2e478f72808f203df68addb3b765"
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
