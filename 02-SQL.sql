
-- ===== A. SELECT =====
-- Ejemplo 1: Selecciona únicamente la columna 'nombre' de la tabla 'usuarios'.
-- Esto sirve para obtener una lista de nombres sin traer otros datos.
SELECT nombre FROM usuarios;

-- Ejemplo 2: Muestra todos los productos cuyo precio sea mayor a 100.
-- Es útil para filtrar artículos considerados costosos.
SELECT * FROM articulos WHERE precio > 100;

-- Ejemplo 3: Ordena los estudiantes por su nombre en orden alfabético.
-- Así se obtiene una lista organizada de manera más legible.
SELECT id, nombre FROM alumnos ORDER BY nombre;


-- ===== B. INSERT =====
-- Ejemplo 1: Inserta un nuevo usuario con nombre y edad.
-- Permite agregar registros individuales a la tabla.
INSERT INTO usuarios(nombre, edad) VALUES ('Carlos', 25);

-- Ejemplo 2: Inserta un producto con todos sus campos completos.
-- Se usa cuando conocemos todos los valores de la fila.
INSERT INTO articulos VALUES (1,'Zapatos',120.0);

-- Ejemplo 3: Inserta varias ventas en una sola instrucción.
-- Es más eficiente que múltiples sentencias individuales.
INSERT INTO ventas VALUES (201,1,4),(202,2,1);


-- ===== C. UPDATE =====
-- Ejemplo 1: Incrementa el precio de todos los artículos en un 5%.
-- Útil para aplicar ajustes generales de precios.
UPDATE articulos SET precio = precio*1.05;

-- Ejemplo 2: Marca como 'inactivo' a usuarios mayores de 70 años.
-- Sirve para gestionar estados según condiciones.
UPDATE usuarios SET estado='inactivo' WHERE edad>70;

-- Ejemplo 3: Cambia la cantidad de una venta específica.
-- Permite corregir errores en registros existentes.
UPDATE ventas SET cantidad=10 WHERE id=202;


-- ===== D. DELETE =====
-- Ejemplo 1: Elimina una venta puntual según su id.
DELETE FROM ventas WHERE id=201;

-- Ejemplo 2: Borra productos con precio inferior a 5.
-- Se usa para limpiar artículos irrelevantes o de prueba.
DELETE FROM articulos WHERE precio < 5;

-- Ejemplo 3: Vacía por completo la tabla 'temporal'.
-- TRUNCATE elimina todos los registros de manera rápida.
TRUNCATE TABLE temporal;


-- ===== E. CREATE TABLE =====
-- Ejemplo 1: Crea la tabla 'alumnos' con id, nombre y edad.
CREATE TABLE alumnos(
 id INT PRIMARY KEY,
 nombre VARCHAR(50),
 edad INT
);

-- Ejemplo 2: Crea la tabla 'articulos' con id, nombre y precio.
CREATE TABLE articulos(
 id INT PRIMARY KEY,
 nombre VARCHAR(50),
 precio DECIMAL(10,2)
);

-- Ejemplo 3: Crea la tabla 'ventas' con id, producto y cantidad.
CREATE TABLE ventas(
 id INT PRIMARY KEY,
 id_articulo INT,
 cantidad INT
);


-- ===== F. JOINS =====
-- Ejemplo 1: Une usuarios con ventas para mostrar nombre y cantidad comprada.
SELECT u.nombre, v.cantidad
 FROM usuarios u
 JOIN ventas v ON u.id = v.id_usuario;

-- Ejemplo 2: Lista todos los artículos aunque no tengan ventas registradas.
SELECT a.nombre, v.cantidad
 FROM articulos a
 LEFT JOIN ventas v ON a.id = v.id_articulo;

-- Ejemplo 3: RIGHT JOIN para mostrar todos los artículos y sus ventas si existen.
SELECT *
 FROM ventas v
 RIGHT JOIN articulos a ON v.id_articulo = a.id;


-- ===== G. Subconsultas =====
-- Ejemplo 1: Obtiene nombres de usuarios que tienen ventas asociadas.
SELECT nombre FROM usuarios WHERE id IN (SELECT id_usuario FROM ventas);

-- Ejemplo 2: Selecciona artículos cuyo precio sea mayor al promedio.
SELECT * FROM articulos WHERE precio > (SELECT AVG(precio) FROM articulos);

-- Ejemplo 3: Usa una subconsulta en FROM para crear una tabla temporal.
SELECT * FROM (
 SELECT id, nombre FROM usuarios
) AS temp;


-- ===== H. Funciones =====
-- Ejemplo 1: Cuenta cuántos usuarios hay en total.
SELECT COUNT(*) FROM usuarios;

-- Ejemplo 2: Calcula el promedio de precios de los artículos.
SELECT AVG(precio) FROM articulos;

-- Ejemplo 3: Devuelve el precio máximo y mínimo de los artículos.
SELECT MAX(precio), MIN(precio) FROM articulos;


-- ===== I. GROUP BY =====
-- Ejemplo 1: Suma las cantidades vendidas agrupadas por artículo.
SELECT id_articulo, SUM(cantidad) FROM ventas GROUP BY id_articulo;

-- Ejemplo 2: Cuenta cuántos usuarios hay por cada edad.
SELECT edad, COUNT(*) FROM usuarios GROUP BY edad;

-- Ejemplo 3: Muestra estados con más de 5 usuarios registrados.
SELECT estado, COUNT(*) FROM usuarios GROUP BY estado HAVING COUNT(*) > 5;


-- ===== J. Índices =====
-- Ejemplo 1: Crea un índice en la columna 'nombre' de usuarios.
CREATE INDEX idx_nombre ON usuarios(nombre);

-- Ejemplo 2: Elimina el índice creado anteriormente.
DROP INDEX idx_nombre ON usuarios;

-- Ejemplo 3: Crea un índice único en la columna 'email' de usuarios.
CREATE UNIQUE INDEX idx_email ON usuarios(email);


-- ===== K. Vistas =====
-- Ejemplo 1: Crea una vista con usuarios activos.
-- Las vistas permiten consultas predefinidas reutilizables.
CREATE VIEW usuarios_activos AS
 SELECT * FROM usuarios WHERE estado='activo';


-- ===== L. CTE =====
-- Ejemplo 1: Usa una CTE para calcular totales de ventas por artículo.
WITH totales AS (
 SELECT id_articulo, SUM(cantidad) AS total
 FROM ventas
 GROUP BY id_articulo
)
SELECT * FROM totales;


-- ===== M. Procedimientos y triggers =====
-- Ejemplo 1: Procedimiento que inserta un nuevo usuario.
DELIMITER //
CREATE PROCEDURE registrar_usuario(IN nom VARCHAR(50))
BEGIN
 INSERT INTO usuarios(nombre) VALUES(nom);
END //
DELIMITER ;

-- Ejemplo 2: Trigger que guarda cambios de precio en una tabla de auditoría.
DELIMITER //
CREATE TRIGGER aud_precios AFTER UPDATE ON articulos
FOR EACH ROW
BEGIN
 INSERT INTO auditoria(id_articulo,precio_antiguo,precio_nuevo)
 VALUES(OLD.id,OLD.precio,NEW.precio);
END //
DELIMITER ;

-- Ejemplo 3: Función que aplica un descuento del 15% al precio.
CREATE FUNCTION aplicar_descuento(precio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
RETURN precio*0.85;
