class Twg < Formula
  require "fileutils"
  require "json"

  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.7.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.9/twg-0.7.9-darwin-arm64.tar.gz"
      sha256 "736e7155a62d476f3f1c500f2f4fc10ed1e094cd6d5550ddc696884ffcf94192"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.9/twg-0.7.9-darwin-x64.tar.gz"
      sha256 "eb83cf248bd1611fe712048bbf49d802be38d85230ce90a023f20ae11139c600"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.9/twg-0.7.9-linux-arm64.tar.gz"
      sha256 "6529d5351e444788c23d0b497f5144a258056334a90ab58ac91a80c54c4ebf7b"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.9/twg-0.7.9-linux-x64.tar.gz"
      sha256 "8c101d39c0c7e837b4f34cfe828a357f48bc2939976bf79346c39e8c01ae527f"
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
