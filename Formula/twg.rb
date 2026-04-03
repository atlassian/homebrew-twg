class Twg < Formula
  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.7.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.3/twg-0.7.3-darwin-arm64.tar.gz"
      sha256 "b032984d8a04f6460d8baa0e7f2f9439b1aaed23e3937e3a699bb4b1dee2b680"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.3/twg-0.7.3-darwin-x64.tar.gz"
      sha256 "a09c00b4ff5406a5a7a00de26d1f30cfeac93e9299c46fb4bc05ffc2ec99dd99"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.3/twg-0.7.3-linux-arm64.tar.gz"
      sha256 "a966feddb940cd75bea08130cb730f54f6e154e1bdd31d47ceca404885989393"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.3/twg-0.7.3-linux-x64.tar.gz"
      sha256 "ed1293fdc081c0e4cd5ba6af523d24814fdda299ec34e8e91d6d83f151b353d8"
    end
  end

  def install
    bin.install "twg"
  end

  def caveats
    <<~EOS
      Next steps:
        twg skills install --global --yes
        twg login
    EOS
  end

  test do
    output = shell_output("#{bin}/twg doctor -o json")
    assert_match "\"command\": \"doctor.get\"", output
    assert_match version.to_s, output
  end
end
