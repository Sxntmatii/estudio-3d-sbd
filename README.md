# Estudio de Impresión 3D — Accesorios y Setups

Este es nuestro proyecto de la materia **Sistemas de Bases de Datos** de la ESPOL.

Se trata de un estudio que imprime piezas en 3D y también vende filamentos,
resinas y accesorios. Hicimos la base de datos para llevar todo eso: los
clientes, los pedidos, las impresiones, el material que se usa y los envíos.
La base la hicimos en MySQL y el programa que la maneja está en Python.

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

En MySQL Workbench se abre este archivo y se ejecuta:

```
sql/schema_completo_estudio3d.sql
```

Ese solo ya trae todo: las 19 tablas, los 10 registros de cada una, los triggers,
los reportes, los procedimientos, los índices y los usuarios. Ojo que empieza
borrando la base `estudio3d` si ya existe, así que queda limpia.

Los archivos `sql/avance-proyecto-sbd.sql` y `sql/avance-proyecto-sbd-inserts.sql`
son los del avance pasado (solo tablas y datos) y `sql/objetos_estudio3d.sql` es
la parte nueva por separado. Los dejamos por si hay que ver algo suelto, pero para
que la aplicación funcione hay que correr el completo.

**2. Instalar el conector de MySQL para Python**

Esto se hace una sola vez:

```
pip install mysql-connector-python
```

**3. Poner la contraseña de MySQL**

En `app/crud_estudio3d.py`, arriba de todo, está la conexión. Ahí cada quien
pone su propia clave:

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

Sale un menú con las 19 tablas, separadas por módulo. Uno escribe el número de
la tabla que quiere y ahí aparecen las cuatro operaciones:

```
1) Anadir     2) Consultar     3) Editar     4) Eliminar
```

También pusimos la opción 20, que son consultas que juntan varias tablas. Por
ejemplo se puede ver el total de un pedido con su forma de pago, o quién fue el
que envió un pedido. Y en la opción 21 están los cuatro reportes.

El programa valida lo que uno escribe. Si se intenta guardar una clave que ya
existe, o borrar un cliente que tiene pedidos, avisa con un mensaje y no se cae.
Para añadir, editar y eliminar no manda SQL directo: llama a los procedimientos
de la base, que son los que validan y manejan la transacción.

## Lo que tiene la base

| Objeto | Cuántos | Para qué |
|---|---|---|
| Tablas | 19 | Con 190 registros de prueba, 10 por tabla |
| Triggers | 3 | Calculan el subtotal solo y descuentan el material del inventario |
| Reportes (vistas) | 4 | Juntan de 4 a 5 tablas y muestran nombres en vez de códigos |
| Procedimientos | 57 | Insertar, actualizar y eliminar en cada tabla, con transacción y validaciones |
| Índices | 6 | En las columnas por las que más se busca |
| Usuarios | 6 | Cada uno con permisos según su rol |

## Usuarios de la base

A los tres primeros les pusimos nuestros nombres, que son los que usamos
nosotros para entrar. Los otros tres son los roles que ya teníamos en el modelo.

| Usuario | Clave | Qué puede hacer |
|---|---|---|
| `santiago_herrera` | `Santiago_2026` | Todo sobre la base (es el administrador) |
| `james_santana` | `James_2026` | CLIENTE y PEDIDO, la vista de pedidos y un procedimiento |
| `eduardo_mora` | `Eduardo_2026` | ORDEN_IMPRESION y CONSUMO_MATERIAL, la vista de producción y un procedimiento |
| `bodeguero01` | `Bode_2026` | MATERIAL y ENTRADA_MATERIAL, y la vista de consumo |
| `despachador01` | `Desp_2026` | DESPACHO, la vista de entregas y un procedimiento |
| `cliente_consulta` | `Clie_2026` | Solo cuatro columnas de PRODUCTO y la vista de entregas |

Para ver los permisos de cualquiera:

```sql
SHOW GRANTS FOR 'james_santana'@'localhost';
```

## Para probar que todo funciona

En `sql/pruebas_estudio3d.sql` dejamos las sentencias listas para copiar y pegar
en Workbench. Están separadas por partes: los triggers, los cuatro reportes, los
procedimientos con sus validaciones, la prueba del ROLLBACK, los `EXPLAIN` de los
índices y los `SHOW GRANTS` de los usuarios. Al final hay una parte que borra lo
que insertaron las pruebas, así la base queda como estaba.

## Tablas que salen de una relación de muchos a muchos

| Tabla | Resuelve el muchos a muchos entre |
|---|---|
| `DETALLE_PEDIDO` | Pedido y Producto |
| `CONSUMO_MATERIAL` | Orden de impresión y Material |
| `ENTRADA_MATERIAL` | Proveedor y Material |
| `MANTENIMIENTO` | Impresora y Empleado |

## Reparto del trabajo

El proyecto lo hicimos entre los tres. Así nos repartimos las partes:

| Integrante | GitHub | Lo que hizo |
|---|---|---|
| **Santiago Herrera** | [@santherr1espol](https://github.com/santherr1espol) | La base de datos en MySQL: el script de creación, las tablas, las llaves, las restricciones y los datos de prueba |
| **Santana James** | [@Sxntmatii](https://github.com/Sxntmatii) | La aplicación en Python: el CRUD de las 19 tablas, las consultas y los procedimientos almacenados |
| **Mora Eduardo** | [@Robimora](https://github.com/Robimora) | El modelo entidad-relación, el manual de usuario y las pruebas de la aplicación |

En la pestaña de *Commits* se pueden ver los aportes de cada uno.

## Otros archivos

En `app/app_estudio3d.py` está la aplicación del avance pasado, la que solo
mostraba dos pantallas de consulta. La dejamos por si acaso.
