// lib/models/tarea_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Tarea {
  final String? id; // ID de Firestore, Opcional
  final String title;
  final DateTime? dueDate;
  bool isDone;

  Tarea({
    this.id,
    required this.title,
    this.dueDate,
    this.isDone = false,
  });

  // RF11: Método para guardar en Firebase (toDocument)
  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      // Usamos Timestamp para guardar fechas correctamente en Firestore
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'isDone': isDone,
    };
  }

  // RF6: Método para leer desde Firebase (fromDocument)
  static Tarea fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null || !data.containsKey('title')) {
      throw Exception("Documento de Tarea inválido o incompleto.");
    }

    return Tarea(
      id: doc.id,
      title: data['title'] as String,
      // Convertir Timestamp de Firebase a DateTime de Dart
      dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
      isDone: data['isDone'] as bool? ?? false,
    );
  }
}
