---
title: Product Launch Lab
version: 0.4.0
updated: 2026-08-17
status: ready-for-pilot
---

# Product Launch Lab

## Start here: 2 минуты

- За 4 часа ты не дописываешь продукт. Ты готовишь его первый понятный выход наружу.
- На каждом раунде открыт один файл. Остальное пока не трогай.
- К концу нужен draft PR. Публикация и рассылка только после твоего решения.

Результат:

**case → one-liner / Product Card → 60–90s demo → launch message → 7-day test**

## Твой маршрут

| Когда | Открой | Готово, когда |
|---|---|---|
| До встречи | `INPUT.md` | Product работает, один scenario и limits известны |
| Round 1 | `01-POSITIONING.md` | User, outcome, proof и CTA понятны за 20 секунд |
| Round 2 | `02-DEMO.md` | 60–90s video URL открывается и показывает один scenario |
| Round 3 | `03-DISTRIBUTION.md` | Готовы post, DM, 10 targets и одна metric |
| Finish | `SUBMISSION.md` | Check прошёл, PR открыт |

Во время Lab следуй текущему сообщению ведущего и [`kit/WORKBOOK.md`](kit/WORKBOOK.md). Agent prompts лежат в [`kit/prompts/`](kit/prompts/).

## До встречи

```bash
gh repo clone AI-Neighbors/product-launch-lab
cd product-launch-lab
bash scripts/init-participant.sh YOUR_GITHUB_HANDLE
```

Команда создаёт branch/folder и включает repo-local hook, который блокирует прямой push в `main`.

Запусти Codex или другой coding agent в корне repo и напиши:

```text
Я <github-handle>. Мой contact handle <optional>. Продукт <название>. Начни Product Launch Lab.
```

Project-local Participant Coach определит current phase, покажет один exact file и будет задавать по одному вопросу. Можно спрашивать что угодно: сначала он ответит, затем вернёт тебя к текущему шагу.

До встречи:

1. Заполни `participants/YOUR_GITHUB_HANDLE/INPUT.md`.
2. Сделай test push.
3. Запиши 10 секунд экрана знакомым recorder.
4. Открой share link в incognito.

Используй Loom, QuickTime или уже знакомый инструмент. Creative AI tools не нужны. Video-файл в Git не добавляй.

## Finish

```bash
bash scripts/check-submission.sh YOUR_GITHUB_HANDLE origin/main
git add participants/YOUR_GITHUB_HANDLE
git commit -m "feat(capsule): add YOUR_GITHUB_HANDLE pilot-01 submission"
git push -u origin pilot-01/YOUR_GITHUB_HANDLE
gh pr create --base main --fill
```

## Не клади сюда

- product source и datasets;
- `.env`, tokens и credentials;
- client data и private contacts;
- video binaries;
- материалы других участников.

Все collaborators private repo видят все participant folders. Используй scrubbed demo data и ссылки, которыми готов поделиться с группой.
