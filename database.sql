-- PIZZERÍA DON PICCOLO - Script de Creación de Base de Datos y Tablas
-- Ejecutar este script primero. Crea la base de datos, las 9 tablas
-- con sus relaciones (FOREIGN KEY) y los datos de prueba iniciales.

DROP DATABASE IF EXISTS pizzeria_don_piccolo;
CREATE DATABASE IF NOT EXISTS pizzeria_don_piccolo;
USE pizzeria_don_piccolo;

-- TABLAS MAESTRAS (no dependen de otras tablas)

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    correo VARCHAR(100)
);

CREATE TABLE pizzas (
    id_pizza INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tamano ENUM('Pequeña', 'Mediana', 'Familiar', 'Mega') NOT NULL,
    precio_base DECIMAL(10, 2) NOT NULL,
    tipo ENUM('Vegetariana', 'Especial', 'Clásica') NOT NULL
);

CREATE TABLE ingredientes (
    id_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    stock_disponible DECIMAL(10, 2) NOT NULL DEFAULT 0,
    stock_minimo DECIMAL(10, 2) NOT NULL DEFAULT 0,
    unidad_medida VARCHAR(20) NOT NULL,
    costo_por_unidad DECIMAL(10, 2) NOT NULL
);

-- TABLA PUENTE (Relación Muchos a Muchos entre pizzas e ingredientes)

CREATE TABLE pizza_ingredientes (
    id_pizza INT,
    id_ingrediente INT,
    cantidad_requerida DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id_pizza, id_ingrediente),
    FOREIGN KEY (id_pizza) REFERENCES pizzas(id_pizza) ON DELETE CASCADE,
    FOREIGN KEY (id_ingrediente) REFERENCES ingredientes(id_ingrediente) ON DELETE CASCADE
);

-- TABLA DE REPARTIDORES

CREATE TABLE repartidores (
    id_repartidor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    zona_asignada VARCHAR(50),
    estado ENUM('Disponible', 'No Disponible') NOT NULL DEFAULT 'Disponible'
);

-- TABLAS TRANSACCIONALES (dependen de las maestras)

CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    metodo_pago ENUM('Efectivo', 'Tarjeta', 'App') NOT NULL,
    estado ENUM('Pendiente', 'En preparación', 'En camino', 'Entregado', 'Cancelado') NOT NULL DEFAULT 'Pendiente',
    total DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE pedido_detalles (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_pizza INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_pizza) REFERENCES pizzas(id_pizza)
);

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

-- TABLA DE AUDITORÍA (se alimenta automáticamente por un trigger)

CREATE TABLE historial_precios (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_pizza INT NOT NULL,
    precio_anterior DECIMAL(10, 2),
    precio_nuevo DECIMAL(10, 2),
    fecha_modificacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pizza) REFERENCES pizzas(id_pizza) ON DELETE CASCADE
);

-- DATOS DE PRUEBA

-- Clientes
INSERT INTO clientes (nombre, telefono, direccion, correo) VALUES 
('Juan Perez', '3001234567', 'Calle 10 # 5-20, Zona Norte', 'juan@mail.com'),
('Maria Lopez', '3109876543', 'Cra 50 # 12-40, Zona Sur', 'maria@mail.com'),
('Carlos Ramirez', '3201112233', 'Av. 30 # 22-15, Zona Norte', 'carlos@mail.com'),
('Ana Martinez', '3154445566', 'Calle 8 # 10-30, Zona Centro', 'ana@mail.com'),
('Pedro Gomez', '3187778899', 'Cra 15 # 45-60, Zona Sur', 'pedro@mail.com');

-- Pizzas
INSERT INTO pizzas (nombre, tamano, precio_base, tipo) VALUES 
('Hawaiana', 'Mediana', 25000.00, 'Clásica'),
('Pepperoni', 'Familiar', 35000.00, 'Especial'),
('Cuatro Quesos', 'Mediana', 30000.00, 'Especial'),
('Vegetariana Suprema', 'Familiar', 32000.00, 'Vegetariana'),
('Margarita', 'Pequeña', 18000.00, 'Clásica');

-- Ingredientes
INSERT INTO ingredientes (nombre, stock_disponible, stock_minimo, unidad_medida, costo_por_unidad) VALUES 
('Queso Mozzarella', 5000, 1000, 'Gramos', 15.00),
('Piña', 2000, 500, 'Gramos', 5.00),
('Pepperoni', 1000, 200, 'Gramos', 25.00),
('Champiñones', 1500, 300, 'Gramos', 12.00),
('Pimentón', 800, 200, 'Gramos', 8.00),
('Queso Parmesano', 900, 300, 'Gramos', 30.00),
('Albahaca', 500, 100, 'Gramos', 10.00),
('Salsa de Tomate', 3000, 500, 'Mililitros', 6.00);

-- Recetas (pizza_ingredientes)
INSERT INTO pizza_ingredientes (id_pizza, id_ingrediente, cantidad_requerida) VALUES 
(1, 1, 200), (1, 2, 100), (1, 8, 50),       -- Hawaiana
(2, 1, 250), (2, 3, 150), (2, 8, 50),       -- Pepperoni
(3, 1, 200), (3, 6, 100),                    -- Cuatro Quesos
(4, 1, 200), (4, 4, 100), (4, 5, 80), (4, 8, 50), -- Vegetariana Suprema
(5, 1, 180), (5, 7, 30), (5, 8, 40);        -- Margarita

-- Repartidores
INSERT INTO repartidores (nombre, zona_asignada) VALUES 
('Carlos Gomez', 'Zona Norte'),
('Laura Diaz', 'Zona Sur'),
('Miguel Torres', 'Zona Centro');

-- Pedidos
INSERT INTO pedidos (id_cliente, fecha_hora, metodo_pago, estado, total) VALUES 
(1, '2025-03-10 12:30:00', 'Efectivo', 'Entregado', 59500.00),
(2, '2025-03-10 13:00:00', 'Tarjeta', 'Entregado', 41650.00),
(3, '2025-03-11 19:00:00', 'App', 'Entregado', 29750.00),
(1, '2025-03-12 20:00:00', 'Tarjeta', 'Entregado', 71400.00),
(4, '2025-03-15 14:00:00', 'Efectivo', 'Pendiente', 35700.00);

-- Detalles del pedido
INSERT INTO pedido_detalles (id_pedido, id_pizza, cantidad, subtotal) VALUES 
(1, 1, 1, 25000.00),   -- Pedido 1: 1 Hawaiana
(1, 2, 1, 35000.00),   -- Pedido 1: 1 Pepperoni
(2, 2, 1, 35000.00),   -- Pedido 2: 1 Pepperoni
(3, 1, 1, 25000.00),   -- Pedido 3: 1 Hawaiana
(4, 3, 2, 60000.00),   -- Pedido 4: 2 Cuatro Quesos
(5, 4, 1, 32000.00);   -- Pedido 5: 1 Vegetariana Suprema

-- Domicilios
INSERT INTO domicilios (id_pedido, id_repartidor, hora_salida, hora_entrega, distancia_km, costo_envio) VALUES 
(1, 1, '2025-03-10 12:45:00', '2025-03-10 13:10:00', 3.5, 5000.00),
(2, 2, '2025-03-10 13:20:00', '2025-03-10 13:55:00', 5.0, 7000.00),
(3, 1, '2025-03-11 19:20:00', '2025-03-11 19:40:00', 2.0, 3000.00),
(4, 3, '2025-03-12 20:15:00', '2025-03-12 20:50:00', 4.5, 6000.00);
