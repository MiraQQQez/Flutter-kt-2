import 'package:flutter/material.dart';
import '../models/todo_model.dart';

/// Виджет карточки туду задачи
/// Отображает информацию о задаче с возможностью отметить выполнение и удалить
class TodoCard extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback onToggle;   // Колбэк переключения статуса
  final VoidCallback onDelete;   // Колбэк удаления

  const TodoCard({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  /// Получить цвет в зависимости от приоритета
  Color _priorityColor() {
    switch (todo.priority) {
      case TodoPriority.high:
        return const Color(0xFFEF4444); // Красный
      case TodoPriority.medium:
        return const Color(0xFFF59E0B); // Жёлтый/оранжевый
      case TodoPriority.low:
        return const Color(0xFF10B981); // Зелёный
    }
  }

  /// Получить иконку в зависимости от приоритета
  IconData _priorityIcon() {
    switch (todo.priority) {
      case TodoPriority.high:
        return Icons.keyboard_double_arrow_up;
      case TodoPriority.medium:
        return Icons.drag_handle;
      case TodoPriority.low:
        return Icons.keyboard_double_arrow_down;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      // Фон при свайпе — красный с иконкой удаления
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Чекбокс выполнения задачи
                  _buildCheckbox(),
                  const SizedBox(width: 14),
                  // Основная информация о задаче
                  Expanded(child: _buildContent()),
                  const SizedBox(width: 8),
                  // Индикатор приоритета
                  _buildPriorityBadge(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Виджет чекбокса с анимацией
  Widget _buildCheckbox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: todo.isCompleted ? const Color(0xFF9333EA) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: todo.isCompleted
              ? const Color(0xFF9333EA)
              : const Color(0xFFD1D5DB),
          width: 2,
        ),
      ),
      child: todo.isCompleted
          ? const Icon(Icons.check, color: Colors.white, size: 18)
          : null,
    );
  }

  /// Виджет с заголовком, описанием и датой
  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок задачи
        Text(
          todo.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: todo.isCompleted
                ? const Color(0xFF9CA3AF)
                : const Color(0xFF1F2937),
            decoration:
                todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // Текст описания задачи
        Text(
          todo.text,
          style: TextStyle(
            fontSize: 13,
            color: todo.isCompleted
                ? const Color(0xFFD1D5DB)
                : const Color(0xFF6B7280),
            decoration:
                todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        // Дата создания задачи
        Text(
          _formatDate(todo.createdAt),
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFFD1D5DB),
          ),
        ),
      ],
    );
  }

  /// Бейдж приоритета
  Widget _buildPriorityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _priorityColor().withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        _priorityIcon(),
        size: 18,
        color: _priorityColor(),
      ),
    );
  }

  /// Форматирование даты в читаемый вид
  String _formatDate(DateTime date) {
    final months = [
      'янв', 'фев', 'мар', 'апр', 'май', 'июн',
      'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}, '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
