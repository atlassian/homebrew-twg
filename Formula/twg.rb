class Twg < Formula
  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.0/twg-0.7.0-darwin-arm64.tar.gz"
      sha256 "aa33f817dfe7552872f214335e272c9affe78d96298280931017c0f145ab20a9"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.0/twg-0.7.0-darwin-x64.tar.gz"
      sha256 "0bee31f41f78d32a215d169b974e2c915db80bdb0543569720e5f71a336a0da7"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.0/twg-0.7.0-linux-arm64.tar.gz"
      sha256 "1fdf1c7dbbe4fdc324ef0085572072c70056093bb405741e4b5fa89e7d452eb5"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.7.0/twg-0.7.0-linux-x64.tar.gz"
      sha256 "97010a77a89789bede88f037edc91c338670dbbe25612c1db8d1b1bcd891e231"
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
