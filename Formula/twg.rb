class Twg < Formula
  require "fileutils"
  require "json"

  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.7.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.4/twg-0.7.4-darwin-arm64.tar.gz"
      sha256 "b7180a84428d038074206c7c63ee797e366c1d317646800730154f4b2a3be27e"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.4/twg-0.7.4-darwin-x64.tar.gz"
      sha256 "0b5f22d253b80c7574b79913704c66f68fd14394324288fa43f21ce47eb6ca2f"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.4/twg-0.7.4-linux-arm64.tar.gz"
      sha256 "8c6ea6bba6c419d11c9b5d6eecfc75643fef9137f2829bc12baefc186daed03c"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.4/twg-0.7.4-linux-x64.tar.gz"
      sha256 "144a999c69d56b5edfec175bb8da2004d9a3565c45f749fa9a8533840ba750f3"
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
