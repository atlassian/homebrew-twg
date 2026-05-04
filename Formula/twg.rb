class Twg < Formula
  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.9.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.2/twg-0.9.2-darwin-arm64.tar.gz"
      sha256 "66fc6ab19d785d6f88eaeafb872de4ce0f7b7c09af7f081b9975ba4a41c737fa"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.2/twg-0.9.2-darwin-x64.tar.gz"
      sha256 "e3663efb86454660bfb266d89346ef0905edc5a90a00301f13afa0f862d22e05"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.2/twg-0.9.2-linux-arm64.tar.gz"
      sha256 "dfb3e8e05a6e4f212e1e9ec3deaed888f50bba62702742976736c67ef596e08d"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.2/twg-0.9.2-linux-x64.tar.gz"
      sha256 "36e4baeccb09e60641bd7127e1c2a46cf9b74481fa56e8fb03a27f7c9223ab54"
    end
  end

  def install
    libexec.install "twg-bin"
    (bin/"twg").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      for name in "${!BUN_@}"; do
        unset "$name"
      done
      exec "#{libexec}/twg-bin" "$@"
    EOS
    chmod 0755, bin/"twg"
  end

  def post_install
    system bin/"twg", "consent", "--agree", "--source", "homebrew"
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
