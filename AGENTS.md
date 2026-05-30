# Project Zomboid Modding Agent Rules

Scope: entire repository.

## Source of truth
- Primary docs: https://pzwiki.net/wiki/Modding, https://pzwiki.net/wiki/Getting_started_with_modding, https://pzwiki.net/wiki/Lua_(API), https://pzwiki.net/wiki/Mod_structure, https://pzwiki.net/wiki/Java
- API verification: PZ JavaDocs and Lua API pages linked from PZwiki.

## Hard requirements for all coding agents
- Never invent Project Zomboid classes, methods, fields, globals, or Lua events.
- Before introducing any Project Zomboid API call, verify it exists in PZwiki Lua API or JavaDocs.
- For Java modding targeting B42.13+, require Java 25 for compile and run workflows.
- Use correct call syntax:
  - Instance methods: object:method(args)
  - Static methods: ClassName.method(args)
- Do not hide unknown API errors with defensive wrappers like checking nonexistent methods to silently skip logic.
- Avoid pcall-based suppression for normal mod logic unless the user explicitly requests robust error trapping.
- Keep paths and casing aligned with mod structure docs (for Build 42, common and version folder naming are case-sensitive on some platforms).

## Implementation workflow
- Start from official structure:
  - Contents/mods/<ModId>/common/
  - Contents/mods/<ModId>/<version>/
- Lua files go under media/lua/client, media/lua/server, or media/lua/shared.
- Put mod.info in version folder(s), with at least name and id.
- For Java class overrides/experiments, compile with a command equivalent to:
  - javac -cp "<GameFiles>\\projectzomboid.jar" "<path\\to\\file.java>"

## Output standards
- When suggesting PZ API usage, include a short "Verified against" note in your response that names the source page.
- If an API is uncertain, stop and ask for clarification instead of guessing.
- For Java instructions, explicitly mention Java version expectations and the source page.
