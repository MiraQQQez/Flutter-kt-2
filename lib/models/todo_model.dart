/// Перечисление приоритетов для туду задачи
enum TodoPriority {
  low,    // Низкий приоритет
  medium, // Средний приоритет
  high,   // Высокий приоритет
}

/// Модель туду задачи с уникальным идентификатором
class TodoModel {
  final String id;          // Уникальный идентификатор
  final String title;       // Заголовок задачи
  final String text;        // Описание задачи
  final bool isCompleted;   // Статус выполнения
  final DateTime createdAt; // Дата создания
  final TodoPriority priority; // Приоритет задачи

  const TodoModel({
    required this.id,
    required this.title,
    required this.text,
    this.isCompleted = false,
    required this.createdAt,
    this.priority = TodoPriority.medium,
  });

  /// Создание копии с изменёнными полями
  TodoModel copyWith({
    String? id,
    String? title,
    String? text,
    bool? isCompleted,
    DateTime? createdAt,
    TodoPriority? priority,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
    );
  }

  /// Получение цвета приоритета
  /// Используется для визуального отображения приоритета в UI
  static String priorityLabel(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.low:
        return 'Низкий';
      case TodoPriority.medium:
        return 'Средний';
      case TodoPriority.high:
        return 'Высокий';
    }
  }
}
