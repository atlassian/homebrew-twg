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
      sha256 "0cef4330db9e3e6886e3175f0a62a263f7bd903a219979b784a6ef0ab2c2ee6c"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.6/twg-0.8.6-darwin-x64.tar.gz"
      sha256 "86635d79afb1cca7260cfc1dee22c8248a5999c20e9d9cbfcc98b12e0950a055"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.6/twg-0.8.6-linux-arm64.tar.gz"
      sha256 "a4a3d2da8957a3317fcd5b5110783de77559da58e2170d79b3800c2550a33a24"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.6/twg-0.8.6-linux-x64.tar.gz"
      sha256 "5fbb13ff78872dccfabf81c328588dad8ab388156e332ac63bf001520c73e136"
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
