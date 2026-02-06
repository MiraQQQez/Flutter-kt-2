import '../models/todo_model.dart';

/// Репозиторий для управления списком туду задач
/// Реализует паттерн Singleton для единого хранилища данных
class TodoRepository {
  // Приватный конструктор для реализации Singleton
  TodoRepository._internal();

  // Единственный экземпляр репозитория
  static final TodoRepository _instance = TodoRepository._internal();

  // Фабричный конструктор возвращает единственный экземпляр
  factory TodoRepository() => _instance;

  // Внутренний список туду задач
  final List<TodoModel> _todos = [];

  // Счётчик для генерации уникальных Id
  int _nextId = 1;

  /// Получить все туду задачи (неизменяемая копия)
  List<TodoModel> getAll() => List.unmodifiable(_todos);

  /// Добавить новую туду задачу
  /// Автоматически присваивает уникальный Id
  void add({
    required String title,
    required String text,
    TodoPriority priority = TodoPriority.medium,
  }) {
    final todo = TodoModel(
      id: 'todo_${_nextId++}',
      title: title,
      text: text,
      createdAt: DateTime.now(),
      priority: priority,
    );
    _todos.insert(0, todo); // Новые задачи — в начало списка
  }

  /// Переключить статус выполнения задачи по Id
  void toggleComplete(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        isCompleted: !_todos[index].isCompleted,
      );
    }
  }

  /// Удалить туду задачу по Id
  void delete(String id) {
    _todos.removeWhere((todo) => todo.id == id);
  }

  /// Найти туду задачу по Id
  TodoModel? findById(String id) {
    try {
      return _todos.firstWhere((todo) => todo.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Получить количество задач
  int get count => _todos.length;

  /// Получить количество выполненных задач
  int get completedCount => _todos.where((t) => t.isCompleted).length;
}
