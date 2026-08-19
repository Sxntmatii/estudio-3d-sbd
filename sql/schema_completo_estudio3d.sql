-- ===================================================================
--  PROYECTO: Estudio de Impresion 3D - Accesorios y Setups
--  Sistemas de Bases de Datos - Grupo 1
--  Mora Eduardo, Santana James, Santiago Herrera
--
--  Schema completo: tablas, datos, triggers, reportes,
--  procedimientos, usuarios e indices.
--  Se ejecuta de una sola vez en MySQL Workbench.
-- ===================================================================

DROP DATABASE IF EXISTS estudio3d;


-- ===================================================================
--  1) CREACION DE LA BASE Y LAS TABLAS
-- ===================================================================

create database if not exists estudio3d;
use estudio3d;

create table CLIENTE (
    Cedula_ID varchar(13) primary key,
    Nombre varchar(100) not null,
    Correo varchar(120),
    Telefono varchar(15)
);

-- empleado
create table EMPLEADO (
    ID_Empleado int auto_increment primary key,
    Nombre varchar(100) not null,
    Rol varchar(50) not null,
    Telefono varchar(15)
);

-- proveedor
create table PROVEEDOR (
    ID_Proveedor int auto_increment primary key,
    Nombre varchar(100) not null,
    Telefono varchar(15),
    Correo varchar(120)
);

-- transportadora
create table TRANSPORTADORA (
    ID_Transportadora int auto_increment primary key,
    Nombre varchar(100) not null,
    Telefono varchar(15),
    Sitio_Web varchar(150)
);

-- material
create table MATERIAL (
    ID_Material int auto_increment primary key,
    Tipo varchar(50) not null,
    Color varchar(50) not null,
    Unidad varchar(20) not null,
    Stock_Actual decimal(10,2) not null,
    Costo_Unitario decimal(10,3) not null,
    check (Stock_Actual >= 0)
);

-- producto
create table PRODUCTO (
    Codigo_Producto varchar(20) primary key,
    Nombre varchar(100) not null,
    Precio decimal(10,2) not null,
    Categoria varchar(50) not null,
    Tipo_Garantia varchar(100),
    Stock int not null
);

-- impresora_3d
create table IMPRESORA_3D (
    Codigo_Interno varchar(20) primary key,
    Marca varchar(50) not null,
    Modelo varchar(50) not null,
    Tecnologia varchar(20) not null,
    Numero_Serie varchar(50) not null,
    Fecha_Compra date,
    Estado varchar(30) not null,
    ID_Proveedor int not null,

    constraint fk_impresora_proveedor
        foreign key (ID_Proveedor)
        references PROVEEDOR(ID_Proveedor)
);

-- pedido
create table PEDIDO (
    Numero_Pedido int auto_increment primary key,
    Fecha_Hora datetime not null,
    Tipo varchar(30),
    Estado_Actual varchar(40),
    Fecha_Estim_Entrega date,
    Total decimal(10,2),
    Cedula_ID varchar(13) not null,

    constraint fk_pedido_cliente
        foreign key (Cedula_ID)
        references CLIENTE(Cedula_ID)
);

-- detalle_pedido
create table DETALLE_PEDIDO (
    ID_Detalle int auto_increment primary key,
    Cantidad int not null,
    Precio_Unitario decimal(10,2) not null,
    Subtotal decimal(10,2),
    Numero_Pedido int not null,
    Codigo_Producto varchar(20) not null,

    constraint fk_detalle_pedido
        foreign key (Numero_Pedido)
        references PEDIDO(Numero_Pedido),

    constraint fk_detalle_producto
        foreign key (Codigo_Producto)
        references PRODUCTO(Codigo_Producto)
);

-- factura
create table FACTURA (
    Numero_Factura int auto_increment primary key,
    Fecha_Emision date not null,
    Total decimal(10,2) not null,
    Estado_Pago varchar(20) not null default 'Pendiente',
    Forma_Pago varchar(20),
    Fecha_Pago date,
    Numero_Pedido int not null unique,

    constraint fk_factura_pedido
        foreign key (Numero_Pedido)
        references PEDIDO(Numero_Pedido)
);

