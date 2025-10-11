import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tareas_provider.dart';
import '../widgets/tarea_card.dart';
import '../widgets/search_field.dart';
import '../widgets/filter_chips.dart';
import '../widgets/new_task_fab.dart';

class TareasScreen extends StatelessWidget {
  final String email;
  const TareasScreen({super.key, required this.email});

  void _mostrarFormularioNuevaTarea(BuildContext context) {
    final tareasProvider = Provider.of<TareasProvider>(context, listen: false);
    final formKey = GlobalKey<FormState>();
    final tituloController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
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
                'Añadir Nueva Tarea',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: tituloController,
                decoration: const InputDecoration(
                  labelText: '¿Qué vas a hacer?',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? 'Describe la tarea, por favor'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    tareasProvider.anadirTarea(tituloController.text);
                    Navigator.of(ctx).pop();
                  }
                },
                child: const Text('¡Añadir!'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tareasProvider = context.watch<TareasProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deja de Procrastinar'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SearchField(
            onChanged: (value) => tareasProvider.actualizarBusqueda(value),
          ),
          FilterChips(
            filtroActivo: tareasProvider.filtroActivo,
            onFilterChanged: (filtro) => tareasProvider.cambiarFiltro(filtro),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tareasProvider.tareasFiltradas.length,
              itemBuilder: (context, index) {
                final tarea = tareasProvider.tareasFiltradas[index];

                return Dismissible(
                  key: ValueKey(tarea),
                  onDismissed: (direction) {
                    final posicionOriginal = tareasProvider.eliminarTarea(
                      tarea,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${tarea.title} (eliminada)'),
                        action: SnackBarAction(
                          label: 'DESHACER',
                          onPressed: () {
                            if (posicionOriginal != -1) {
                              tareasProvider.reinsertarTarea(
                                posicionOriginal,
                                tarea,
                              );
                            }
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
                  // ¡MIRA QUÉ LIMPIO QUEDA AHORA!
                  // La pantalla ya no se preocupa por los estilos.
                  child: TareaCard(
                    tarea: tarea,
                    onCheckboxChanged: (_) =>
                        tareasProvider.toggleEstadoTarea(tarea),
                  ),
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
