USE pizzeria_don_piccolo;

-- 1. Clientes con pedidos entre dos fechas (BETWEEN).
SELECT DISTINCT c.nombre, c.telefono, c.correo
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.fecha_hora BETWEEN '2025-03-01 00:00:00' AND '2025-03-31 23:59:59';

-- 2. Pizzas más vendidas (GROUP BY y COUNT).
SELECT pz.nombre, pz.tamano, SUM(pd.cantidad) AS total_vendidas
FROM pizzas pz
JOIN pedido_detalles pd ON pz.id_pizza = pd.id_pizza
GROUP BY pz.id_pizza, pz.nombre, pz.tamano
ORDER BY total_vendidas DESC;

-- 3. Pedidos por repartidor (JOIN).
SELECT r.nombre AS repartidor, r.zona_asignada, p.id_pedido, p.fecha_hora, p.estado
FROM repartidores r
JOIN domicilios d ON r.id_repartidor = d.id_repartidor
JOIN pedidos p ON d.id_pedido = p.id_pedido
ORDER BY r.nombre, p.fecha_hora DESC;

-- 4. Promedio de entrega por zona (AVG y JOIN).
SELECT r.zona_asignada, 
       AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)) AS promedio_minutos
FROM repartidores r
JOIN domicilios d ON r.id_repartidor = d.id_repartidor
WHERE d.hora_entrega IS NOT NULL
GROUP BY r.zona_asignada;

-- 5. Clientes que gastaron más de un monto (HAVING).
-- Ejemplo: Clientes que han gastado más de $500.00 en total.
SELECT c.nombre, SUM(p.total) AS total_gastado
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre
HAVING SUM(p.total) > 500.00;

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