-- solicitud_impresion
create table SOLICITUD_IMPRESION (
    ID_Solicitud int auto_increment primary key,
    Descripcion varchar(255),
    Referencias_Visuales text,
    Color varchar(40),
    Escala decimal(5,2),
    Fecha_Solicitud date,
    Numero_Pedido int not null,
    ID_Material int not null,

    foreign key (Numero_Pedido)
        references PEDIDO(Numero_Pedido),

    foreign key (ID_Material)
        references MATERIAL(ID_Material)
);

-- render_preliminar
create table RENDER_PRELIMINAR (
    ID_Render int auto_increment primary key,
    Fecha_Envio date,
    Imagen text,
    Respuesta varchar(20),
    Comentarios text,
    Fecha_Respuesta date,
    Numero_Pedido int not null,
    ID_Empleado int not null,
    Cedula_ID varchar(13) not null,

    foreign key (Numero_Pedido)
        references PEDIDO(Numero_Pedido),

    foreign key (ID_Empleado)
        references EMPLEADO(ID_Empleado),

    foreign key (Cedula_ID)
        references CLIENTE(Cedula_ID)
);

-- orden_impresion
create table ORDEN_IMPRESION (
    ID_Orden int auto_increment primary key,
    Gramos_Proyectados decimal(8,2),
    Tiempo_Estimado decimal(6,2),
    Fecha_Inicio datetime,
    Fecha_Fin datetime,
    Estado varchar(30),
    Numero_Pedido int not null,
    Codigo_Interno varchar(20) not null,
    ID_Empleado int not null,

    foreign key (Numero_Pedido)
        references PEDIDO(Numero_Pedido),

    foreign key (Codigo_Interno)
        references IMPRESORA_3D(Codigo_Interno),

    foreign key (ID_Empleado)
        references EMPLEADO(ID_Empleado)
);

-- consumo_material
create table CONSUMO_MATERIAL (
    ID_Consumo int auto_increment primary key,
    Material_Bueno decimal(8,2),
    Material_Desperdiciado decimal(8,2),
    Fecha date,
    ID_Orden int not null,
    ID_Material int not null,

    foreign key (ID_Orden)
        references ORDEN_IMPRESION(ID_Orden),

    foreign key (ID_Material)
        references MATERIAL(ID_Material)
);

-- fallo_impresion
create table FALLO_IMPRESION (
    ID_Fallo int auto_increment primary key,
    Tipo_Fallo varchar(100),
    Material_Desperdiciado decimal(8,2),
    Tiempo_Perdido decimal(8,2),
    Causa text,
    Fue_Reimpresa boolean,
    Costo_Reproceso decimal(10,2),
    ID_Orden int not null,
    ID_Empleado int not null,

    foreign key (ID_Orden)
        references ORDEN_IMPRESION(ID_Orden),

    foreign key (ID_Empleado)
        references EMPLEADO(ID_Empleado)
);

-- mantenimiento
create table MANTENIMIENTO (
    ID_Mantenimiento int auto_increment primary key,
    Fecha date,
    Tipo varchar(50),
    Descripcion text,
    Codigo_Interno varchar(20) not null,
    ID_Empleado int not null,

    foreign key (Codigo_Interno)
        references IMPRESORA_3D(Codigo_Interno),

    foreign key (ID_Empleado)
        references EMPLEADO(ID_Empleado)
);

-- entrada_material
create table ENTRADA_MATERIAL (
    Numero_Entrada int auto_increment primary key,
    Fecha_Recepcion date,
    Cantidad decimal(10,2),
    Fecha_Vencimiento date,
    Estado_Empaque varchar(40),
    ID_Proveedor int not null,
    ID_Material int not null,
    ID_Empleado int not null,

    foreign key (ID_Proveedor)
        references PROVEEDOR(ID_Proveedor),

    foreign key (ID_Material)
        references MATERIAL(ID_Material),

    foreign key (ID_Empleado)
        references EMPLEADO(ID_Empleado)
);

-- despacho
create table DESPACHO (
    ID_Despacho int auto_increment primary key,
    Codigo_Rastreo varchar(100),
    Fecha_Envio date,
    Fecha_Entrega date,
    Estado varchar(30),
    Numero_Pedido int not null unique,
    ID_Empleado int not null,
    ID_Transportadora int not null,

    foreign key (Numero_Pedido)
        references PEDIDO(Numero_Pedido),

    foreign key (ID_Empleado)
        references EMPLEADO(ID_Empleado),

    foreign key (ID_Transportadora)
        references TRANSPORTADORA(ID_Transportadora)
);

