import 'package:flutter/material.dart';
import '../widgets/profile_card.dart';

/// Экран профиля — страница с карточками Игоря Силина
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6B46C1),
      appBar: AppBar(
        title: const Text(
          'Мои карточки',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF553C9A),
        elevation: 0,
        actions: [
          // IconButton с иконкой настроек
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Настройки'),
                  backgroundColor: Color(0xFF9333EA),
                ),
              );
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            tooltip: 'Настройки',
          ),
          // IconButton с иконкой профиля
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Профиль Игоря Силина'),
                  backgroundColor: Color(0xFF9333EA),
                ),
              );
            },
            icon: const Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            tooltip: 'Профиль',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // Карточка 1 - Игорь Силин
            ProfileCard(
              name: 'Игорь Силин',
              description: 'Flutter разработчик, создаю красивые интерфейсы',
              icon: Icons.person,
              cardColor: Color(0xFF9333EA),
              actionIcons: [
                Icons.phone,
                Icons.email,
                Icons.message,
              ],
            ),
            // Карточка 2 - Работа
            ProfileCard(
              name: 'Проекты',
              description: 'Разрабатываю мобильные приложения',
              icon: Icons.work,
              cardColor: Color(0xFFEC4899),
              actionIcons: [
                Icons.star,
                Icons.favorite,
                Icons.share,
              ],
            ),
            // Карточка 3 - Хобби
            ProfileCard(
              name: 'Хобби',
              description: 'Программирование, дизайн, музыка',
              icon: Icons.sports_esports,
              cardColor: Color(0xFF3B82F6),
              actionIcons: [
                Icons.music_note,
                Icons.camera_alt,
                Icons.book,
              ],
            ),
            // Карточка 4 - Контакты
            ProfileCard(
              name: 'Контакты',
              description: 'Свяжись со мной для сотрудничества',
              icon: Icons.contact_page,
              cardColor: Color(0xFF10B981),
              actionIcons: [
                Icons.telegram,
                Icons.chat,
                Icons.link,
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
