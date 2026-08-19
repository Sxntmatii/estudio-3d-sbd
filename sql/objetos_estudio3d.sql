-- ===================================================================
--  Proyecto: Estudio de Impresion 3D - Grupo 1
--  Objetos avanzados: triggers, reportes, procedimientos, indices
--  y usuarios con permisos.
--  Ejecutar despues de crear la base y cargar los datos.
-- ===================================================================

USE estudio3d;


-- ###################################################################
-- 1) TRIGGERS
-- ###################################################################

DROP TRIGGER IF EXISTS tr_detalle_subtotal;
DROP TRIGGER IF EXISTS tr_detalle_subtotal_editar;
DROP TRIGGER IF EXISTS tr_consumo_descuenta_stock;

-- Trigger 1: calcula solo el subtotal de cada linea del pedido.
DELIMITER $$
CREATE TRIGGER tr_detalle_subtotal
BEFORE INSERT ON DETALLE_PEDIDO
FOR EACH ROW
BEGIN
    SET NEW.Subtotal = NEW.Cantidad * NEW.Precio_Unitario;
END $$
DELIMITER ;

-- Trigger 3: si se edita la linea, vuelve a calcular el subtotal.
DELIMITER $$
CREATE TRIGGER tr_detalle_subtotal_editar
BEFORE UPDATE ON DETALLE_PEDIDO
FOR EACH ROW
BEGIN
    SET NEW.Subtotal = NEW.Cantidad * NEW.Precio_Unitario;
END $$
DELIMITER ;

-- Trigger 2: al registrar un consumo, descuenta el material del inventario.
DELIMITER $$
CREATE TRIGGER tr_consumo_descuenta_stock
AFTER INSERT ON CONSUMO_MATERIAL
FOR EACH ROW
BEGIN
    UPDATE MATERIAL
    SET Stock_Actual = Stock_Actual - (NEW.Material_Bueno + NEW.Material_Desperdiciado)
    WHERE ID_Material = NEW.ID_Material;
END $$
DELIMITER ;


-- ###################################################################
-- 2) REPORTES (vistas que juntan 3 o mas tablas)
-- ###################################################################

-- v_reporte_pedidos: usa PEDIDO, CLIENTE, DETALLE_PEDIDO, PRODUCTO
DROP VIEW IF EXISTS v_reporte_pedidos;
CREATE VIEW v_reporte_pedidos AS
SELECT p.Numero_Pedido,
       c.Nombre AS Cliente,
       p.Fecha_Hora,
       p.Estado_Actual,
       pr.Nombre AS Producto,
       pr.Categoria,
       d.Cantidad,
       d.Precio_Unitario,
       d.Subtotal
FROM PEDIDO p
JOIN CLIENTE c        ON p.Cedula_ID = c.Cedula_ID
JOIN DETALLE_PEDIDO d ON d.Numero_Pedido = p.Numero_Pedido
JOIN PRODUCTO pr      ON pr.Codigo_Producto = d.Codigo_Producto;

-- v_reporte_produccion: usa ORDEN_IMPRESION, PEDIDO, CLIENTE, IMPRESORA_3D, EMPLEADO
DROP VIEW IF EXISTS v_reporte_produccion;
CREATE VIEW v_reporte_produccion AS
SELECT o.ID_Orden,
       o.Estado AS Estado_Orden,
       p.Numero_Pedido,
       c.Nombre AS Cliente,
       i.Marca,
       i.Modelo,
       i.Tecnologia,
       e.Nombre AS Operador,
       o.Gramos_Proyectados,
       o.Tiempo_Estimado
FROM ORDEN_IMPRESION o
JOIN PEDIDO p       ON o.Numero_Pedido = p.Numero_Pedido
JOIN CLIENTE c      ON p.Cedula_ID = c.Cedula_ID
JOIN IMPRESORA_3D i ON o.Codigo_Interno = i.Codigo_Interno
JOIN EMPLEADO e     ON o.ID_Empleado = e.ID_Empleado;

-- v_reporte_consumo: usa CONSUMO_MATERIAL, ORDEN_IMPRESION, MATERIAL, PEDIDO
DROP VIEW IF EXISTS v_reporte_consumo;
CREATE VIEW v_reporte_consumo AS
SELECT cm.ID_Consumo,
       cm.Fecha,
       o.ID_Orden,
       p.Numero_Pedido,
       m.Tipo AS Material,
       m.Color,
       m.Unidad,
       cm.Material_Bueno,
       cm.Material_Desperdiciado,
       (cm.Material_Bueno + cm.Material_Desperdiciado) * m.Costo_Unitario AS Costo_Total
FROM CONSUMO_MATERIAL cm
JOIN ORDEN_IMPRESION o ON cm.ID_Orden = o.ID_Orden
JOIN PEDIDO p          ON o.Numero_Pedido = p.Numero_Pedido
JOIN MATERIAL m        ON cm.ID_Material = m.ID_Material;

-- v_reporte_entregas: usa DESPACHO, PEDIDO, CLIENTE, TRANSPORTADORA, EMPLEADO
DROP VIEW IF EXISTS v_reporte_entregas;
CREATE VIEW v_reporte_entregas AS
SELECT d.ID_Despacho,
       d.Numero_Pedido,
       c.Nombre AS Cliente,
       t.Nombre AS Transportadora,
       e.Nombre AS Encargado,
       d.Codigo_Rastreo,
       d.Estado AS Estado_Despacho,
       d.Fecha_Envio,
       d.Fecha_Entrega
FROM DESPACHO d
JOIN PEDIDO p          ON d.Numero_Pedido = p.Numero_Pedido
JOIN CLIENTE c         ON p.Cedula_ID = c.Cedula_ID
JOIN TRANSPORTADORA t  ON d.ID_Transportadora = t.ID_Transportadora
JOIN EMPLEADO e        ON d.ID_Empleado = e.ID_Empleado;


-- ###################################################################
-- 3) PROCEDIMIENTOS para insertar, actualizar y eliminar
--    Todos usan START TRANSACTION / COMMIT / ROLLBACK y avisan
--    los errores con SIGNAL.
-- ###################################################################

