# Vicaria for Claude Code

Vicaria records your Claude Code sessions — every prompt, every step the agent
took with what it was given and what came back, every reply, your thumbs and
your answers — and shows them to you at https://app.vicaria.ai as tasks.
Nothing is redacted. You can pause a session, and delete anything you sent.

Three lines, typed in Claude Code:

```
/plugin marketplace add vicaria-ai/vicaria-plugins
/plugin install vicaria@vicaria
/vicaria:connect
```

The last one shows a code; approve it at https://app.vicaria.ai, signed in.
Then work as usual.

- `/vicaria:off` pauses a session; `/vicaria:on` resumes it.
- `/vicaria:feedback up` or `down`, with a comment, marks the last reply.
- `/vicaria:yes`, `/vicaria:partly`, `/vicaria:no` answer the question a
  session start asks about your last task.
- `/vicaria:status` says what this computer holds.

The plugin here is built from [smart-gateway](https://github.com/vicaria-ai/smart-gateway)
(`tools/build_plugin_marketplace.py`); each release names the commit it was
built from in `plugins/vicaria/.claude-plugin/plugin.json`.
