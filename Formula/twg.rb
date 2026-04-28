class Twg < Formula
  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.9.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.0/twg-0.9.0-darwin-arm64.tar.gz"
      sha256 "8bd1e285d09d236cbe4d04e0caf51f2111e0bee56f750ff5ed20fcf36bc3aef9"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.0/twg-0.9.0-darwin-x64.tar.gz"
      sha256 "0033297cfb7122e036508fb4cc30bd6739e4ced52da56e7e71cdc0aa7857236b"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.0/twg-0.9.0-linux-arm64.tar.gz"
      sha256 "10a3ee30033973675079768b6681dbf8cb78f4d59242eed5aec321769f5b0e2a"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.0/twg-0.9.0-linux-x64.tar.gz"
      sha256 "019e2ac9d2a13a98224290f3ea634da9ce49e0c66e1394ea631435241932aa04"
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
