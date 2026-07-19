# Guía de Variables

Referencia rápida para no confundirse con los nombres de tablas y columnas.

> **Recuerda:** los nombres usan guion bajo `_` (no punto `.`).  
> Ejemplo: `fecha_hora` ✅ — `fecha.hora` ❌

---

## Clientes con pedidos entre fechas

| Variable              | Tabla    | Descripción                       |
| --------------------- | -------- | --------------------------------- |
| `clientes.nombre`     | clientes | Nombre del cliente                |
| `clientes.telefono`   | clientes | Teléfono del cliente              |
| `clientes.correo`     | clientes | Correo del cliente                |
| `clientes.id_cliente` | clientes | ID del cliente                    |
| `pedidos.id_cliente`  | pedidos  | ID del cliente (para unir tablas) |
| `pedidos.fecha_hora`  | pedidos  | Fecha y hora del pedido           |

**Palabras clave:** `DISTINCT`, `BETWEEN`, `JOIN`, `ON`

---

## Pizzas más vendidas

| Variable                   | Tabla           | Descripción                       |
| -------------------------- | --------------- | --------------------------------- |
| `pizzas.nombre`            | pizzas          | Nombre de la pizza                |
| `pizzas.tamano`            | pizzas          | Tamaño de la pizza                |
| `pizzas.id_pizza`          | pizzas          | ID de la pizza                    |
| `pedido_detalles.cantidad` | pedido_detalles | Cantidad pedida                   |
| `pedido_detalles.id_pizza` | pedido_detalles | ID de la pizza (para unir tablas) |

**Palabras clave:** `SUM`, `AS`, `GROUP BY`, `ORDER BY`, `DESC`

---

## Pedidos por repartidor

| Variable                     | Tabla        | Descripción                          |
| ---------------------------- | ------------ | ------------------------------------ |
| `repartidores.nombre`        | repartidores | Nombre del repartidor                |
| `repartidores.zona_asignada` | repartidores | Zona del repartidor                  |
| `repartidores.id_repartidor` | repartidores | ID del repartidor                    |
| `domicilios.id_repartidor`   | domicilios   | ID del repartidor (para unir tablas) |
| `domicilios.id_pedido`       | domicilios   | ID del pedido (para unir tablas)     |
| `pedidos.id_pedido`          | pedidos      | ID del pedido                        |
| `pedidos.fecha_hora`         | pedidos      | Fecha y hora del pedido              |
| `pedidos.estado`             | pedidos      | Estado del pedido                    |

**Palabras clave:** `AS`, `JOIN` (doble), `ORDER BY`, `DESC`

---

## Promedio de entrega por zona

| Variable                     | Tabla        | Descripción                          |
| ---------------------------- | ------------ | ------------------------------------ |
| `repartidores.zona_asignada` | repartidores | Zona del repartidor                  |
| `repartidores.id_repartidor` | repartidores | ID del repartidor                    |
| `domicilios.id_repartidor`   | domicilios   | ID del repartidor (para unir tablas) |
| `domicilios.hora_salida`     | domicilios   | Hora de salida del domicilio         |
| `domicilios.hora_entrega`    | domicilios   | Hora de entrega del domicilio        |

**Palabras clave:** `AVG`, `TIMESTAMPDIFF`, `IS NOT NULL`, `GROUP BY`

---

## Clientes que gastaron más de $500

| Variable              | Tabla    | Descripción                       |
| --------------------- | -------- | --------------------------------- |
| `clientes.nombre`     | clientes | Nombre del cliente                |
| `clientes.id_cliente` | clientes | ID del cliente                    |
| `pedidos.id_cliente`  | pedidos  | ID del cliente (para unir tablas) |
| `pedidos.total`       | pedidos  | Total del pedido                  |

**Palabras clave:** `SUM`, `AS`, `GROUP BY`, `HAVING`

---

## Búsqueda con LIKE

| Variable      | Tabla  | Descripción             |
| ------------- | ------ | ----------------------- |
| `nombre`      | pizzas | Nombre de la pizza      |
| `tamano`      | pizzas | Tamaño de la pizza      |
| `precio_base` | pizzas | Precio base de la pizza |
| `tipo`        | pizzas | Tipo de pizza           |

**Palabras clave:** `LIKE`, `%`

> Esta consulta no usa `tabla.columna` porque solo trabaja con una tabla (`pizzas`), no hay ambigüedad.

---

## Clientes frecuentes (subconsulta)

| Variable     | Tabla              | Descripción             |
| ------------ | ------------------ | ----------------------- |
| `nombre`     | clientes           | Nombre del cliente      |
| `telefono`   | clientes           | Teléfono del cliente    |
| `correo`     | clientes           | Correo del cliente      |
| `id_cliente` | clientes / pedidos | ID del cliente          |
| `fecha_hora` | pedidos            | Fecha y hora del pedido |
| `id_pedido`  | pedidos            | ID del pedido           |

**Palabras clave:** `IN`, `MONTH`, `YEAR`, `GROUP BY`, `HAVING`, `COUNT`

> Esta consulta tampoco usa `tabla.columna` porque la consulta principal solo toca `clientes` y la subconsulta solo toca `pedidos`.

---

## Resumen: Todas las Tablas y sus Columnas

### clientes

- `id_cliente`, `nombre`, `telefono`, `direccion`, `correo`

### pizzas

- `id_pizza`, `nombre`, `tamano`, `precio_base`, `tipo`

### pedidos

- `id_pedido`, `id_cliente`, `fecha_hora`, `metodo_pago`, `estado`, `total`

### pedido_detalles

- `id_detalle`, `id_pedido`, `id_pizza`, `cantidad`, `subtotal`

### repartidores

- `id_repartidor`, `nombre`, `zona_asignada`, `estado`

### domicilios

- `id_domicilio`, `id_pedido`, `id_repartidor`, `hora_salida`, `hora_entrega`, `distancia_km`, `costo_envio`

### ingredientes

- `id_ingrediente`, `nombre`, `stock_disponible`, `stock_minimo`, `unidad_medida`, `costo_por_unidad`

### pizza_ingredientes

- `id_pizza`, `id_ingrediente`, `cantidad_requerida`

### historial_precios

- `id_historial`, `id_pizza`, `precio_anterior`, `precio_nuevo`, `fecha_modificacion`
