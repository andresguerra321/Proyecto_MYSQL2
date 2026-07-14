USE pizzeria_don_piccolo;

DELIMITER //

-- Trigger de actualización automática de stock de ingredientes cuando se realiza un pedido.
CREATE TRIGGER tr_actualizar_stock_ingredientes
AFTER INSERT ON pedido_detalles
FOR EACH ROW
BEGIN
    -- Reducir el stock de todos los ingredientes asociados a la pizza según la cantidad solicitada
    UPDATE ingredientes i
    JOIN pizza_ingredientes pi ON i.id_ingrediente = pi.id_ingrediente
    SET i.stock_disponible = i.stock_disponible - (pi.cantidad_requerida * NEW.cantidad)
    WHERE pi.id_pizza = NEW.id_pizza;
END //

-- Trigger de auditoría que registre en una tabla historial_precios cada vez que se modifique el precio de una pizza.
CREATE TRIGGER tr_auditoria_precio_pizza
AFTER UPDATE ON pizzas
FOR EACH ROW
BEGIN
    IF OLD.precio_base <> NEW.precio_base THEN
        INSERT INTO historial_precios (id_pizza, precio_anterior, precio_nuevo, fecha_modificacion)
        VALUES (NEW.id_pizza, OLD.precio_base, NEW.precio_base, CURRENT_TIMESTAMP);
    END IF;
END //

-- Trigger para marcar repartidor como “disponible” nuevamente cuando termina un domicilio
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
