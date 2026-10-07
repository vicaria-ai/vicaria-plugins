# Vicaria for Codex and Claude Code

Vicaria records your coding sessions under the consent you gave on the website
and shows their trajectories and analysis at <https://app.vicaria.ai>.
Nothing is redacted. You can pause a session and delete what you sent.

Website access is invitation-only. Sign in at <https://app.vicaria.ai> with the
Google account whose email was invited. You do not need a separate invitation
link. Install the plugin on the computer where you run your coding agent.

## Codex

Install from your terminal:

```sh
codex plugin marketplace add vicaria-ai/vicaria-plugins
codex plugin add vicaria@vicaria
```

Start a new Codex session, review and trust the Vicaria hooks, then type this as
a prompt:

```text
vicaria connect https://app.vicaria.ai
```

Approve the displayed code in the browser when linking a new computer. An
already linked computer keeps its connection. Continue with an ordinary task.

- `vicaria status` reports the connection and local capture queue.
- `vicaria off` pauses this session; `vicaria on` resumes it.
- `vicaria feedback up` or `down`, optionally followed by a comment, marks a reply.
- `vicaria yes`, `vicaria partly`, and `vicaria no` answer the task-outcome question.

Codex commands are plain prompts. Claude Code uses the slash commands below.

## Claude Code

Type these in a local Claude Code session, one at a time:

```text
/plugin marketplace add vicaria-ai/vicaria-plugins
/plugin install vicaria@vicaria
```

Opening Claude Code's plugin panel is expected. Adding the marketplace registers
Vicaria's catalog; it does not install the plugin. Select **Vicaria** and choose
**Install for you**. Follow any reload prompt, or start a new session.

If the panel is confusing, the equivalent terminal commands install directly:

```sh
claude plugin marketplace add vicaria-ai/vicaria-plugins
claude plugin install vicaria@vicaria --scope user
claude plugin list
```

Then type `/vicaria:connect` in Claude Code. Approve the displayed code at
<https://app.vicaria.ai> while signed in with your invited Google account. Your
next prompt completes the connection; `/vicaria:status` checks it. Captured tasks
appear on the website after you work with the agent.
The controls are `/vicaria:status`, `/vicaria:off`, `/vicaria:on`,
`/vicaria:feedback`, `/vicaria:yes`, `/vicaria:partly`, and `/vicaria:no`.

These instructions use the local Claude Code terminal, desktop, or IDE session.
Claude's cloud sessions do not load plugins installed on your computer. See
[Claude Code's installation guide](https://code.claude.com/docs/en/discover-plugins).

## Release and scope

This package is built by
[smart-gateway](https://github.com/vicaria-ai/smart-gateway)'s
`tools/build_plugin_marketplace.py`. Both harnesses use the bundled Python
wheels; each bundle selects its own immutable runtime. `release.json` records
the hashes of the 0.4.8 package verified on 2026-10-07.

An independent rebuild on 2026-10-07 verified that every file inside both wheels
matches client commit `d93d1e961d33d698e0a718970fc711c92cc6dd11` and contracts commit
`26dbd0ef90dc5acfe9d82bb69b52005b62c12287`. This release emits
`cb.session_event.v6`.

Connecting enables capture. Live configuration advice additionally requires an
advisor connection and supported evidence; this package alone does not provision
the personal device-to-advisor path. A collected trajectory is not proof that a
recommendation was requested or returned.
