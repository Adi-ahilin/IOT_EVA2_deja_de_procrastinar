procrastination_app ✔️
Deja de Procrastinar: Tu Gestor de Tareas Sencillo y Eficaz
Una aplicación móvil construida con Flutter para ayudarte a organizar tus tareas diarias, enfocarte en lo importante y, finalmente, dejar de procrastinar.

Características Principales
Este proyecto implementa las funcionalidades esenciales de una aplicación de lista de tareas (To-Do list) con una interfaz limpia y una experiencia de usuario fluida.

✅ Gestión de Tareas: Añade nuevas tareas, márcalas como "hechas" o "pendientes" con un simple toque.
🗑️ Eliminación Segura: Borra tareas deslizando y deshaz la acción al instante si cometes un error.
🔍 Filtrado y Búsqueda Dinámica: Visualiza tus tareas filtrando por Todas, Pendientes o Hechas, y encuentra cualquier tarea al instante con la barra de búsqueda.
✨ Diseño Limpio: Interfaz minimalista y centrada en la productividad, con un "estado vacío" amigable cuando no hay tareas que mostrar.
🔒 Login con Validación: Pantalla de inicio de sesión que valida el formato del correo y la longitud de la contraseña.


🛠️ Arquitectura y Tecnologías Utilizadas
Este proyecto fue desarrollado siguiendo las mejores prácticas de Flutter para asegurar un código limpio, escalable y fácil de mantener.

Framework: Flutter
Lenguaje: Dart
Gestión de Estado: provider con ChangeNotifier. La lógica de negocio y el estado de la aplicación están centralizados en TareasProvider, separando la UI de la lógica de datos.
Arquitectura por Capas: El código está organizado en models, providers, screens y widgets para una clara división de responsabilidades.
Componentización: La interfaz se construye a partir de widgets pequeños y reutilizables (TareaCard, FilterChips, SearchField), lo que hace que el código de las pantallas sea declarativo y fácil de leer.

📁 Estructura del Proyecto
La estructura de carpetas está organizada para facilitar la navegación y la escalabilidad del proyecto:

- **lib/** (Contiene todo el código fuente de la aplicación)
    - **main.dart** (Punto de entrada de la aplicación)
    - **models/**
        - `tarea_model.dart` (Modelo de datos para una Tarea)
    - **providers/**
        - `tareas_provider.dart` (Lógica de negocio y gestión del estado)
    - **screens/**
        - `login_screen.dart` (Pantalla de inicio de sesión)
        - `tareas_screen.dart` (Pantalla principal que muestra la lista de tareas)
    - **widgets/**
        - `empty_state.dart`   (Widget para cuando no hay tareas)
        - `filter_chips.dart`  (Widget para los chips de filtrado)
        - `new_task_fab.dart`  (Widget para el Floating Action Button)
        - `search_field.dart`  (Widget para el campo de búsqueda)
        - `tarea_card.dart`    (Widget que muestra una tarea individual)
          

⚙️ Cómo Ejecutar el Proyecto
Sigue estos pasos para tener una copia del proyecto funcionando en tu máquina local.

Pre-requisitos
Asegúrate de tener el SDK de Flutter instalado en tu computadora. Si no lo tienes, sigue la guía oficial de instalación.

Instalación y Ejecución
-Clona el repositorio: git clone [https://github.com/Adi-ahilin/IOT_EVA2_deja_de_procrastinar.git](https://github.com/Adi-ahilin/IOT_EVA2_deja_de_procrastinar.git)
-Navega al directorio del proyecto: cd procrastination_app
-Instala las dependencias:flutter pub get
-Ejecuta la aplicación: flutter run
-La aplicación se iniciará en tu emulador, dispositivo físico conectado o navegador web.

🌟 Posibles Mejoras a Futuro
Este proyecto es una excelente base que puede ser extendida con nuevas funcionalidades:
-Persistencia de Datos: Guardar las tareas localmente usando shared_preferences o sqflite.
-Autenticación Real: Integrar un servicio como Firebase Authentication.
-Sincronización en la Nube: Usar Firestore para guardar las tareas en la nube.
-Notificaciones: Añadir recordatorios para las tareas con fechas de vencimiento.
-Añadir Fechas de Vencimiento: Implementar un DatePicker al crear o editar una tarea.
