# 1. Rastreador de Hábitos Diarios

DailyHabitTracker es una app iOS para registrar habitos diarios y visualizar el progreso del día. La interfaz es limpia y minimalista, y la navegación principal se organiza con un Tab Bar Controller.

## Funcionalidades principales
- Lista de habitos con Table View y celdas personalizadas.
- Marcado de completado por día con persistencia en UserDefaults.
- Resumen del progreso en una pestaña independiente.
- Sincronizacion de cambios entre pantallas con NotificationCenter.
- Feedback visual con Core Animation y vistas personalizadas.

## Arquitectura y patrones
- MVVM para separar la logica de presentacion del UI.
- Clean Architecture con capas claras: modelos, servicios, view models y vistas/controladores.
- Clean Code: componentes pequenos, responsabilidades unicas y dependencias simples.

## Componentes clave
- `RootTabBarController` como entrada de la app.
- `HabitsListViewController` para el listado de habitos.
- `StatsViewController` para el resumen diario.
- `HabitStore` como fuente de datos y persistencia.
- `CheckmarkView` para animaciones con Core Animation.

## Ejecucion
1. Abre el proyecto en Xcode.
2. Selecciona un simulador o dispositivo.
3. Ejecuta la app y registra el progreso diario.
