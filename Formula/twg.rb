class Twg < Formula
  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.9.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.5/twg-0.9.5-darwin-arm64.tar.gz"
      sha256 "476c5db4a366607b6aec6c9f8114383964ec491a8dadc29d20379f60400df309"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.5/twg-0.9.5-darwin-x64.tar.gz"
      sha256 "b4dbd27c608f2a44b96eafbcd3f556a08f4b3df5c40df6017a4c78c06ed60fd3"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.5/twg-0.9.5-linux-arm64.tar.gz"
      sha256 "f8634439874a9fedbaea9ecef22ecc3b5ef09b0679b1dd0596be4c643caff37c"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.5/twg-0.9.5-linux-x64.tar.gz"
      sha256 "d91acb34bdde54f9ca55978232746cab4f3ef00939ffaf0347650131009841f8"
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
