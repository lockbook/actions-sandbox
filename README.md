# actions-sandbox

Hosted test workflows for [token-sink](https://github.com/lockbook/token-sink) QA runs against [lockbook](https://github.com/lockbook/lockbook). Free standard runners only.

## lb-rs tests

Starts a local lockbook server and runs `cargo test -p lb-rs` against a pinned lockbook revision.

```
gh workflow run lb-rs-tests.yml -R lockbook/actions-sandbox -f ref=<sha|branch> [-f filter=<test name>] [-f patch=patches/<name>.patch]
```

- `ref`: lockbook ref to test. Use a commit SHA so the run is reproducible.
- `filter`: forwarded to `cargo test`, so only matching test names run.
- `patch`: a file in `patches/` applied to the lockbook checkout before building. Put minimal failing tests for reproductions there.

Save the run URL immediately after dispatch and record it in the token-sink findings note.

## cli smoke

Builds the `lockbook` CLI, creates a throwaway account on the local server, writes a few files, and prints every `lockbook list` variant through `cat -A` so whitespace and line endings are visible. Then pipes `list` output into `cat` and `edit` (with `scripts/append-editor.sh` as a non-interactive editor).

```
gh workflow run cli-smoke.yml -R lockbook/actions-sandbox -f ref=<sha|branch>
```

## server tests

Starts a local lockbook server, then runs `cargo test -p lockbook-server --no-fail-fast` and `cargo test -p test_utils --no-fail-fast` with `server/local.env` exported. The server log is uploaded as the `server-log` artifact.

```
gh workflow run server-tests.yml -R lockbook/actions-sandbox -f ref=<sha|branch>
```

## cli smoke windows

Same idea as `cli smoke` but on `windows-latest` with PowerShell steps. Builds the CLI and a release server (with `RUSTFLAGS=-l advapi32`, which the server's shadow-rs/libgit2 build script needs to link on MSVC), then in a single step starts the server directly (lbdev's `ci start-server` relies on `fuser` and `/tmp`), polls `/get-build-info` until it answers, creates an account, writes a file, runs `list`, `cat`, `sync`, and `account status`, and stops the server in a `finally`. The server lives in the same step because the Windows runner kills a step's process tree when the step ends. Server stdout, stderr, and `lockbook_server.log` are uploaded as the `server-log` artifact.

```
gh workflow run cli-smoke-windows.yml -R lockbook/actions-sandbox -f ref=<sha|branch>
```

## headless tests

No server and no system packages. Runs `cargo test --no-fail-fast` for `workspace`, `lockbook-desktop`, `lockbook` (cli), and `test_utils`, one step per package with `continue-on-error` so every package reports; a final step fails the job if any package failed and writes the per-package outcome to the step summary.

```
gh workflow run headless-tests.yml -R lockbook/actions-sandbox -f ref=<sha|branch>
```