-- encuesta_satisfaccion
create table ENCUESTA_SATISFACCION (
    ID_Encuesta int auto_increment primary key,
    Calif_Resistencia int,
    Calif_Acabado int,
    Comentario text,
    Recomienda boolean,
    Fecha_Respuesta date,
    Numero_Pedido int not null unique,
    Cedula_ID varchar(13) not null,
    ID_Empleado int not null,

    check (Calif_Resistencia between 1 and 5),
    check (Calif_Acabado between 1 and 5),

    foreign key (Numero_Pedido)
        references PEDIDO(Numero_Pedido),

    foreign key (Cedula_ID)
        references CLIENTE(Cedula_ID),

    foreign key (ID_Empleado)
        references EMPLEADO(ID_Empleado)
);


-- ===================================================================
--  2) DATOS (10 registros por tabla)
-- ===================================================================

use estudio3d;

-- cliente (10)
insert into CLIENTE (Cedula_ID, Nombre, Correo, Telefono) values
('0950000000001', 'Carlos Vera', 'cvera@mail.com', '0991110001'),
('0950000000002', 'Andrea Salas', 'asalas@mail.com', '0991110002'),
('0950000000003', 'Jorge Lema', 'jlema@mail.com', '0991110003'),
('0950000000004', 'Lucia Paz', 'lpaz@mail.com', '0991110004'),
('0950000000005', 'Maria Rios', 'mrios@mail.com', '0991110005'),
('0950000000006', 'Diego Luna', 'dluna@mail.com', '0991110006'),
('0950000000007', 'Paola Nunez', 'pnunez@mail.com', '0991110007'),
('0950000000008', 'Sofia Mena', 'smena@mail.com', '0991110008'),
('0950000000009', 'Kevin Ortiz', 'kortiz@mail.com', '0991110009'),
('0950000000010', 'Valeria Cede', 'vcede@mail.com', '0991110010');

-- empleado (10)
insert into EMPLEADO (ID_Empleado, Nombre, Rol, Telefono) values
(1, 'Maria Garcia', 'Vendedor', '0981000001'),
(2, 'Juan Soto', 'Operador', '0981000002'),
(3, 'Ana Perez', 'Diseñador', '0981000003'),
(4, 'Luis Mejia', 'Bodega', '0981000004'),
(5, 'Paola Ruiz', 'Operador', '0981000005'),
(6, 'Diego Cobo', 'Mantenimiento', '0981000006'),
(7, 'Sofia Zamora', 'Vendedor', '0981000007'),
(8, 'Kevin Bravo', 'Operador', '0981000008'),
(9, 'Lucia Alarcon', 'Despacho', '0981000009'),
(10, 'Rene Torres', 'Calidad', '0981000010');

-- proveedor (10)
insert into PROVEEDOR (ID_Proveedor, Nombre, Telefono, Correo) values
(1, 'Filamentos Andinos', '022200001', 'ventas@filandinos.com'),
(2, 'Resin Pro EC', '022200002', 'contacto@resinpro.ec'),
(3, 'PrintSupply', '022200003', 'info@printsupply.com'),
(4, 'Tech3D Parts', '022200004', 'sales@tech3dparts.com'),
(5, 'Maq Center', '022200005', 'maq@center.com'),
(6, 'Global Additive', '022200006', 'hola@globaladd.com'),
(7, 'Nova Print', '022200007', 'ventas@novaprint.com'),
(8, 'RoboMakers', '022200008', 'info@robomakers.com'),
(9, 'SLA House', '022200009', 'ventas@slahouse.com'),
(10, 'FDM Planet', '022200010', 'contacto@fdmplanet.com');

