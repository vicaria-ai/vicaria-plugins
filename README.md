# Vicaria for Codex and Claude Code

Vicaria records your coding sessions under the consent you gave on the website
and shows their trajectories and analysis at <https://app.vicaria.ai>.
Nothing is redacted. You can pause a session and delete what you sent.

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

Type these in Claude Code:

```text
/plugin marketplace add vicaria-ai/vicaria-plugins
/plugin install vicaria@vicaria
/vicaria:connect
```

Approve the displayed code at <https://app.vicaria.ai>, then work as usual.
The controls are `/vicaria:status`, `/vicaria:off`, `/vicaria:on`,
`/vicaria:feedback`, `/vicaria:yes`, `/vicaria:partly`, and `/vicaria:no`.

## Release and scope

This package is built by
[smart-gateway](https://github.com/vicaria-ai/smart-gateway)'s
`tools/build_plugin_marketplace.py`. Both harnesses use the bundled Python
wheels; each bundle selects its own immutable runtime. `release.json` records
the hashes of the 0.4.8 package verified on 2026-10-07.

Connecting enables capture. Live configuration advice additionally requires an
advisor connection and supported evidence; this package alone does not provision
the personal device-to-advisor path. A collected trajectory is not proof that a
recommendation was requested or returned.
