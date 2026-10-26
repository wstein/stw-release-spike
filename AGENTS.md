# Spike agent policy

Throwaway repository for rehearsing the stw release flow. Write all English text in US spelling.
Agents push only their own topic branches and open pull requests; the owner merges, tags and releases.
Stacks are at most two levels deep; restack with `git rebase --onto <new parent> <old parent> <branch>`
and push with `--force-with-lease=<ref>:<observed full SHA>`. Use Conventional Commits.
Run `go vet ./...` and `go test ./...` before every push.
