# 7. Mi Lista de Peliculas por Ver

MyMovieList es una app iOS para registrar peliculas por ver, ordenarlas y llevar un estado de visto o pendiente. La navegacion principal se organiza con un Tab Bar Controller.

## Funcionalidades principales
- Lista con Table View y posters simulados usando SF Symbols.
- CRUD completo: crear, editar y eliminar peliculas.
- Orden configurable por titulo o recientes (UserDefaults).
- Uso de arreglos y diccionarios para resumen por genero y anio.
- Sincronizacion entre pestañas con NotificationCenter.
- Animacion de UIView al borrar una pelicula y pulso con Core Animation.
- Alertas para validacion y confirmaciones.

## Arquitectura y patrones
- MVVM para separar la logica de presentacion del UI.
- Clean Architecture con capas claras: modelos, servicios, view models y vistas/controladores.
- Clean Code: componentes pequenos, responsabilidades unicas y dependencias simples.

## Componentes clave
- `RootTabBarController` como entrada de la app.
- `MoviesListViewController` para el listado y CRUD.
- `SettingsViewController` para el orden y resumenes.
- `MovieStore` como fuente de datos y persistencia.
- `MovieCell` para mostrar poster, estado y detalles.

## Interaccion
- Boton "+" para agregar peliculas.
- Desliza a la izquierda para editar o eliminar.
- Boton "Editar" para activar el modo de borrado.
- Alertas para validar datos.

## Ejecucion
1. Abre el proyecto en Xcode.
2. Selecciona un simulador o dispositivo.
3. Ejecuta la app y organiza tu lista de peliculas.
