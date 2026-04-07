# 3. Lista de Tareas con Prioridad

ToDoList es una app iOS para crear tareas con prioridad, marcar completadas y controlar vencimientos. La navegación principal se organiza con un Tab Bar Controller.

## Funcionalidades principales
- Lista de tareas con Table View y celdas personalizadas.
- CRUD completo: crear, editar y eliminar tareas.
- Prioridades Alta, Media y Baja.
- Vencimientos con cambio de color en tiempo real.
- Persistencia en UserDefaults.
- Sincronización entre pantallas con NotificationCenter.
- Feedback visual con Core Animation y UIView.

## Arquitectura y patrones
- MVVM para separar la lógica de presentación del UI.
- Clean Architecture con capas claras: modelos, servicios, view models y vistas/controladores.
- Clean Code: componentes pequeños, responsabilidades únicas y dependencias simples.

## Componentes clave
- `RootTabBarController` como entrada de la app.
- `TaskListViewController` para listado y CRUD.
- `TaskSummaryViewController` para resumen por prioridad.
- `TaskStore` como fuente de datos y persistencia.
- `TaskCell` con indicador animado para vencidas.

## Interacción
- Botón "+" para crear tareas.
- Desliza a la izquierda para editar o eliminar.
- Botón "Editar" para activar el modo de borrado.
- Alertas para validación de datos.

## Ejecución
1. Abre el proyecto en Xcode.
2. Selecciona un simulador o dispositivo.
3. Ejecuta la app y gestiona tus tareas.
