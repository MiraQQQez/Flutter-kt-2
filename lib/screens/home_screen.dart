import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../repositories/todo_repository.dart';
import '../widgets/todo_card.dart';
import 'create_todo_screen.dart';

/// Главный экран приложения — список туду задач
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Получаем Singleton экземпляр репозитория
  final _repository = TodoRepository();

  /// Переход на экран создания задачи и обработка результата
  Future<void> _navigateToCreate() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const CreateTodoScreen()),
    );

    // Если пользователь заполнил форму и нажал "Создать"
    if (result != null) {
      setState(() {
        _repository.add(
          title: result['title'] as String,
          text: result['text'] as String,
          priority: result['priority'] as TodoPriority,
        );
      });

      // Показываем уведомление об успешном создании
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Задача создана!'),
            backgroundColor: const Color(0xFF9333EA),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  /// Переключение статуса выполнения задачи
  void _toggleTodo(String id) {
    setState(() {
      _repository.toggleComplete(id);
    });
  }

  /// Удаление задачи
  void _deleteTodo(String id) {
    setState(() {
      _repository.delete(id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Задача удалена'),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todos = _repository.getAll();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FF),
      appBar: AppBar(
        title: const Text(
          'Мои задачи',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF553C9A),
        elevation: 0,
        actions: [
          // Информация о профиле
          IconButton(
            onPressed: () {
              _showProfileDialog(context);
            },
            icon: const Icon(Icons.account_circle, color: Colors.white),
            tooltip: 'Профиль',
          ),
          const SizedBox(width: 8),
        ],
      ),
      // Кнопка добавления новой задачи
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreate,
        backgroundColor: const Color(0xFF9333EA),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Новая задача',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 6,
      ),
      body: Column(
        children: [
          // Заголовок со статистикой
          _buildHeader(todos),
          // Список задач или пустое состояние
          Expanded(
            child: todos.isEmpty ? _buildEmptyState() : _buildTodoList(todos),
          ),
        ],
      ),
    );
  }

  /// Заголовок с информацией о количестве задач
  Widget _buildHeader(List<TodoModel> todos) {
    final completed = _repository.completedCount;
    final total = _repository.count;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF553C9A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Привет, Игорь! 👋',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.95),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            total == 0
                ? 'Пока задач нет — создай первую!'
                : 'Выполнено $completed из $total задач',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          if (total > 0) ...[
            const SizedBox(height: 14),
            // Прогресс-бар выполнения
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: total > 0 ? completed / total : 0,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF10B981),
                ),
                minHeight: 8,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Пустое состояние — когда нет задач
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checklist_rounded,
            size: 80,
            color: const Color(0xFF9333EA).withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'Список пуст',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Нажми кнопку ниже, чтобы\nдобавить первую задачу',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 80), // Отступ под FAB
        ],
      ),
    );
  }

  /// Список туду задач
  Widget _buildTodoList(List<TodoModel> todos) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 100),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoCard(
          todo: todo,
          onToggle: () => _toggleTodo(todo.id),
          onDelete: () => _deleteTodo(todo.id),
        );
      },
    );
  }

  /// Диалог с информацией о профиле
  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.person, color: Color(0xFF9333EA)),
            SizedBox(width: 10),
            Text('Профиль'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Игорь Силин',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Flutter разработчик',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Портфолио: Todo List App',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Закрыть',
              style: TextStyle(color: Color(0xFF9333EA)),
            ),
          ),
        ],
      ),
    );
  }
}
