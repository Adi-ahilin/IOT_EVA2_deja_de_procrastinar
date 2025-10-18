// lib/repositories/tareas_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tarea_model.dart';

class TareasRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtiene la colección de evaluaciones del usuario
  CollectionReference getTareasCollection(String userId) {
    // Estructura: users/{userId}/evaluaciones
    return _firestore.collection('users').doc(userId).collection('evaluaciones');
  }

  // RF6, RF13: OBTENER (Stream) el listado ordenado
  Stream<List<Tarea>> getTareasStream(String userId) {
    return getTareasCollection(userId)
        // RF13: Orden ascendente por fecha (sugerido por defecto)
        .orderBy('dueDate', descending: false) 
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Tarea.fromDocument(doc)).toList();
    });
  }
  
  // RF11: CREAR una nueva evaluación
  Future<void> anadirTarea(String userId, Tarea tarea) {
    return getTareasCollection(userId).add(tarea.toDocument());
  }

  // RF10: ACTUALIZAR el estado (isDone)
  Future<void> toggleEstadoTarea(String userId, Tarea tarea) {
    if (tarea.id == null) return Future.value(); 

    return getTareasCollection(userId).doc(tarea.id).update({
      'isDone': tarea.isDone,
    });
  }

  // RF12: ELIMINAR una evaluación
  Future<void> eliminarTarea(String userId, String tareaId) {
    return getTareasCollection(userId).doc(tareaId).delete();
  }
}