-- transportadora (10)
insert into TRANSPORTADORA (ID_Transportadora, Nombre, Telefono, Sitio_Web) values
(1, 'Servientrega', '1800000001', 'https://www.servientrega.com'),
(2, 'Tramaco', '1800000002', 'https://www.tramaco.com'),
(3, 'Laarcourier', '1800000003', 'https://www.laarcourier.com'),
(4, 'RapidExpress', '1800000004', 'https://www.rapidexpress.ec'),
(5, 'CargoPlus', '1800000005', 'https://www.cargoplus.ec'),
(6, 'EnviaYa', '1800000006', 'https://www.enviaya.ec'),
(7, 'PackAndGo', '1800000007', 'https://www.packandgo.ec'),
(8, 'UrbanoShip', '1800000008', 'https://www.urbanoship.ec'),
(9, 'RastroFast', '1800000009', 'https://www.rastrofast.ec'),
(10, 'AndesCourier', '1800000010', 'https://www.andescourier.ec');

-- material (10)
insert into MATERIAL (ID_Material, Tipo, Color, Unidad, Stock_Actual, Costo_Unitario) values
(1, 'PLA', 'Rojo', 'g', 5000.00, 0.022),
(2, 'PLA', 'Blanco', 'g', 4200.00, 0.022),
(3, 'PETG', 'Negro', 'g', 3100.00, 0.026),
(4, 'ABS', 'Gris', 'g', 2800.00, 0.029),
(5, 'Resina', 'Gris', 'ml', 6000.00, 0.075),
(6, 'Resina', 'Transparente', 'ml', 3500.00, 0.082),
(7, 'TPU', 'Negro', 'g', 1500.00, 0.031),
(8, 'Nylon', 'Natural', 'g', 1200.00, 0.038),
(9, 'PLA', 'Azul', 'g', 2600.00, 0.022),
(10, 'PETG', 'Blanco', 'g', 2200.00, 0.027);

-- producto (10)
insert into PRODUCTO (Codigo_Producto, Nombre, Precio, Categoria, Tipo_Garantia, Stock) values
('FIL-PLA-R', 'Filamento PLA Rojo 1kg', 22.50, 'Filamento', '30 dias', 14),
('FIL-PLA-B', 'Filamento PLA Blanco 1kg', 22.50, 'Filamento', '30 dias', 8),
('FIL-PET-N', 'Filamento PETG Negro 1kg', 26.00, 'Filamento', '30 dias', 0),
('FIL-ABS-G', 'Filamento ABS Gris 1kg', 29.00, 'Filamento', '30 dias', 6),
('RES-GRY-1', 'Resina Gris 1L', 75.00, 'Resina', '15 dias', 7),
('RES-TRN-1', 'Resina Transparente 1L', 82.00, 'Resina', '15 dias', 5),
('ACC-BOQ-04', 'Boquilla 0.4mm', 6.50, 'Accesorio', '90 dias', 20),
('ACC-CAM-PT', 'Cama PEI Texturizada', 35.00, 'Accesorio', '90 dias', 9),
('ACC-NOZ-06', 'Boquilla 0.6mm', 7.20, 'Accesorio', '90 dias', 16),
('ACC-PTFE-2', 'Tubo PTFE 2m', 8.90, 'Accesorio', '90 dias', 12);

-- impresora_3d (10)
insert into IMPRESORA_3D (Codigo_Interno, Marca, Modelo, Tecnologia, Numero_Serie, Fecha_Compra, Estado, ID_Proveedor) values
('IMP-FDM-01', 'Creality', 'Ender 3 S1', 'FDM', 'SN-FDM-0001', '2024-01-15', 'Activa', 1),
('IMP-FDM-02', 'Prusa', 'MK4', 'FDM', 'SN-FDM-0002', '2024-02-01', 'Activa', 2),
('IMP-FDM-03', 'Bambu', 'P1S', 'FDM', 'SN-FDM-0003', '2024-03-10', 'Activa', 3),
('IMP-SLA-01', 'Anycubic', 'Photon M3', 'SLA', 'SN-SLA-0001', '2024-01-28', 'Activa', 4),
('IMP-SLA-02', 'Elegoo', 'Mars 4', 'SLA', 'SN-SLA-0002', '2024-04-19', 'Mantenimiento', 5),
('IMP-FDM-04', 'Creality', 'K1', 'FDM', 'SN-FDM-0004', '2024-05-02', 'Activa', 6),
('IMP-FDM-05', 'Artillery', 'X2', 'FDM', 'SN-FDM-0005', '2024-06-15', 'Activa', 7),
('IMP-SLA-03', 'Phrozen', 'Sonic Mini', 'SLA', 'SN-SLA-0003', '2024-07-22', 'Activa', 8),
('IMP-FDM-06', 'Qidi', 'X-Plus', 'FDM', 'SN-FDM-0006', '2024-08-11', 'Activa', 9),
('IMP-FDM-07', 'Raise3D', 'E2', 'FDM', 'SN-FDM-0007', '2024-09-03', 'Activa', 10);

