# Copilot Instructions for Project Zomboid Modding

This repository is for Project Zomboid modding.

## Mandatory behavior
- Use official PZwiki pages as the first reference:
  - https://pzwiki.net/wiki/Modding
  - https://pzwiki.net/wiki/Getting_started_with_modding
  - https://pzwiki.net/wiki/Mod_structure
  - https://pzwiki.net/wiki/Lua_(API)
  - https://pzwiki.net/wiki/Java
- For API details, verify against linked JavaDocs before writing code that calls PZ objects.
- Do not hallucinate API methods, events, fields, or globals.
- If a method/event cannot be verified, do not write it as working code.
- For Build 42.13+ Java workflows, use Java 25.

## Lua API usage rules
- Use colon for instance methods and dot for static methods.
- Prefer event-driven entry points documented on PZwiki Lua event pages.
- Keep multiplayer context in mind when placing files:
  - media/lua/client
  - media/lua/server
  - media/lua/shared

## Structure rules
- Keep Build 42 layout:
  - Contents/mods/<ModId>/common/media
  - Contents/mods/<ModId>/<version>/media
  - mod.info in version folder
- Preserve exact folder casing.

## Java rules (B42.13+)
- Require JDK 25 for compile/run tasks.
- Use compile command pattern:
  - javac -cp "<GameFiles>\\projectzomboid.jar" "<path\\to\\file.java>"
- Keep Java instructions aligned with the wiki Java page and JavaDocs.

## Safety rules
- Do not add fake compatibility code that swallows errors for nonexistent methods.
- Do not use pcall as a default workaround for unknown API behavior.
- Explain which page/docs were used when adding new API-dependent code.
