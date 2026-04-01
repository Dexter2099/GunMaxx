# GunMaxx

**GunMaxx** is a solo-developed **2D top-down action roguelite**: fast room clearing, high lethality, and short runs with light meta progression. Design target is a cross of **Hotline Miami** (pace, trial-and-error mastery) and **Enter the Gungeon** (gun-forward combat, roguelite structure).

## Constraints

- **Offline only** — No required network for gameplay or progression.
- **Single-player only.**

## Documentation

| File | Purpose |
|------|---------|
| [ONE_PAGER.md](ONE_PAGER.md) | Fantasy, pillars, inspirations, hard constraints |
| [MVP.md](MVP.md) | First shippable prototype scope and exclusions |
| [CORE_LOOP.md](CORE_LOOP.md) | Mechanical loop: moment-to-moment through rewards |
| [ML_PLAN.md](ML_PLAN.md) | Post–core-loop offline ML direction (adaptive pacing) |
| [TASKS.md](TASKS.md) | Now / Next / Later / Cut |
| [DECISIONS.md](DECISIONS.md) | Decision log (append-only) |

## Stack

- **Game engine:** TBD (2D-capable; choice driven by workflow and export targets).
- **Language/tooling:** Follows engine choice.
- **ML (later):** Local/offline only; see `ML_PLAN.md`. No production dependency until core gameplay is validated.

## Current goals

1. Prove **movement + shooting + room flow + fail/retry** in a minimal vertical slice.
2. Hit **MVP** criteria in `MVP.md` with a fixed, finite room set and two enemy archetypes.
3. Avoid scope creep; prefer **cuts** over parallel systems.

## Planned ML angle 

After manual tuning works: **offline adaptive difficulty / pacing** — selecting among designer-bounded parameter presets from session signals. No reinforcement learning in the shipping hot path, no LLM content, no “smart AI” as a marketing substitute for hand-tuned enemies.

## Project status

**Early setup.** Design docs and repo scaffolding; core playable slice and engine choice tracked in `TASKS.md` (Now).

## License

TBD.
