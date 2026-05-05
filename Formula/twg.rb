class Twg < Formula
  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.9.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.3/twg-0.9.3-darwin-arm64.tar.gz"
      sha256 "31c12661c1f0201bda76524db05211c6f973c250e8c64d1d904056d8ec459617"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.3/twg-0.9.3-darwin-x64.tar.gz"
      sha256 "b1cc99e4e4e58464c0837723643c16791f3beac05a6c0e6dc4aec3cc2aa976f2"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.3/twg-0.9.3-linux-arm64.tar.gz"
      sha256 "eea1a6bd21435954f76daa656d4a86a4f0e4f15d66d6f0822957ad23819ba571"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.3/twg-0.9.3-linux-x64.tar.gz"
      sha256 "35d0ca08ff33a19a1e98cbf36075b958472089db995dc5b5ab25e2bdd5d2a055"
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
