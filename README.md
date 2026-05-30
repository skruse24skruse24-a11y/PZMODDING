# Project Zomboid Modding Workspace (Build 42)

This workspace is scaffolded as a local Workshop-style mod project using the official wiki guidance.

## Created structure

- Contents/mods/MyFirstPZMod/common/media
- Contents/mods/MyFirstPZMod/42/mod.info
- Contents/mods/MyFirstPZMod/42/media/lua/client/MyFirstPZMod/Bootstrap.lua
- Contents/mods/MyFirstPZMod/42/media/lua/server/MyFirstPZMod/Bootstrap.lua
- Contents/mods/MyFirstPZMod/42/media/lua/shared/MyFirstPZMod/Bootstrap.lua
- workshop.txt
- AGENTS.md
- .github/copilot-instructions.md

## Why this structure

- Build 42 expects a common/versioned folder layout.
- At least one common or version folder must exist for recognition.
- Lua scripts should be separated into client/server/shared folders.

References:
- https://pzwiki.net/wiki/Modding
- https://pzwiki.net/wiki/Getting_started_with_modding
- https://pzwiki.net/wiki/Mod_structure
- https://pzwiki.net/wiki/Lua_(API)
- https://pzwiki.net/wiki/Java
- https://pzwiki.net/wiki/Mod.info
- https://pzwiki.net/wiki/Workshop.txt

## Java modding note (B42.13+)

- Project Zomboid uses Java 25 as of B42.13.
- Compile Java files against `projectzomboid.jar` using:

```powershell
javac -cp "GameFiles\projectzomboid.jar" "path\file.java"
```

- Replace `GameFiles` with your Project Zomboid game files path.
- Replace `path\\file.java` with the Java file you want to compile.

## Next edits you should make

1. Rename MyFirstPZMod folder to your real mod ID/name.
2. Update mod metadata in Contents/mods/MyFirstPZMod/42/mod.info.
3. Replace workshop.txt title/description/tags with your values.
4. Add a preview image (256x256) as preview.png at repository root if you plan to upload.
5. Add your actual mod logic under the existing lua folders.

## Important

Agent instruction files are configured to force API verification against PZwiki and JavaDocs before adding Project Zomboid API calls.

## Rough prototype status

The shared Lua prototype loop is now implemented for:

1. Glowing initiator selection (first observed zombie in update loop).
2. Swarm collection (up to configured cap).
3. Initiator conversion to Nest Heart after configured ticks.
4. Timed zombie absorption into biomass.
5. Heart stage progression based on biomass.
6. Abstract nest expansion (cell count growth from biomass spend).
7. Structure unlock/build milestones (Storage Cell, Pod I, Deconstructor).

### Debug helpers (Lua console)

The bootstrap exposes a debug table:

```lua
MyFirstPZModDebug.getSnapshot()
MyFirstPZModDebug.addBiomass(50)
MyFirstPZModDebug.reset()
```

Use `getSnapshot()` repeatedly to confirm the prototype lifecycle is advancing.
