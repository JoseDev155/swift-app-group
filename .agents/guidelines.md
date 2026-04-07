# Guía operativa para la codificacion

- Mantener el alcance centrado en la app activa del momento; no mezclar requisitos de otros proyectos o ideas genéricas.
- Preferir UIKit y vistas por codigo cuando sea mas claro que depender del storyboard por defecto.
- Si una pantalla requiere navegacion global, usar Tab Bar Controller; si requiere listas, usar Table View.
- Persistir estados sencillos con UserDefaults cuando el problema no justifique Core Data.
- Usar NotificationCenter para sincronizar pantallas o pestañas cuando haya cambios de estado compartido.
- Introducir animaciones con Core Animation o UIView solo cuando aporten feedback util.
- Evitar duplicar logica entre controladores; extraer modelos, helpers o servicios pequenos cuando sea necesario.
- No reemplazar ni eliminar la estructura del proyecto Xcode sin una razon funcional clara.
