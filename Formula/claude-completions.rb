class ClaudeCompletions < Formula
  desc "Bash and zsh tab completion for the Claude Code CLI"
  homepage "https://github.com/earchibald/claude-code-completions"
  url "https://github.com/earchibald/claude-code-completions/releases/download/v1.0.0/claude-completions-1.0.0.tar.gz"
  sha256 "9f994eda2e7156347366cd482600bb7e6851e71ecd2fdb1a64416e703fe3ddfd"
  license "MIT"
  head "https://github.com/earchibald/claude-code-completions.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install "claude-completions"
    doc.install "README.md"
    pkgshare.install "tests"
  end

  def caveats
    <<~EOS
      The completion scripts are generated from the Claude Code CLI you have
      installed, so generate them once:

        claude-completions install

      That writes into your home directory and prints the line to add to your
      shell rc. Re-run it after upgrading Claude Code; it rewrites the scripts
      only if the CLI surface actually changed.
    EOS
  end

  test do
    # The tool must run without Claude Code present.
    assert_match "claude-completions", shell_output("#{bin}/claude-completions --help")

    # The reported version must match the formula, so a stale bottle is visible.
    assert_equal version.to_s, shell_output("#{bin}/claude-completions --version").strip

    # `paths` is the machine-readable contract other scripts rely on.
    paths = shell_output("#{bin}/claude-completions paths")
    assert_match "BASH_FILE=", paths
    assert_match "ZSH_FILE=", paths

    # Generating without a claude binary must fail cleanly, not hang or crash.
    output = shell_output("CLAUDE_BIN=definitely-not-a-real-binary " \
                          "#{bin}/claude-completions install 2>&1", 1)
    assert_match "not found", output
  end
end
