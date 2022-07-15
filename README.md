# README

## Флоу по диспуту
* Участник сделки заходит на страницу сделки
* На странице сделки нажимает кнопку Открыть диспут
* Всплывает Метамаск
* В Метамаске участник подписывает начало диспута
* В блокчейн уходит сообщение и изменяет статус диспута
* Следилка ловит это изменение и посылает сигнал в кролика
* Сигнал ловит бакенд и изменяет статус сделки в базе а также уведомляет арбитра
* Арбитр заходит на страницу сделки под своим логином
* Начинает переписку с участниками и выясняет обстоятельства
* Арбитр нажимает кнопку cancel или clear
* У Арбитр всплывает metamask
* Арбитр подписывает команду в metamask
* Изменение статуса уходит в контракт по сделке
* Следилка ловит изменения сделки и отправляет сигнал в кролика
* БАкенд ловит сигнал и изменяет статус сделки в базе

## Staging

* http://172.16.0.70:9771/swagger


## Статусы сделки
```mermaid
  graph TD;
    buyer{Buyer} -- acceptDealBuyer -->started;
    started -- cancelTimeoutArbiter --> canceled_timeout_arbiter("❌ canceled_timeout_arbiter");
    started -- cancelDealBuyer --> canceled_buyer("❌ canceled_buyer");
    started -- completePaymentBuyer --> payment_complete;
    payment_complete -- callHelpSeller or callHelpBuyer --> dispute;
    payment_complete -- clearDealSeller --> cleared_seller("✅ cleared_seller");
    dispute -- cancelDealArbiter --> canceled_arbiter("❌ canceled_arbiter");
    dispute -- clearDealArbiter --> cleared_arbiter("✅ cleared_arbiter");
```
