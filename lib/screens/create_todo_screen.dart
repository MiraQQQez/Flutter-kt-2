import 'package:flutter/material.dart';
import '../models/todo_model.dart';

/// Экран создания новой туду задачи
/// Содержит форму с полями: заголовок, описание, приоритет
class CreateTodoScreen extends StatefulWidget {
  const CreateTodoScreen({super.key});

  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  // Ключ формы для валидации
  final _formKey = GlobalKey<FormState>();

  // Контроллеры для текстовых полей
  final _titleController = TextEditingController();
  final _textController = TextEditingController();

  // Выбранный приоритет по умолчанию — средний
  TodoPriority _selectedPriority = TodoPriority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  /// Обработка нажатия кнопки "Создать"
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Возвращаем данные на предыдущий экран через Navigator
      Navigator.of(context).pop({
        'title': _titleController.text.trim(),
        'text': _textController.text.trim(),
        'priority': _selectedPriority,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FF),
      appBar: AppBar(
        title: const Text(
          'Новая задача',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF553C9A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок секции
              const Text(
                'Что нужно сделать?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 24),

              // Поле ввода заголовка
              _buildInputLabel('Заголовок'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration(
                  hint: 'Введите заголовок задачи',
                  icon: Icons.title,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Заголовок обязателен';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),

              // Поле ввода описания
              _buildInputLabel('Описание'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _textController,
                decoration: _inputDecoration(
                  hint: 'Опишите задачу подробнее',
                  icon: Icons.notes,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Описание обязательно';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Выбор приоритета
              _buildInputLabel('Приоритет'),
              const SizedBox(height: 12),
              _buildPrioritySelector(),
              const SizedBox(height: 36),

              // Кнопка создания задачи
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9333EA),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: const Color(0xFF9333EA).withValues(alpha: 0.4),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_task, size: 22),
                      SizedBox(width: 10),
                      Text(
                        'Создать задачу',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Виджет подписи к полю ввода
  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFF4B5563),
      ),
    );
  }

  /// Общий стиль полей ввода
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFBBBBBB)),
      prefixIcon: Icon(icon, color: const Color(0xFF9333EA)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF9333EA), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  /// Виджет выбора приоритета — три кнопки в ряд
  Widget _buildPrioritySelector() {
    return Row(
      children: TodoPriority.values.map((priority) {
        final isSelected = _selectedPriority == priority;
        final color = _priorityColor(priority);
        final label = TodoModel.priorityLabel(priority);
        final icon = _priorityIcon(priority);

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedPriority = priority),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isSelected ? color.withValues(alpha: 0.15) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? color : const Color(0xFFE5E7EB),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(icon, color: color, size: 22),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? color : const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Цвет для каждого приоритета
  Color _priorityColor(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.high:
        return const Color(0xFFEF4444);
      case TodoPriority.medium:
        return const Color(0xFFF59E0B);
      case TodoPriority.low:
        return const Color(0xFF10B981);
    }
  }

  /// Иконка для каждого приоритета
  IconData _priorityIcon(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.high:
        return Icons.keyboard_double_arrow_up;
      case TodoPriority.medium:
        return Icons.drag_handle;
      case TodoPriority.low:
        return Icons.keyboard_double_arrow_down;
    }
  }
}
