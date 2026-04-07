# 7. Mi Lista de Películas por Ver

MyMovieList es una app iOS para registrar películas por ver, ordenarlas y llevar un estado de visto o pendiente. La navegación principal se organiza con un Tab Bar Controller.

## Funcionalidades principales
- Lista con Table View y pósters simulados usando SF Symbols.
- CRUD completo: crear, editar y eliminar películas.
- Orden configurable por título o recientes (UserDefaults).
- Uso de arreglos y diccionarios para resumen por género y año.
- Sincronización entre pestañas con NotificationCenter.
- Animación de UIView al borrar una película y pulso con Core Animation.
- Alertas para validación y confirmaciones.

## Arquitectura y patrones
- MVVM para separar la lógica de presentación del UI.
- Clean Architecture con capas claras: modelos, servicios, view models y vistas/controladores.
- Clean Code: componentes pequeños, responsabilidades únicas y dependencias simples.

## Componentes clave
- `RootTabBarController` como entrada de la app.
- `MoviesListViewController` para el listado y CRUD.
- `SettingsViewController` para el orden y resúmenes.
- `MovieStore` como fuente de datos y persistencia.
- `MovieCell` para mostrar póster, estado y detalles.

## Interacción
- Botón "+" para agregar películas.
- Desliza a la izquierda para editar o eliminar.
- Boton "Editar" para activar el modo de borrado.
- Alertas para validar datos.

## Ejecución
1. Abre el proyecto en Xcode.
2. Selecciona un simulador o dispositivo.
3. Ejecuta la app y organiza tu lista de películas.
