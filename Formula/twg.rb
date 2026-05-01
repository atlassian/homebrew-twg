class Twg < Formula
  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.9.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.1/twg-0.9.1-darwin-arm64.tar.gz"
      sha256 "432512c6f1ffda7bce60ea2409ed42acaf89369992a00e8457fcf438a1336bd5"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.1/twg-0.9.1-darwin-x64.tar.gz"
      sha256 "08560155e9392f99b939718c06924326f5bee43113442b6b0130430427404e59"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.1/twg-0.9.1-linux-arm64.tar.gz"
      sha256 "a3a001b525c408ee1cf1cc258e13d001121d8a4e58b7898a3f0fed5575a23db1"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.9.1/twg-0.9.1-linux-x64.tar.gz"
      sha256 "cc97d4758b2985ed3e343e8aa0b9ad0f80bec46cb256a81ea919949b7b4033ea"
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
