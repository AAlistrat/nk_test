## Like Kanban App

Описание работы приложения:
1. Запуск.
2. Проверка авторизации:
  2.1. Показывается SplashScreen.
  2.2. Из SharedPreferences читается токен:
    * если токен есть и не равен пустой строке, открывается KanbanScreen;
    * иначе открывается LoginScreen.
3. Авторизация (LoginScreen)
4. Загрузка карточек задач (KanbanScreen)
5. Выход (KanbanScreen)
