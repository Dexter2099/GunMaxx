# GunMaxx — Decision Log

Append new entries at the **bottom**. Use a monotonic **ID** (e.g. `D-001`, `D-002`).

**Format:**

| ID | Date | Decision | Reason | Tradeoff |
|----|------|----------|--------|----------|
| D-xxx | YYYY-MM-DD | What was decided | Why | What was given up or risked |

---

## Initial decisions

| ID | Date | Decision | Reason | Tradeoff |
|----|------|----------|--------|----------|
| D-001 | 2026-04-01 | Offline-only game | Privacy, portability, no infra dependency; aligns with solo scope | No live ops, no cross-device sync without manual copy |
| D-002 | 2026-04-01 | Single-player only | Focus and scope; one input and simulation path | No co-op or async hooks |
| D-003 | 2026-04-01 | Solo-first scope; ship small complete loop | Finishability over ambition | Fewer features than many commercial roguelites |
| D-004 | 2026-04-01 | Handcrafted rooms before advanced procgen | Readable design, faster iteration, fewer failure modes | Less infinite replay from layout variety early on |
| D-005 | 2026-04-01 | ML only after core loop is fun without ML | Avoid ML as crutch; keep game valid if ML is removed | ML ship date moves right |
| D-006 | 2026-04-01 | Roguelite structure (runs + light meta) | Retry hook and resume-worthy systems work without MMO scope | Requires careful tuning so meta does not replace skill |
| D-007 | 2026-04-01 | Two enemy archetypes for MVP | Clear readability and implementation bounds | Less variety than players might expect in a “full” roguelite |
| D-008 | 2026-04-01 | No narrative/cutscene pipeline in MVP | Reduces asset and writing load; combat-first | Weaker emotional framing until later |

---

*Add new rows below as the project evolves.*
