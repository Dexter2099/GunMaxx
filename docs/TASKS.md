# GunMaxx — Tasks

High-level only. Reorder as needed; keep **Now** honest about what blocks a first playable build.

## Now

- Pick engine and repo layout; commit a **single** canonical project root.
- Implement **player**: move, aim, camera bounds, health, death.
- Implement **one gun** and **two enemy archetypes** with readable attacks.
- Build **3** test rooms in-engine; verify framerate and clarity on target resolution.
- Add **run start → room chain → end or death → restart** with no missing states.
- Define **one** inter-run progression hook (currency or single unlock track) if time permits; otherwise defer to Next.

## Next

- Expand to **MVP room count** (see `MVP.md`); light reorder or shuffle if desired.
- Add minimal **UI** (HUD, pause, game over).
- **Audio pass** — feedback for hits, deaths, room clear (even placeholder).
- **Playtest loop** — note deaths that feel unfair; fix readability before adding content.
- Lock **MVP feature freeze** and cut list.

## Later

- Additional weapons and enemies **only** if MVP criteria are met.
- Meta progression depth (more unlocks, optional branching paths).
- Polished game feel (juice, screen effects) without expanding systems.
- **ML planning implementation** per `ML_PLAN.md` after manual difficulty works.

## Cut (tempting scope creep — do not start until v1 is done)

- Full procedural level generation.
- Multiple playable characters with unique mechanics.
- Story, NPCs, hub narrative, lore logs.
- Online leaderboards, accounts, or sync.
- Companion apps, editors for players, or mod tooling.
- “Infinite” content promises — ship a **complete small game** first.
