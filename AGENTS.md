# Agent Contract

Этот repo содержит shared event kit и Launch Capsule участников. Агент помогает с формулировками и материалами, но не принимает внешние решения за участника.

## Participant Coach

При первом сообщении участника полностью прочитай `.agents/skills/participant-coach/SKILL.md` и следуй ему. Веди человека по одному шагу: current phase, exact file, один next action. На вопрос сначала отвечай, потом возвращай к current output.

## Перед работой

1. Прочитай `kit/WORKBOOK.md`.
2. Определи GitHub handle владельца. Он задаёт branch/folder; public/contact handle может отличаться.
3. Прочитай его `participants/<handle>/INPUT.md` и только текущий round file.
4. Проверь branch: `pilot-01/<handle>` или `test/<run-id>/<handle>`.

## Branch contract

| Working branch | PR base | Назначение |
|---|---|---|
| `test/<run-id>/<handle>` | `rehearsal/<run-id>` | Изолированная репетиция |
| `pilot-01/<handle>` | `main` | Настоящий Pilot 01 |

- Для test branch никогда не используй `origin/main` как validator base или PR base.
- Raw rehearsal merge идёт только `test/...` → `rehearsal/...`; raw participant result не merge’ится в `main`.
- Curated example попадает в `main` позже отдельным maintainer PR.
- Human-readable diagram и команды: [`README.md`](README.md#ветки-и-направление-merge).

## Scope boundary

- Изменяй только `participants/<handle>/`.
- Не изменяй `kit/`, `.github/`, `scripts/`, root-файлы и папки других участников.
- Не копируй сюда product source, datasets, credentials, `.env`, client data или private screenshots.
- Product source можно читать по явно указанному участником пути, но нельзя изменять или копировать в этот repo.
- Video хранится по shareable HTTPS URL; video-файлы в Git не добавляются.

## Content contract

- Пиши конкретно: audience, trigger, current alternative, observable outcome, proof, limitation, CTA.
- Не выдумывай users, metrics, revenue, testimonials или capabilities.
- Unsupported claim удаляй или маркируй как hypothesis.
- Показывай один end-to-end scenario, не архитектурный tour.
- Один primary channel, один CTA и одна 7-day metric лучше широкого списка без действия.

## Human-in-the-loop

- Не публикуй, не отправляй DM/email, не загружай video и не вызывай внешние API без явного решения участника.
- До 21:00 готовим draft. Внешний send/publish — отдельный 7-day action.
- Не force-push после baseline tag, показанного `scripts/init-participant.sh`.
- Не push в `main` или `rehearsal/**`; только participant branch и PR.

## Finish

```bash
# pilot
bash scripts/check-submission.sh <handle> origin/main

# rehearsal
bash scripts/check-submission.sh <handle> origin/rehearsal/<run-id>
```

Затем покажи участнику diff, source/head branch, target/base branch и clickable artifact links. Дай ему самому подтвердить push, PR и внешние действия.
