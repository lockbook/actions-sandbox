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
