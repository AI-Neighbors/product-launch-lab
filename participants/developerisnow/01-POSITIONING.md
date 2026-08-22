# 01. Positioning

Timebox: один рабочий блок. Сейчас нужен смысл, не polish.

## Сейчас

1. User: Hypothesis — health-conscious взрослый, который годами отслеживает здоровье своё и семьи, но хранит анализы, wearable data и заметки в разных местах.
2. Trigger: Пользователь получил новые результаты анализов и хочет добавить их к накопленному за 5–10 лет архиву, чтобы не потерять историю отклонений.
3. Current alternative: Вручную искать анализы среди фотографий, файлов и сообщений в Telegram, собирать их и разово передавать AI-агенту без единого timeline.
4. Observable outcome: Пользователь видит health domains на body map и открывает blood markers, reference ranges и trends в одном view.
5. Proof: В опубликованном 66-second demo виден работающий переход из body map в blood-analysis view; данные хранятся в базе, реализованы GET/PUT API methods, founder self-use operator-reported.
6. Limitation / do-not-claim: API-token flow ещё не verified end-to-end для внешнего пользователя; health-device/MCP onboarding не входит в текущий scenario.
7. One CTA: Оставить заявку на доступ к HealthOS.

## One-liner

Health-медицинская карточка сквозь года и все поликлиники, не только по мне, но и по жене, детям... За пару кликов увидеть всю историю анализов, показателей по годам, динамику а также визуализацию. К этому будет навешиваться фичи и маркеры 🟢 - 🟡 - 🔴. 
**Вишенка на торте  AgentFirst (он заполняет и объясняет через MCP/CLI/SKILL/HEALTH Devices)**

Шаблон, если застрял:

> Для [user] в ситуации [trigger] продукт [action], чтобы получить [outcome], вместо [current alternative].

## Product Card

- Product: HealthOS
- For: Health-conscious взрослого с разрозненными данными о здоровье себя и семьи (hypothesis).
- Does: Показывает health domains на body map и открывает blood markers, reference ranges и trends в одном view.
- Proof: Published 66-second demo, работающие database view и GET/PUT API methods; founder self-use (operator-reported).
- Limitation: Внешний API-token flow ещё не verified end-to-end; health-device integration вне текущего scenario.
- CTA: Оставить заявку на доступ к HealthOS.

## Готово, когда

- [x] Другой человек понимает user, outcome и CTA за 20 секунд.
- [x] Proof можно показать.
- [x] В one-liner нет unsupported claim.
