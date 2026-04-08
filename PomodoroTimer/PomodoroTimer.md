# 10. Temporizador Pomodoro Personalizable

PomodoroTimer es una app iOS para gestionar sesiones de trabajo y descanso con tiempos configurables. La navegación principal se organiza con un Tab Bar Controller.

## Funcionalidades principales
- Temporizador con animación circular usando `CABasicAnimation`.
- CRUD completo de sesiones de Pomodoro.
- Resumen por modo y por día usando arreglos y diccionarios.
- Persistencia de sesiones y tiempos con UserDefaults.
- Sincronización entre pestañas con NotificationCenter.
- Alertas para validación y confirmaciones.

## Arquitectura y patrones
- MVVM para separar la lógica de presentación del UI.
- Clean Architecture con capas claras: modelos, servicios, view models y vistas/controladores.
- Clean Code: componentes pequeños, responsabilidades únicas y dependencias simples.

## Componentes clave
- `RootTabBarController` como entrada de la app.
- `TimerViewController` para el temporizador principal.
- `SessionsViewController` para el historial y CRUD.
- `SettingsViewController` para personalizar los tiempos.
- `PomodoroStore` como fuente de datos y persistencia.
- `ProgressRingView` con animación circular.

## Interacción
- Botón "Iniciar" para comenzar el temporizador.
- Botón "Reiniciar" para volver al inicio.
- Botón "Registrar" para guardar sesiones manuales.
- Alertas para validar datos.

## Ejecución
1. Abre el proyecto en Xcode.
2. Selecciona un simulador o dispositivo.
3. Ejecuta la app y personaliza tus ciclos Pomodoro.
