import 'package:flutter/material.dart';

class QuestCard extends StatelessWidget {
  final String title;
  final bool completed;
  final VoidCallback onToggle;

  const QuestCard({
    required this.title,
    required this.completed,
    required this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: completed ? Colors.green.withOpacity(0.8) : Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(title, style: TextStyle(color: Colors.white)),
        trailing: Checkbox(
          value: completed,
          onChanged: (_) => onToggle(),
        ),
      ),
    );
  }
}
