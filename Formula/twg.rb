class Twg < Formula
  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.9.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.6/twg-0.9.6-darwin-arm64.tar.gz"
      sha256 "f0587f0cbc6a27e7ca761a0735d9176dc4b1a3c6bae924d9efdc9deeac26ab9c"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.6/twg-0.9.6-darwin-x64.tar.gz"
      sha256 "471348c8268f8bc7a59e2173dfdb382cdb1143c2a91288d0dbc5c6c097a45a9b"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.6/twg-0.9.6-linux-arm64.tar.gz"
      sha256 "239416aa9afdd1377c22b728f9ac5d7cf82e072bde744d00de5228bb6d49105a"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.6/twg-0.9.6-linux-x64.tar.gz"
      sha256 "d81c7c10f5d0d09d8ed598dc6cc05ae2b82d31aa40270d42de0925a1ec1e6dc5"
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
