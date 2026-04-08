# 9. Control de Inventario para Pequeños Negocios

InventoryControl es una app iOS para registrar productos, ubicarlos por pasillos y secciones, y detectar bajo stock. La navegación principal se organiza con un Tab Bar Controller.

## Funcionalidades principales
- Tab Bar con Inventario, Escáner, Historial y Perfil.
- CRUD completo: crear, editar y eliminar productos.
- Diccionarios anidados para agrupar productos por pasillo y sección.
- Persistencia local con UserDefaults.
- Sincronización entre pestañas con NotificationCenter.
- Feedback visual con Core Animation para bajo stock.
- Alertas para validación y confirmaciones.

## Arquitectura y patrones
- MVVM para separar la lógica de presentación del UI.
- Clean Architecture con capas claras: modelos, servicios, view models y vistas/controladores.
- Clean Code: componentes pequeños, responsabilidades únicas y dependencias simples.

## Componentes clave
- `RootTabBarController` como entrada de la app.
- `InventoryListViewController` para el listado y CRUD.
- `ScannerViewController` para simular escaneos rápidos.
- `ProfileViewController` para datos del negocio y resúmenes.
- `ScanHistoryViewController` para el historial de escaneos.
- `InventoryStore` como fuente de datos y persistencia.
- `InventoryItemCell` con indicador de bajo stock.

## Interacción
- Botón "+" para agregar productos.
- Botón "Editar" para activar el modo de borrado.
- Desliza a la izquierda para editar o eliminar.
- Alertas para validar datos.

## Ejecución
1. Abre el proyecto en Xcode.
2. Selecciona un simulador o dispositivo.
3. Ejecuta la app y registra el inventario.
