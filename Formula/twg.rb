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
      sha256 "e911670c590326733bda8dde7f6ed61f449ad74784304ea33e4356409b2179ff"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.7/twg-0.7.7-darwin-x64.tar.gz"
      sha256 "9e8d969c90bcfafb460460f018ba344f435f42de0cb58dee1077ea29e82ba9df"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.7/twg-0.7.7-linux-arm64.tar.gz"
      sha256 "a4625302ac30a333d33c9b90008eecdf2b7d536fe81c5dc380e05de10793912e"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.7/twg-0.7.7-linux-x64.tar.gz"
      sha256 "5cabc8bfe9ab68f10d6061290cc67ebe1381f04824ca301abb57c0bad38e4341"
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
