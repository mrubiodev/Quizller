<?php
// Obtén los valores de las variables de entorno para la conexión a la base de datos
$dbHost = getenv('DB_HOST');
$dbUsername = getenv('DB_USERNAME');
$dbPassword = getenv('DB_PASSWORD');
$dbDatabase = getenv('DB_DATABASE');

// Establece la conexión a la base de datos usando las variables de entorno
$conn = mysqli_connect($dbHost, $dbUsername, $dbPassword, $dbDatabase);
?>