-- ---------- CLIENTE ----------
DROP PROCEDURE IF EXISTS sp_cliente_insertar;
DROP PROCEDURE IF EXISTS sp_cliente_actualizar;
DROP PROCEDURE IF EXISTS sp_cliente_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_cliente_insertar(IN p_Cedula_ID varchar(13), IN p_Nombre varchar(100), IN p_Correo varchar(120), IN p_Telefono varchar(15))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en CLIENTE';
    END;

    IF EXISTS (SELECT 1 FROM CLIENTE WHERE Cedula_ID = p_Cedula_ID) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Ya existe un registro con esa clave en CLIENTE';
    END IF;

    START TRANSACTION;
        INSERT INTO CLIENTE (Cedula_ID, Nombre, Correo, Telefono)
        VALUES (p_Cedula_ID, p_Nombre, p_Correo, p_Telefono);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_cliente_actualizar(IN p_Cedula_ID varchar(13), IN p_Nombre varchar(100), IN p_Correo varchar(120), IN p_Telefono varchar(15))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en CLIENTE';
    END;

    IF NOT EXISTS (SELECT 1 FROM CLIENTE WHERE Cedula_ID = p_Cedula_ID) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en CLIENTE';
    END IF;

    START TRANSACTION;
        UPDATE CLIENTE
        SET Nombre = p_Nombre,
            Correo = p_Correo,
            Telefono = p_Telefono
        WHERE Cedula_ID = p_Cedula_ID;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_cliente_eliminar(IN p_Cedula_ID varchar(13))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de CLIENTE, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM CLIENTE WHERE Cedula_ID = p_Cedula_ID) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en CLIENTE';
    END IF;

    START TRANSACTION;
        DELETE FROM CLIENTE WHERE Cedula_ID = p_Cedula_ID;
    COMMIT;
END $$
DELIMITER ;

-- ---------- EMPLEADO ----------
DROP PROCEDURE IF EXISTS sp_empleado_insertar;
DROP PROCEDURE IF EXISTS sp_empleado_actualizar;
DROP PROCEDURE IF EXISTS sp_empleado_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_empleado_insertar(IN p_Nombre varchar(100), IN p_Rol varchar(50), IN p_Telefono varchar(15))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en EMPLEADO';
    END;

    START TRANSACTION;
        INSERT INTO EMPLEADO (Nombre, Rol, Telefono)
        VALUES (p_Nombre, p_Rol, p_Telefono);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_empleado_actualizar(IN p_ID_Empleado int, IN p_Nombre varchar(100), IN p_Rol varchar(50), IN p_Telefono varchar(15))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en EMPLEADO';
    END;

    IF NOT EXISTS (SELECT 1 FROM EMPLEADO WHERE ID_Empleado = p_ID_Empleado) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en EMPLEADO';
    END IF;

    START TRANSACTION;
        UPDATE EMPLEADO
        SET Nombre = p_Nombre,
            Rol = p_Rol,
            Telefono = p_Telefono
        WHERE ID_Empleado = p_ID_Empleado;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_empleado_eliminar(IN p_ID_Empleado int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de EMPLEADO, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM EMPLEADO WHERE ID_Empleado = p_ID_Empleado) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en EMPLEADO';
    END IF;

    START TRANSACTION;
        DELETE FROM EMPLEADO WHERE ID_Empleado = p_ID_Empleado;
    COMMIT;
END $$
DELIMITER ;

-- ---------- PROVEEDOR ----------
DROP PROCEDURE IF EXISTS sp_proveedor_insertar;
DROP PROCEDURE IF EXISTS sp_proveedor_actualizar;
DROP PROCEDURE IF EXISTS sp_proveedor_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_proveedor_insertar(IN p_Nombre varchar(100), IN p_Telefono varchar(15), IN p_Correo varchar(120))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en PROVEEDOR';
    END;

    START TRANSACTION;
        INSERT INTO PROVEEDOR (Nombre, Telefono, Correo)
        VALUES (p_Nombre, p_Telefono, p_Correo);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_proveedor_actualizar(IN p_ID_Proveedor int, IN p_Nombre varchar(100), IN p_Telefono varchar(15), IN p_Correo varchar(120))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en PROVEEDOR';
    END;

    IF NOT EXISTS (SELECT 1 FROM PROVEEDOR WHERE ID_Proveedor = p_ID_Proveedor) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en PROVEEDOR';
    END IF;

    START TRANSACTION;
        UPDATE PROVEEDOR
        SET Nombre = p_Nombre,
            Telefono = p_Telefono,
            Correo = p_Correo
        WHERE ID_Proveedor = p_ID_Proveedor;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_proveedor_eliminar(IN p_ID_Proveedor int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de PROVEEDOR, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM PROVEEDOR WHERE ID_Proveedor = p_ID_Proveedor) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en PROVEEDOR';
    END IF;

    START TRANSACTION;
        DELETE FROM PROVEEDOR WHERE ID_Proveedor = p_ID_Proveedor;
    COMMIT;
END $$
DELIMITER ;

-- ---------- TRANSPORTADORA ----------
DROP PROCEDURE IF EXISTS sp_transportadora_insertar;
DROP PROCEDURE IF EXISTS sp_transportadora_actualizar;
DROP PROCEDURE IF EXISTS sp_transportadora_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_transportadora_insertar(IN p_Nombre varchar(100), IN p_Telefono varchar(15), IN p_Sitio_Web varchar(150))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en TRANSPORTADORA';
    END;

    START TRANSACTION;
        INSERT INTO TRANSPORTADORA (Nombre, Telefono, Sitio_Web)
        VALUES (p_Nombre, p_Telefono, p_Sitio_Web);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_transportadora_actualizar(IN p_ID_Transportadora int, IN p_Nombre varchar(100), IN p_Telefono varchar(15), IN p_Sitio_Web varchar(150))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en TRANSPORTADORA';
    END;

    IF NOT EXISTS (SELECT 1 FROM TRANSPORTADORA WHERE ID_Transportadora = p_ID_Transportadora) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en TRANSPORTADORA';
    END IF;

    START TRANSACTION;
        UPDATE TRANSPORTADORA
        SET Nombre = p_Nombre,
            Telefono = p_Telefono,
            Sitio_Web = p_Sitio_Web
        WHERE ID_Transportadora = p_ID_Transportadora;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_transportadora_eliminar(IN p_ID_Transportadora int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de TRANSPORTADORA, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM TRANSPORTADORA WHERE ID_Transportadora = p_ID_Transportadora) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en TRANSPORTADORA';
    END IF;

    START TRANSACTION;
        DELETE FROM TRANSPORTADORA WHERE ID_Transportadora = p_ID_Transportadora;
    COMMIT;
END $$
DELIMITER ;