-- pedido (10)
insert into PEDIDO (Numero_Pedido, Fecha_Hora, Tipo, Estado_Actual, Fecha_Estim_Entrega, Total, Cedula_ID) values
(1, '2026-06-01 09:15:00', 'Personalizado', 'Pendiente', '2026-06-08', 45.00, '0950000000001'),
(2, '2026-06-02 10:20:00', 'Catalogo', 'En impresion', '2026-06-09', 52.00, '0950000000002'),
(3, '2026-06-03 11:25:00', 'Personalizado', 'Post-procesado', '2026-06-10', 75.00, '0950000000003'),
(4, '2026-06-04 12:10:00', 'Catalogo', 'Enviado', '2026-06-11', 120.00, '0950000000004'),
(5, '2026-06-05 13:05:00', 'Catalogo', 'Entregado', '2026-06-12', 89.00, '0950000000005'),
(6, '2026-06-06 14:40:00', 'Personalizado', 'Pendiente', '2026-06-13', 38.00, '0950000000006'),
(7, '2026-06-07 15:00:00', 'Catalogo', 'En impresion', '2026-06-14', 64.00, '0950000000007'),
(8, '2026-06-08 16:30:00', 'Personalizado', 'Post-procesado', '2026-06-15', 98.00, '0950000000008'),
(9, '2026-06-09 17:45:00', 'Catalogo', 'Enviado', '2026-06-16', 33.00, '0950000000009'),
(10, '2026-06-10 18:55:00', 'Personalizado', 'Entregado', '2026-06-17', 150.00, '0950000000010');

-- detalle_pedido (10)
insert into DETALLE_PEDIDO (ID_Detalle, Cantidad, Precio_Unitario, Subtotal, Numero_Pedido, Codigo_Producto) values
(1, 2, 22.50, 45.00, 1, 'FIL-PLA-R'),
(2, 2, 26.00, 52.00, 2, 'FIL-PET-N'),
(3, 1, 75.00, 75.00, 3, 'RES-GRY-1'),
(4, 4, 30.00, 120.00, 4, 'ACC-CAM-PT'),
(5, 1, 89.00, 89.00, 5, 'RES-TRN-1'),
(6, 4, 9.50, 38.00, 6, 'ACC-PTFE-2'),
(7, 8, 8.00, 64.00, 7, 'ACC-NOZ-06'),
(8, 14, 7.00, 98.00, 8, 'ACC-BOQ-04'),
(9, 1, 33.00, 33.00, 9, 'FIL-ABS-G'),
(10, 2, 75.00, 150.00, 10, 'RES-GRY-1');

-- factura (10)
insert into FACTURA (Numero_Factura, Fecha_Emision, Total, Estado_Pago, Forma_Pago, Fecha_Pago, Numero_Pedido) values
(1, '2026-06-01', 45.00, 'Pagado', 'Tarjeta', '2026-06-01', 1),
(2, '2026-06-02', 52.00, 'Pendiente', null, null, 2),
(3, '2026-06-03', 75.00, 'Pagado', 'Transferencia', '2026-06-03', 3),
(4, '2026-06-04', 120.00, 'Pagado', 'Tarjeta', '2026-06-07', 4),
(5, '2026-06-05', 89.00, 'Pendiente', null, null, 5),
(6, '2026-06-06', 38.00, 'Pagado', 'Efectivo', '2026-06-06', 6),
(7, '2026-06-07', 64.00, 'Pendiente', null, null, 7),
(8, '2026-06-08', 98.00, 'Pagado', 'Transferencia', '2026-06-09', 8),
(9, '2026-06-09', 33.00, 'Pagado', 'Tarjeta', '2026-06-10', 9),
(10, '2026-06-10', 150.00, 'Pendiente', null, null, 10);

