p# 🚀 IOT_EVA2_DEJA_DE_PROCRASTINAR

## Aplicación Móvil para IoT: Gestor de Actividades y Trámites

Este proyecto es la evaluación sumativa del módulo **Aplicaciones Móviles para IoT**. Se desarrolla una aplicación Flutter funcional que implementa la **autenticación** y la **persistencia de datos en la nube**, simulando un gestor de tareas diarias para el usuario final.

## 1. Características Principales y Cumplimiento de Requisitos

La aplicación demuestra el cumplimiento de los siguientes requisitos técnicos y funcionales de la evaluación:

| Característica | Detalle Funcionalidad | Requisito Clave |
| :--- | :--- | :--- |
| **Login y Autenticación** | Implementación de una pantalla de login que valida el formato de correo y la longitud mínima de contraseña. Autenticación real vía **Firebase Auth**. | RF1, RF2, RF3 |
| **Persistencia de Datos** | Manejo de tareas (Actividades o Trámites) a través de un **CRUD asíncrono completo** conectado a **Firebase Firestore**. | RF10, RF11, RF12 |
| **Gestión de Listados** | La pantalla principal muestra un listado ordenado por la fecha de entrega y soporta **búsqueda** y **filtros** por estado. | RF8, RF9, RF13 |
| **Estados Derivados** | Lógica para mostrar estilos visuales según el estado: **Pendiente**, **Completada** (tachado), y **Atrasada/Vencida** (si la fecha pasó sin completar). | RF7 |
| **Eliminación Segura** | Implementación del *swipe* (`Dismissible`) que incluye un **Snackbar** con la opción **"DESHACER"** (re-creando el registro en Firestore). | RF12 |

## 2. 🛠️ Arquitectura y Tecnologías Clave

La arquitectura del proyecto está diseñada para la escalabilidad, demostrando la interconexión con servicios en la nube:

* **Tecnologías IOT/Nube:**
    * **Firebase Firestore:** Persistencia de datos (lectura vía `Stream`).
    * **Firebase Authentication:** Servicio de control de acceso.
* **Gestión de Estado y Arquitectura:**
    * **Provider:** Utilizado con `ChangeNotifier` y `ChangeNotifierProxyProvider` para la inyección de dependencias (`Auth` y `Tareas`).
    * **Repository Pattern:** El código está organizado en `repositories` (conexión a Firebase), consumidos por los `providers` (lógica de negocio).

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

Para acceder y validar todas las funcionalidades (CRUD, Filtros, Estados), el revisor debe utilizar las siguientes credenciales, ya registradas en el servicio **Firebase Authentication** del proyecto:

| Campo | Valor | Propósito |
| :--- | :--- | :--- |
| **Correo Electrónico** | `test@gmail.com` | Usuario de prueba. |
| **Contraseña** | **[TU_CONTRASEÑA_DE_6_CARACTERES_O_MÁS]** | *Se debe usar la contraseña establecida para este usuario en la consola de Firebase.* |

---
---