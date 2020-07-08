$createdb = @"
USE master;
GO
DROP DATABASE IF EXISTS ChicagoWhiteSox;
GO
CREATE DATABASE ChicagoWhiteSox;
GO$createdb = @"
USE master;
GO
DROP DATABASE IF EXISTS ChicagoWhiteSox;
GO
CREATE DATABASE ChicagoWhiteSox;
GO
USE ChicagoWhiteSox;
GO
CREATE OR ALTER PROCEDURE letsgosox
AS
CREATE TABLE #gosox (col1 INT);
GO
"@

$instance = "localhost";
