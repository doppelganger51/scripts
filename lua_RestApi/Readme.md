Application uses mysql db, before running create database and following tables.
Create table "categories"
CREATE TABLE IF NOT EXISTS categories (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255) NOT NULL);
Create table "products"
CREATE TABLE IF NOT EXISTS products (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255) NOT NULL, category_id INT);

Example requests: (POSTMAN recommended for testing)

Show all categories
GET http://localhost:8080/category?

Show category with id 2
GET http://localhost:8080/category?id=2

Delete category with id 2
DELETE http://localhost:8080/category?id=2

Create category with name "books"
POST http://localhost:8080/category?name=cakes

Update category with id 2 using name "magazines"
POST http://localhost:8080/category?id=2&name=goodcakes
