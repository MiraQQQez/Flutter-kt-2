import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';

/// Точка входа в приложение Todo List — портфолио Игоря Силина
void main() {
  runApp(const TodoApp());
}

/// Корневой виджет приложения
class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List — Игорь Силин',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Фиолетовая тема в стиле портфолио
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9333EA),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        // Настройка шрифтов и стиля AppBar
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

/// Главный виджет с навигацией между вкладками
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // Текущий индекс вкладки
  int _currentIndex = 0;

  // Список экранов для навигации
  final List<Widget> _screens = const [
    HomeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF9333EA).withValues(alpha: 0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.checklist_rounded),
            selectedIcon:
                Icon(Icons.checklist_rounded, color: Color(0xFF9333EA)),
            label: 'Задачи',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFF9333EA)),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
