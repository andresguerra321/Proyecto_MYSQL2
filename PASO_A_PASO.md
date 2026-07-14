# 🎓 Tutorial Completo y Detallado: Construye la Base de Datos "Pizzería Don Piccolo" desde Cero

¡Hola! Bienvenido a este recorrido completo. Hoy te vas a poner el sombrero de **Arquitecto de Datos** y vamos a construir juntos, línea por línea, el sistema de gestión de la **Pizzería Don Piccolo**.

Este tutorial cubre **absolutamente todo** lo que tiene el proyecto:

- 9 tablas con sus relaciones
- Datos de prueba para poder probar todo
- 2 funciones
- 1 procedimiento almacenado
- 3 triggers
- 3 vistas
- 7 consultas avanzadas
- Verificaciones paso a paso para comprobar que todo funciona

Prepara tu herramienta (MySQL Workbench, DBeaver, phpMyAdmin o la consola de MySQL) y ¡empecemos! 🚀

---

# 📋 ÍNDICE COMPLETO

1. [Paso 1: Crear la Base de Datos](#paso-1-crear-la-base-de-datos)
2. [Paso 2: Crear las Tablas Maestras (Clientes, Pizzas, Ingredientes, Repartidores)](#paso-2-crear-las-tablas-maestras)
3. [Paso 3: Crear la Tabla Puente — Receta de Pizzas](#paso-3-crear-la-tabla-puente--receta-de-pizzas)
4. [Paso 4: Crear las Tablas Transaccionales (Pedidos, Detalles, Domicilios)](#paso-4-crear-las-tablas-transaccionales)
5. [Paso 5: Crear la Tabla de Auditoría (Historial de Precios)](#paso-5-crear-la-tabla-de-auditoría)
6. [Paso 6: Insertar Datos de Prueba Completos](#paso-6-insertar-datos-de-prueba-completos)
7. [Paso 7: Crear la Función — Calcular Total del Pedido](#paso-7-crear-la-función--calcular-total-del-pedido)
8. [Paso 8: Crear la Función — Calcular Ganancia Neta Diaria](#paso-8-crear-la-función--calcular-ganancia-neta-diaria)
9. [Paso 9: Crear el Procedimiento — Registrar Hora de Entrega](#paso-9-crear-el-procedimiento--registrar-hora-de-entrega)
10. [Paso 10: Crear el Trigger — Descontar Stock Automáticamente](#paso-10-crear-el-trigger--descontar-stock-automáticamente)
11. [Paso 11: Crear el Trigger — Auditoría de Precios de Pizzas](#paso-11-crear-el-trigger--auditoría-de-precios-de-pizzas)
12. [Paso 12: Crear el Trigger — Liberar Repartidor al Entregar](#paso-12-crear-el-trigger--liberar-repartidor-al-entregar)
13. [Paso 13: Crear la Vista — Resumen de Pedidos por Cliente](#paso-13-crear-la-vista--resumen-de-pedidos-por-cliente)
14. [Paso 14: Crear la Vista — Desempeño de Repartidores](#paso-14-crear-la-vista--desempeño-de-repartidores)
15. [Paso 15: Crear la Vista — Alertas de Stock Bajo](#paso-15-crear-la-vista--alertas-de-stock-bajo)
16. [Paso 16: Consulta 1 — Clientes con Pedidos entre Dos Fechas (BETWEEN)](#paso-16-consulta-1--clientes-con-pedidos-entre-dos-fechas)
17. [Paso 17: Consulta 2 — Pizzas Más Vendidas (GROUP BY y COUNT)](#paso-17-consulta-2--pizzas-más-vendidas)
18. [Paso 18: Consulta 3 — Pedidos por Repartidor (JOIN múltiple)](#paso-18-consulta-3--pedidos-por-repartidor)
19. [Paso 19: Consulta 4 — Promedio de Entrega por Zona (AVG)](#paso-19-consulta-4--promedio-de-entrega-por-zona)
20. [Paso 20: Consulta 5 — Clientes que Gastaron más de un Monto (HAVING)](#paso-20-consulta-5--clientes-que-gastaron-más-de-un-monto)
21. [Paso 21: Consulta 6 — Búsqueda Parcial de Pizzas (LIKE)](#paso-21-consulta-6--búsqueda-parcial-de-pizzas)
22. [Paso 22: Consulta 7 — Clientes Frecuentes del Mes (Subconsulta)](#paso-22-consulta-7--clientes-frecuentes-del-mes)

---

# Paso 1: Crear la Base de Datos

Lo primero que necesitamos es un "contenedor" donde vivirán todas nuestras tablas. En MySQL, ese contenedor se llama **Base de Datos** (o **Schema**).

Abre tu editor de consultas y escribe esto:

```sql
CREATE DATABASE IF NOT EXISTS pizzeria_don_piccolo;
```

**¿Qué hace cada parte de esta línea?**

- `CREATE DATABASE`: Es la instrucción de MySQL para crear una base de datos nueva.
- `IF NOT EXISTS`: Es un seguro. Si por alguna razón ejecutas este script dos veces (por ejemplo, si te equivocas y lo vuelves a correr), MySQL no va a lanzar un error diciendo "¡Ya existe!". Simplemente lo ignora y sigue adelante. Sin esta cláusula, la segunda ejecución fallaría.
- `pizzeria_don_piccolo`: Es el nombre que le damos a nuestra base de datos. Usamos guiones bajos (`_`) en lugar de espacios porque MySQL no acepta espacios en los nombres.

Ahora necesitamos decirle a MySQL que **todo lo que hagamos de aquí en adelante** vaya dirigido a esa base de datos:

```sql
USE pizzeria_don_piccolo;
```

**¿Qué hace `USE`?** Le dice al motor: "Selecciona esta base de datos como la activa. Todas las tablas, funciones y consultas que cree a continuación deben pertenecer a `pizzeria_don_piccolo`". Sin este comando, MySQL no sabría dónde crear las tablas.

**Ejecútalo.** Deberías ver un mensaje como: *"Query OK, 1 row affected"*.

---

# Paso 2: Crear las Tablas Maestras

Las tablas maestras son las que almacenan la información base del negocio: los clientes, las pizzas del menú, los ingredientes de la bodega y los repartidores. Estas tablas **no dependen de otras**, por eso las creamos primero. Si intentáramos crear la tabla de pedidos antes que la de clientes, MySQL nos daría un error de llave foránea.

## 2.1 Tabla: `clientes`

Esta tabla guarda la información personal de cada cliente de la pizzería.

```sql
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    correo VARCHAR(100)
);
```

**Explicación columna por columna:**

| Columna      | Tipo de Dato     | ¿Qué significa?                                                                                                                                                                                                                                                              |
| ------------ | ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `id_cliente` | `INT`            | Almacena un número entero. El rango va de -2,147,483,648 hasta 2,147,483,647. Más que suficiente para los clientes de una pizzería.                                                                                                                                          |
|              | `AUTO_INCREMENT` | MySQL se encarga de asignar el número automáticamente. El primer cliente será 1, el segundo 2, el tercero 3... **Nunca debes insertar este campo manualmente**, MySQL lo hace solo.                                                                                          |
|              | `PRIMARY KEY`    | Marca esta columna como el identificador único de la tabla. Esto significa que: (1) no puede haber dos clientes con el mismo `id_cliente`, y (2) MySQL crea internamente un **índice** sobre esta columna, lo que hace que las búsquedas por ID sean extremadamente rápidas. |
| `nombre`     | `VARCHAR(100)`   | Almacena texto de longitud **variable** hasta 100 caracteres. Si escribes "Ana" (3 letras), solo ocupa 3 bytes en disco, no 100. Esto es mucho más eficiente que `CHAR(100)`, que siempre reservaría 100 bytes sin importar la longitud real.                                |
|              | `NOT NULL`       | Es una restricción que **prohíbe** dejar este campo vacío. Si alguien intenta insertar un cliente sin nombre, MySQL rechazará la operación con un error. Los campos sin `NOT NULL` (como `telefono`) sí pueden quedar vacíos (`NULL`).                                       |
| `telefono`   | `VARCHAR(20)`    | Usamos `VARCHAR` y no `INT` porque los teléfonos pueden tener signos como `+`, `-`, paréntesis, o empezar con `0` (y los enteros eliminan los ceros a la izquierda).                                                                                                         |
| `direccion`  | `VARCHAR(255)`   | 255 caracteres para direcciones largas como "Carrera 50 Norte #12-40, Barrio El Poblado, Edificio Torre Central, Apto 502".                                                                                                                                                  |
| `correo`     | `VARCHAR(100)`   | Para el email del cliente. No tiene `NOT NULL`, así que es opcional.                                                                                                                                                                                                         |

## 2.2 Tabla: `pizzas`

El catálogo de pizzas que vende Don Piccolo.

```sql
CREATE TABLE pizzas (
    id_pizza INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tamano ENUM('Pequeña', 'Mediana', 'Familiar', 'Mega') NOT NULL,
    precio_base DECIMAL(10, 2) NOT NULL,
    tipo ENUM('Vegetariana', 'Especial', 'Clásica') NOT NULL
);
```

**Explicación de los tipos de datos nuevos:**

| Columna       | Tipo de Dato                                     | ¿Qué significa?                                                                                                                                                                                                                                                                                                                                                                         |
| ------------- | ------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `tamano`      | `ENUM('Pequeña', 'Mediana', 'Familiar', 'Mega')` | `ENUM` es una **lista cerrada de valores permitidos**. MySQL solo aceptará exactamente uno de esos 4 valores. Si alguien intenta insertar `'Gigante'` o `'XL'`, MySQL rechazará la operación con un error. Esto protege la integridad de tus datos a nivel del motor, sin depender de validaciones en el código de la aplicación.                                                       |
| `precio_base` | `DECIMAL(10, 2)`                                 | **Regla de oro para dinero: NUNCA uses `FLOAT` o `DOUBLE`**. Esos tipos hacen aproximaciones binarias internas. Ejemplo real: si sumas 0.1 + 0.2 con `FLOAT`, el resultado puede dar 0.30000000000000004 en vez de 0.30. Con `DECIMAL`, todo es exacto. El `(10, 2)` significa: hasta 10 dígitos en total, de los cuales 2 son decimales. Entonces el valor máximo sería `99999999.99`. |
| `tipo`        | `ENUM('Vegetariana', 'Especial', 'Clásica')`     | Mismo concepto que `tamano`. Restringe las categorías posibles de la pizza.                                                                                                                                                                                                                                                                                                             |

## 2.3 Tabla: `ingredientes`

El inventario de la bodega de ingredientes.

```sql
CREATE TABLE ingredientes (
    id_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    stock_disponible DECIMAL(10, 2) NOT NULL DEFAULT 0,
    stock_minimo DECIMAL(10, 2) NOT NULL DEFAULT 0,
    unidad_medida VARCHAR(20) NOT NULL,
    costo_por_unidad DECIMAL(10, 2) NOT NULL
);
```

**¿Qué hace `DEFAULT 0`?**
Cuando insertas un ingrediente nuevo y no especificas cuánto stock hay, MySQL le asignará el valor `0` en vez de dejarlo en `NULL`. ¿Por qué importa? Porque las operaciones matemáticas con `NULL` dan `NULL`. Ejemplo:

- `5000 - NULL` = `NULL` (se pierde el dato)
- `5000 - 0` = `5000` (resultado correcto)

El `stock_minimo` es la cantidad mínima que siempre debería haber en bodega. Lo usaremos más adelante para crear una vista de alertas.

## 2.4 Tabla: `repartidores`

El equipo de repartidores de la pizzería.

```sql
CREATE TABLE repartidores (
    id_repartidor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    zona_asignada VARCHAR(50),
    estado ENUM('Disponible', 'No Disponible') NOT NULL DEFAULT 'Disponible'
);
```

**Detalle importante:** `DEFAULT 'Disponible'` hace que cuando contratamos a un repartidor nuevo, su estado inicial siempre sea "Disponible" sin necesidad de especificarlo manualmente en el `INSERT`. Más adelante, un trigger se encargará de cambiar este estado automáticamente cuando esté haciendo una entrega.

---

# Paso 3: Crear la Tabla Puente — Receta de Pizzas

Aquí resolvemos una situación llamada **Relación de Muchos a Muchos (N:M)**:

- Una pizza tiene **muchos** ingredientes (la Hawaiana lleva queso, piña, jamón...).
- Un ingrediente se usa en **muchas** pizzas (el queso va en la Hawaiana, la Pepperoni, la Cuatro Quesos...).

Las bases de datos relacionales **no pueden representar esta relación directamente**. La solución es crear una **tabla puente** (también llamada tabla intermedia o de rompimiento) que conecte ambas:

```sql
CREATE TABLE pizza_ingredientes (
    id_pizza INT,
    id_ingrediente INT,
    cantidad_requerida DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id_pizza, id_ingrediente),
    FOREIGN KEY (id_pizza) REFERENCES pizzas(id_pizza) ON DELETE CASCADE,
    FOREIGN KEY (id_ingrediente) REFERENCES ingredientes(id_ingrediente) ON DELETE CASCADE
);
```

**Explicación detallada de cada concepto nuevo:**

**`PRIMARY KEY (id_pizza, id_ingrediente)`** — **Llave Primaria Compuesta:**
A diferencia de las tablas anteriores donde la llave era una sola columna, aquí la llave la forman **dos columnas juntas**. Esto significa que:

- Puedes tener: Pizza 1 con Ingrediente 1, y Pizza 1 con Ingrediente 2 (diferentes ingredientes para la misma pizza ✅).
- Puedes tener: Pizza 1 con Ingrediente 1, y Pizza 2 con Ingrediente 1 (el mismo ingrediente en diferentes pizzas ✅).
- **NO** puedes tener: Pizza 1 con Ingrediente 1 **dos veces** (no puedes meter Queso dos veces en la misma receta ❌).

**`FOREIGN KEY (id_pizza) REFERENCES pizzas(id_pizza)`** — **Llave Foránea:**
Le dice a MySQL: "El valor de `id_pizza` en esta tabla **debe existir** previamente en la columna `id_pizza` de la tabla `pizzas`". Si intentas crear una receta para la pizza ID 999 y esa pizza no existe, MySQL rechazará la operación. Esto se llama **Integridad Referencial**.

**`ON DELETE CASCADE`** — **Borrado en Cascada:**
Imagina que el dueño decide sacar la Hawaiana del menú y la borra de la tabla `pizzas`. Sin `CASCADE`, MySQL te daría un error porque la receta de la Hawaiana sigue existiendo aquí. Con `CASCADE`, MySQL borra automáticamente las filas de la receta que pertenecían a esa pizza. Es como decir: "Si el padre muere, los hijos dependientes también se eliminan".

---

# Paso 4: Crear las Tablas Transaccionales

Estas tablas registran las operaciones del día a día: los pedidos que hacen los clientes, el detalle de qué pizzas pidieron, y la información de los viajes de domicilio.

## 4.1 Tabla: `pedidos`

La cabecera del "ticket de compra".

```sql
CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    metodo_pago ENUM('Efectivo', 'Tarjeta', 'App') NOT NULL,
    estado ENUM('Pendiente', 'En preparación', 'En camino', 'Entregado', 'Cancelado') NOT NULL DEFAULT 'Pendiente',
    total DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);
```

**Conceptos clave:**

- **`DATETIME`**: Almacena fecha y hora juntos. Formato: `'2025-03-15 14:30:00'` (año-mes-día hora:minuto:segundo).
- **`DEFAULT CURRENT_TIMESTAMP`**: En el momento exacto (milisegundo) en que se inserta un nuevo pedido, MySQL toma la fecha y hora del reloj del servidor y la guarda automáticamente. Esto es mucho más confiable que enviar la hora desde la aplicación, porque evita problemas de zonas horarias o de manipulación.
- **`DEFAULT 'Pendiente'`**: Todo pedido nuevo nace con estado "Pendiente". Luego un empleado o el sistema lo cambiará a "En preparación", "En camino", "Entregado" o "Cancelado".
- **`FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)`**: No puedes crear un pedido para un cliente que no existe en la tabla `clientes`. MySQL lo garantiza.

## 4.2 Tabla: `pedido_detalles`

Las líneas individuales del ticket. Si un cliente pidió 2 Hawaianas y 1 Pepperoni, serán 2 filas aquí.

```sql
CREATE TABLE pedido_detalles (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_pizza INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_pizza) REFERENCES pizzas(id_pizza)
);
```

**Observación crítica sobre el CASCADE aquí:**

- `id_pedido` tiene `ON DELETE CASCADE`: Si se borra un pedido (por ejemplo, fue un pedido de prueba o un error), se borran automáticamente sus líneas de detalle. Tiene sentido, porque el detalle no tiene vida propia sin su pedido.
- `id_pizza` **NO tiene CASCADE**: Si sacamos la Hawaiana del menú mañana, **NO queremos borrar los registros históricos** de todas las Hawaianas que se vendieron en el pasado. Esos datos son contables y deben preservarse.

## 4.3 Tabla: `domicilios`

Cada registro representa un viaje del repartidor.

```sql
CREATE TABLE domicilios (
    id_domicilio INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_repartidor INT NOT NULL,
    hora_salida DATETIME,
    hora_entrega DATETIME,
    distancia_km DECIMAL(5, 2),
    costo_envio DECIMAL(10, 2) NOT NULL DEFAULT 0,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_repartidor) REFERENCES repartidores(id_repartidor)
);
```

**¿Por qué `hora_salida` y `hora_entrega` no tienen `NOT NULL`?**
Porque cuando se crea el registro del domicilio, el repartidor aún no ha salido. La `hora_salida` se llena cuando el repartidor sale de la pizzería, y la `hora_entrega` se llena cuando confirma que llegó al destino. Así que al inicio, ambas pueden estar vacías (`NULL`).

**`DECIMAL(5, 2)` en `distancia_km`:** Permite números como `15.50` km. El `(5, 2)` significa máximo 5 dígitos totales con 2 decimales, es decir, el máximo sería `999.99` km.

---

# Paso 5: Crear la Tabla de Auditoría

Esta tabla no la alimenta ningún empleado ni ninguna aplicación. Se llena **automáticamente** mediante un trigger cada vez que alguien modifica el precio de una pizza.

```sql
CREATE TABLE historial_precios (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_pizza INT NOT NULL,
    precio_anterior DECIMAL(10, 2),
    precio_nuevo DECIMAL(10, 2),
    fecha_modificacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pizza) REFERENCES pizzas(id_pizza) ON DELETE CASCADE
);
```

**¿Para qué sirve?** Imagina que la Hawaiana costaba $25,000 y el dueño la sube a $28,000. Sin esta tabla, nadie sabría cuándo cambió ni cuánto costaba antes. Con esta tabla + el trigger que crearemos más adelante, cada cambio de precio queda registrado automáticamente con la fecha exacta.

---

# Paso 6: Insertar Datos de Prueba Completos

Si solo creamos tablas vacías, no podemos probar nada. Vamos a llenar la pizzería con datos realistas para poder ejecutar las funciones, triggers, vistas y consultas.

**Importante:** Antes de crear los triggers (que los haremos después), necesitamos insertar datos base. Los triggers de descuento de stock se activan al insertar detalles de pedido, así que primero creamos los datos que no dependen de triggers.

```sql
-- ═══════════════════════════════════════════════════════
-- 6.1 CLIENTES
-- ═══════════════════════════════════════════════════════
-- Nota: NO escribimos id_cliente porque AUTO_INCREMENT lo genera solo.
-- La sintaxis es: INSERT INTO tabla (columna1, columna2, ...) VALUES (valor1, valor2, ...);

INSERT INTO clientes (nombre, telefono, direccion, correo) VALUES 
('Juan Perez', '3001234567', 'Calle 10 # 5-20, Zona Norte', 'juan@mail.com'),
('Maria Lopez', '3109876543', 'Cra 50 # 12-40, Zona Sur', 'maria@mail.com'),
('Carlos Ramirez', '3201112233', 'Av. 30 # 22-15, Zona Norte', 'carlos@mail.com'),
('Ana Martinez', '3154445566', 'Calle 8 # 10-30, Zona Centro', 'ana@mail.com'),
('Pedro Gomez', '3187778899', 'Cra 15 # 45-60, Zona Sur', 'pedro@mail.com');
-- Después de ejecutar esto, tendremos clientes con IDs 1 al 5.

-- ═══════════════════════════════════════════════════════
-- 6.2 PIZZAS
-- ═══════════════════════════════════════════════════════
INSERT INTO pizzas (nombre, tamano, precio_base, tipo) VALUES 
('Hawaiana', 'Mediana', 25000.00, 'Clásica'),             -- ID 1
('Pepperoni', 'Familiar', 35000.00, 'Especial'),           -- ID 2
('Cuatro Quesos', 'Mediana', 30000.00, 'Especial'),        -- ID 3
('Vegetariana Suprema', 'Familiar', 32000.00, 'Vegetariana'), -- ID 4
('Margarita', 'Pequeña', 18000.00, 'Clásica');             -- ID 5

-- ═══════════════════════════════════════════════════════
-- 6.3 INGREDIENTES
-- ═══════════════════════════════════════════════════════
INSERT INTO ingredientes (nombre, stock_disponible, stock_minimo, unidad_medida, costo_por_unidad) VALUES 
('Queso Mozzarella', 5000, 1000, 'Gramos', 15.00),   -- ID 1
('Piña', 2000, 500, 'Gramos', 5.00),                  -- ID 2
('Pepperoni', 1000, 200, 'Gramos', 25.00),             -- ID 3
('Champiñones', 1500, 300, 'Gramos', 12.00),           -- ID 4
('Pimentón', 800, 200, 'Gramos', 8.00),                -- ID 5
('Queso Parmesano', 900, 300, 'Gramos', 30.00),        -- ID 6
('Albahaca', 500, 100, 'Gramos', 10.00),               -- ID 7
('Salsa de Tomate', 3000, 500, 'Mililitros', 6.00);    -- ID 8

-- ═══════════════════════════════════════════════════════
-- 6.4 RECETAS (pizza_ingredientes)
-- ═══════════════════════════════════════════════════════
-- Aquí definimos qué ingredientes y cuántos gramos lleva cada pizza.

-- Hawaiana (ID 1): 200g Mozzarella + 100g Piña + 50ml Salsa
INSERT INTO pizza_ingredientes (id_pizza, id_ingrediente, cantidad_requerida) VALUES 
(1, 1, 200), (1, 2, 100), (1, 8, 50);

-- Pepperoni (ID 2): 250g Mozzarella + 150g Pepperoni + 50ml Salsa
INSERT INTO pizza_ingredientes (id_pizza, id_ingrediente, cantidad_requerida) VALUES 
(2, 1, 250), (2, 3, 150), (2, 8, 50);

-- Cuatro Quesos (ID 3): 200g Mozzarella + 100g Parmesano
INSERT INTO pizza_ingredientes (id_pizza, id_ingrediente, cantidad_requerida) VALUES 
(3, 1, 200), (3, 6, 100);

-- Vegetariana Suprema (ID 4): 200g Mozzarella + 100g Champiñones + 80g Pimentón + 50ml Salsa
INSERT INTO pizza_ingredientes (id_pizza, id_ingrediente, cantidad_requerida) VALUES 
(4, 1, 200), (4, 4, 100), (4, 5, 80), (4, 8, 50);

-- Margarita (ID 5): 180g Mozzarella + 30g Albahaca + 40ml Salsa
INSERT INTO pizza_ingredientes (id_pizza, id_ingrediente, cantidad_requerida) VALUES 
(5, 1, 180), (5, 7, 30), (5, 8, 40);

-- ═══════════════════════════════════════════════════════
-- 6.5 REPARTIDORES
-- ═══════════════════════════════════════════════════════
INSERT INTO repartidores (nombre, zona_asignada) VALUES 
('Carlos Gomez', 'Zona Norte'),    -- ID 1
('Laura Diaz', 'Zona Sur'),       -- ID 2
('Miguel Torres', 'Zona Centro'); -- ID 3

-- ═══════════════════════════════════════════════════════
-- 6.6 PEDIDOS (la cabecera del ticket)
-- ═══════════════════════════════════════════════════════
INSERT INTO pedidos (id_cliente, fecha_hora, metodo_pago, estado, total) VALUES 
(1, '2025-03-10 12:30:00', 'Efectivo', 'Entregado', 59500.00),
(2, '2025-03-10 13:00:00', 'Tarjeta', 'Entregado', 41650.00),
(3, '2025-03-11 19:00:00', 'App', 'Entregado', 29750.00),
(1, '2025-03-12 20:00:00', 'Tarjeta', 'Entregado', 71400.00),
(4, '2025-03-15 14:00:00', 'Efectivo', 'Pendiente', 35700.00);

-- ═══════════════════════════════════════════════════════
-- 6.7 DETALLES DEL PEDIDO (las líneas del ticket)
-- ═══════════════════════════════════════════════════════
-- Pedido 1: Juan pidió 1 Hawaiana y 1 Pepperoni
INSERT INTO pedido_detalles (id_pedido, id_pizza, cantidad, subtotal) VALUES 
(1, 1, 1, 25000.00),
(1, 2, 1, 35000.00);

-- Pedido 2: Maria pidió 1 Pepperoni
INSERT INTO pedido_detalles (id_pedido, id_pizza, cantidad, subtotal) VALUES 
(2, 2, 1, 35000.00);

-- Pedido 3: Carlos pidió 1 Hawaiana
INSERT INTO pedido_detalles (id_pedido, id_pizza, cantidad, subtotal) VALUES 
(3, 1, 1, 25000.00);

-- Pedido 4: Juan pidió 2 Cuatro Quesos
INSERT INTO pedido_detalles (id_pedido, id_pizza, cantidad, subtotal) VALUES 
(4, 3, 2, 60000.00);

-- Pedido 5: Ana pidió 1 Vegetariana Suprema
INSERT INTO pedido_detalles (id_pedido, id_pizza, cantidad, subtotal) VALUES 
(5, 4, 1, 32000.00);

-- ═══════════════════════════════════════════════════════
-- 6.8 DOMICILIOS (los viajes de entrega)
-- ═══════════════════════════════════════════════════════
INSERT INTO domicilios (id_pedido, id_repartidor, hora_salida, hora_entrega, distancia_km, costo_envio) VALUES 
(1, 1, '2025-03-10 12:45:00', '2025-03-10 13:10:00', 3.5, 5000.00),
(2, 2, '2025-03-10 13:20:00', '2025-03-10 13:55:00', 5.0, 7000.00),
(3, 1, '2025-03-11 19:20:00', '2025-03-11 19:40:00', 2.0, 3000.00),
(4, 3, '2025-03-12 20:15:00', '2025-03-12 20:50:00', 4.5, 6000.00);
-- El pedido 5 NO tiene domicilio (es para recoger en tienda).
```

**¡Verifica que todo quedó bien!** Ejecuta estas consultas una por una:

```sql
SELECT * FROM clientes;          -- Deberías ver 5 filas
SELECT * FROM pizzas;            -- Deberías ver 5 filas
SELECT * FROM ingredientes;      -- Deberías ver 8 filas
SELECT * FROM pizza_ingredientes; -- Deberías ver 14 filas (las recetas)
SELECT * FROM repartidores;      -- Deberías ver 3 filas
SELECT * FROM pedidos;           -- Deberías ver 5 filas
SELECT * FROM pedido_detalles;   -- Deberías ver 6 filas
SELECT * FROM domicilios;        -- Deberías ver 4 filas
```

---

# Paso 7: Crear la Función — Calcular Total del Pedido

Una **función** en MySQL es un programa que recibe datos de entrada, hace cálculos internos, y **devuelve un único resultado**. Se puede usar dentro de un `SELECT` como si fuera una fórmula de Excel.

Esta función recibe el ID de un pedido y devuelve el total a cobrar (pizzas + envío + 19% de IVA).

**Antes de escribir la función**, debemos cambiar el delimitador:

```sql
DELIMITER //
```

**¿Por qué `DELIMITER //`?**
MySQL normalmente ejecuta cada instrucción que termina en punto y coma (`;`). Pero dentro de una función necesitamos escribir **varias líneas con punto y coma** (como `DECLARE v_total DECIMAL(10,2);`). Si no cambiamos el delimitador, MySQL intentaría ejecutar la función en la primera línea que tenga `;`, provocando un error de sintaxis. 

Con `DELIMITER //` le decimos: "No ejecutes nada hasta que veas `//`. Ignora los `;` intermedios". Al terminar, volvemos al delimitador normal con `DELIMITER ;`.

**Ahora sí, la función:**

```sql
CREATE FUNCTION calcular_total_pedido(p_id_pedido INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_subtotal_pizzas DECIMAL(10,2) DEFAULT 0;
    DECLARE v_costo_envio DECIMAL(10,2) DEFAULT 0;
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_iva DECIMAL(10,2);

    SELECT IFNULL(SUM(subtotal), 0) INTO v_subtotal_pizzas
    FROM pedido_detalles
    WHERE id_pedido = p_id_pedido;

    SELECT IFNULL(SUM(costo_envio), 0) INTO v_costo_envio
    FROM domicilios
    WHERE id_pedido = p_id_pedido;

    SET v_iva = (v_subtotal_pizzas + v_costo_envio) * 0.19;
    SET v_total = v_subtotal_pizzas + v_costo_envio + v_iva;

    RETURN v_total;
END //
DELIMITER ;
```

**Desglose completo línea por línea:**

| Línea                                                    | ¿Qué hace?                                                                                                                                                                                                                                                                              |
| -------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `CREATE FUNCTION calcular_total_pedido(p_id_pedido INT)` | Crea la función con el nombre `calcular_total_pedido`. Recibe un parámetro de entrada llamado `p_id_pedido` de tipo entero. El prefijo `p_` es una convención para distinguir parámetros de columnas de tablas.                                                                         |
| `RETURNS DECIMAL(10,2)`                                  | Declara que esta función devolverá un número decimal. Toda función **debe** declarar su tipo de retorno.                                                                                                                                                                                |
| `DETERMINISTIC`                                          | Le indica a MySQL que, dado el mismo `p_id_pedido`, la función siempre devolverá el mismo resultado. Esto permite a MySQL cachear el resultado para mejorar el rendimiento.                                                                                                             |
| `BEGIN ... END`                                          | Delimita el cuerpo de la función. Todo el código ejecutable va entre estas dos palabras.                                                                                                                                                                                                |
| `DECLARE v_subtotal_pizzas DECIMAL(10,2) DEFAULT 0;`     | Crea una variable local temporal llamada `v_subtotal_pizzas` en la memoria de MySQL. El `DEFAULT 0` le da un valor inicial para evitar `NULL`. El prefijo `v_` es convención para variables locales.                                                                                    |
| `SELECT IFNULL(SUM(subtotal), 0) INTO v_subtotal_pizzas` | Ejecuta una consulta que suma (`SUM`) todos los subtotales de las pizzas del pedido. El resultado se guarda (`INTO`) en la variable `v_subtotal_pizzas`. `IFNULL(x, 0)` actúa como protección: si el pedido no tiene detalles, `SUM` devolvería `NULL`, e `IFNULL` lo convierte en `0`. |
| `SET v_iva = (...) * 0.19;`                              | Calcula el 19% de IVA sobre la suma de pizzas más envío. `SET` es el comando para asignar un valor a una variable.                                                                                                                                                                      |
| `RETURN v_total;`                                        | Devuelve el resultado final. Es obligatorio que toda función tenga un `RETURN`.                                                                                                                                                                                                         |

**¡Pruébala!** Ejecuta:

```sql
SELECT calcular_total_pedido(1);
-- Debería devolver el total del pedido 1 (25000 + 35000 + 5000 de envío + 19% IVA)
```

---

# Paso 8: Crear la Función — Calcular Ganancia Neta Diaria

Esta función responde: *"¿Cuánto dinero ganamos hoy restando los costos de los ingredientes?"*

```sql
DELIMITER //
CREATE FUNCTION calcular_ganancia_diaria(p_fecha DATE)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_total_ventas DECIMAL(10,2) DEFAULT 0;
    DECLARE v_costo_ingredientes DECIMAL(10,2) DEFAULT 0;
    DECLARE v_ganancia DECIMAL(10,2);

    -- Paso 1: Sumar los totales de todos los pedidos ENTREGADOS en esa fecha
    SELECT IFNULL(SUM(total), 0) INTO v_total_ventas
    FROM pedidos
    WHERE DATE(fecha_hora) = p_fecha AND estado = 'Entregado';

    -- Paso 2: Calcular cuánto costaron los ingredientes usados en esos pedidos
    SELECT IFNULL(SUM(pi.cantidad_requerida * i.costo_por_unidad * pd.cantidad), 0) 
    INTO v_costo_ingredientes
    FROM pedidos p
    JOIN pedido_detalles pd ON p.id_pedido = pd.id_pedido
    JOIN pizza_ingredientes pi ON pd.id_pizza = pi.id_pizza
    JOIN ingredientes i ON pi.id_ingrediente = i.id_ingrediente
    WHERE DATE(p.fecha_hora) = p_fecha AND p.estado = 'Entregado';

    -- Paso 3: Ganancia = Lo que nos pagaron - Lo que nos costó
    SET v_ganancia = v_total_ventas - v_costo_ingredientes;

    RETURN v_ganancia;
END //
DELIMITER ;
```

**El JOIN cuádruple explicado paso a paso:**

Este es el corazón de la función. Necesitamos cruzar 4 tablas para llegar desde el pedido hasta el costo de cada ingrediente. Así funciona la cadena:

1. `pedidos p` → Nos da los pedidos del día con estado "Entregado".
2. `JOIN pedido_detalles pd ON p.id_pedido = pd.id_pedido` → Para cada pedido, nos da las líneas (qué pizza y cuántas).
3. `JOIN pizza_ingredientes pi ON pd.id_pizza = pi.id_pizza` → Para cada pizza vendida, nos da su receta (qué ingredientes usa y cuántos gramos).
4. `JOIN ingredientes i ON pi.id_ingrediente = i.id_ingrediente` → Para cada ingrediente de la receta, nos da su costo por unidad.

La fórmula `pi.cantidad_requerida * i.costo_por_unidad * pd.cantidad` calcula:

- `cantidad_requerida` = gramos que usa la receta (ej: 200g de queso).
- `costo_por_unidad` = precio por gramo del ingrediente (ej: $15 el gramo).
- `pd.cantidad` = cuántas pizzas de ese tipo pidieron (ej: 2 Hawaianas).
- Resultado: `200 * 15 * 2 = $6,000` costó el queso para esas 2 Hawaianas.

**¡Pruébala!**

```sql
SELECT calcular_ganancia_diaria('2025-03-10');
-- Ventas del 10 de marzo - Costos de ingredientes del 10 de marzo
```

---

# Paso 9: Crear el Procedimiento — Registrar Hora de Entrega

Un **procedimiento almacenado** es diferente a una función: **no devuelve un valor**, sino que **ejecuta acciones** (modificar datos, actualizar tablas, etc.). Se invoca con el comando `CALL`.

Este procedimiento hace dos cosas en una sola llamada:

1. Registra la hora de entrega en la tabla `domicilios`.
2. Cambia el estado del pedido a "Entregado" en la tabla `pedidos`.

```sql
DELIMITER //
CREATE PROCEDURE registrar_hora_entrega(IN p_id_domicilio INT, IN p_hora_entrega DATETIME)
BEGIN
    DECLARE v_id_pedido INT;

    -- Paso 1: Actualizamos la hora de entrega del domicilio
    UPDATE domicilios 
    SET hora_entrega = p_hora_entrega
    WHERE id_domicilio = p_id_domicilio;

    -- Paso 2: Averiguamos a qué pedido pertenece este domicilio
    SELECT id_pedido INTO v_id_pedido
    FROM domicilios
    WHERE id_domicilio = p_id_domicilio;

    -- Paso 3: Marcamos ese pedido como entregado
    UPDATE pedidos
    SET estado = 'Entregado'
    WHERE id_pedido = v_id_pedido;

END //
DELIMITER ;
```

**Desglose:**

| Concepto                      | Explicación                                                                                                                                                     |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `IN p_id_domicilio INT`       | `IN` significa que es un parámetro de **entrada**. El usuario envía el dato, pero no lo recibe de vuelta. También existe `OUT` (solo salida) e `INOUT` (ambos). |
| `DECLARE v_id_pedido INT;`    | Variable temporal para guardar el ID del pedido que encontremos al consultar la tabla domicilios.                                                               |
| Primer `UPDATE`               | Actualiza la columna `hora_entrega` en la fila del domicilio específico.                                                                                        |
| `SELECT ... INTO v_id_pedido` | Busca a qué pedido pertenece ese domicilio y guarda el resultado en la variable.                                                                                |
| Segundo `UPDATE`              | Usa esa variable para encontrar el pedido correcto y cambiarle el estado.                                                                                       |

**¿Por qué es útil un procedimiento?** Porque con una sola llamada actualizamos dos tablas de forma segura. Sin el procedimiento, el programador tendría que escribir dos `UPDATE` separados desde la aplicación, con el riesgo de que uno falle y el otro no, dejando los datos inconsistentes.

**¡Pruébalo!** (Nota: como nuestros datos de prueba ya tienen hora de entrega, pruébalo con el pedido 5 que no tiene domicilio aún. Primero crea un domicilio para ese pedido):

```sql
-- Creamos un domicilio sin hora de entrega para el pedido 5
INSERT INTO domicilios (id_pedido, id_repartidor, hora_salida, distancia_km, costo_envio) 
VALUES (5, 2, '2025-03-15 14:15:00', 3.0, 4000.00);

-- Ahora llamamos al procedimiento para registrar la entrega
CALL registrar_hora_entrega(5, '2025-03-15 14:45:00');

-- Verificamos que funcionó:
SELECT estado FROM pedidos WHERE id_pedido = 5;      -- Debería decir 'Entregado'
SELECT hora_entrega FROM domicilios WHERE id_domicilio = 5; -- Debería mostrar '2025-03-15 14:45:00'
```

---

# Paso 10: Crear el Trigger — Descontar Stock Automáticamente

Un **trigger ("gatillo")** es un bloque de código que se ejecuta **automáticamente** cuando ocurre un evento en una tabla. No lo invoca ningún programador; se dispara solo.

Los triggers tienen acceso a dos variables especiales:

- **`NEW`**: Contiene los datos de la fila que **está entrando** (en `INSERT` y `UPDATE`).
- **`OLD`**: Contiene los datos de la fila **antes de ser modificada** (en `UPDATE` y `DELETE`).

**Este trigger escucha la tabla `pedido_detalles`**. Cada vez que se inserta una nueva línea (una pizza vendida), el trigger busca la receta de esa pizza y descuenta los ingredientes del inventario.

```sql
DELIMITER //
CREATE TRIGGER tr_actualizar_stock_ingredientes
AFTER INSERT ON pedido_detalles
FOR EACH ROW
BEGIN
    UPDATE ingredientes i
    JOIN pizza_ingredientes pi ON i.id_ingrediente = pi.id_ingrediente
    SET i.stock_disponible = i.stock_disponible - (pi.cantidad_requerida * NEW.cantidad)
    WHERE pi.id_pizza = NEW.id_pizza;
END //
DELIMITER ;
```

**Desglose específico:**

| Parte del código                                                                       | Explicación detallada                                                                                                                                                                         |
| -------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `AFTER INSERT ON pedido_detalles`                                                      | "Actívate **después** de que se inserte una nueva fila en `pedido_detalles`". Usamos `AFTER` y no `BEFORE` porque queremos que el registro ya esté guardado antes de modificar el inventario. |
| `FOR EACH ROW`                                                                         | Si un solo `INSERT` mete 3 filas a la vez, este trigger se ejecutará 3 veces (una por cada fila).                                                                                             |
| `NEW.cantidad`                                                                         | `NEW` hace referencia a la fila que acaba de entrar. `NEW.cantidad` es el número de pizzas que pidió el cliente en esa línea (ej: 2 Hawaianas).                                               |
| `NEW.id_pizza`                                                                         | El ID de la pizza que se vendió en esa línea.                                                                                                                                                 |
| `UPDATE ingredientes i JOIN pizza_ingredientes pi ...`                                 | Hace un cruce entre la bodega y el recetario para encontrar todos los ingredientes de esa pizza.                                                                                              |
| `SET i.stock_disponible = i.stock_disponible - (pi.cantidad_requerida * NEW.cantidad)` | La fórmula central: `stock_nuevo = stock_actual - (gramos_por_receta × cantidad_de_pizzas)`. Si la Hawaiana lleva 200g de queso y pidieron 2, se restan 400g.                                 |

**¡Pruébalo!** Verifica el stock antes y después de una venta:

```sql
-- Mira el stock actual del Queso Mozzarella (ID 1)
SELECT nombre, stock_disponible FROM ingredientes WHERE id_ingrediente = 1;

-- Ahora vende 1 Hawaiana más (que usa 200g de Mozzarella)
INSERT INTO pedidos (id_cliente, metodo_pago) VALUES (2, 'Efectivo'); -- Crea pedido nuevo
INSERT INTO pedido_detalles (id_pedido, id_pizza, cantidad, subtotal) VALUES (6, 1, 1, 25000.00);

-- Vuelve a mirar el stock. ¡Debería haber bajado 200!
SELECT nombre, stock_disponible FROM ingredientes WHERE id_ingrediente = 1;
```

---

# Paso 11: Crear el Trigger — Auditoría de Precios de Pizzas

Este trigger vigila la tabla `pizzas`. Si alguien hace un `UPDATE` que cambie el `precio_base`, el trigger automáticamente inserta un registro en `historial_precios` con el precio viejo, el nuevo, y la fecha del cambio.

```sql
DELIMITER //
CREATE TRIGGER tr_auditoria_precio_pizza
AFTER UPDATE ON pizzas
FOR EACH ROW
BEGIN
    IF OLD.precio_base <> NEW.precio_base THEN
        INSERT INTO historial_precios (id_pizza, precio_anterior, precio_nuevo, fecha_modificacion)
        VALUES (NEW.id_pizza, OLD.precio_base, NEW.precio_base, CURRENT_TIMESTAMP);
    END IF;
END //
DELIMITER ;
```

**Desglose específico:**

| Parte                                        | Explicación                                                                                                                                                                                                                                         |
| -------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `AFTER UPDATE ON pizzas`                     | Se activa después de que se modifique cualquier fila de la tabla `pizzas`.                                                                                                                                                                          |
| `IF OLD.precio_base <> NEW.precio_base THEN` | `OLD.precio_base` es el precio **antes** del cambio. `NEW.precio_base` es el precio **después** del cambio. `<>` significa "diferente de". Esto evita que se registre en el historial si alguien actualiza el nombre de la pizza pero no el precio. |
| `INSERT INTO historial_precios (...)`        | Guarda automáticamente el registro de auditoría. `CURRENT_TIMESTAMP` captura el instante exacto del cambio.                                                                                                                                         |

**¡Pruébalo!**

```sql
-- La Hawaiana cuesta $25,000. Vamos a subirle el precio:
UPDATE pizzas SET precio_base = 28000.00 WHERE id_pizza = 1;

-- Revisemos que el historial se llenó solo:
SELECT * FROM historial_precios;
-- Deberías ver: id_pizza=1, precio_anterior=25000, precio_nuevo=28000, fecha=...
```

---

# Paso 12: Crear el Trigger — Liberar Repartidor al Entregar

Cuando un repartidor sale a entregar un pedido, su estado debería cambiar a "No Disponible". Cuando termina la entrega (se registra la `hora_entrega`), este trigger lo pone de vuelta en "Disponible".

```sql
DELIMITER //
CREATE TRIGGER tr_repartidor_disponible_entrega
AFTER UPDATE ON domicilios
FOR EACH ROW
BEGIN
    IF OLD.hora_entrega IS NULL AND NEW.hora_entrega IS NOT NULL THEN
        UPDATE repartidores
        SET estado = 'Disponible'
        WHERE id_repartidor = NEW.id_repartidor;
    END IF;
END //
DELIMITER ;
```

**Desglose específico:**

| Parte                                                          | Explicación                                                                                                                                                                                                                                                                           |
| -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `AFTER UPDATE ON domicilios`                                   | Se activa cuando se modifica una fila de la tabla `domicilios`.                                                                                                                                                                                                                       |
| `IF OLD.hora_entrega IS NULL AND NEW.hora_entrega IS NOT NULL` | Condición doble que verifica: (1) antes de la modificación, la hora de entrega estaba vacía (`NULL`), y (2) después de la modificación, ya tiene un valor. Esto asegura que el trigger solo se active en el momento justo de la entrega, no en cualquier actualización del domicilio. |
| `UPDATE repartidores SET estado = 'Disponible'`                | Cambia el estado del repartidor que hizo la entrega (`NEW.id_repartidor`) de vuelta a "Disponible".                                                                                                                                                                                   |

**¡Pruébalo!**

```sql
-- Primero, pongamos un repartidor como "No Disponible"
UPDATE repartidores SET estado = 'No Disponible' WHERE id_repartidor = 1;
SELECT nombre, estado FROM repartidores WHERE id_repartidor = 1; -- "No Disponible"

-- Ahora creemos un domicilio sin hora de entrega
INSERT INTO pedidos (id_cliente, metodo_pago) VALUES (3, 'App');
INSERT INTO domicilios (id_pedido, id_repartidor, hora_salida, distancia_km, costo_envio) 
VALUES (7, 1, NOW(), 2.5, 3500.00);

-- Registramos la hora de entrega (simulamos que el repartidor llegó)
UPDATE domicilios SET hora_entrega = NOW() WHERE id_domicilio = 6;

-- ¡Verificamos! El repartidor debería estar "Disponible" de nuevo
SELECT nombre, estado FROM repartidores WHERE id_repartidor = 1; -- "Disponible"
```

---

# Paso 13: Crear la Vista — Resumen de Pedidos por Cliente

Una **vista** es una consulta `SELECT` guardada con un nombre. No almacena datos físicos; cada vez que la consultas, MySQL ejecuta la consulta internamente. Es como guardar un reporte favorito.

```sql
CREATE OR REPLACE VIEW vista_resumen_clientes AS
SELECT 
    c.nombre AS cliente,
    COUNT(p.id_pedido) AS cantidad_pedidos,
    SUM(p.total) AS total_gastado
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre;
```

**Desglose:**

| Parte                             | Explicación                                                                                                                                                                     |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `CREATE OR REPLACE VIEW`          | Crea la vista. Si ya existe una vista con ese nombre, la reemplaza sin dar error.                                                                                               |
| `c.nombre AS cliente`             | `AS` es un alias. Renombra la columna en el resultado para que aparezca como "cliente" en vez de "nombre".                                                                      |
| `COUNT(p.id_pedido)`              | Cuenta cuántos pedidos tiene cada cliente.                                                                                                                                      |
| `SUM(p.total)`                    | Suma el total de dinero de todos los pedidos de cada cliente.                                                                                                                   |
| `LEFT JOIN`                       | Incluye a **todos** los clientes, incluso los que nunca han hecho un pedido. Si usáramos `INNER JOIN` (o simplemente `JOIN`), un cliente sin pedidos desaparecería del reporte. |
| `GROUP BY c.id_cliente, c.nombre` | Agrupa los resultados por cliente. Es obligatorio: toda columna que no esté dentro de un `COUNT()` o `SUM()` debe ir en el `GROUP BY`.                                          |

**Consulta la vista como si fuera una tabla normal:**

```sql
SELECT * FROM vista_resumen_clientes;
```

---

# Paso 14: Crear la Vista — Desempeño de Repartidores

Muestra cuántas entregas ha hecho cada repartidor y su tiempo promedio.

```sql
CREATE OR REPLACE VIEW vista_desempeno_repartidores AS
SELECT 
    r.nombre AS repartidor,
    r.zona_asignada AS zona,
    COUNT(d.id_domicilio) AS numero_entregas,
    AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)) AS tiempo_promedio_minutos
FROM repartidores r
JOIN domicilios d ON r.id_repartidor = d.id_repartidor
WHERE d.hora_entrega IS NOT NULL
GROUP BY r.id_repartidor, r.nombre, r.zona_asignada;
```

**Desglose:**

| Parte                                                  | Explicación                                                                                                                                                                           |
| ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)` | Calcula la diferencia en **minutos** entre la hora de salida y la hora de entrega. El primer argumento (`MINUTE`) define la unidad. También puedes usar `SECOND`, `HOUR`, `DAY`, etc. |
| `AVG(...)`                                             | Promedia todos los tiempos de entrega de ese repartidor. Si Carlos hizo 3 entregas de 25, 35 y 20 minutos, el promedio será 26.67.                                                    |
| `WHERE d.hora_entrega IS NOT NULL`                     | Filtra solo los domicilios que ya fueron entregados. Los que están en camino (sin hora de entrega) no se promedian.                                                                   |
| Aquí usamos `JOIN` (no `LEFT JOIN`)                    | Porque solo nos interesan los repartidores que **sí** tienen entregas. Un repartidor nuevo sin entregas no aparece en este reporte de desempeño.                                      |

**Consulta:**

```sql
SELECT * FROM vista_desempeno_repartidores;
```

---

# Paso 15: Crear la Vista — Alertas de Stock Bajo

Esta vista identifica los ingredientes que están por debajo de su stock mínimo. Es perfecta para que el encargado de compras sepa qué debe pedir.

```sql
CREATE OR REPLACE VIEW vista_alertas_stock AS
SELECT 
    nombre AS ingrediente,
    stock_disponible,
    stock_minimo,
    unidad_medida,
    (stock_minimo - stock_disponible) AS cantidad_a_reponer
FROM ingredientes
WHERE stock_disponible < stock_minimo;
```

**Desglose:**

| Parte                                                     | Explicación                                                                                                                                                                                          |
| --------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `WHERE stock_disponible < stock_minimo`                   | Solo muestra ingredientes cuyo stock actual está por debajo del mínimo definido. Si el queso tiene 5000g y su mínimo es 1000g, no aparece. Si la albahaca tiene 80g y su mínimo es 100g, sí aparece. |
| `(stock_minimo - stock_disponible) AS cantidad_a_reponer` | Calcula cuánto hay que comprar para volver al mínimo. Si el mínimo es 100 y hay 80, la cantidad a reponer es 20.                                                                                     |
| No tiene `JOIN`                                           | Esta vista es sencilla porque solo necesita una tabla: `ingredientes`. No todas las vistas requieren cruces entre tablas.                                                                            |

**Consulta:**

```sql
SELECT * FROM vista_alertas_stock;
-- Si todas las cantidades están bien, el resultado estará vacío (¡eso es bueno!)
-- Si quieres probarla, baja artificialmente un stock:
UPDATE ingredientes SET stock_disponible = 50 WHERE id_ingrediente = 7; -- Albahaca a 50g (mínimo es 100)
SELECT * FROM vista_alertas_stock; -- Ahora debería aparecer la Albahaca
```

---

# Paso 16: Consulta 1 — Clientes con Pedidos entre Dos Fechas

El operador `BETWEEN` filtra valores dentro de un rango (inclusive en ambos extremos).

```sql
SELECT DISTINCT c.nombre, c.telefono, c.correo
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.fecha_hora BETWEEN '2025-03-10 00:00:00' AND '2025-03-12 23:59:59';
```

**Desglose:**

| Parte                                                     | Explicación                                                                                                                                                                                                                                           |
| --------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `SELECT DISTINCT`                                         | `DISTINCT` elimina filas duplicadas del resultado. Si Juan hizo 3 pedidos en ese rango, solo aparece 1 vez en vez de 3.                                                                                                                               |
| `JOIN pedidos p ON c.id_cliente = p.id_cliente`           | Cruza la tabla de clientes con la de pedidos para poder acceder a la fecha del pedido.                                                                                                                                                                |
| `BETWEEN '2025-03-10 00:00:00' AND '2025-03-12 23:59:59'` | Filtra pedidos cuya `fecha_hora` esté entre el 10 de marzo a las 00:00 y el 12 de marzo a las 23:59. Los extremos están **incluidos**. Es equivalente a escribir `WHERE fecha_hora >= '2025-03-10 00:00:00' AND fecha_hora <= '2025-03-12 23:59:59'`. |

---

# Paso 17: Consulta 2 — Pizzas Más Vendidas

Usamos `GROUP BY` para agrupar por pizza y `SUM` para sumar las cantidades vendidas.

```sql
SELECT pz.nombre, pz.tamano, SUM(pd.cantidad) AS total_vendidas
FROM pizzas pz
JOIN pedido_detalles pd ON pz.id_pizza = pd.id_pizza
GROUP BY pz.id_pizza, pz.nombre, pz.tamano
ORDER BY total_vendidas DESC;
```

**Desglose:**

| Parte                                        | Explicación                                                                                                                                                                                                                     |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `SUM(pd.cantidad)`                           | Suma el campo `cantidad` de todas las filas que pertenezcan a cada pizza. Si la Hawaiana aparece 3 veces con cantidades 1, 2 y 1, el resultado es 4.                                                                            |
| `GROUP BY pz.id_pizza, pz.nombre, pz.tamano` | Agrupa los resultados "por pizza". Sin `GROUP BY`, el `SUM` sumaría **todas** las pizzas juntas en un solo número.                                                                                                              |
| `ORDER BY total_vendidas DESC`               | Ordena el resultado de mayor a menor (`DESC` = descendente). La pizza más vendida aparece primero. Si quisieras la menos vendida primero, usarías `ASC` (o simplemente no pondrías nada, ya que `ASC` es el valor por defecto). |

---

# Paso 18: Consulta 3 — Pedidos por Repartidor

Usa un **JOIN triple** para conectar repartidores → domicilios → pedidos.

```sql
SELECT r.nombre AS repartidor, r.zona_asignada, p.id_pedido, p.fecha_hora, p.estado
FROM repartidores r
JOIN domicilios d ON r.id_repartidor = d.id_repartidor
JOIN pedidos p ON d.id_pedido = p.id_pedido
ORDER BY r.nombre, p.fecha_hora DESC;
```

**Desglose del camino del JOIN:**

La tabla `repartidores` no tiene relación directa con `pedidos`. Pero `domicilios` está en el medio conectando a ambas. El flujo es:

1. `repartidores r` → Empezamos con los repartidores.
2. `JOIN domicilios d ON r.id_repartidor = d.id_repartidor` → Cruzamos con sus viajes de entrega.
3. `JOIN pedidos p ON d.id_pedido = p.id_pedido` → Para cada viaje, obtenemos los datos del pedido que entregaron.

`ORDER BY r.nombre, p.fecha_hora DESC` ordena primero por nombre del repartidor (alfabético), y dentro de cada repartidor, los pedidos más recientes primero.

---

# Paso 19: Consulta 4 — Promedio de Entrega por Zona

```sql
SELECT r.zona_asignada, 
       AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)) AS promedio_minutos
FROM repartidores r
JOIN domicilios d ON r.id_repartidor = d.id_repartidor
WHERE d.hora_entrega IS NOT NULL
GROUP BY r.zona_asignada;
```

**Desglose:**

| Parte                                                  | Explicación                                                                                                                                                   |
| ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)` | Calcula cuántos minutos pasaron entre la salida y la entrega. Ejemplo: salida a las 12:45, entrega a las 13:10 = 25 minutos.                                  |
| `AVG(...)`                                             | Promedia todos esos valores para cada zona. Si Zona Norte tiene entregas de 25 y 20 minutos, el promedio es 22.5.                                             |
| `WHERE d.hora_entrega IS NOT NULL`                     | Excluye los domicilios que aún no han sido entregados (hora de entrega vacía), porque `TIMESTAMPDIFF` con un `NULL` devuelve `NULL` y arruinaría el promedio. |
| `GROUP BY r.zona_asignada`                             | Agrupa por zona para obtener un promedio **por cada zona**, no un promedio general de toda la pizzería.                                                       |

---

# Paso 20: Consulta 5 — Clientes que Gastaron más de un Monto

```sql
SELECT c.nombre, SUM(p.total) AS total_gastado
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre
HAVING SUM(p.total) > 500.00;
```

**¿Por qué `HAVING` y no `WHERE`?**

Esta es una de las preguntas más importantes de SQL:

| `WHERE`                                                         | `HAVING`                                                |
| --------------------------------------------------------------- | ------------------------------------------------------- |
| Filtra filas **individuales antes** de agruparlas.              | Filtra **resultados agrupados después** de calcularlos. |
| No puedes usar funciones de agregación (`SUM`, `COUNT`, `AVG`). | Sí puedes usar funciones de agregación.                 |
| Ejemplo válido: `WHERE nombre = 'Juan'`                         | Ejemplo válido: `HAVING SUM(total) > 500`               |
| Ejemplo inválido: `WHERE SUM(total) > 500` ❌                    |                                                         |

El flujo de ejecución es: MySQL primero ejecuta el `JOIN`, luego aplica el `WHERE` (si lo hubiera), luego agrupa con `GROUP BY`, luego calcula los `SUM`/`COUNT`, y **al final** aplica el `HAVING` para filtrar los grupos que no cumplen la condición.

---

# Paso 21: Consulta 6 — Búsqueda Parcial de Pizzas

```sql
SELECT nombre, tamano, precio_base, tipo
FROM pizzas
WHERE nombre LIKE '%Queso%';
```

**Desglose del operador `LIKE`:**

| Patrón      | Significado                                                | Ejemplo                                                             |
| ----------- | ---------------------------------------------------------- | ------------------------------------------------------------------- |
| `'%Queso%'` | Busca "Queso" en **cualquier parte** del texto.            | Encuentra: "Cuatro Quesos", "Pizza de Queso Azul", "Queso Fundido". |
| `'Queso%'`  | Busca textos que **empiecen** con "Queso".                 | Encuentra: "Queso Fundido". No encuentra: "Cuatro Quesos".          |
| `'%Queso'`  | Busca textos que **terminen** con "Queso".                 | Encuentra: "Pizza de Queso". No encuentra: "Queso Fundido".         |
| `'_ueso'`   | El guion bajo (`_`) representa **exactamente 1 carácter**. | Encuentra: "Queso", "Hueso".                                        |

---

# Paso 22: Consulta 7 — Clientes Frecuentes del Mes (Subconsulta)

Una **subconsulta** es un `SELECT` dentro de otro `SELECT`. MySQL ejecuta primero la consulta interna, obtiene un resultado, y luego usa ese resultado en la consulta externa.

```sql
SELECT nombre, telefono, correo
FROM clientes
WHERE id_cliente IN (
    SELECT id_cliente
    FROM pedidos
    WHERE MONTH(fecha_hora) = MONTH(CURRENT_DATE()) 
      AND YEAR(fecha_hora) = YEAR(CURRENT_DATE())
    GROUP BY id_cliente
    HAVING COUNT(id_pedido) > 5
);
```

**Flujo de ejecución paso a paso:**

1. **Primero se ejecuta la subconsulta interna** (la que está entre paréntesis):
   
   - `MONTH(fecha_hora) = MONTH(CURRENT_DATE())`: Filtra pedidos del **mes actual**. `MONTH()` extrae el número del mes (1-12) de una fecha. `CURRENT_DATE()` devuelve la fecha de hoy.
   - `YEAR(fecha_hora) = YEAR(CURRENT_DATE())`: También filtra por el **año actual** (para que marzo de 2024 no se mezcle con marzo de 2025).
   - `GROUP BY id_cliente`: Agrupa los pedidos por cliente.
   - `HAVING COUNT(id_pedido) > 5`: Solo se queda con los clientes que tienen **más de 5 pedidos** en ese mes.
   - **Resultado**: Una lista de IDs, por ejemplo: `(1, 4, 15)`.

2. **Luego se ejecuta la consulta externa**:
   
   - `WHERE id_cliente IN (1, 4, 15)`: Busca en la tabla `clientes` aquellos cuyo ID esté en la lista que devolvió la subconsulta.
   - Devuelve el nombre, teléfono y correo de esos clientes frecuentes.

---

# 🎉 ¡Felicitaciones! Tutorial Completado

Has construido desde cero un sistema de base de datos completo con:

| Componente      | Cantidad         | Lo que aprendiste                                                                                                                                   |
| --------------- | ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tablas          | 9                | Tipos de datos, `AUTO_INCREMENT`, `PRIMARY KEY`, `FOREIGN KEY`, `ENUM`, `DECIMAL`, `DEFAULT`, `ON DELETE CASCADE`, llaves compuestas.               |
| Datos de prueba | 8 bloques INSERT | Sintaxis de `INSERT INTO ... VALUES`, omisión de columnas `AUTO_INCREMENT`.                                                                         |
| Funciones       | 2                | `DELIMITER`, `DECLARE`, `SELECT ... INTO`, `IFNULL`, `SET`, `RETURN`, `DETERMINISTIC`, JOINs múltiples dentro de funciones.                         |
| Procedimiento   | 1                | Parámetros `IN`, diferencia entre función y procedimiento, `CALL`, transacciones multi-tabla.                                                       |
| Triggers        | 3                | `AFTER INSERT`, `AFTER UPDATE`, `FOR EACH ROW`, variables `NEW` y `OLD`, lógica condicional `IF ... THEN`.                                          |
| Vistas          | 3                | `CREATE OR REPLACE VIEW`, `LEFT JOIN` vs `INNER JOIN`, `GROUP BY` en vistas.                                                                        |
| Consultas       | 7                | `BETWEEN`, `GROUP BY`, `ORDER BY`, `HAVING`, `LIKE`, `DISTINCT`, `AVG`, `TIMESTAMPDIFF`, `JOIN` triple, subconsultas con `IN`, `MONTH()`, `YEAR()`. |

**Guarda este documento.** Te servirá como referencia rápida para cualquier proyecto futuro de bases de datos en MySQL. 🚀
