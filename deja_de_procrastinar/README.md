# 🚀 IOT_EVA2_DEJA_DE_PROCRASTINAR

## Aplicación Móvil para IoT: Gestor de Actividades y Trámites

Este proyecto es la evaluación sumativa del módulo **Aplicaciones Móviles para IoT**. Implementa una aplicación Flutter funcional para la gestión de tareas diarias, destacando la **Autenticación** y **Persistencia de Datos en la Nube** (Firebase).

## 1. Características Principales y Cumplimiento de Requisitos

| Característica | Detalle Funcionalidad | Requisito Clave |
| :--- | :--- | :--- |
| **Login y Autenticación** | Login con validación de formato/longitud. Autenticación real vía **Firebase Auth**. | RF1, RF2, RF3 |
| **Persistencia Completa** | Manejo del **CRUD asíncrono** (Creación, Lectura, Actualización/Toggle, Eliminación) conectado a **Firebase Firestore**. | RF10, RF11, RF12 |
| **Gestión de Listados** | Listado ordenado por la fecha de entrega y soporte para **búsqueda** y **filtros** por estado. | RF8, RF9, RF13 |
| **Estados Derivados** | Lógica para mostrar estilos visuales según el estado: **Pendiente**, **Completada** (tachado), y **Atrasada/Vencida** (si la fecha pasó sin completar). | RF7 |
| **Optimización de Consulta** | **Índice Compuesto** creado en Firestore para optimizar las consultas de filtrado y orden de la lista principal. | Requisito de Índice |
| **Diseño Tabulado** | Interfaz organizada con navegación por pestañas (**Tareas** y **Notas**). | Diseño Tabular |

## 2. 🛠️ Arquitectura y Tecnologías Clave

* **Tecnologías IOT/Nube:** Firebase Firestore y Firebase Authentication.
* **Gestión de Estado:** **Provider** (`ChangeNotifierProxyProvider`) para inyectar dependencias (`Auth` y `Tareas`).
* **Patrón:** **Repository Pattern** para aislar la lógica de acceso a datos de la aplicación.

## 3. 🔑 Guía de Ejecución y Credenciales de Prueba

### A. Ejecución del Proyecto

1.  **Clonar y Dependencias:**
    ```bash
    git clone [URL_DE_TU_REPOSITORIO]
    cd IOT_EVA2_deja_de_procrastinar
    flutter pub get
    ```
2.  **Ejecutar:** Ejecute `flutter run` en un dispositivo o navegador.

### B. Credenciales para la Revisión (¡CRUCIAL!)

Para acceder y validar la funcionalidad, el revisor debe utilizar las siguientes credenciales de prueba:

| Campo | Valor |
| :--- | :--- |
| **Correo Electrónico** | `test@gmail.com` |
| **Contraseña** | **[TU_CONTRASEÑA_DE_6_CARACTERES_O_MÁS]** |

---

## 4. Verificación de Requisitos (Pruebas Funcionales Clave)

Utilice estas pruebas para confirmar el correcto funcionamiento de los servicios conectados:

1.  **LOGIN (RF1):** Iniciar sesión con `test@gmail.com`.
2.  **PERSISTENCIA (RF11):** Crear una nueva actividad. La tarea debe aparecer y guardarse en Firestore.
3.  **ORDEN (RF13):** Verificar que las tareas se ordenen **ascendentemente por fecha**.
4.  **TOGGLE (RF10):** Marcar una tarea como hecha y verificar que el cambio de estado se guarde en Firebase.
5.  **ELIMINACIÓN (RF12):** Deslizar una tarea. Verificar que la opción **DESHACER** funcione, re-creando el registro en la base de datos.

---
---