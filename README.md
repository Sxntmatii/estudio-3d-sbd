# Estudio de Impresión 3D — Accesorios y Setups

Proyecto de la materia **Sistemas de Bases de Datos** (ESPOL).

Sistema para manejar los datos de un estudio de impresión 3D: clientes, pedidos,
producción, inventario y entregas. La base está en MySQL y la aplicación está
hecha en Python.

## Grupo 1

- Mora Eduardo
- Santana James
- Santiago Herrera

## Contenido del repositorio

| Carpeta | Qué hay |
|---|---|
| `sql/` | Script de creación de la base de datos y los datos de prueba |
| `app/` | Código fuente de la aplicación en Python |
| `docs/` | Manual de usuario y documento del modelo entidad-relación |

## Cómo ponerlo a funcionar

**1. Crear la base de datos**

En MySQL Workbench, abrir y ejecutar en este orden:

```
sql/avance-proyecto-sbd.sql
sql/avance-proyecto-sbd-inserts.sql
```

Queda creada la base `estudio3d` con 19 tablas y 190 registros (10 por tabla).

**2. Instalar el conector de MySQL para Python** (una sola vez)

```
pip install mysql-connector-python
```

**3. Poner la contraseña de MySQL**

Dentro de `app/crud_estudio3d.py`, en las primeras líneas, cambiar la clave por
la de cada quien:

```python
conexion = mysql.connector.connect(
    host="localhost",
    user="root",
    password="1234",
    database="estudio3d"
)
```

**4. Ejecutar la aplicación**

```
python app/crud_estudio3d.py
```

## Qué hace la aplicación

Un menú con las 19 tablas agrupadas por módulo. Al entrar en cualquiera aparecen
las cuatro operaciones:

```
1) Anadir     2) Consultar     3) Editar     4) Eliminar
```

La opción 20 abre las consultas que cruzan varias tablas (productos por
categoría, pedidos personalizados, quién envió un pedido, el pago de un pedido y
las calificaciones de un empleado entre dos fechas).

## Tablas que salen de una relación de muchos a muchos

| Tabla | Resuelve el muchos a muchos entre |
|---|---|
| `DETALLE_PEDIDO` | Pedido y Producto |
| `CONSUMO_MATERIAL` | Orden de impresión y Material |
| `ENTRADA_MATERIAL` | Proveedor y Material |
| `MANTENIMIENTO` | Impresora y Empleado |

## Reparto del trabajo

| Integrante | Módulo | Tablas |
|---|---|---|
| Mora Eduardo | Comercial | Cliente, Producto, Pedido, Detalle de pedido, Factura |
| Santana James | Producción y calidad | Empleado, Impresora, Material, Orden de impresión, Consumo de material, Fallos, Mantenimiento |
| Santiago Herrera | Inventario y entrega | Proveedor, Entrada de material, Transportadora, Despacho, Encuesta, Solicitud, Render |

## Otros archivos

`app/app_estudio3d.py` es la aplicación del avance anterior, que solo muestra
dos pantallas de consulta. Se deja como referencia.
