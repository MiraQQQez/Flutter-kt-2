import 'package:flutter/material.dart';

/// Виджет карточки профиля — отображает информацию с иконкой и действиями
class ProfileCard extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;
  final Color cardColor;
  final List<IconData> actionIcons;

  const ProfileCard({
    super.key,
    required this.name,
    required this.description,
    required this.icon,
    required this.cardColor,
    required this.actionIcons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Верхняя строка с иконкой и именем
            Row(
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Описание
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const Spacer(),
            // Row с иконками действий
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actionIcons
                  .map(
                    (iconData) => Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Icon(
                        iconData,
                        size: 24,
                        color: Colors.white70,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
