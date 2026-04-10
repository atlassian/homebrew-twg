class Twg < Formula
  require "fileutils"
  require "json"

  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.7.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.8/twg-0.7.8-darwin-arm64.tar.gz"
      sha256 "5dd69a3f9aa054afac6b4a2d183806c2451a300d68e3e2739ec191939eda86cb"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.8/twg-0.7.8-darwin-x64.tar.gz"
      sha256 "c7f54d02a3e2ce93cdbfbfbc73aa3c7151c1e121453fde18ed21974cbc769a87"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.8/twg-0.7.8-linux-arm64.tar.gz"
      sha256 "7bec3186dfbe5099816784f64f086010655b33bab553cc8e242085631236233f"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.8/twg-0.7.8-linux-x64.tar.gz"
      sha256 "ac7f0bab3f172985627bbcdfd8afff19b1fd242014145c8aae6c40298ac1217f"
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
