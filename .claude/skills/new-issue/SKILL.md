---
name: new-issue
description: Aus einer kurzen Beschreibung ein strukturiertes GitHub-Issue (Bug, Feature oder Task) mit Labels anlegen. Aufruf mit /new-issue <beschreibung>, oder automatisch, wenn QA/Review ein Finding festhalten soll.
allowed-tools: Bash(gh issue *), Bash(gh label *)
---

Lege ein Issue in milchlabgit/ssh-console-manager an für: **$ARGUMENTS**

1. Typ bestimmen: Bug (etwas ist kaputt), Feature (neu), Task (technisch/Doku/Chore).
2. Falls nötig kurz im Code nachsehen, um betroffene Module zu nennen.
3. Body nach dem passenden Template unter `.github/ISSUE_TEMPLATE/` aufbauen (Beschreibung, Schritte/Umfang, Akzeptanzkriterien als Checkliste, technische Notizen).
4. Anlegen:
   ```bash
   gh issue create --title "<Typ-Präfix> <englischer Titel>" --label "<bug|feature|task>,priority:<high|medium|low>,claude" --body-file <tmp>
   ```
5. Issue-Nummer und Link zurückgeben.
