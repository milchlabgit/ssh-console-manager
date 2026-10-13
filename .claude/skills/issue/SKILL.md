---
name: issue
description: Ein GitHub-Issue von Anfang bis Ende bearbeiten – Issue lesen, Branch anlegen, umsetzen, QA, Review, PR erstellen. Aufruf mit /issue <nummer>.
disable-model-invocation: true
arguments: [issue_number]
allowed-tools: Bash(gh issue *), Bash(gh pr *), Bash(git *)
---

Bearbeite Issue **#$issue_number** in milchlabgit/ssh-console-manager vollständig.

1. **Lesen**: `gh issue view $issue_number --comments`. Ziel, Umfang und Akzeptanzkriterien zusammenfassen. Unklarheiten vor dem Start fragen.
2. **Branch**: Von aktuellem `main` aus `feature/$issue_number-<kurz>` bzw. `fix/$issue_number-<kurz>` anlegen. Issue mit `gh issue edit $issue_number --add-label "claude"` markieren und per Kommentar kurz den Plan festhalten.
3. **Umsetzen**: Nach den Regeln in `CLAUDE.md`. Fachlichen Agent nutzen, wenn passend. Commits als `type(scope): description (#$issue_number)`.
4. **QA**: `qa-engineer`-Agent ausführen (entspricht `/qa`). Rote Ergebnisse beheben, nicht umgehen.
5. **Review**: `code-reviewer`-Agent über den Diff laufen lassen. Blocker beheben.
6. **PR**: `/pr` ausführen (Body mit `Closes #$issue_number`, QA-Bericht, Review-Fazit).
7. Am Ende: PR-Link, QA-Zusammenfassung und offene Punkte berichten.
