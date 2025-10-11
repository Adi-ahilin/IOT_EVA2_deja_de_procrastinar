import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tarea_model.dart';

class TareaCard extends StatelessWidget {
  final Tarea tarea;
  final Function(bool?) onCheckboxChanged;

  const TareaCard({
    super.key,
    required this.tarea,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    // 2. Toda la lógica de estilos ahora vive DENTRO del widget.
    final estado = _getEstado(tarea);
    final colorEstado = _getEstadoColor(estado);
    final iconoEstado = _getIconoPorEstado(estado);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        // 3. Usamos las variables que acabamos de calcular.
        leading: Icon(iconoEstado, color: colorEstado),
        title: Text(
          tarea.title,
          style: TextStyle(
            decoration: tarea.isDone
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: tarea.isDone ? Colors.grey[600] : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${estado.toUpperCase()} ${tarea.dueDate != null ? '- ${DateFormat('dd/MM/yyyy').format(tarea.dueDate!)}' : ''}',
          style: TextStyle(color: colorEstado, fontWeight: FontWeight.bold),
        ),
        trailing: Checkbox(value: tarea.isDone, onChanged: onCheckboxChanged),
      ),
    );
  }

  // --- 4. Las funciones de ayuda ahora son privadas del widget ---
  String _getEstado(Tarea tarea) {
    if (tarea.isDone) {
      return 'Hecha';
    }
    if (tarea.dueDate != null && DateTime.now().isAfter(tarea.dueDate!)) {
      return 'Atrasada';
    }
    return 'Pendiente';
  }

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'Hecha':
        return Colors.green;
      case 'Atrasada':
        return Colors.red;
      case 'Pendiente':
      default:
        return Colors.orange;
    }
  }

  IconData _getIconoPorEstado(String estado) {
    switch (estado) {
      case 'Hecha':
        return Icons.check_circle;
      case 'Atrasada':
        return Icons.warning_amber_rounded;
      case 'Pendiente':
      default:
        return Icons.rocket_launch_outlined;
    }
  }
}
