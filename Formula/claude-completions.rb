class ClaudeCompletions < Formula
  desc "Bash and zsh tab completion for the Claude Code CLI"
  homepage "https://github.com/earchibald/claude-code-completions"
  url "https://github.com/earchibald/claude-code-completions/releases/download/v1.0.3/claude-completions-1.0.3.tar.gz"
  sha256 "0118708860227e17f6b5eaf9eb6eb4d89b77dc3ac92d0b8147dee68d9d705076"
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

    # Completion for this tool itself. The `claude` completions are generated
    # later, by `claude-completions install`, since they depend on which Claude
    # Code the user has.
    # The default parameter format appends the bare shell name, which gives
    # `claude-completions completions bash`.
    generate_completions_from_executable(bin/"claude-completions", "completions",
                                         shells: [:bash, :zsh])
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

    # Self-completion must be emitted for both shells.
    assert_match "complete -F _claude_completions",
                 shell_output("#{bin}/claude-completions completions bash")
    assert_match "compdef", shell_output("#{bin}/claude-completions completions zsh")

    # Generating without a claude binary must fail cleanly, not hang or crash.
    output = shell_output("CLAUDE_BIN=definitely-not-a-real-binary " \
                          "#{bin}/claude-completions install 2>&1", 1)
    assert_match "not found", output
  end
end
