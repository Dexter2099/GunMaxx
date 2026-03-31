# GunMaxx — ML Plan (Offline, Post–Core Loop)

## Status

**Not part of MVP.** Machine learning is added only after the core loop is **fun without** ML. Until then, this file is planning only.

## One ML problem (chosen)

**Adaptive difficulty / pacing via run-level parameter selection.**

The game adjusts **a small set of run parameters** (e.g. enemy count caps, spawn pacing, pickup availability weights) based on **observed player performance**, so runs stay in a target band of challenge — neither trivial nor repeatedly hopeless — without requiring the player to open a menu.

## Why this use is justified

- **Measurable inputs and outputs** — Performance signals (time-to-clear, damage taken, deaths per room) map to a few discrete tuning knobs. This is a supervised / bandit-style problem, not open-ended “AI.”
- **Offline and local** — Models or rules can live on disk; training can use **logged play sessions** from this machine only (no cloud, no PII requirement).
- **Resume-worthy** — Shows applied ML judgment: problem framing, feature design, evaluation, and iteration — not a demo of buzzwords.
- **Scoped effect** — Wrong predictions tune a few numbers; they do not need to generate dialogue, levels, or “creative” content.

## Likely inputs (examples)

- Rolling window of: time in room, shots fired, hits taken, kills, room ID or type.
- Run-level: current depth, recent death streak, build tags (weapon class in use — coarse categories only).

## Likely outputs (examples)

- One of **N** discrete presets (e.g. “standard / pressure / recovery”) that map to designer-authored tables: spawn budget, pickup bias, optional modifier presence.
- Optional: small continuous adjustments **clamped** to safe min/max set by design.

## Effect on gameplay

- Player **feels** runs that stay tense but survivable with practice; difficulty adapts without exposing internal numbers.
- Designers retain control via **caps and presets**; ML selects among allowed states, not inventing new mechanics.

## Explicitly rejected (for this project)

| Idea | Reason |
|------|--------|
| **Live reinforcement learning in production** | Hard to validate, unstable behavior, poor fit for a shippable solo game. |
| **LLM dialogue or narrative** | Offline-only constraint, scope explosion, not core to GunMaxx. |
| **“Smart” enemy AI** marketed as ML | Usually unnecessary; hand-tuned behavior + good readability beats opaque agents. |
| **Cloud training or player data collection** | Conflicts with offline-only design and privacy posture. |

## Realistic first-project path

1. Ship core loop with **manual** difficulty presets.
2. Log anonymized session summaries locally (opt-in if you add a setting later).
3. Train a simple model or calibrated rule layer offline; ship **preset selection** or **bounded adjustments** only.
4. Evaluate with playtests: retention of challenge band, no obvious exploits.

If ML never ships, **manual presets** remain the fallback — the game must stay complete without ML.
