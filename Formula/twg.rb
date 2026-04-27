class Twg < Formula
  desc "CLI wrapper for the Atlassian GraphQL Gateway API"
  homepage "https://bitbucket.org/atlassian/twg-cli"
  version "0.8.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.9/twg-0.8.9-darwin-arm64.tar.gz"
      sha256 "4e9a29f3cad4535a8e18092604a536fe42e3cde7ce0a2994fa3986b9442c2321"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.9/twg-0.8.9-darwin-x64.tar.gz"
      sha256 "a1674b76f6acceab3c90c38efa92627c1638b69cfe1268cd6370ba15080ea9d2"
    end
  end

  on_linux do
    on_arm do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.9/twg-0.8.9-linux-arm64.tar.gz"
      sha256 "c401a0cf005f738ef96e222804524a686dd26b87d224d0b8a56935ddebcf6789"
    end
    on_intel do
      url "https://teamwork-graph.atlassian.com/cli/homebrew/0.8.9/twg-0.8.9-linux-x64.tar.gz"
      sha256 "fcffabd9dae03aca8e0999bffe99bb13796cf01b2485bfc8d48a84c8f9d0c021"
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
