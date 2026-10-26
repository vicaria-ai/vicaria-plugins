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

- `vicaria status` reports the connection, local capture queue and the matching turn reports for your last applied configuration.
- `vicaria apply` previews a saved suggestion; `vicaria apply yes <code>` applies it to user defaults for new sessions.
- `vicaria apply undo` works locally, even after unlinking. If an interrupted operation has mixed managed settings, `vicaria apply recover` previews a confirmation-bound discard option.
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
Use `/vicaria:apply` to preview a saved suggestion, `/vicaria:apply yes <code>` to apply the exact preview, and `/vicaria:apply undo` to restore previous values. Start a new session after applying.

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

Check that Vicaria is version **0.4.21** or newer, fully quit and reopen Claude
Desktop, then start a new **Code → Local** session and run `/vicaria:connect`.
Use the Code tab, not a regular Chat or Cowork conversation.

Version 0.4.10 passes locally computed command results to Claude Desktop as
normal chat replies, avoiding its hidden hook-message channel. The code comes
from the plugin on your computer; it is not sent by email. Enter that code on
the Vicaria page that opened, then run `/vicaria:status` in the same session.

Version 0.4.11 keeps displaying a command from automatically starting capture.
After approval, `/vicaria:status` can truthfully report that this session is not
collecting yet; your next ordinary task prompt starts it under your existing
consent. An explicit pause stays in effect until `/vicaria:on`.

Version 0.4.12 keeps a background task's completion notice from being lost. Claude Code
delivers that notice with the id of the prompt that started the task, and earlier versions
sent both messages under one event id, so the service refused the notice. The first message
keeps the id; later ones get their own.

Version 0.4.13 keeps more of a session when the service has a bad moment. A session start
that cannot reach the service, or gets a 502, 503 or 504, tries once more, and your next
prompt tries again at once rather than a minute later. A document the service asks to
retry (its disk was full, or it was busy) stays queued instead of being set aside. And one
document the service refuses for its content no longer holds up every upload behind it:
the others are sent one at a time, and opting out stops that sending at once.

Desktop needs an available Claude response to display the result. If you hit
a Claude usage limit or still see no reply, open `claude` in Terminal on the
same computer and run `/vicaria:connect` there. The terminal displays the code
locally without a model response. Approve it, then return to Desktop.

Version 0.4.17 improves capture recovery after slow uploads and interrupted sessions.
Captured text containing U+0000 is recorded with U+FFFD, with explicit replacement
metadata; IDs and protocol fields are unchanged. Older queued events receive the
same repair before upload. A confirmed document refusal is retained locally with
its receipt so valid events can continue. Existing connections are kept. Backlog
uploads still need later hooks and remain limited by server response times.

Version 0.4.18 speeds up automatic backlog uploads by reading the oldest 500 queued
events per background pass and reducing the minimum pause between requests from
five seconds to one. Requests still contain at most ten events. Claude Code also
recognizes the effort and lesson a session received after apply, so those settings
are not suggested again. End-of-session and command-line flushes keep their full
queue behavior. Headless-session handoff and update notices are deferred.

Version 0.4.19 keeps a cancelled session-end upload from leaving a synthetic
failure that delays later uploads. A background pass that runs out of time while
the service is accepting events can continue with another pass after its cooldown,
for up to 15 minutes from launch. Failures, opt-out and session-end priority still
stop the chain. Actual backlog drain depends on upload time and incoming volume.

Version 0.4.20 lets an active background upload chain pause for a session-end
upload and continue afterward. It waits without holding the upload lock until
all session-end senders have exited, then respects the latest saved cooldown.
The original 15-minute cap still applies; outages, opt-out and the disable switch
still stop further uploads. Actual backlog drain depends on incoming volume,
upload time and later hooks launching another chain.

Version 0.4.21 records, on each reply, the model and the reasoning effort the harness
recorded for it (`cb.session_event.v8`). Claude Code reads both from that reply's own
records in the session transcript; Codex reads them from the settings record of the
reply's own turn, matched by turn id. A value the harness did not record is sent as
missing with its reason, never guessed. The command-line capture notices for Claude
Code and Codex now name the model and the effort, so a computer that confirmed capture
from the command line is asked once more.

## Release and scope

This package is built by
[smart-gateway](https://github.com/vicaria-ai/smart-gateway)'s
`tools/build_plugin_marketplace.py`. Both harnesses use the bundled Python
wheels; each bundle selects its own immutable runtime. `release.json` records the source commits and hashes of the 0.4.21 package, built on 2026-10-26.
This release emits `cb.session_event.v8`; the service accepts it since 2026-10-25.

Both harnesses request configuration suggestions through their existing device connection while collecting. A supported response may propose model, effort and a working lesson. Configured test arms are labeled **configured**; they are not evidence-backed recommendations. An unchanged or refused decision does not authorize a settings change, and a policy refusal is displayed with the allowed models.

Apply always requires a preview and explicit confirmation. It changes native user settings for the next session, preserves provider/authentication and unrelated settings, and retains private local undo information. Project/profile/command-line overrides may win; status reports what the matching session or turn actually reports. Model/effort reports and lesson delivery are distinguished from provider-request evidence: matching reports do not prove the request body. Codex's recovery journal contains local configuration backups at 0600; it is not uploaded as raw capture telemetry.

Version 0.4.17 integrates recommendation display and explicit apply/undo/status for Claude Code and Codex on the current shared client core. It also includes the previously merged capture/SDK work from source main; this package still emits `cb.session_event.v7`. Applying a configured arm proves the mechanism, not that it improves task quality.
