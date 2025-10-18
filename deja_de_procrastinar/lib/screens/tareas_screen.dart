// lib/screens/tareas_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/tareas_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/tarea_card.dart';
import '../widgets/search_field.dart';
import '../widgets/filter_chips.dart';
import '../widgets/new_task_fab.dart';
import 'notas_screen.dart'; // Asegúrate de que este archivo exista

class TareasScreen extends StatelessWidget {
  const TareasScreen({super.key});

  // RF11: Muestra el modal para añadir tarea con título, notas y fecha.
  void _mostrarFormularioNuevaTarea(BuildContext context) {
    final tareasProvider = Provider.of<TareasProvider>(context, listen: false);
    final formKey = GlobalKey<FormState>();
    final tituloController = TextEditingController();
    final notasController = TextEditingController(); // Controlador para Notas

    DateTime? fechaSeleccionada;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Nueva Actividad/Trámite',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  // TÍTULO (OBLIGATORIO)
                  TextFormField(
                    controller: tituloController,
                    decoration: const InputDecoration(
                      labelText: 'Título de la Actividad (Obligatorio)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El título es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // CAMPO DE NOTAS (OPCIONAL)
                  TextFormField(
                    controller: notasController,
                    decoration: const InputDecoration(
                      labelText: 'Notas (Opcional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),
                  // WIDGETS DE FECHA (Selector y Limpiar)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          fechaSeleccionada == null
                              ? 'Fecha de Entrega (Opcional)'
                              : 'Fecha: ${DateFormat('dd/MM/yyyy').format(fechaSeleccionada!)}',
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Cambiar'),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: fechaSeleccionada ?? DateTime.now(),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 1)),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              fechaSeleccionada = picked;
                            });
                          }
                        },
                      ),
                      // Botón para quitar la fecha
                      if (fechaSeleccionada != null)
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              fechaSeleccionada = null;
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // RF11: Añadir tarea a través del Provider
                        tareasProvider.anadirTarea(
                          tituloController.text.trim(),
                          dueDate: fechaSeleccionada,
                        );
                        Navigator.pop(context); // Cerrar el modal
                      }
                    },
                    child: const Text('Añadir Actividad o Trámite'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- WIDGET PRINCIPAL con TabBar ---
  @override
  Widget build(BuildContext context) {
    // Implementamos DefaultTabController para manejar el estado de las pestañas
    return DefaultTabController(
      length: 2, // 'Tareas' y 'Notas'
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Deja de Procrastinar'),
          actions: [
            // Botón de Cerrar Sesión (RF4)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).signOut();
              },
              tooltip: 'Cerrar Sesión',
            ),
          ],
          // Agregamos la TabBar en la parte inferior del AppBar
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list_alt), text: 'Tareas'),
              Tab(icon: Icon(Icons.note_alt), text: 'Notas'),
            ],
          ),
        ),
        // TabBarView para el contenido de cada pestaña
        body: TabBarView(
          children: [
            // Pestaña 1: TAREAS (Contenido principal de la aplicación)
            _buildTareasList(context),

            // Pestaña 2: NOTAS
            const NotasScreen(),
          ],
        ),
        // FAB condicional: solo visible en la pestaña de Tareas
        floatingActionButton: Builder(
          builder: (context) {
            final tabController = DefaultTabController.of(context);
            // Solo mostramos el FAB si la pestaña activa es la de Tareas (índice 0)
            if (tabController.index == 0) {
              return NewTaskFab(
                onPressed: () => _mostrarFormularioNuevaTarea(context),
              );
            }
            return const SizedBox.shrink(); // Ocultar en la pestaña de Notas
          },
        ),
      ),
    );
  }

  // --- FUNCIÓN PRIVADA PARA CONSTRUIR LA LISTA DE TAREAS ---
  Widget _buildTareasList(BuildContext context) {
    final tareasProvider = Provider.of<TareasProvider>(context);
    final tareas = tareasProvider.tareasFiltradas;

    return Column(
      children: [
        // RF8: Búsqueda
        SearchField(
          onChanged: tareasProvider.actualizarBusqueda,
        ),
        // RF9: Filtros
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FilterChips(
            filtroActivo: tareasProvider.filtroActivo,
            onFilterChanged: tareasProvider.cambiarFiltro,
          ),
        ),
        const SizedBox(height: 10),
        // RF6: Lista o EmptyState
        Expanded(
          child: tareas.isEmpty
              ? const EmptyState()
              : ListView.builder(
                  itemCount: tareas.length,
                  itemBuilder: (context, index) {
                    final tarea = tareas[index];

                    // RF12: Eliminación con Deshacer
                    return Dismissible(
                      key: ValueKey(tarea.id),

                      // CORRECCIÓN FINAL: onDismissed es ahora asíncrona
                      onDismissed: (direction) async {
                        final tareaEliminada = tarea;

                        // Llamamos al método asíncrono y esperamos su resultado
                        // Esto soluciona el error de "Future<Tarea>"
                        await tareasProvider.eliminarTarea(tareaEliminada);

                        // RF12: Mensaje de Deshacer
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Se eliminó la tarea: ${tareaEliminada.title}'),
                            action: SnackBarAction(
                              label: 'DESHACER',
                              onPressed: () {
                                // Recreamos la tarea en Firebase (forma segura de "undo")
                                tareasProvider.anadirTarea(
                                  tareaEliminada.title,
                                  dueDate: tareaEliminada.dueDate,
                                );
                              },
                            ),
                          ),
                        );
                      },

                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      child: TareaCard(
                        tarea: tarea,
                        // RF10: Toggle Estado
                        onCheckboxChanged: (_) =>
                            tareasProvider.toggleEstadoTarea(tarea),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
