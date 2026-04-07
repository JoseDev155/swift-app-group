# 5. Tarjetas de Estudio (Flashcards)

StudyCards es una app iOS para crear tarjetas de estudio con preguntas y respuestas, y repasarlas con un efecto de volteo. La navegación principal se organiza con un Tab Bar Controller.

## Funcionalidades principales
- Lista de tarjetas con Table View y celdas personalizadas.
- CRUD completo: crear, editar y eliminar tarjetas.
- Pares Pregunta-Respuesta almacenados en diccionarios.
- Persistencia en UserDefaults.
- Sincronización entre pantallas con NotificationCenter.
- Feedback visual con Core Animation y UIView.

## Arquitectura y patrones
- MVVM para separar la lógica de presentación del UI.
- Clean Architecture con capas claras: modelos, servicios, view models y vistas/controladores.
- Clean Code: componentes pequeños, responsabilidades únicas y dependencias simples.

## Componentes clave
- `RootTabBarController` como entrada de la app.
- `CardsListViewController` para listado y CRUD.
- `StudyViewController` para el modo estudio y animación de volteo.
- `StudyStore` como fuente de datos y persistencia.
- `CardFlipView` para el efecto de flip.

## Interacción
- Botón "+" para crear tarjetas.
- Desliza a la izquierda para editar o eliminar.
- Botón "Editar" para activar el modo de borrado.
- Alertas para validación de datos.

## Ejecución
1. Abre el proyecto en Xcode.
2. Selecciona un simulador o dispositivo.
3. Ejecuta la app y crea tus tarjetas de estudio.
