// lib/widgets/new_task_fab.dart
import 'package:flutter/material.dart';

class NewTaskFab extends StatelessWidget {
  final VoidCallback onPressed;

  const NewTaskFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: 'Nueva Tarea',
      child: const Icon(Icons.add),
    );
  }
}
