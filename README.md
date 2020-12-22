## Like Kanban App
Описание работы:
1. Запуск.
2. Проверка авторизации:
   1. Показывается SplashScreen.
   2. Из SharedPreferences читается токен:
      * если токен есть и не равен пустой строке, открывается KanbanScreen;
      * иначе открывается LoginScreen.
3. Авторизация (LoginScreen):
   1. Пользователь вводит данные, валидация которых осуществляется в реальном времени.
   2. При нажатии кнопки входа, отправляется запрос на сервер для получения токена:
      * если ошибок нет и токен получен, он записывается в SharedPreferences, и открывается KanbanScreen;
      * в случае невреного запроса (код 400) всплывает диалог с сообщением о неверных имени и пароле;
      * в случае отсутствия интернет соединения всплывает диалог с соответсвующим сообщением;
      * иначе всплывает диалог ошибки с кодом статуса ответа сервера.
4. Загрузка карточек задач и выход (KanbanScreen):
   1. При открытии одной из страниц с карточками, отправляется запрос на обновление токена:
      * если ошибок нет и токен получен, он записывается в SharedPreferences, и с новым токеном отправляется запрос на получение карточек:
        * если ошибок нет показывается список карточек с задачами;
        * в случае ошибки авторизации (код 401) в SharedPreferences записывается в качестве токена пустая строка, открывается LoginScreen.
      * в случае отсутствия интернет соединения отображается соответствующее сообщение;
      * иначе отображается диалог ошибки с кодом статуса ответа сервера.
   2. При нажатии кнопки выхода в SharedPreferences записывается в качестве токена пустая строка и открывается LoginScreen.
### Сводка по требованиям
- [x] Использовать Flutter
- [x] Использовать Bloc (кроме проверки вводимых данных на кол-во символов, она реализована в виджете Form)
- [x] Использовать API https://trello.backend.tests.nekidaem.ru/redoc/
- [x] Код на github
- [x] Локализация (за исключением некоторых сообщений об ошибках)