-- Encargado del SQL: Santiago Herrera

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
