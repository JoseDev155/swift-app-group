# Las APP a desarrollar son las siguientes

## 1. Rastreador de Hábitos Diarios

Una app donde los usuarios listan sus metas diarias.

- **Funciones:** Usa `UITableView` para mostrar los hábitos. `NSUserDefaults` guarda el estado de "completado" del día. Al completar un hábito, se activa una Core Animation de confeti o un check animado.
- **Notificaciones:** El `NSNotificationCenter` avisa a otras pestañas del `TabBar` para actualizar las estadísticas de progreso global.

## 2. Gestor de Presupuesto Personal

Practicar la organización de datos complejos.

- **Funciones:** Emplear arreglos y diccionarios para agrupar gastos por categoría (Alimentos, Renta, etc.).
- **Interfaz:** Un `TabBarController` separa la entrada de gastos de los reportes visuales.
- **Animación:** Al superar un límite de gasto, una `UIView` de alerta puede vibrar o cambiar de color mediante animaciones de escala.

## 3. Lista de Tareas con Prioridad

- **Funciones:** `NSUserDefaults` para guardar tareas pendientes de forma permanente pero sencilla.
- **Interacción:** `NSNotificationCenter` para detectar cuando una tarea expira y cambiar el color de la celda en tiempo real.

## 4. Diario de Viajes

- **Funciones:** Un `UITableView` muestra los países visitados. Al tocar una celda, se expande una `UIView` con detalles usando una transición personalizada de Core Animation.
- **Persistencia:** Guarda las preferencias del usuario (como unidades de distancia o moneda) en `NSUserDefaults`.

## 5. Tarjetas de Estudio (Flashcards)

- **Funciones:** Los diccionarios guardan pares de "Pregunta: Respuesta".
- **Animación:** Usa Core Animation para crear el efecto de "voltear la carta" (flip animation) sobre una `UIView`.

## 6. Registro de Hidratación y Sueño

- **Funciones:** Diferentes pestañas en el `TabBar` para Agua, Sueño y Ajustes.
- **Comunicación:** Si el usuario registra agua en una pestaña, el `NSNotificationCenter` actualiza el resumen en la pestaña principal.

## 7. Mi Lista de Películas por Ver

- **Funciones:** Un `UITableView` con imágenes de posters. `NSUserDefaults` guarda la configuración de orden (alfabético o por fecha).
- **Visual:** Al borrar una película, usa animaciones de `UIView` para que la celda se desvanezca suavemente.

## 8. Monitor de Precios

- **Funciones:** Simula precios con un arreglo de datos. Usa `NSNotificationCenter` para refrescar la tabla cuando los "precios" cambien.
- **Feedback:** Si una moneda sube, el texto parpadea en verde usando una animación de opacidad de Core Animation.

## 9. Control de Inventario para Pequeños Negocios

- **Funciones:** Usa diccionarios anidados para organizar productos por pasillos o secciones.
- **Navegación:** Un `TabBar` para Inventario, Escáner (simulado) y Configuración de Perfil.

## 10. Temporizador Pomodoro Personalizable

- **Funciones:** La duración de los ciclos se guarda en `NSUserDefaults`.
- **Animación:** Una `UIView` circular que se va llenando o vaciando mediante `CABasicAnimation` (Core Animation) a medida que pasa el tiempo.