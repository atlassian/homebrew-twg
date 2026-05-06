class Twg < Formula
  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.9.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.7/twg-0.9.7-darwin-arm64.tar.gz"
      sha256 "6d9e30c4cbdecba90e075e0dc702f67e3bf35ca85743151d1afb9ab9fc2399b9"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.7/twg-0.9.7-darwin-x64.tar.gz"
      sha256 "456e45ce54c9111a631506346eb6dca2e531275b844fca1dcbc2355884f4d6ad"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.7/twg-0.9.7-linux-arm64.tar.gz"
      sha256 "81d4a5f357d25145c183c2cbb7cbfe1e57a63b137f3a1e6ce085b8124fa64aaf"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.7/twg-0.9.7-linux-x64.tar.gz"
      sha256 "8bbf69a64919c322651b97d2bb59758587a29f4edced10850f564ed6aa700cf1"
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

  def caveats
    <<~EOS
      Next steps:
        twg setup --agent

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
