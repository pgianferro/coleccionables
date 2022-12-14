DROP DATABASE IF EXISTS coleccionables_db;
CREATE DATABASE coleccionables_db;
USE coleccionables_db;


-- Estructura de la tabla de PRODUCTOS
DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id INTEGER NOT NULL AUTO_INCREMENT,
  sku varchar(50) NOT NULL,
  product_name varchar(240) NOT NULL,
  short_description TEXT,
  long_description TEXT,
  regular_price DECIMAL UNSIGNED NOT NULL,
  discount MEDIUMINT UNSIGNED,
  fee_q MEDIUMINT UNSIGNED,
  tags varchar(200) DEFAULT NULL,
  is_offer TINYINT NOT NULL,
  is_physical TINYINT NOT NULL,
  image_url varchar(200) NOT NULL,
  visits_q MEDIUMINT UNSIGNED NOT NULL,
  sales_q MEDIUMINT UNSIGNED NOT NULL,
  best_seller TINYINT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);


-- Estructura de la tabla OPCIONES DE PRODUCTO
DROP TABLE IF EXISTS options;
CREATE TABLE options (
  id INTEGER NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);


-- Estructura de la tabla intermedia PRODUCTOS - OPCIONES DE PRODUCTO
DROP TABLE IF EXISTS products_options;
CREATE TABLE products_options (
  id INTEGER NOT NULL AUTO_INCREMENT,
  product_id INTEGER NOT NULL,
  option_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (option_id) REFERENCES options (id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
);


-- Estructura de la tabla CATEGORIAS DE PRODUCTOS
DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
  id INTEGER NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);


-- Estructura de la tabla intermedia PRODUCTO - CATEGORIAS DE PRODUCTO
DROP TABLE IF EXISTS products_categories;
CREATE TABLE products_categories (
  id INTEGER NOT NULL AUTO_INCREMENT,
  product_id INTEGER NOT NULL,
  category_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
);


-- Estructura de la tabla SEXOS DE USUARIO
DROP TABLE IF EXISTS genders;
CREATE TABLE genders (
  id INTEGER NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);


-- Estructura de la tabla ROLES DE USUARIO
DROP TABLE IF EXISTS users_roles;
CREATE TABLE users_roles (
  id INTEGER NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);


-- Estructura de la tabla de USUARIOS
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INTEGER NOT NULL AUTO_INCREMENT,
  first_name varchar(100) NOT NULL,
  last_name varchar(100) NOT NULL,
  user varchar(50) NOT NULL,
  phone_country varchar(5),
  phone_number varchar(20),
  email varchar(50) NOT NULL,
  birth_date DATE NOT NULL,
  address varchar(50) DEFAULT NULL,
  gender INTEGER NOT NULL,
  password varchar(200) NOT NULL,
  image_url varchar(200) DEFAULT NULL,
  last_visit_date DATE DEFAULT NULL,
  user_role_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE (user),
  UNIQUE (email),
  FOREIGN KEY (user_role_id) REFERENCES users_roles (id) ON DELETE CASCADE,
  FOREIGN KEY (gender) REFERENCES genders (id) ON DELETE CASCADE
);


-- Estructura de la tabla INTERESES DE USUARIO
DROP TABLE IF EXISTS interests;
CREATE TABLE interests (
  id INTEGER NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);


-- Estructura de la tabla intermedia USUARIO - INTERESES DE USUARIO
DROP TABLE IF EXISTS users_interests;
CREATE TABLE users_interests (
  id INTEGER NOT NULL AUTO_INCREMENT,
  user_id INTEGER NOT NULL,
  interest_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  FOREIGN KEY (interest_id) REFERENCES interests (id) ON DELETE CASCADE
);


-- Estructura de la tabla PRODUCTOS VISITADOS DEL USUARIO
DROP TABLE IF EXISTS users_visited_products;
CREATE TABLE users_visited_products (
  id INTEGER NOT NULL AUTO_INCREMENT,
  user_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  last_visited DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
);


-- Estructura de la tabla ESTADOS DE ORDENES (CARRITOS)
DROP TABLE IF EXISTS orders_status;
CREATE TABLE orders_status (
  id INTEGER NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);


-- Estructura de la tabla de ORDENES (CARRITOS)
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id INTEGER NOT NULL AUTO_INCREMENT,
  user_id INTEGER NOT NULL,
  ammount DECIMAL,
  items_q MEDIUMINT,
  shipping_address varchar(50),
  billing_address varchar(50),
  email varchar(50),
  date DATE,
  status_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  FOREIGN KEY (status_id) REFERENCES orders_status (id) ON DELETE CASCADE
);


-- Estructura de la tabla intermedia ORDENES (CARRITOS) - PRODUCTOS
DROP TABLE IF EXISTS orders_details;
CREATE TABLE orders_details (
  id INTEGER NOT NULL AUTO_INCREMENT,
  order_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  price MEDIUMINT UNSIGNED NOT NULL,
  quantity MEDIUMINT UNSIGNED NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE (order_id, product_id),
  FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
);