-- solicitud_impresion (10)
insert into SOLICITUD_IMPRESION (ID_Solicitud, Descripcion, Referencias_Visuales, Color, Escala, Fecha_Solicitud, Numero_Pedido, ID_Material) values
(1, 'Llaveros corporativos', 'ref_llavero_01.png', 'Rojo', 1.00, '2026-06-01', 1, 1),
(2, 'Prototipo carcasa', 'ref_carcasa_02.png', 'Negro', 1.20, '2026-06-02', 2, 3),
(3, 'Figura coleccionable', 'ref_figura_03.png', 'Gris', 0.80, '2026-06-03', 3, 5),
(4, 'Soporte de camara', 'ref_soporte_04.png', 'Blanco', 1.00, '2026-06-04', 4, 2),
(5, 'Logo de escritorio', 'ref_logo_05.png', 'Transparente', 0.90, '2026-06-05', 5, 6),
(6, 'Pieza mecanica', 'ref_pieza_06.png', 'Gris', 1.50, '2026-06-06', 6, 4),
(7, 'Base para sensor', 'ref_base_07.png', 'Azul', 1.00, '2026-06-07', 7, 9),
(8, 'Miniatura arquitectonica', 'ref_mini_08.png', 'Natural', 0.70, '2026-06-08', 8, 8),
(9, 'Clip industrial', 'ref_clip_09.png', 'Negro', 1.10, '2026-06-09', 9, 7),
(10, 'Carcasa drone', 'ref_drone_10.png', 'Blanco', 1.30, '2026-06-10', 10, 10);

-- render_preliminar (10)
insert into RENDER_PRELIMINAR (ID_Render, Fecha_Envio, Imagen, Respuesta, Comentarios, Fecha_Respuesta, Numero_Pedido, ID_Empleado, Cedula_ID) values
(1, '2026-06-01', 'render_01.png', 'Aprobado', 'Todo correcto', '2026-06-01', 1, 3, '0950000000001'),
(2, '2026-06-02', 'render_02.png', 'Aprobado', 'Ajustar borde', '2026-06-02', 2, 3, '0950000000002'),
(3, '2026-06-03', 'render_03.png', 'Aprobado', 'Sin cambios', '2026-06-03', 3, 10, '0950000000003'),
(4, '2026-06-04', 'render_04.png', 'Rechazado', 'Cambiar color', '2026-06-04', 4, 10, '0950000000004'),
(5, '2026-06-05', 'render_05.png', 'Aprobado', 'Perfecto', '2026-06-05', 5, 3, '0950000000005'),
(6, '2026-06-06', 'render_06.png', 'Aprobado', 'Reducir escala', '2026-06-06', 6, 10, '0950000000006'),
(7, '2026-06-07', 'render_07.png', 'Aprobado', 'Ok', '2026-06-07', 7, 3, '0950000000007'),
(8, '2026-06-08', 'render_08.png', 'Aprobado', 'Sin observacion', '2026-06-08', 8, 10, '0950000000008'),
(9, '2026-06-09', 'render_09.png', 'Aprobado', 'Listo para producir', '2026-06-09', 9, 3, '0950000000009'),
(10, '2026-06-10', 'render_10.png', 'Aprobado', 'Continuar', '2026-06-10', 10, 10, '0950000000010');

-- orden_impresion (10)
insert into ORDEN_IMPRESION (ID_Orden, Gramos_Proyectados, Tiempo_Estimado, Fecha_Inicio, Fecha_Fin, Estado, Numero_Pedido, Codigo_Interno, ID_Empleado) values
(1, 120.00, 3.50, '2026-06-01 10:00:00', '2026-06-01 13:30:00', 'Finalizada', 1, 'IMP-FDM-01', 2),
(2, 210.00, 5.00, '2026-06-02 11:00:00', '2026-06-02 16:00:00', 'Finalizada', 2, 'IMP-FDM-02', 5),
(3, 95.00, 4.20, '2026-06-03 09:00:00', '2026-06-03 13:12:00', 'Finalizada', 3, 'IMP-SLA-01', 8),
(4, 300.00, 7.00, '2026-06-04 08:30:00', '2026-06-04 15:30:00', 'Finalizada', 4, 'IMP-FDM-03', 2),
(5, 145.00, 4.80, '2026-06-05 10:20:00', '2026-06-05 15:08:00', 'Finalizada', 5, 'IMP-SLA-03', 8),
(6, 80.00, 2.90, '2026-06-06 12:00:00', '2026-06-06 14:54:00', 'Finalizada', 6, 'IMP-FDM-04', 5),
(7, 160.00, 5.60, '2026-06-07 09:40:00', '2026-06-07 15:16:00', 'En proceso', 7, 'IMP-FDM-05', 2),
(8, 260.00, 6.40, '2026-06-08 11:20:00', '2026-06-08 17:44:00', 'En proceso', 8, 'IMP-FDM-06', 5),
(9, 70.00, 2.30, '2026-06-09 13:15:00', '2026-06-09 15:33:00', 'Finalizada', 9, 'IMP-FDM-07', 8),
(10, 330.00, 8.10, '2026-06-10 07:50:00', '2026-06-10 15:56:00', 'En proceso', 10, 'IMP-FDM-02', 2);

