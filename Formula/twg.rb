class Twg < Formula
  require "fileutils"
  require "json"

  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.8.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.1/twg-0.8.1-darwin-arm64.tar.gz"
      sha256 "1643c7c71ea1b9f78251f5c5e35900f1e6872d2b76a9151c51db0e7de4669a96"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.1/twg-0.8.1-darwin-x64.tar.gz"
      sha256 "5f2f9b3b374716fa328d23028f692736cdc33aed6acb208c127bf2309f2ec937"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.1/twg-0.8.1-linux-arm64.tar.gz"
      sha256 "f99d60bcff1715821222b756bd22a4998489c10ae591bdef9e13f2548d228b0c"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.1/twg-0.8.1-linux-x64.tar.gz"
      sha256 "8942f4c4580c905d1db454d66835952db0afd4ec3e80efdb65242953a4f0977d"
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
