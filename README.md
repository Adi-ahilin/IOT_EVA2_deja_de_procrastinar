procrastination_app ✔️
Deja de Procrastinar: Tu Gestor de Tareas Sencillo y Eficaz
Una aplicación móvil construida con Flutter para ayudarte a organizar tus tareas diarias, enfocarte en lo importante y, finalmente, dejar de procrastinar.

🚀 Características Principales
Este proyecto implementa las funcionalidades esenciales de una aplicación de lista de tareas (To-Do list) con una interfaz limpia y una experiencia de usuario fluida.

Creación de Tareas: Añade nuevas tareas rápidamente a través de un formulario modal.
Gestión de Estado: Marca las tareas como "hechas" o "pendientes" con un simple toque.
Eliminación con Deshacer: Borra tareas deslizando y deshaz la acción al instante si cometes un error.
Filtrado Dinámico: Visualiza tus tareas filtrando por Todas, Pendientes o Hechas.
Búsqueda Integrada: Encuentra cualquier tarea al instante con la barra de búsqueda.
Diseño Limpio: Interfaz minimalista y centrada en la productividad.
🛠️ Arquitectura y Tecnologías Utilizadas
Este proyecto fue desarrollado siguiendo las mejores prácticas de Flutter para asegurar un código limpio, escalable y fácil de mantener.

Framework: Flutter
Lenguaje: Dart
Gestión de Estado: Provider
La lógica de negocio y el estado de la aplicación están centralizados en TareasProvider, separando la UI de la lógica de datos.
Arquitectura:
Separación de Responsabilidades: El código está organizado en models, providers, screens y widgets para una clara división de funciones.
Componentización: La interfaz se construye a partir de widgets pequeños y reutilizables (TareaCard, FilterChips, SearchField), lo que hace que el código de las pantallas principales (TareasScreen) sea declarativo y fácil de leer.
📁 Estructura del Proyecto
La estructura de carpetas está organizada para facilitar la navegación y la escalabilidad del proyecto.

lib/ 
├── main.dart # Punto de entrada de la aplicación 
|
├── models/ 
│ └── tarea_model.dart # Modelo de datos para una Tarea 
| 
├── providers/ 
│ └── tareas_provider.dart # Lógica de negocio y gestión del estado 
| 
├── screens/ 
│ ├── login_screen.dart # Pantalla de inicio de sesión 
│ └── tareas_screen.dart # Pantalla principal que muestra la lista de tareas 
| 
└── widgets/ 
├── filter_chips.dart # Widget para los chips de filtrado 
├── new_task_fab.dart # Widget para el Floating Action Button 
├── search_field.dart # Widget para el campo de búsqueda 
└── tarea_card.dart # Widget que muestra una tarea individual

⚙️ Cómo Ejecutar el Proyecto
Sigue estos pasos para tener una copia del proyecto funcionando en tu máquina local.

Pre-requisitos
Asegúrate de tener el SDK de Flutter instalado en tu computadora. Si no lo tienes, sigue la guía oficial de instalación.

Instalación y Ejecución
Clona el repositorio:

git clone https://github.com/Adi-ahilin/IOT_EVA2_deja_de_procrastinar.git
Navega al directorio del proyecto:

cd procrastination_app
Instala las dependencias:

flutter pub get
Ejecuta la aplicación:

flutter run
La aplicación se iniciará en tu emulador o dispositivo físico conectado.

🌟 Posibles Mejoras a Futuro
Este proyecto es una excelente base que puede ser extendida con nuevas funcionalidades:

 Persistencia de Datos: Guardar las tareas localmente usando shared_preferences o una base de datos como sqflite para que no se pierdan al cerrar la app.
 Autenticación Real: Integrar un servicio como Firebase Authentication para un sistema de login y registro seguro.
 Sincronización en la Nube: Usar Firestore para guardar las tareas en la nube y sincronizarlas entre dispositivos.
 Notificaciones: Añadir recordatorios para las tareas con fechas de vencimiento.
 Añadir Fechas de Vencimiento: Implementar un selector de fechas (DatePicker) al crear o editar una tarea.
