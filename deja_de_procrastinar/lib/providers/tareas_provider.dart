// lib/providers/tareas_provider.dart

import 'package:flutter/foundation.dart'; // <-- ¡LA IMPORTACIÓN CLAVE!
import '../models/tarea_model.dart';

enum FilterState { todas, pendientes, hechas }

class TareasProvider with ChangeNotifier {
  final List<Tarea> _tareasOriginales = [
    Tarea(
      title: 'Hacer 30 minutos de ejercicio',
      dueDate: DateTime(2025, 10, 10),
    ),
    Tarea(title: 'Ordenar el escritorio', dueDate: DateTime(2025, 10, 13)),
    Tarea(
      title: 'Empezar a leer ese libro',
      dueDate: DateTime(2025, 10, 9),
      isDone: true,
    ),
    Tarea(title: 'Llamar a mamá', dueDate: DateTime(2025, 10, 31)),
    Tarea(title: 'Planificar la semana', isDone: true),
  ];

  List<Tarea> _tareasFiltradas = [];
  String _searchQuery = '';
  FilterState _filtroActivo = FilterState.todas;

  List<Tarea> get tareasFiltradas => _tareasFiltradas;
  FilterState get filtroActivo => _filtroActivo;

  TareasProvider() {
    _filtrarTareas();
  }

  void _filtrarTareas() {
    List<Tarea> tempLista = [];
    if (_filtroActivo == FilterState.pendientes) {
      tempLista = _tareasOriginales.where((e) => !e.isDone).toList();
    } else if (_filtroActivo == FilterState.hechas) {
      tempLista = _tareasOriginales.where((e) => e.isDone).toList();
    } else {
      tempLista = List.from(_tareasOriginales);
    }

    if (_searchQuery.isNotEmpty) {
      tempLista = tempLista
          .where((tarea) => tarea.title.toLowerCase().contains(_searchQuery))
          .toList();
    }
    _tareasFiltradas = tempLista;
    notifyListeners();
  }

  void actualizarBusqueda(String query) {
    _searchQuery = query.toLowerCase();
    _filtrarTareas();
  }

  void cambiarFiltro(FilterState nuevoFiltro) {
    _filtroActivo = nuevoFiltro;
    _filtrarTareas();
  }

  void anadirTarea(String titulo) {
    final nuevaTarea = Tarea(title: titulo);
    _tareasOriginales.add(nuevaTarea);
    _filtrarTareas();
  }

  int eliminarTarea(Tarea tarea) {
    // El provider busca el índice en su propia lista privada.
    final index = _tareasOriginales.indexOf(tarea);
    if (index != -1) {
      // Nos aseguramos de que la tarea exista
      _tareasOriginales.removeAt(index);
      _filtrarTareas();
    }
    return index; // Devolvemos la posición para la función "Deshacer".
  }

  void reinsertarTarea(int index, Tarea tarea) {
    _tareasOriginales.insert(index, tarea);
    _filtrarTareas();
  }

  void toggleEstadoTarea(Tarea tarea) {
    tarea.isDone = !tarea.isDone;
    _filtrarTareas();
  }
}
