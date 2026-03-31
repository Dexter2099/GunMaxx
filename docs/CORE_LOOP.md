# GunMaxx — Core Loop

Mechanical description only — no story framing.

## Moment-to-moment

- Player **positions** in a constrained arena while **enemies apply pressure** (movement, projectiles, timing).
- Player **uses weapons** to reduce threats; resource friction (reload, swap, heat, or ammo — exact model is implementation detail) creates pacing between bursts of damage.
- **Damage is high** relative to health; the primary skill is **avoidance and target order**, not tanking.
- Feedback is immediate: hit reactions, death, and room state reset on run failure.

## Room-to-room

- Completing a room **clears threats** and **opens the exit** (door, portal, or explicit transition).
- Between rooms, the player may receive **pickups** (health, weapon, or modifier) according to the reward rules for that segment of the run.
- Room order may be **fixed** or **lightly varied** (shuffle of a handcrafted pool); MVP favors fixed or simple shuffle for predictability.

## Run-level progression

- A **run** is a contiguous sequence of rooms from start to end condition (clear final gate or die).
- **Variance** within a run comes from pickup order, optional room branches if any, and enemy density or composition if tuned per segment — kept minimal in MVP.
- **Meta progression** (between runs) unlocks content or options slowly; it must not replace skill at clearing rooms.

## Fail state and retry

- **Death** ends the run immediately (no mid-run checkpoints unless explicitly added later).
- Player returns to **hub or menu**; restart is **one clear action** from game-over.
- Retry goal: **short path back into combat** with lessons intact, not grinding unrelated systems.

## Reward structure (high level)

- **Intra-run** — Surviving rooms and optional risk (e.g. harder room for better pickup) trades safety for power.
- **Inter-run** — Sparse unlocks or currency that widen options without invalidating skill (new weapon in pool, not raw stat inflation only).

This document stays stable when art and exact numbers change; it defines **structure**, not tuning.
