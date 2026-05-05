class Twg < Formula
  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.9.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.4/twg-0.9.4-darwin-arm64.tar.gz"
      sha256 "06d508966c5c3812b1c2b4e990a1efd0ade19a6bde91f10974657148323c0d73"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.4/twg-0.9.4-darwin-x64.tar.gz"
      sha256 "45a63253f134acacf73598756a93851e6e1b72330d40c1a8e0e48cee5494777a"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.4/twg-0.9.4-linux-arm64.tar.gz"
      sha256 "d32d7f4bb15a46fd26229d14c1d8d025f7296e5a90c7d4cd6790a322575c8fb3"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.4/twg-0.9.4-linux-x64.tar.gz"
      sha256 "b643ff0dc94f4d317d850770d73827b22fd982483cb867c95333a56cf8c1109b"
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
