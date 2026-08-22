# Input

Заполни до встречи. Timebox: 15 минут.

## Сейчас

- GitHub handle: OXI-717
- Public/contact handle (optional): Telegram @oxigen717
- Participant Kit version: 0.8.0
- Kit base commit: a46afb0b6601204ec08f4d8b911d81672c7f6033
- Product name: GIMS / navolnu.ru
- Product URL or local demo path (если уже есть): https://navolnu.ru (тренажёр — https://trainer.navolnu.ru, Android — Google Play и RuStore)
- Stage: working product в проде; веб + мобильное приложение опубликованы 2026-04-07, инфраструктура на self-hosted Coolify since 2026-04-22
- Target user or current hypothesis: частник, который сам готовится к экзамену ГИМС на маломерное судно (маломерное моторное, гидроцикл, парусное) и хочет сдать с первого раза; курсы учебного центра дают теорию, но не тренировку по билетам
- One scenario that works now: открыть trainer.navolnu.ru → онбординг из 2 шагов (тип судна и район плавания, ММС/ВВ предвыбраны) → «Начать» → бесплатный режим «Экзамен» ровно по регламенту ГИМС (Приказ МЧС России №90 от 13.02.2026: 25 вопросов, 40 минут, допустима 1 ошибка). Проверено вживую 2026-08-22 в чистом браузере: от захода до первого вопроса 4 действия, регистрация не требуется, открывается /quiz/<id> с таймером и счётчиком «1 из 25»
- Existing users or proof: бета-тест через практикующего преподавателя ГИМС, который валидирует содержание и гоняет приложение с учениками; автор проекта сдал теоретический экзамен 2026-03-31 (1 ошибка) и практический 2026-06-22, готовясь на этом же тренажёре
- Limits / do-not-claim: нет проверенных цифр по активным пользователям, конверсии и выручке — не заявлять их как proof; не обещать «гарантированную сдачу»; тренажёр готовит только к теории, практику принимают на воде; B2B-часть (center.navolnu.ru) сейчас лежит (см. navolnu/gims-center#128)
- CTA candidate: «Пройди бесплатный пробный экзамен по правилам ГИМС за 40 минут — узнаешь, сдал бы ты сегодня» → trainer.navolnu.ru

## Parking lot

Features и polish, которые не делаем во время Lab:

- Озвучка аудиокурсов с «якорями»
- Видео-инструкции для блока «Борьба с пожарами» (16:9)
- Партнёрская интеграция navolnu.ru в учебные центры Сормово/Бор
- Починка center.navolnu.ru и CSP/Service Worker (заведены как issue, вне Lab)

## Готово, когда

- [x] Stage указан честно: idea, prototype или working product.
- [x] URL/demo указан, если уже есть; его отсутствие не блокирует участие.
- [x] Для idea-stage записаны primary user и проверяемая hypothesis. (n/a — working product, но primary user зафиксирован)
- [ ] Sensitive data скрыты.
- [x] Test push в branch работает.
- [x] Если есть inspectable surface, 10s test video открывается по shareable URL. — 83s демо: https://yadi.sk/i/C9Mm6qU-o0tdzA
