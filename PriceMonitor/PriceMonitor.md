# 8. Monitor de Precios

PriceMonitor es una app iOS para simular precios y monitorear cambios en tiempo real. La navegación principal se organiza con un Tab Bar Controller.

## Funcionalidades principales
- Lista con Table View y actualizaciones simuladas.
- CRUD completo: crear, editar y eliminar precios.
- Uso de arreglos y diccionarios para resúmenes por moneda.
- Persistencia local con UserDefaults.
- Sincronización entre pestañas con NotificationCenter.
- Feedback visual cuando un precio sube mediante animación de opacidad.
- Alertas para validación y confirmaciones.

## Arquitectura y patrones
- MVVM para separar la lógica de presentación del UI.
- Clean Architecture con capas claras: modelos, servicios, view models y vistas/controladores.
- Clean Code: componentes pequeños, responsabilidades únicas y dependencias simples.

## Componentes clave
- `RootTabBarController` como entrada de la app.
- `PriceListViewController` para el listado y CRUD.
- `PriceSummaryViewController` para el resumen de monedas.
- `PriceStore` como fuente de datos y persistencia.
- `PriceCell` con animación de parpadeo cuando sube un precio.

## Interacción
- Botón "+" para agregar precios.
- Botón "Simular" para cambios aleatorios.
- Desliza a la izquierda para editar o eliminar.
- Alertas para validar datos.

## Ejecución
1. Abre el proyecto en Xcode.
2. Selecciona un simulador o dispositivo.
3. Ejecuta la app y monitorea los precios.
