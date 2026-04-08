class Twg < Formula
  require "fileutils"
  require "json"

  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.7.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.5/twg-0.7.5-darwin-arm64.tar.gz"
      sha256 "667354806f9752638ef84e99eef62033f0361394a3c9cdb2cb5b1fd1e1d0c26b"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.5/twg-0.7.5-darwin-x64.tar.gz"
      sha256 "5b714b676cc1ede4d830bfce9aaf3292f3d790f31e7255c070175bd7db4b30ec"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.5/twg-0.7.5-linux-arm64.tar.gz"
      sha256 "a5cb4aef31115df46c307305e1c396943731cb90b6ea8c69b1c0d787105f2c0d"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.5/twg-0.7.5-linux-x64.tar.gz"
      sha256 "2b9e0ce23ed714b26f537d0f7fb82554ad020e7396b995c60f2734e5bebb6c92"
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
