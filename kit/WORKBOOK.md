---
title: Product Launch Lab Workbook
version: 0.2.0
updated: 2026-08-17
status: ready-for-pilot
---

# Workbook

Открывай только текущий round file. Если хочется писать feature или полировать дизайн, добавь это в `INPUT.md → Parking lot`.

## Round 1: сформулировать

Файл: `01-POSITIONING.md`. Timebox: 40 минут.

Ответь на 7 пунктов:

1. Кто user?
2. В какой trigger-ситуации?
3. Что он делает сейчас?
4. Какой observable result получает?
5. Какой proof уже есть?
6. Что нельзя обещать?
7. Какой один CTA?

Finish: другой человек повторяет user, outcome и CTA за 20 секунд.

Если застрял, используй [`prompts/01-positioning.md`](prompts/01-positioning.md).

## Round 2: показать

Файл: `02-DEMO.md`. Timebox: 45 минут.

- Working product: покажи один end-to-end scenario.
- Idea-stage: после ясного positioning собери минимальную validation page с одним CTA и покажи её как hypothesis, не как proof.

Landing до Lab желателен, но не является admission gate. Страница без конкретных user, trigger и CTA — не готовый артефакт.

Запиши один scenario:

| Video | Что показать |
|---|---|
| 0–10s | User и trigger |
| 10–65s | Input → action → result |
| 65–80s | Proof |
| 80–90s | Limitation и CTA |

Максимум три дубля. Screen recording важнее монтажа. Проверь URL в incognito и скрой sensitive data.

Finish: человек видит работающий scenario или проверяемую validation page и понимает следующий шаг.

Если застрял, используй [`prompts/02-demo.md`](prompts/02-demo.md).

## Round 3: подготовить выход

Файл: `03-DISTRIBUTION.md`. Timebox: 45 минут.

Сделай:

1. один primary channel;
2. один launch post;
3. одно direct message;
4. 10 конкретных recipients или places;
5. один CTA;
6. одну 7-day metric;
7. дату первого send/publish.

Signal: qualified reply, demo request, pilot interest или payment. Likes сами по себе не считаются.

Finish: первый внешний шаг можно сделать без новой доработки продукта.

Если застрял, используй [`prompts/03-distribution.md`](prompts/03-distribution.md).

## Finish: PR

Файл: `SUBMISSION.md`.

1. Заполни все поля.
2. Запусти `bash scripts/check-submission.sh <handle> origin/main`.
3. Push только `participants/<handle>/`.
4. Открой PR.

Draft к концу Lab достаточен. Ничего не отправляй наружу автоматически.

## Feedback

Buddy отвечает в PR:

1. Кому и зачем нужен продукт, понятно?
2. Какой proof самый убедительный?
3. Что мешает сделать следующий шаг?
