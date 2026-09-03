---
created: 2026-09-03
about: git shortcuts for REPL for self
---

# todo: Git shortcuts

either pipe to `fzf`, `bat`, `PowerShellRun`, `Spectre[pwsh]` ? 

- [todo: Git shortcuts](#todo-git-shortcuts)
  - [first](#first)
  - [later](#later)
  - [completion templates](#completion-templates)
    - [CompletionType keys](#completiontype-keys)
    - [CompletionType Value](#completiontype-value)

## first 

- [ ] git status
  - [ ] preview shows `diff` -> `bat`

- [ ] git add
  - [ ] `fzf` changed files, preview shows `diff` -> `bat`

- [ ] git diff
  - [ ] `fzf` changed files, preview shows `diff` -> `bat`


## later

- [ ] git log 
  - [ ] templates: auto completer patterns

- [ ] git tags
  - [ ] `fzf` tag, preview shows `git show <tag>`

## completion templates

tab completion suggestions based on context

Example for `git log`

### CompletionType keys

`--since=<date>` =>
- `--since`

### CompletionType Value

`<date>` => 
- `2.months`
- `2024-01-01`



