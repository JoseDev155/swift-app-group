# 4. Diario de Viajes

TravelDiary es una app iOS para registrar países visitados, guardar notas y visualizar un resumen anual. La navegación principal se organiza con un Tab Bar Controller.

## Funcionalidades principales
- Lista de viajes con Table View y celdas personalizadas.
- CRUD completo: crear, editar y eliminar viajes.
- Vista de detalles expandible con animación con Core Animation.
- Resumen por año usando arreglos y diccionarios.
- Persistencia de preferencias (unidad y moneda) con UserDefaults.
- Sincronización de cambios entre pantallas con NotificationCenter.
- Alertas para validación y confirmaciones.

## Arquitectura y patrones
- MVVM para separar la lógica de presentación del UI.
- Clean Architecture con capas claras: modelos, servicios, view models y vistas/controladores.
- Clean Code: componentes pequeños, responsabilidades únicas y dependencias simples.

## Componentes clave
- `RootTabBarController` como entrada de la app.
- `TravelListViewController` para el diario y CRUD.
- `TravelSummaryViewController` para el resumen por año.
- `TravelSettingsViewController` para preferencias.
- `TravelStore` como fuente de datos y persistencia.
- `TravelEntryCell` con detalle expandible.

## Interacción
- Botón "+" para agregar un viaje.
- Desliza a la izquierda para editar o eliminar.
- Botón "Editar" para activar el modo de borrado.
- Alertas para validar datos.

## Ejecución
1. Abre el proyecto en Xcode.
2. Selecciona un simulador o dispositivo.
3. Ejecuta la app y registra tus viajes.