-- consumo_material (10)
insert into CONSUMO_MATERIAL (ID_Consumo, Material_Bueno, Material_Desperdiciado, Fecha, ID_Orden, ID_Material) values
(1, 115.00, 5.00, '2026-06-01', 1, 1),
(2, 200.00, 10.00, '2026-06-02', 2, 3),
(3, 90.00, 5.00, '2026-06-03', 3, 5),
(4, 286.00, 14.00, '2026-06-04', 4, 2),
(5, 138.00, 7.00, '2026-06-05', 5, 6),
(6, 76.00, 4.00, '2026-06-06', 6, 4),
(7, 151.00, 9.00, '2026-06-07', 7, 9),
(8, 247.00, 13.00, '2026-06-08', 8, 8),
(9, 66.00, 4.00, '2026-06-09', 9, 7),
(10, 315.00, 15.00, '2026-06-10', 10, 10);

-- fallo_impresion (10)
insert into FALLO_IMPRESION (ID_Fallo, Tipo_Fallo, Material_Desperdiciado, Tiempo_Perdido, Causa, Fue_Reimpresa, Costo_Reproceso, ID_Orden, ID_Empleado) values
(1, 'Warping', 3.00, 0.80, 'Cama fria', 1, 2.10, 1, 2),
(2, 'Adherencia', 4.00, 1.10, 'Nivelacion irregular', 1, 3.00, 2, 5),
(3, 'Laminado', 2.50, 0.70, 'Exceso de exposicion', 0, 1.90, 3, 8),
(4, 'Stringing', 1.80, 0.50, 'Temperatura alta', 1, 1.20, 4, 2),
(5, 'Soportes', 2.20, 0.60, 'Soporte insuficiente', 1, 1.70, 5, 8),
(6, 'Desplazamiento', 3.40, 0.90, 'Correa floja', 1, 2.40, 6, 5),
(7, 'Subextrusion', 2.00, 0.70, 'Boquilla obstruida', 1, 1.50, 7, 2),
(8, 'Huecos', 2.70, 0.80, 'Flujo bajo', 0, 1.80, 8, 5),
(9, 'Despegue', 1.60, 0.40, 'Superficie sucia', 1, 1.10, 9, 8),
(10, 'Sobrecalentamiento', 3.10, 1.00, 'Ventilacion deficiente', 0, 2.20, 10, 2);

-- mantenimiento (10)
insert into MANTENIMIENTO (ID_Mantenimiento, Fecha, Tipo, Descripcion, Codigo_Interno, ID_Empleado) values
(1, '2026-05-20', 'Preventivo', 'Limpieza general y ajuste ejes', 'IMP-FDM-01', 6),
(2, '2026-05-21', 'Correctivo', 'Cambio de boquilla', 'IMP-FDM-02', 6),
(3, '2026-05-22', 'Preventivo', 'Calibracion de cama', 'IMP-FDM-03', 6),
(4, '2026-05-23', 'Preventivo', 'Cambio de FEP', 'IMP-SLA-01', 6),
(5, '2026-05-24', 'Correctivo', 'Cambio de pantalla LCD', 'IMP-SLA-02', 6),
(6, '2026-05-25', 'Preventivo', 'Lubricacion de guias', 'IMP-FDM-04', 6),
(7, '2026-05-26', 'Preventivo', 'Ajuste de extrusor', 'IMP-FDM-05', 6),
(8, '2026-05-27', 'Correctivo', 'Cambio de ventilador', 'IMP-SLA-03', 6),
(9, '2026-05-28', 'Preventivo', 'Tension de correas', 'IMP-FDM-06', 6),
(10, '2026-05-29', 'Preventivo', 'Revision electrica', 'IMP-FDM-07', 6);

