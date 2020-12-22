## Like Kanban App

Описание работы приложения:
1. Запуск.
1. Проверка авторизации:
   2. Показывается SplashScreen.
   2. Из SharedPreferences читается токен:
      * если токен есть и не равен пустой строке, открывается KanbanScreen;
      * иначе открывается LoginScreen.
1. Авторизация (LoginScreen)
1. Загрузка карточек задач (KanbanScreen)
1. Выход (KanbanScreen)
