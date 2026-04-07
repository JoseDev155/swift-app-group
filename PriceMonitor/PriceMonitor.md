# 8. Monitor de Precios

PriceMonitor es una app iOS para simular precios y monitorear cambios en tiempo real. La navegacion principal se organiza con un Tab Bar Controller.

## Funcionalidades principales
- Lista con Table View y actualizaciones simuladas.
- CRUD completo: crear, editar y eliminar precios.
- Uso de arreglos y diccionarios para resumenes por moneda.
- Persistencia local con UserDefaults.
- Sincronizacion entre pestañas con NotificationCenter.
- Feedback visual cuando un precio sube mediante animacion de opacidad.
- Alertas para validacion y confirmaciones.

## Arquitectura y patrones
- MVVM para separar la logica de presentacion del UI.
- Clean Architecture con capas claras: modelos, servicios, view models y vistas/controladores.
- Clean Code: componentes pequenos, responsabilidades unicas y dependencias simples.

## Componentes clave
- `RootTabBarController` como entrada de la app.
- `PriceListViewController` para el listado y CRUD.
- `PriceSummaryViewController` para el resumen de monedas.
- `PriceStore` como fuente de datos y persistencia.
- `PriceCell` con animacion de parpadeo cuando sube un precio.

## Interaccion
- Boton "+" para agregar precios.
- Boton "Simular" para cambios aleatorios.
- Desliza a la izquierda para editar o eliminar.
- Alertas para validar datos.

## Ejecucion
1. Abre el proyecto en Xcode.
2. Selecciona un simulador o dispositivo.
3. Ejecuta la app y monitorea los precios.