-- entrada_material (10)
insert into ENTRADA_MATERIAL (Numero_Entrada, Fecha_Recepcion, Cantidad, Fecha_Vencimiento, Estado_Empaque, ID_Proveedor, ID_Material, ID_Empleado) values
(1, '2026-05-01', 1000.00, '2028-05-01', 'Sellado', 1, 1, 4),
(2, '2026-05-02', 1000.00, '2028-05-02', 'Sellado', 2, 2, 4),
(3, '2026-05-03', 800.00, '2028-05-03', 'Sellado', 3, 3, 4),
(4, '2026-05-04', 700.00, '2028-05-04', 'Sellado', 4, 4, 4),
(5, '2026-05-05', 1200.00, '2027-05-05', 'Integro', 5, 5, 4),
(6, '2026-05-06', 900.00, '2027-05-06', 'Integro', 6, 6, 4),
(7, '2026-05-07', 600.00, '2028-05-07', 'Sellado', 7, 7, 4),
(8, '2026-05-08', 500.00, '2028-05-08', 'Sellado', 8, 8, 4),
(9, '2026-05-09', 700.00, '2028-05-09', 'Integro', 9, 9, 4),
(10, '2026-05-10', 650.00, '2028-05-10', 'Integro', 10, 10, 4);

-- despacho (10)
insert into DESPACHO (ID_Despacho, Codigo_Rastreo, Fecha_Envio, Fecha_Entrega, Estado, Numero_Pedido, ID_Empleado, ID_Transportadora) values
(1, 'TRK-0001', '2026-06-02', '2026-06-03', 'Entregado', 1, 9, 1),
(2, 'TRK-0002', '2026-06-03', null, 'En ruta', 2, 9, 2),
(3, 'TRK-0003', '2026-06-04', '2026-06-05', 'Entregado', 3, 9, 3),
(4, 'TRK-0004', '2026-06-05', '2026-06-06', 'Entregado', 4, 9, 4),
(5, 'TRK-0005', '2026-06-06', null, 'En ruta', 5, 9, 5),
(6, 'TRK-0006', '2026-06-07', '2026-06-08', 'Entregado', 6, 9, 6),
(7, 'TRK-0007', '2026-06-08', null, 'En ruta', 7, 9, 7),
(8, 'TRK-0008', '2026-06-09', null, 'En ruta', 8, 9, 8),
(9, 'TRK-0009', '2026-06-10', '2026-06-11', 'Entregado', 9, 9, 9),
(10, 'TRK-0010', '2026-06-11', null, 'Preparado', 10, 9, 10);

-- encuesta_satisfaccion (10)
insert into ENCUESTA_SATISFACCION (ID_Encuesta, Calif_Resistencia, Calif_Acabado, Comentario, Recomienda, Fecha_Respuesta, Numero_Pedido, Cedula_ID, ID_Empleado) values
(1, 5, 4, 'Muy buen trabajo', 1, '2026-06-05', 1, '0950000000001', 2),
(2, 4, 4, 'Cumple lo esperado', 1, '2026-06-06', 2, '0950000000002', 5),
(3, 5, 5, 'Excelente acabado', 1, '2026-06-07', 3, '0950000000003', 8),
(4, 3, 4, 'Buena atencion', 1, '2026-06-08', 4, '0950000000004', 2),
(5, 4, 3, 'Tiempo de entrega aceptable', 1, '2026-06-09', 5, '0950000000005', 5),
(6, 5, 4, 'Recomendado', 1, '2026-06-10', 6, '0950000000006', 8),
(7, 4, 5, 'Muy conforme', 1, '2026-06-11', 7, '0950000000007', 2),
(8, 3, 3, 'Puede mejorar', 0, '2026-06-12', 8, '0950000000008', 5),
(9, 5, 4, 'Buen soporte', 1, '2026-06-13', 9, '0950000000009', 8),
(10, 4, 5, 'Trabajo prolijo', 1, '2026-06-14', 10, '0950000000010', 2);


-- ===================================================================
--  3) TRIGGERS, REPORTES, PROCEDIMIENTOS, USUARIOS E INDICES
-- ===================================================================

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

