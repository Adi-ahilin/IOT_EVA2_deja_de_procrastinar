// lib/widgets/filter_chips.dart
import 'package:flutter/material.dart';
import '../providers/tareas_provider.dart';

class FilterChips extends StatelessWidget {
  final FilterState filtroActivo;
  final Function(FilterState) onFilterChanged;

  const FilterChips({
    super.key,
    required this.filtroActivo,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: [
        ChoiceChip(
          label: const Text('Todas'),
          selected: filtroActivo == FilterState.todas,
          onSelected: (_) => onFilterChanged(FilterState.todas),
        ),
        ChoiceChip(
          label: const Text('Pendientes'),
          selected: filtroActivo == FilterState.pendientes,
          onSelected: (_) => onFilterChanged(FilterState.pendientes),
        ),
        ChoiceChip(
          label: const Text('Hechas'),
          selected: filtroActivo == FilterState.hechas,
          onSelected: (_) => onFilterChanged(FilterState.hechas),
        ),
      ],
    );
  }
}
