// lib/providers/tareas_provider.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/tarea_model.dart';
import '../repositories/tareas_repository.dart';

enum FilterState { todas, pendientes, hechas }

class TareasProvider with ChangeNotifier {
  final TareasRepository _tareasRepository;
  final String _userId;

  List<Tarea> _tareas = [];
  String _searchQuery = '';
  FilterState _filtroActivo = FilterState.todas;

  StreamSubscription<List<Tarea>>? _tareasSubscription;

  // CONSTRUCTOR CON ARGUMENTOS NOMBRADOS (¡Sincronizado con main.dart!)
  TareasProvider(
      {required String userId, required TareasRepository tareasRepository})
      : _userId = userId,
        _tareasRepository = tareasRepository {
    _startListeningToTasks();
  }

  void _startListeningToTasks() {
    // RF6 y RF13: Suscribe al Stream que obtiene las tareas ORDENADAS de Firebase
    _tareasSubscription =
        _tareasRepository.getTareasStream(_userId).listen((tareas) {
      _tareas = tareas;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _tareasSubscription?.cancel();
    super.dispose();
  }

  // GETTER MODIFICADO: Aplica el filtrado/búsqueda sobre la lista _tareas (de Firebase)
  List<Tarea> get tareasFiltradas {
    List<Tarea> tempLista = List.from(_tareas);

    // 1. Aplicar filtro de estado (RF9)
    if (_filtroActivo == FilterState.pendientes) {
      tempLista = tempLista.where((e) => !e.isDone).toList();
    } else if (_filtroActivo == FilterState.hechas) {
      tempLista = tempLista.where((e) => e.isDone).toList();
    }

    // 2. Aplicar búsqueda (RF8)
    if (_searchQuery.isNotEmpty) {
      tempLista = tempLista
          .where((tarea) => tarea.title.toLowerCase().contains(_searchQuery))
          .toList();
    }

    return tempLista;
  }

  FilterState get filtroActivo => _filtroActivo;

  void actualizarBusqueda(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void cambiarFiltro(FilterState nuevoFiltro) {
    _filtroActivo = nuevoFiltro;
    notifyListeners();
  }

  // RF11: AÑADIR TAREA (ASÍNCRONA con Firebase)
  Future<void> anadirTarea(String titulo, {DateTime? dueDate}) async {
    final nuevaTarea = Tarea(title: titulo, dueDate: dueDate);
    await _tareasRepository.anadirTarea(_userId, nuevaTarea);
  }

  // RF12: ELIMINACIÓN (ASÍNCRONA con Firebase)
  Future<Tarea> eliminarTarea(Tarea tarea) async {
    if (tarea.id == null) {
      throw Exception("No se puede eliminar una tarea sin ID de Firebase.");
    }
    await _tareasRepository.eliminarTarea(_userId, tarea.id!);
    return tarea;
  }

  // RF10: TOGGLE ESTADO (ASÍNCRONA con Firebase)
  Future<void> toggleEstadoTarea(Tarea tarea) async {
    tarea.isDone = !tarea.isDone;

    if (tarea.id == null) {
      return;
    }

    await _tareasRepository.toggleEstadoTarea(_userId, tarea);
  }

  // RF12: Función para el 'Undo' (recrear)
  void reinsertarTarea(int index, Tarea tarea) async {
    await anadirTarea(tarea.title, dueDate: tarea.dueDate);
  }
}
