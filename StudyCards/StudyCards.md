# 5. Tarjetas de Estudio (Flashcards)

StudyCards es una app iOS para crear tarjetas de estudio con preguntas y respuestas, y repasarlas con un efecto de volteo. La navegacion principal se organiza con un Tab Bar Controller.

## Funcionalidades principales
- Lista de tarjetas con Table View y celdas personalizadas.
- CRUD completo: crear, editar y eliminar tarjetas.
- Pares Pregunta-Respuesta almacenados en diccionarios.
- Persistencia en UserDefaults.
- Sincronizacion entre pantallas con NotificationCenter.
- Feedback visual con Core Animation y UIView.

## Arquitectura y patrones
- MVVM para separar la logica de presentacion del UI.
- Clean Architecture con capas claras: modelos, servicios, view models y vistas/controladores.
- Clean Code: componentes pequenos, responsabilidades unicas y dependencias simples.

## Componentes clave
- `RootTabBarController` como entrada de la app.
- `CardsListViewController` para listado y CRUD.
- `StudyViewController` para el modo estudio y animacion de volteo.
- `StudyStore` como fuente de datos y persistencia.
- `CardFlipView` para el efecto de flip.

## Interaccion
- Boton "+" para crear tarjetas.
- Desliza a la izquierda para editar o eliminar.
- Boton "Editar" para activar el modo de borrado.
- Alertas para validacion de datos.

## Ejecucion
1. Abre el proyecto en Xcode.
2. Selecciona un simulador o dispositivo.
3. Ejecuta la app y crea tus tarjetas de estudio.
