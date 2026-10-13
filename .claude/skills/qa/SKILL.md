---
name: qa
description: Das QA-Gate des Projekts ausführen (Lint, Tests, Build) und einen QA-Bericht liefern. Aufruf mit /qa, oder vor jedem Commit/PR.
context: fork
agent: qa-engineer
---

Führe das vollständige QA-Gate für ssh-console-manager aus und liefere den QA-Bericht. Falls ein Issue genannt ist ($ARGUMENTS), prüfe zusätzlich dessen Akzeptanzkriterien.
