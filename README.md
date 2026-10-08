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

### Updating an existing installation

In Terminal, run:

```sh
claude plugin marketplace update vicaria
claude plugin update vicaria@vicaria --scope user
claude plugin list
```

Check that Vicaria is version **0.4.10** or newer, fully quit and reopen Claude
Desktop, then start a new **Code → Local** session and run `/vicaria:connect`.
Use the Code tab, not a regular Chat or Cowork conversation.

Version 0.4.10 passes locally computed command results to Claude Desktop as
normal chat replies, avoiding its hidden hook-message channel. The code comes
from the plugin on your computer; it is not sent by email. Enter that code on
the Vicaria page that opened, then run `/vicaria:status` in the same session.

Desktop needs an available Claude response to display the result. If you hit
a Claude usage limit or still see no reply, open `claude` in Terminal on the
same computer and run `/vicaria:connect` there. The terminal displays the code
locally without a model response. Approve it, then return to Desktop.

## Release and scope

This package is built by
[smart-gateway](https://github.com/vicaria-ai/smart-gateway)'s
`tools/build_plugin_marketplace.py`. Both harnesses use the bundled Python
wheels; each bundle selects its own immutable runtime. `release.json` records
the source commits and hashes of the 0.4.10 package built on 2026-10-07.
This release emits `cb.session_event.v7`.

Codex requests advice through its existing device connection while the session
is collecting. The server must provide the device advice endpoint, an active
workspace membership, and an advisor policy. Existing organization control
configurations remain authoritative. A recommendation is shown only when the
evidence supports a change; Codex model and effort recommendations are suggestions.
An unchanged decision is still recorded by the server and can be inspected in
the authorized debug view. A collected trajectory alone is not proof that a
recommendation was requested or returned.
