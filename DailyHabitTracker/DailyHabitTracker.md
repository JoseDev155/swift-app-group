# 1. Rastreador de Hábitos Diarios

DailyHabitTracker es una app iOS para registrar habitos diarios y visualizar el progreso del dia. La interfaz es limpia y minimalista, y la navegación principal se organiza con un Tab Bar Controller.

## Funcionalidades principales
- Lista de habitos con Table View y celdas personalizadas.
- CRUD completo de habitos: crear, editar y eliminar.
- Marcado de completado por dia con persistencia en UserDefaults.
- Resumen del progreso en una pestana independiente.
- Sincronizacion de cambios entre pantallas con NotificationCenter.
- Feedback visual con Core Animation y vistas personalizadas.

## Arquitectura y patrones
- MVVM para separar la logica de presentacion del UI.
- Clean Architecture con capas claras: modelos, servicios, view models y vistas/controladores.
- Clean Code: componentes pequenos, responsabilidades unicas y dependencias simples.

## Componentes clave
- `RootTabBarController` como entrada de la app.
- `HabitsListViewController` para el listado de habitos y acciones CRUD.
- `StatsViewController` para el resumen diario.
- `HabitStore` como fuente de datos y persistencia.
- `CheckmarkView` para animaciones con Core Animation.

## Interacción
- Boton "+" para crear hábitos.
- Desliza a la izquierda en una fila para editar o eliminar.
- Botón "Editar" para activar el modo de borrado por filas.

## Ejecución
1. Abre el proyecto en Xcode.
2. Selecciona un simulador o dispositivo.
3. Ejecuta la app y registra el progreso diario.
