# Example(1): Find all commit messages matching basic grep
git.exe --no-pager log --grep="build" --oneline | rg -i 'build.*' -o

# Example(2): Select and copy message from Example(1)
git.exe --no-pager log --grep="build" --oneline | rg -i 'build.*' -o | fzf | cl -PassThru

# Example(3): grab commit message text based on exact name of message to clipboard from Example(2)
GitServe.Invoke-UGit log | ? CommitMessage -Match ([regex]::Escape('build: GitServe.psm1 v0.0.10')) | % CommitMessage | cl -Passthru
