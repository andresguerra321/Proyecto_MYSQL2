USE pizzeria_don_piccolo;

-- 1. Clientes con pedidos entre dos fechas (BETWEEN).
SELECT DISTINCT clientes.nombre, clientes.telefono, clientes.correo
FROM clientes
JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente
WHERE pedidos.fecha_hora BETWEEN '2025-03-01 00:00:00' AND '2025-03-31 23:59:59';

-- 2. Pizzas más vendidas (GROUP BY y COUNT).
SELECT pizzas.nombre, pizzas.tamano, SUM(pedido_detalles.cantidad) AS total_vendidas
FROM pizzas
JOIN pedido_detalles ON pizzas.id_pizza = pedido_detalles.id_pizza
GROUP BY pizzas.id_pizza, pizzas.nombre, pizzas.tamano
ORDER BY total_vendidas DESC;

-- 3. Pedidos por repartidor (JOIN).
SELECT repartidores.nombre AS repartidor, repartidores.zona_asignada, pedidos.id_pedido, pedidos.fecha_hora, pedidos.estado
FROM repartidores
JOIN domicilios ON repartidores.id_repartidor = domicilios.id_repartidor
JOIN pedidos ON domicilios.id_pedido = pedidos.id_pedido
ORDER BY repartidores.nombre, pedidos.fecha_hora DESC;

-- 4. Promedio de entrega por zona (AVG y JOIN).
SELECT repartidores.zona_asignada, 
       AVG(TIMESTAMPDIFF(MINUTE, domicilios.hora_salida, domicilios.hora_entrega)) AS promedio_minutos
FROM repartidores
JOIN domicilios ON repartidores.id_repartidor = domicilios.id_repartidor
WHERE domicilios.hora_entrega IS NOT NULL
GROUP BY repartidores.zona_asignada;

-- 5. Clientes que gastaron más de un monto (HAVING).
-- Ejemplo: Clientes que han gastado más de $500.00 en total.
SELECT clientes.nombre, SUM(pedidos.total) AS total_gastado
FROM clientes
JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente
GROUP BY clientes.id_cliente, clientes.nombre
HAVING SUM(pedidos.total) > 500.00;

-- 6. Búsqueda por coincidencia parcial de nombre de pizza (LIKE).
-- Ejemplo: Buscar pizzas que tengan la palabra 'Queso'.
SELECT nombre, tamano, precio_base, tipo
FROM pizzas
WHERE nombre LIKE '%Queso%';

-- 7. Subconsulta para obtener los clientes frecuentes (más de 1 pedido mensual).
SELECT nombre, telefono, correo
FROM clientes
WHERE id_cliente IN (
    SELECT id_cliente
    FROM pedidos
    WHERE MONTH(fecha_hora) = 3 
      AND YEAR(fecha_hora) = 2025
    GROUP BY id_cliente
    HAVING COUNT(id_pedido) > 1
);