-- ---------- MATERIAL ----------
DROP PROCEDURE IF EXISTS sp_material_insertar;
DROP PROCEDURE IF EXISTS sp_material_actualizar;
DROP PROCEDURE IF EXISTS sp_material_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_material_insertar(IN p_Tipo varchar(50), IN p_Color varchar(50), IN p_Unidad varchar(20), IN p_Stock_Actual decimal(10,2), IN p_Costo_Unitario decimal(10,3))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en MATERIAL';
    END;

    IF p_Stock_Actual < 0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'El stock del material no puede ser negativo';
    END IF;

    START TRANSACTION;
        INSERT INTO MATERIAL (Tipo, Color, Unidad, Stock_Actual, Costo_Unitario)
        VALUES (p_Tipo, p_Color, p_Unidad, p_Stock_Actual, p_Costo_Unitario);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_material_actualizar(IN p_ID_Material int, IN p_Tipo varchar(50), IN p_Color varchar(50), IN p_Unidad varchar(20), IN p_Stock_Actual decimal(10,2), IN p_Costo_Unitario decimal(10,3))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en MATERIAL';
    END;

    IF NOT EXISTS (SELECT 1 FROM MATERIAL WHERE ID_Material = p_ID_Material) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en MATERIAL';
    END IF;

    START TRANSACTION;
        UPDATE MATERIAL
        SET Tipo = p_Tipo,
            Color = p_Color,
            Unidad = p_Unidad,
            Stock_Actual = p_Stock_Actual,
            Costo_Unitario = p_Costo_Unitario
        WHERE ID_Material = p_ID_Material;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_material_eliminar(IN p_ID_Material int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de MATERIAL, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM MATERIAL WHERE ID_Material = p_ID_Material) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en MATERIAL';
    END IF;

    START TRANSACTION;
        DELETE FROM MATERIAL WHERE ID_Material = p_ID_Material;
    COMMIT;
END $$
DELIMITER ;

