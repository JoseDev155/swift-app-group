# 2. Gestor de Presupuesto Personal

PersonalBudgetManager es una app iOS para registrar ingresos y gastos, agruparlos por categoria y visualizar el balance mensual. La navegacion principal se organiza con un Tab Bar Controller.

## Funcionalidades principales
- Lista de movimientos con Table View y celdas personalizadas.
- CRUD completo de movimientos: crear, editar y eliminar.
- Agrupación por categoría usando arreglos y diccionarios.
- Límite mensual configurable con alerta al superar el gasto.
- Persistencia en UserDefaults para movimientos y límite.
- Sincronización de cambios entre pantallas con NotificationCenter.
- Feedback visual con Core Animation y UIView.

## Arquitectura y patrones
- MVVM para separar la logica de presentacion del UI.
- Clean Architecture con capas claras: modelos, servicios, view models y vistas/controladores.
- Clean Code: componentes pequenos, responsabilidades únicas y dependencias simples.

## Componentes clave
- `RootTabBarController` como entrada de la app.
- `BudgetListViewController` para movimientos y CRUD.
- `ReportsViewController` para resumen y categorias.
- `BudgetStore` como fuente de datos y persistencia.
- `LimitWarningView` para alertas visuales con animacion.

## Interacción
- Boton "+" para crear un movimiento.
- Desliza a la izquierda en una fila para editar o eliminar.
- Botón "Editar" para activar el modo de borrado.
- Botón "Limite" para definir el límite mensual.

## Ejecución
1. Abre el proyecto en Xcode.
2. Selecciona un simulador o dispositivo.
3. Ejecuta la app y registra ingresos y gastos.
