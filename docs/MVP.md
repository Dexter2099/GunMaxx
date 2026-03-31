# GunMaxx — MVP (First Shippable Prototype)

## Purpose

Validate that **movement + shooting + room flow + one death-and-retry cycle** is fun before adding breadth. The MVP is a **vertical slice**, not a mini full game.

## Included in MVP

- **Core combat** — Move, aim, shoot, reload or equivalent friction; health; basic enemy types (e.g. melee rusher, ranged grunt) kept to **two** distinct patterns.
- **Room format** — Single-screen or small bounded arenas; **handcrafted** set of **8–12** rooms, reused in a simple sequence or light shuffle.
- **Run container** — Start run → clear rooms in order (or fixed graph) → **boss or exit** as a single simple gate (can be a heavy enemy room, not a multi-phase boss).
- **Fail and retry** — Death ends run; player returns to hub or menu; **one** meta currency or unlock (optional but recommended to test progression feel).
- **Minimal UI** — Health, ammo or weapon indicator, pause, restart.

## Explicitly excluded from MVP

- Procedural generation beyond light room reorder or seed shuffle.
- Narrative, cutscenes, dialogue, lore collectibles.
- More than **two** enemy archetypes plus a simple “gate” encounter.
- Shops, crafting, deep inventory, multiple characters.
- Achievements, cloud saves, cosmetics, DLC hooks.
- **Any** ML-driven systems (see `ML_PLAN.md` — after core loop works).

## MVP success criteria

1. **60-second test** — A new player understands move, shoot, and why they died within one minute of play.
2. **Retry hook** — After a death, starting again feels faster than quitting (low friction restart, readable failure).
3. **Room clarity** — In any MVP room, the player can name what killed them without guessing.
4. **Scope held** — MVP ships as a **finite** build (listed room count, fixed feature set), not an open-ended checklist.

## Principle

If something does not serve the first playable loop, it is **out** until post-MVP.
