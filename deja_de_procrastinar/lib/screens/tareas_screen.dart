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

// Es un StatefulWidget para poder usar 'mounted'
class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  void _mostrarFormularioNuevaTarea(BuildContext context) {
    final tareasProvider = Provider.of<TareasProvider?>(context, listen: false);
    if (tareasProvider == null) return;

    final formKey = GlobalKey<FormState>();
    final tituloController = TextEditingController();

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
              top: 24,
              left: 24,
              right: 24,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Añadir Nueva Actividad o Trámite',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: tituloController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de la Actividad o Trámite',
                      border: OutlineInputBorder(),
                    ),
                    autofocus: true,
                    validator: (val) => (val == null || val.trim().isEmpty)
                        ? 'El título es obligatorio'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Row(
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
                        label: const Text('Seleccionar'),
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
                      if (fechaSeleccionada != null)
                        IconButton(
                          icon: const Icon(Icons.clear, color: Colors.red),
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
                        tareasProvider.anadirTarea(
                          tituloController.text,
                          dueDate: fechaSeleccionada,
                        );
                        Navigator.of(ctx).pop();
                      }
                    },
                    child: const Text('¡Añadir Actividad o trámite!'),
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

  @override
  Widget build(BuildContext context) {
    final tareasProvider = context.watch<TareasProvider?>();
    final authProvider = context.read<AuthProvider>();

    if (tareasProvider == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final userEmail = authProvider.user?.email ?? 'Usuario';

    return Scaffold(
      appBar: AppBar(
        title: Text('Actividades o trámite de ${userEmail.split('@').first}'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => authProvider.signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          SearchField(
            onChanged: (value) =>
                tareasProvider.actualizarBusqueda(value), // RF8
          ),
          FilterChips(
            filtroActivo: tareasProvider.filtroActivo,
            onFilterChanged: (filtro) =>
                tareasProvider.cambiarFiltro(filtro), // RF9
          ),
          Expanded(
            child: tareasProvider.tareasFiltradas.isEmpty
                ? const EmptyState()
                : ListView.builder(
                    itemCount: tareasProvider.tareasFiltradas.length,
                    itemBuilder: (context, index) {
                      final tarea = tareasProvider.tareasFiltradas[index];

                      // RF12: Implementación de Eliminación con Dismissible
                      return Dismissible(
                        key: ValueKey(tarea.id ?? UniqueKey()),

                        // 1. Confirmación de Eliminación
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirmar Eliminación"),
                                content: Text(
                                    "¿Estás seguro de que quieres eliminar la Actividad o Trámite '${tarea.title}'?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("CANCELAR"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("ELIMINAR",
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              );
                            },
                          );
                        },

                        // 2. Eliminación y Snackbar (Undo)
                        onDismissed: (direction) async {
                          final tareaEliminada = tarea;

                          // **SOLUCIÓN FINAL**
                          // 1. Capturamos el BuildContext antes del await
                          final scaffoldContext = context;

                          await tareasProvider.eliminarTarea(tareaEliminada);

                          // 2. Verificamos mounted antes de usar el contexto
                          if (!mounted) return;

                          // 3. Usamos la referencia capturada (scaffoldContext)
                          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                            SnackBar(
                              content:
                                  Text('${tareaEliminada.title} (eliminada)'),
                              action: SnackBarAction(
                                label: 'DESHACER (Re-crear)',
                                onPressed: () {
                                  tareasProvider.reinsertarTarea(
                                    index,
                                    tareaEliminada,
                                  );
                                },
                              ),
                            ),
                          );
                        },

                        // 3. Estilo Visual del Swipe
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,

                        // 4. Contenido de la Tarea
                        child: TareaCard(
                            tarea: tarea,
                            // RF10: Toggle Estado (Método asíncrono)
                            onCheckboxChanged: (_) async {
                              await tareasProvider.toggleEstadoTarea(tarea);
                            }),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: NewTaskFab(
        onPressed: () => _mostrarFormularioNuevaTarea(context),
      ),
    );
  }
}
