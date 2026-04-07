# 6. Registro de Hidratación y Sueño

HydrationSleep es una app iOS para registrar tomas de agua y horas de sueño, con un resumen diario y metas configurables. La navegación principal se organiza con un Tab Bar Controller.

## Funcionalidades principales
- Tab Bar con tres pestañas: Agua, Sueño y Ajustes.
- CRUD completo para registros de agua y sueño.
- Resumen diario con progreso visual y Core Animation.
- Uso de arreglos y diccionarios para agrupar datos por día y calidad.
- Persistencia local con UserDefaults.
- Sincronización entre pestañas con NotificationCenter.
- Alertas para validación y confirmaciones.

## Arquitectura y patrones
- MVVM para separar la logica de presentacion del UI.
- Clean Architecture con capas claras: modelos, servicios, view models y vistas/controladores.
- Clean Code: componentes pequenos, responsabilidades unicas y dependencias simples.

## Componentes clave
- `RootTabBarController` como entrada de la app.
- `HydrationListViewController` para registros de agua.
- `SleepListViewController` para registros de sueño.
- `SettingsViewController` para metas y resumen.
- `HydrationSleepStore` como fuente de datos y persistencia.
- `SummaryCardView` con animación de progreso.

## Interacción
- Botón "+" para agregar registros.
- Desliza a la izquierda para editar o eliminar.
- Botón "Editar" para activar el modo de borrado.
- Alertas para validar datos y confirmar eliminaciones.

## Ejecución
1. Abre el proyecto en Xcode.
2. Selecciona un simulador o dispositivo.
3. Ejecuta la app y registra agua y sueño.
