---
name: pr
description: Pull Request für den aktuellen Branch erstellen – mit Template, Closes #n, QA-Bericht und Review-Fazit. Aufruf mit /pr [issue-nummer].
disable-model-invocation: true
allowed-tools: Bash(gh pr *), Bash(git *)
---

Erstelle einen PR für den aktuellen Branch in milchlabgit/ssh-console-manager.

1. Prüfen: Branch ist nicht `main`, alles committed (`git status`), Branch gepusht (`git push -u origin HEAD`).
2. Issue-Nummer aus `$ARGUMENTS` oder aus dem Branch-Namen (`feature/42-...`) ableiten.
3. Falls noch nicht geschehen: `qa-engineer` und `code-reviewer` laufen lassen.
4. PR-Body aus `.github/PULL_REQUEST_TEMPLATE.md` füllen: Zusammenfassung, `Closes #<nr>`, Änderungen, QA-Checkliste, Review-Fazit, Hinweise.
5. `gh pr create --base main --title "type(scope): description (#<nr>)" --label "<labels des issues>" --body-file <tmp>`
6. PR-Link zurückgeben.