-- ---------- PRODUCTO ----------
DROP PROCEDURE IF EXISTS sp_producto_insertar;
DROP PROCEDURE IF EXISTS sp_producto_actualizar;
DROP PROCEDURE IF EXISTS sp_producto_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_producto_insertar(IN p_Codigo_Producto varchar(20), IN p_Nombre varchar(100), IN p_Precio decimal(10,2), IN p_Categoria varchar(50), IN p_Tipo_Garantia varchar(100), IN p_Stock int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en PRODUCTO';
    END;

    IF EXISTS (SELECT 1 FROM PRODUCTO WHERE Codigo_Producto = p_Codigo_Producto) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Ya existe un registro con esa clave en PRODUCTO';
    END IF;

    IF p_Precio < 0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'El precio no puede ser negativo';
    END IF;

    IF p_Stock < 0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'El stock no puede ser negativo';
    END IF;

    START TRANSACTION;
        INSERT INTO PRODUCTO (Codigo_Producto, Nombre, Precio, Categoria, Tipo_Garantia, Stock)
        VALUES (p_Codigo_Producto, p_Nombre, p_Precio, p_Categoria, p_Tipo_Garantia, p_Stock);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_producto_actualizar(IN p_Codigo_Producto varchar(20), IN p_Nombre varchar(100), IN p_Precio decimal(10,2), IN p_Categoria varchar(50), IN p_Tipo_Garantia varchar(100), IN p_Stock int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en PRODUCTO';
    END;

    IF NOT EXISTS (SELECT 1 FROM PRODUCTO WHERE Codigo_Producto = p_Codigo_Producto) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en PRODUCTO';
    END IF;

    START TRANSACTION;
        UPDATE PRODUCTO
        SET Nombre = p_Nombre,
            Precio = p_Precio,
            Categoria = p_Categoria,
            Tipo_Garantia = p_Tipo_Garantia,
            Stock = p_Stock
        WHERE Codigo_Producto = p_Codigo_Producto;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_producto_eliminar(IN p_Codigo_Producto varchar(20))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de PRODUCTO, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM PRODUCTO WHERE Codigo_Producto = p_Codigo_Producto) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en PRODUCTO';
    END IF;

    START TRANSACTION;
        DELETE FROM PRODUCTO WHERE Codigo_Producto = p_Codigo_Producto;
    COMMIT;
END $$
DELIMITER ;

-- ---------- IMPRESORA_3D ----------
DROP PROCEDURE IF EXISTS sp_impresora_3d_insertar;
DROP PROCEDURE IF EXISTS sp_impresora_3d_actualizar;
DROP PROCEDURE IF EXISTS sp_impresora_3d_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_impresora_3d_insertar(IN p_Codigo_Interno varchar(20), IN p_Marca varchar(50), IN p_Modelo varchar(50), IN p_Tecnologia varchar(20), IN p_Numero_Serie varchar(50), IN p_Fecha_Compra date, IN p_Estado varchar(30), IN p_ID_Proveedor int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en IMPRESORA_3D';
    END;

    IF EXISTS (SELECT 1 FROM IMPRESORA_3D WHERE Codigo_Interno = p_Codigo_Interno) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Ya existe un registro con esa clave en IMPRESORA_3D';
    END IF;

    START TRANSACTION;
        INSERT INTO IMPRESORA_3D (Codigo_Interno, Marca, Modelo, Tecnologia, Numero_Serie, Fecha_Compra, Estado, ID_Proveedor)
        VALUES (p_Codigo_Interno, p_Marca, p_Modelo, p_Tecnologia, p_Numero_Serie, p_Fecha_Compra, p_Estado, p_ID_Proveedor);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_impresora_3d_actualizar(IN p_Codigo_Interno varchar(20), IN p_Marca varchar(50), IN p_Modelo varchar(50), IN p_Tecnologia varchar(20), IN p_Numero_Serie varchar(50), IN p_Fecha_Compra date, IN p_Estado varchar(30), IN p_ID_Proveedor int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en IMPRESORA_3D';
    END;

    IF NOT EXISTS (SELECT 1 FROM IMPRESORA_3D WHERE Codigo_Interno = p_Codigo_Interno) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en IMPRESORA_3D';
    END IF;

    START TRANSACTION;
        UPDATE IMPRESORA_3D
        SET Marca = p_Marca,
            Modelo = p_Modelo,
            Tecnologia = p_Tecnologia,
            Numero_Serie = p_Numero_Serie,
            Fecha_Compra = p_Fecha_Compra,
            Estado = p_Estado,
            ID_Proveedor = p_ID_Proveedor
        WHERE Codigo_Interno = p_Codigo_Interno;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_impresora_3d_eliminar(IN p_Codigo_Interno varchar(20))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de IMPRESORA_3D, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM IMPRESORA_3D WHERE Codigo_Interno = p_Codigo_Interno) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en IMPRESORA_3D';
    END IF;

    START TRANSACTION;
        DELETE FROM IMPRESORA_3D WHERE Codigo_Interno = p_Codigo_Interno;
    COMMIT;
END $$
DELIMITER ;

-- ---------- PEDIDO ----------
DROP PROCEDURE IF EXISTS sp_pedido_insertar;
DROP PROCEDURE IF EXISTS sp_pedido_actualizar;
DROP PROCEDURE IF EXISTS sp_pedido_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_pedido_insertar(IN p_Fecha_Hora datetime, IN p_Tipo varchar(30), IN p_Estado_Actual varchar(40), IN p_Fecha_Estim_Entrega date, IN p_Total decimal(10,2), IN p_Cedula_ID varchar(13))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en PEDIDO';
    END;

    START TRANSACTION;
        INSERT INTO PEDIDO (Fecha_Hora, Tipo, Estado_Actual, Fecha_Estim_Entrega, Total, Cedula_ID)
        VALUES (p_Fecha_Hora, p_Tipo, p_Estado_Actual, p_Fecha_Estim_Entrega, p_Total, p_Cedula_ID);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_pedido_actualizar(IN p_Numero_Pedido int, IN p_Fecha_Hora datetime, IN p_Tipo varchar(30), IN p_Estado_Actual varchar(40), IN p_Fecha_Estim_Entrega date, IN p_Total decimal(10,2), IN p_Cedula_ID varchar(13))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en PEDIDO';
    END;

    IF NOT EXISTS (SELECT 1 FROM PEDIDO WHERE Numero_Pedido = p_Numero_Pedido) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en PEDIDO';
    END IF;

    START TRANSACTION;
        UPDATE PEDIDO
        SET Fecha_Hora = p_Fecha_Hora,
            Tipo = p_Tipo,
            Estado_Actual = p_Estado_Actual,
            Fecha_Estim_Entrega = p_Fecha_Estim_Entrega,
            Total = p_Total,
            Cedula_ID = p_Cedula_ID
        WHERE Numero_Pedido = p_Numero_Pedido;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_pedido_eliminar(IN p_Numero_Pedido int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de PEDIDO, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM PEDIDO WHERE Numero_Pedido = p_Numero_Pedido) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en PEDIDO';
    END IF;

    START TRANSACTION;
        DELETE FROM PEDIDO WHERE Numero_Pedido = p_Numero_Pedido;
    COMMIT;
END $$
DELIMITER ;

-- ---------- DETALLE_PEDIDO ----------
DROP PROCEDURE IF EXISTS sp_detalle_pedido_insertar;
DROP PROCEDURE IF EXISTS sp_detalle_pedido_actualizar;
DROP PROCEDURE IF EXISTS sp_detalle_pedido_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_detalle_pedido_insertar(IN p_Cantidad int, IN p_Precio_Unitario decimal(10,2), IN p_Subtotal decimal(10,2), IN p_Numero_Pedido int, IN p_Codigo_Producto varchar(20))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en DETALLE_PEDIDO';
    END;

    IF p_Cantidad <= 0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'La cantidad debe ser mayor que cero';
    END IF;

    START TRANSACTION;
        INSERT INTO DETALLE_PEDIDO (Cantidad, Precio_Unitario, Subtotal, Numero_Pedido, Codigo_Producto)
        VALUES (p_Cantidad, p_Precio_Unitario, p_Subtotal, p_Numero_Pedido, p_Codigo_Producto);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_detalle_pedido_actualizar(IN p_ID_Detalle int, IN p_Cantidad int, IN p_Precio_Unitario decimal(10,2), IN p_Subtotal decimal(10,2), IN p_Numero_Pedido int, IN p_Codigo_Producto varchar(20))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en DETALLE_PEDIDO';
    END;

    IF NOT EXISTS (SELECT 1 FROM DETALLE_PEDIDO WHERE ID_Detalle = p_ID_Detalle) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en DETALLE_PEDIDO';
    END IF;

    START TRANSACTION;
        UPDATE DETALLE_PEDIDO
        SET Cantidad = p_Cantidad,
            Precio_Unitario = p_Precio_Unitario,
            Subtotal = p_Subtotal,
            Numero_Pedido = p_Numero_Pedido,
            Codigo_Producto = p_Codigo_Producto
        WHERE ID_Detalle = p_ID_Detalle;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_detalle_pedido_eliminar(IN p_ID_Detalle int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de DETALLE_PEDIDO, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM DETALLE_PEDIDO WHERE ID_Detalle = p_ID_Detalle) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en DETALLE_PEDIDO';
    END IF;

    START TRANSACTION;
        DELETE FROM DETALLE_PEDIDO WHERE ID_Detalle = p_ID_Detalle;
    COMMIT;
END $$
DELIMITER ;

-- ---------- FACTURA ----------
DROP PROCEDURE IF EXISTS sp_factura_insertar;
DROP PROCEDURE IF EXISTS sp_factura_actualizar;
DROP PROCEDURE IF EXISTS sp_factura_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_factura_insertar(IN p_Fecha_Emision date, IN p_Total decimal(10,2), IN p_Estado_Pago varchar(20), IN p_Forma_Pago varchar(20), IN p_Fecha_Pago date, IN p_Numero_Pedido int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en FACTURA';
    END;

    START TRANSACTION;
        INSERT INTO FACTURA (Fecha_Emision, Total, Estado_Pago, Forma_Pago, Fecha_Pago, Numero_Pedido)
        VALUES (p_Fecha_Emision, p_Total, p_Estado_Pago, p_Forma_Pago, p_Fecha_Pago, p_Numero_Pedido);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_factura_actualizar(IN p_Numero_Factura int, IN p_Fecha_Emision date, IN p_Total decimal(10,2), IN p_Estado_Pago varchar(20), IN p_Forma_Pago varchar(20), IN p_Fecha_Pago date, IN p_Numero_Pedido int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en FACTURA';
    END;

    IF NOT EXISTS (SELECT 1 FROM FACTURA WHERE Numero_Factura = p_Numero_Factura) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en FACTURA';
    END IF;

    START TRANSACTION;
        UPDATE FACTURA
        SET Fecha_Emision = p_Fecha_Emision,
            Total = p_Total,
            Estado_Pago = p_Estado_Pago,
            Forma_Pago = p_Forma_Pago,
            Fecha_Pago = p_Fecha_Pago,
            Numero_Pedido = p_Numero_Pedido
        WHERE Numero_Factura = p_Numero_Factura;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_factura_eliminar(IN p_Numero_Factura int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de FACTURA, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM FACTURA WHERE Numero_Factura = p_Numero_Factura) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en FACTURA';
    END IF;

    START TRANSACTION;
        DELETE FROM FACTURA WHERE Numero_Factura = p_Numero_Factura;
    COMMIT;
END $$
DELIMITER ;

-- ---------- SOLICITUD_IMPRESION ----------
DROP PROCEDURE IF EXISTS sp_solicitud_impresion_insertar;
DROP PROCEDURE IF EXISTS sp_solicitud_impresion_actualizar;
DROP PROCEDURE IF EXISTS sp_solicitud_impresion_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_solicitud_impresion_insertar(IN p_Descripcion varchar(255), IN p_Referencias_Visuales text, IN p_Color varchar(40), IN p_Escala decimal(5,2), IN p_Fecha_Solicitud date, IN p_Numero_Pedido int, IN p_ID_Material int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en SOLICITUD_IMPRESION';
    END;

    START TRANSACTION;
        INSERT INTO SOLICITUD_IMPRESION (Descripcion, Referencias_Visuales, Color, Escala, Fecha_Solicitud, Numero_Pedido, ID_Material)
        VALUES (p_Descripcion, p_Referencias_Visuales, p_Color, p_Escala, p_Fecha_Solicitud, p_Numero_Pedido, p_ID_Material);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_solicitud_impresion_actualizar(IN p_ID_Solicitud int, IN p_Descripcion varchar(255), IN p_Referencias_Visuales text, IN p_Color varchar(40), IN p_Escala decimal(5,2), IN p_Fecha_Solicitud date, IN p_Numero_Pedido int, IN p_ID_Material int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en SOLICITUD_IMPRESION';
    END;

    IF NOT EXISTS (SELECT 1 FROM SOLICITUD_IMPRESION WHERE ID_Solicitud = p_ID_Solicitud) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en SOLICITUD_IMPRESION';
    END IF;

    START TRANSACTION;
        UPDATE SOLICITUD_IMPRESION
        SET Descripcion = p_Descripcion,
            Referencias_Visuales = p_Referencias_Visuales,
            Color = p_Color,
            Escala = p_Escala,
            Fecha_Solicitud = p_Fecha_Solicitud,
            Numero_Pedido = p_Numero_Pedido,
            ID_Material = p_ID_Material
        WHERE ID_Solicitud = p_ID_Solicitud;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_solicitud_impresion_eliminar(IN p_ID_Solicitud int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de SOLICITUD_IMPRESION, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM SOLICITUD_IMPRESION WHERE ID_Solicitud = p_ID_Solicitud) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en SOLICITUD_IMPRESION';
    END IF;

    START TRANSACTION;
        DELETE FROM SOLICITUD_IMPRESION WHERE ID_Solicitud = p_ID_Solicitud;
    COMMIT;
END $$
DELIMITER ;

-- ---------- RENDER_PRELIMINAR ----------
DROP PROCEDURE IF EXISTS sp_render_preliminar_insertar;
DROP PROCEDURE IF EXISTS sp_render_preliminar_actualizar;
DROP PROCEDURE IF EXISTS sp_render_preliminar_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_render_preliminar_insertar(IN p_Fecha_Envio date, IN p_Imagen text, IN p_Respuesta varchar(20), IN p_Comentarios text, IN p_Fecha_Respuesta date, IN p_Numero_Pedido int, IN p_ID_Empleado int, IN p_Cedula_ID varchar(13))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en RENDER_PRELIMINAR';
    END;

    START TRANSACTION;
        INSERT INTO RENDER_PRELIMINAR (Fecha_Envio, Imagen, Respuesta, Comentarios, Fecha_Respuesta, Numero_Pedido, ID_Empleado, Cedula_ID)
        VALUES (p_Fecha_Envio, p_Imagen, p_Respuesta, p_Comentarios, p_Fecha_Respuesta, p_Numero_Pedido, p_ID_Empleado, p_Cedula_ID);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_render_preliminar_actualizar(IN p_ID_Render int, IN p_Fecha_Envio date, IN p_Imagen text, IN p_Respuesta varchar(20), IN p_Comentarios text, IN p_Fecha_Respuesta date, IN p_Numero_Pedido int, IN p_ID_Empleado int, IN p_Cedula_ID varchar(13))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en RENDER_PRELIMINAR';
    END;

    IF NOT EXISTS (SELECT 1 FROM RENDER_PRELIMINAR WHERE ID_Render = p_ID_Render) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en RENDER_PRELIMINAR';
    END IF;

    START TRANSACTION;
        UPDATE RENDER_PRELIMINAR
        SET Fecha_Envio = p_Fecha_Envio,
            Imagen = p_Imagen,
            Respuesta = p_Respuesta,
            Comentarios = p_Comentarios,
            Fecha_Respuesta = p_Fecha_Respuesta,
            Numero_Pedido = p_Numero_Pedido,
            ID_Empleado = p_ID_Empleado,
            Cedula_ID = p_Cedula_ID
        WHERE ID_Render = p_ID_Render;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_render_preliminar_eliminar(IN p_ID_Render int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de RENDER_PRELIMINAR, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM RENDER_PRELIMINAR WHERE ID_Render = p_ID_Render) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en RENDER_PRELIMINAR';
    END IF;

    START TRANSACTION;
        DELETE FROM RENDER_PRELIMINAR WHERE ID_Render = p_ID_Render;
    COMMIT;
END $$
DELIMITER ;

-- ---------- ORDEN_IMPRESION ----------
DROP PROCEDURE IF EXISTS sp_orden_impresion_insertar;
DROP PROCEDURE IF EXISTS sp_orden_impresion_actualizar;
DROP PROCEDURE IF EXISTS sp_orden_impresion_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_orden_impresion_insertar(IN p_Gramos_Proyectados decimal(8,2), IN p_Tiempo_Estimado decimal(6,2), IN p_Fecha_Inicio datetime, IN p_Fecha_Fin datetime, IN p_Estado varchar(30), IN p_Numero_Pedido int, IN p_Codigo_Interno varchar(20), IN p_ID_Empleado int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en ORDEN_IMPRESION';
    END;

    START TRANSACTION;
        INSERT INTO ORDEN_IMPRESION (Gramos_Proyectados, Tiempo_Estimado, Fecha_Inicio, Fecha_Fin, Estado, Numero_Pedido, Codigo_Interno, ID_Empleado)
        VALUES (p_Gramos_Proyectados, p_Tiempo_Estimado, p_Fecha_Inicio, p_Fecha_Fin, p_Estado, p_Numero_Pedido, p_Codigo_Interno, p_ID_Empleado);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_orden_impresion_actualizar(IN p_ID_Orden int, IN p_Gramos_Proyectados decimal(8,2), IN p_Tiempo_Estimado decimal(6,2), IN p_Fecha_Inicio datetime, IN p_Fecha_Fin datetime, IN p_Estado varchar(30), IN p_Numero_Pedido int, IN p_Codigo_Interno varchar(20), IN p_ID_Empleado int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en ORDEN_IMPRESION';
    END;

    IF NOT EXISTS (SELECT 1 FROM ORDEN_IMPRESION WHERE ID_Orden = p_ID_Orden) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en ORDEN_IMPRESION';
    END IF;

    START TRANSACTION;
        UPDATE ORDEN_IMPRESION
        SET Gramos_Proyectados = p_Gramos_Proyectados,
            Tiempo_Estimado = p_Tiempo_Estimado,
            Fecha_Inicio = p_Fecha_Inicio,
            Fecha_Fin = p_Fecha_Fin,
            Estado = p_Estado,
            Numero_Pedido = p_Numero_Pedido,
            Codigo_Interno = p_Codigo_Interno,
            ID_Empleado = p_ID_Empleado
        WHERE ID_Orden = p_ID_Orden;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_orden_impresion_eliminar(IN p_ID_Orden int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de ORDEN_IMPRESION, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM ORDEN_IMPRESION WHERE ID_Orden = p_ID_Orden) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en ORDEN_IMPRESION';
    END IF;

    START TRANSACTION;
        DELETE FROM ORDEN_IMPRESION WHERE ID_Orden = p_ID_Orden;
    COMMIT;
END $$
DELIMITER ;

-- ---------- CONSUMO_MATERIAL ----------
DROP PROCEDURE IF EXISTS sp_consumo_material_insertar;
DROP PROCEDURE IF EXISTS sp_consumo_material_actualizar;
DROP PROCEDURE IF EXISTS sp_consumo_material_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_consumo_material_insertar(IN p_Material_Bueno decimal(8,2), IN p_Material_Desperdiciado decimal(8,2), IN p_Fecha date, IN p_ID_Orden int, IN p_ID_Material int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en CONSUMO_MATERIAL';
    END;

    START TRANSACTION;
        INSERT INTO CONSUMO_MATERIAL (Material_Bueno, Material_Desperdiciado, Fecha, ID_Orden, ID_Material)
        VALUES (p_Material_Bueno, p_Material_Desperdiciado, p_Fecha, p_ID_Orden, p_ID_Material);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_consumo_material_actualizar(IN p_ID_Consumo int, IN p_Material_Bueno decimal(8,2), IN p_Material_Desperdiciado decimal(8,2), IN p_Fecha date, IN p_ID_Orden int, IN p_ID_Material int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en CONSUMO_MATERIAL';
    END;

    IF NOT EXISTS (SELECT 1 FROM CONSUMO_MATERIAL WHERE ID_Consumo = p_ID_Consumo) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en CONSUMO_MATERIAL';
    END IF;

    START TRANSACTION;
        UPDATE CONSUMO_MATERIAL
        SET Material_Bueno = p_Material_Bueno,
            Material_Desperdiciado = p_Material_Desperdiciado,
            Fecha = p_Fecha,
            ID_Orden = p_ID_Orden,
            ID_Material = p_ID_Material
        WHERE ID_Consumo = p_ID_Consumo;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_consumo_material_eliminar(IN p_ID_Consumo int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de CONSUMO_MATERIAL, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM CONSUMO_MATERIAL WHERE ID_Consumo = p_ID_Consumo) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en CONSUMO_MATERIAL';
    END IF;

    START TRANSACTION;
        DELETE FROM CONSUMO_MATERIAL WHERE ID_Consumo = p_ID_Consumo;
    COMMIT;
END $$
DELIMITER ;

-- ---------- FALLO_IMPRESION ----------
DROP PROCEDURE IF EXISTS sp_fallo_impresion_insertar;
DROP PROCEDURE IF EXISTS sp_fallo_impresion_actualizar;
DROP PROCEDURE IF EXISTS sp_fallo_impresion_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_fallo_impresion_insertar(IN p_Tipo_Fallo varchar(100), IN p_Material_Desperdiciado decimal(8,2), IN p_Tiempo_Perdido decimal(8,2), IN p_Causa text, IN p_Fue_Reimpresa tinyint, IN p_Costo_Reproceso decimal(10,2), IN p_ID_Orden int, IN p_ID_Empleado int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en FALLO_IMPRESION';
    END;

    START TRANSACTION;
        INSERT INTO FALLO_IMPRESION (Tipo_Fallo, Material_Desperdiciado, Tiempo_Perdido, Causa, Fue_Reimpresa, Costo_Reproceso, ID_Orden, ID_Empleado)
        VALUES (p_Tipo_Fallo, p_Material_Desperdiciado, p_Tiempo_Perdido, p_Causa, p_Fue_Reimpresa, p_Costo_Reproceso, p_ID_Orden, p_ID_Empleado);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_fallo_impresion_actualizar(IN p_ID_Fallo int, IN p_Tipo_Fallo varchar(100), IN p_Material_Desperdiciado decimal(8,2), IN p_Tiempo_Perdido decimal(8,2), IN p_Causa text, IN p_Fue_Reimpresa tinyint, IN p_Costo_Reproceso decimal(10,2), IN p_ID_Orden int, IN p_ID_Empleado int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en FALLO_IMPRESION';
    END;

    IF NOT EXISTS (SELECT 1 FROM FALLO_IMPRESION WHERE ID_Fallo = p_ID_Fallo) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en FALLO_IMPRESION';
    END IF;

    START TRANSACTION;
        UPDATE FALLO_IMPRESION
        SET Tipo_Fallo = p_Tipo_Fallo,
            Material_Desperdiciado = p_Material_Desperdiciado,
            Tiempo_Perdido = p_Tiempo_Perdido,
            Causa = p_Causa,
            Fue_Reimpresa = p_Fue_Reimpresa,
            Costo_Reproceso = p_Costo_Reproceso,
            ID_Orden = p_ID_Orden,
            ID_Empleado = p_ID_Empleado
        WHERE ID_Fallo = p_ID_Fallo;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_fallo_impresion_eliminar(IN p_ID_Fallo int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de FALLO_IMPRESION, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM FALLO_IMPRESION WHERE ID_Fallo = p_ID_Fallo) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en FALLO_IMPRESION';
    END IF;

    START TRANSACTION;
        DELETE FROM FALLO_IMPRESION WHERE ID_Fallo = p_ID_Fallo;
    COMMIT;
END $$
DELIMITER ;

-- ---------- MANTENIMIENTO ----------
DROP PROCEDURE IF EXISTS sp_mantenimiento_insertar;
DROP PROCEDURE IF EXISTS sp_mantenimiento_actualizar;
DROP PROCEDURE IF EXISTS sp_mantenimiento_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_mantenimiento_insertar(IN p_Fecha date, IN p_Tipo varchar(50), IN p_Descripcion text, IN p_Codigo_Interno varchar(20), IN p_ID_Empleado int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en MANTENIMIENTO';
    END;

    START TRANSACTION;
        INSERT INTO MANTENIMIENTO (Fecha, Tipo, Descripcion, Codigo_Interno, ID_Empleado)
        VALUES (p_Fecha, p_Tipo, p_Descripcion, p_Codigo_Interno, p_ID_Empleado);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_mantenimiento_actualizar(IN p_ID_Mantenimiento int, IN p_Fecha date, IN p_Tipo varchar(50), IN p_Descripcion text, IN p_Codigo_Interno varchar(20), IN p_ID_Empleado int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en MANTENIMIENTO';
    END;

    IF NOT EXISTS (SELECT 1 FROM MANTENIMIENTO WHERE ID_Mantenimiento = p_ID_Mantenimiento) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en MANTENIMIENTO';
    END IF;

    START TRANSACTION;
        UPDATE MANTENIMIENTO
        SET Fecha = p_Fecha,
            Tipo = p_Tipo,
            Descripcion = p_Descripcion,
            Codigo_Interno = p_Codigo_Interno,
            ID_Empleado = p_ID_Empleado
        WHERE ID_Mantenimiento = p_ID_Mantenimiento;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_mantenimiento_eliminar(IN p_ID_Mantenimiento int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de MANTENIMIENTO, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM MANTENIMIENTO WHERE ID_Mantenimiento = p_ID_Mantenimiento) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en MANTENIMIENTO';
    END IF;

    START TRANSACTION;
        DELETE FROM MANTENIMIENTO WHERE ID_Mantenimiento = p_ID_Mantenimiento;
    COMMIT;
END $$
DELIMITER ;

-- ---------- ENTRADA_MATERIAL ----------
DROP PROCEDURE IF EXISTS sp_entrada_material_insertar;
DROP PROCEDURE IF EXISTS sp_entrada_material_actualizar;
DROP PROCEDURE IF EXISTS sp_entrada_material_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_entrada_material_insertar(IN p_Fecha_Recepcion date, IN p_Cantidad decimal(10,2), IN p_Fecha_Vencimiento date, IN p_Estado_Empaque varchar(40), IN p_ID_Proveedor int, IN p_ID_Material int, IN p_ID_Empleado int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en ENTRADA_MATERIAL';
    END;

    START TRANSACTION;
        INSERT INTO ENTRADA_MATERIAL (Fecha_Recepcion, Cantidad, Fecha_Vencimiento, Estado_Empaque, ID_Proveedor, ID_Material, ID_Empleado)
        VALUES (p_Fecha_Recepcion, p_Cantidad, p_Fecha_Vencimiento, p_Estado_Empaque, p_ID_Proveedor, p_ID_Material, p_ID_Empleado);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_entrada_material_actualizar(IN p_Numero_Entrada int, IN p_Fecha_Recepcion date, IN p_Cantidad decimal(10,2), IN p_Fecha_Vencimiento date, IN p_Estado_Empaque varchar(40), IN p_ID_Proveedor int, IN p_ID_Material int, IN p_ID_Empleado int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en ENTRADA_MATERIAL';
    END;

    IF NOT EXISTS (SELECT 1 FROM ENTRADA_MATERIAL WHERE Numero_Entrada = p_Numero_Entrada) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en ENTRADA_MATERIAL';
    END IF;

    START TRANSACTION;
        UPDATE ENTRADA_MATERIAL
        SET Fecha_Recepcion = p_Fecha_Recepcion,
            Cantidad = p_Cantidad,
            Fecha_Vencimiento = p_Fecha_Vencimiento,
            Estado_Empaque = p_Estado_Empaque,
            ID_Proveedor = p_ID_Proveedor,
            ID_Material = p_ID_Material,
            ID_Empleado = p_ID_Empleado
        WHERE Numero_Entrada = p_Numero_Entrada;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_entrada_material_eliminar(IN p_Numero_Entrada int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de ENTRADA_MATERIAL, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM ENTRADA_MATERIAL WHERE Numero_Entrada = p_Numero_Entrada) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en ENTRADA_MATERIAL';
    END IF;

    START TRANSACTION;
        DELETE FROM ENTRADA_MATERIAL WHERE Numero_Entrada = p_Numero_Entrada;
    COMMIT;
END $$
DELIMITER ;

-- ---------- DESPACHO ----------
DROP PROCEDURE IF EXISTS sp_despacho_insertar;
DROP PROCEDURE IF EXISTS sp_despacho_actualizar;
DROP PROCEDURE IF EXISTS sp_despacho_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_despacho_insertar(IN p_Codigo_Rastreo varchar(100), IN p_Fecha_Envio date, IN p_Fecha_Entrega date, IN p_Estado varchar(30), IN p_Numero_Pedido int, IN p_ID_Empleado int, IN p_ID_Transportadora int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en DESPACHO';
    END;

    START TRANSACTION;
        INSERT INTO DESPACHO (Codigo_Rastreo, Fecha_Envio, Fecha_Entrega, Estado, Numero_Pedido, ID_Empleado, ID_Transportadora)
        VALUES (p_Codigo_Rastreo, p_Fecha_Envio, p_Fecha_Entrega, p_Estado, p_Numero_Pedido, p_ID_Empleado, p_ID_Transportadora);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_despacho_actualizar(IN p_ID_Despacho int, IN p_Codigo_Rastreo varchar(100), IN p_Fecha_Envio date, IN p_Fecha_Entrega date, IN p_Estado varchar(30), IN p_Numero_Pedido int, IN p_ID_Empleado int, IN p_ID_Transportadora int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en DESPACHO';
    END;

    IF NOT EXISTS (SELECT 1 FROM DESPACHO WHERE ID_Despacho = p_ID_Despacho) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en DESPACHO';
    END IF;

    START TRANSACTION;
        UPDATE DESPACHO
        SET Codigo_Rastreo = p_Codigo_Rastreo,
            Fecha_Envio = p_Fecha_Envio,
            Fecha_Entrega = p_Fecha_Entrega,
            Estado = p_Estado,
            Numero_Pedido = p_Numero_Pedido,
            ID_Empleado = p_ID_Empleado,
            ID_Transportadora = p_ID_Transportadora
        WHERE ID_Despacho = p_ID_Despacho;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_despacho_eliminar(IN p_ID_Despacho int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de DESPACHO, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM DESPACHO WHERE ID_Despacho = p_ID_Despacho) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en DESPACHO';
    END IF;

    START TRANSACTION;
        DELETE FROM DESPACHO WHERE ID_Despacho = p_ID_Despacho;
    COMMIT;
END $$
DELIMITER ;

-- ---------- ENCUESTA_SATISFACCION ----------
DROP PROCEDURE IF EXISTS sp_encuesta_satisfaccion_insertar;
DROP PROCEDURE IF EXISTS sp_encuesta_satisfaccion_actualizar;
DROP PROCEDURE IF EXISTS sp_encuesta_satisfaccion_eliminar;

DELIMITER $$
CREATE PROCEDURE sp_encuesta_satisfaccion_insertar(IN p_Calif_Resistencia int, IN p_Calif_Acabado int, IN p_Comentario text, IN p_Recomienda tinyint, IN p_Fecha_Respuesta date, IN p_Numero_Pedido int, IN p_Cedula_ID varchar(13), IN p_ID_Empleado int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo insertar en ENCUESTA_SATISFACCION';
    END;

    IF p_Calif_Resistencia < 1 OR p_Calif_Resistencia > 5 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'La calificacion de resistencia va de 1 a 5';
    END IF;

    IF p_Calif_Acabado < 1 OR p_Calif_Acabado > 5 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'La calificacion de acabado va de 1 a 5';
    END IF;

    START TRANSACTION;
        INSERT INTO ENCUESTA_SATISFACCION (Calif_Resistencia, Calif_Acabado, Comentario, Recomienda, Fecha_Respuesta, Numero_Pedido, Cedula_ID, ID_Empleado)
        VALUES (p_Calif_Resistencia, p_Calif_Acabado, p_Comentario, p_Recomienda, p_Fecha_Respuesta, p_Numero_Pedido, p_Cedula_ID, p_ID_Empleado);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_encuesta_satisfaccion_actualizar(IN p_ID_Encuesta int, IN p_Calif_Resistencia int, IN p_Calif_Acabado int, IN p_Comentario text, IN p_Recomienda tinyint, IN p_Fecha_Respuesta date, IN p_Numero_Pedido int, IN p_Cedula_ID varchar(13), IN p_ID_Empleado int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo actualizar en ENCUESTA_SATISFACCION';
    END;

    IF NOT EXISTS (SELECT 1 FROM ENCUESTA_SATISFACCION WHERE ID_Encuesta = p_ID_Encuesta) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en ENCUESTA_SATISFACCION';
    END IF;

    START TRANSACTION;
        UPDATE ENCUESTA_SATISFACCION
        SET Calif_Resistencia = p_Calif_Resistencia,
            Calif_Acabado = p_Calif_Acabado,
            Comentario = p_Comentario,
            Recomienda = p_Recomienda,
            Fecha_Respuesta = p_Fecha_Respuesta,
            Numero_Pedido = p_Numero_Pedido,
            Cedula_ID = p_Cedula_ID,
            ID_Empleado = p_ID_Empleado
        WHERE ID_Encuesta = p_ID_Encuesta;
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_encuesta_satisfaccion_eliminar(IN p_ID_Encuesta int)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No se pudo eliminar de ENCUESTA_SATISFACCION, puede tener registros relacionados';
    END;

    IF NOT EXISTS (SELECT 1 FROM ENCUESTA_SATISFACCION WHERE ID_Encuesta = p_ID_Encuesta) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No existe ese registro en ENCUESTA_SATISFACCION';
    END IF;

    START TRANSACTION;
        DELETE FROM ENCUESTA_SATISFACCION WHERE ID_Encuesta = p_ID_Encuesta;
    COMMIT;
END $$
DELIMITER ;


-- ###################################################################
-- 4) USUARIOS Y PERMISOS
-- ###################################################################

-- Santiago Herrera: hizo la base de datos, entra como administrador.
DROP USER IF EXISTS 'santiago_herrera'@'localhost';
CREATE USER 'santiago_herrera'@'localhost' IDENTIFIED BY 'Santiago_2026';
GRANT ALL PRIVILEGES ON estudio3d.* TO 'santiago_herrera'@'localhost' WITH GRANT OPTION;

-- Santana James: hizo la aplicacion, usa los permisos del programa.
DROP USER IF EXISTS 'james_santana'@'localhost';
CREATE USER 'james_santana'@'localhost' IDENTIFIED BY 'James_2026';
GRANT SELECT, INSERT, UPDATE ON estudio3d.CLIENTE TO 'james_santana'@'localhost';
GRANT SELECT, INSERT ON estudio3d.PEDIDO TO 'james_santana'@'localhost';
GRANT SELECT ON estudio3d.v_reporte_pedidos TO 'james_santana'@'localhost';
GRANT EXECUTE ON PROCEDURE estudio3d.sp_cliente_insertar TO 'james_santana'@'localhost';

-- Mora Eduardo: hizo el modelo y las pruebas, revisa produccion.
DROP USER IF EXISTS 'eduardo_mora'@'localhost';
CREATE USER 'eduardo_mora'@'localhost' IDENTIFIED BY 'Eduardo_2026';
GRANT SELECT, UPDATE ON estudio3d.ORDEN_IMPRESION TO 'eduardo_mora'@'localhost';
GRANT SELECT, INSERT ON estudio3d.CONSUMO_MATERIAL TO 'eduardo_mora'@'localhost';
GRANT SELECT ON estudio3d.v_reporte_produccion TO 'eduardo_mora'@'localhost';
GRANT EXECUTE ON PROCEDURE estudio3d.sp_consumo_material_insertar TO 'eduardo_mora'@'localhost';

DROP USER IF EXISTS 'bodeguero01'@'localhost';
CREATE USER 'bodeguero01'@'localhost' IDENTIFIED BY 'Bode_2026';
GRANT SELECT, UPDATE ON estudio3d.MATERIAL TO 'bodeguero01'@'localhost';
GRANT SELECT, INSERT ON estudio3d.ENTRADA_MATERIAL TO 'bodeguero01'@'localhost';
GRANT SELECT ON estudio3d.v_reporte_consumo TO 'bodeguero01'@'localhost';

DROP USER IF EXISTS 'despachador01'@'localhost';
CREATE USER 'despachador01'@'localhost' IDENTIFIED BY 'Desp_2026';
GRANT SELECT, INSERT, UPDATE ON estudio3d.DESPACHO TO 'despachador01'@'localhost';
GRANT SELECT ON estudio3d.v_reporte_entregas TO 'despachador01'@'localhost';
GRANT EXECUTE ON PROCEDURE estudio3d.sp_despacho_actualizar TO 'despachador01'@'localhost';

DROP USER IF EXISTS 'cliente_consulta'@'localhost';
CREATE USER 'cliente_consulta'@'localhost' IDENTIFIED BY 'Clie_2026';
GRANT SELECT (Codigo_Producto, Nombre, Categoria, Precio) ON estudio3d.PRODUCTO TO 'cliente_consulta'@'localhost';
GRANT SELECT ON estudio3d.v_reporte_entregas TO 'cliente_consulta'@'localhost';

FLUSH PRIVILEGES;



-- ###################################################################
-- 5) INDICES
-- ###################################################################

-- El reporte de pedidos se filtra seguido por el estado.
CREATE INDEX idx_pedido_estado ON PEDIDO(Estado_Actual);

-- El catalogo se consulta y se ordena por categoria.
CREATE INDEX idx_producto_categoria ON PRODUCTO(Categoria);

-- Se busca a los clientes por su nombre.
CREATE INDEX idx_cliente_nombre ON CLIENTE(Nombre);

-- Los reportes de produccion se sacan por rango de fechas.
CREATE INDEX idx_orden_fecha ON ORDEN_IMPRESION(Fecha_Inicio);

-- Se piden las calificaciones de un empleado en un rango de fechas; las dos columnas van en la misma consulta.
CREATE INDEX idx_encuesta_emp_fecha ON ENCUESTA_SATISFACCION(ID_Empleado, Fecha_Respuesta);

-- El reporte de consumo agrupa por material.
CREATE INDEX idx_consumo_material ON CONSUMO_MATERIAL(ID_Material);
