<# Execute lines 1-21 to create a database and stored procedure. Change the $instance variable to your instance #>

$createdb = @"
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
$service = (Get-Service -DisplayName "SQL Server (*").Name;

Invoke-SqlCmd -ServerInstance $instance -Database master -Query $createdb;

<# Execute lines 25-27. This will tempdb in-memory optimization and restart the SQL service. #>

Invoke-Sqlcmd -ServerInstance $instance -Database master -InputFile .\disableopttempdb.sql;

Restart-Service -Name $service -Force;

<# Execute line 31.  This will run 50 threads, each of which will create a temp table 5000 times. #>

.\ostress.exe -Q"exec letsgosox" -n50 -r5000 -dChicagoWhiteSox -S"localhost"; 

<# While ostress is running, execute this query from SSMS:

USE tempdb;
GO
SELECT object_name(page_info.object_id) AS object_name, d.wait_type, page_info.* 
FROM sys.dm_exec_requests AS d 
  CROSS APPLY sys.fn_PageResCracker(d.page_resource) AS r
  CROSS APPLY sys.dm_db_page_info(r.db_id, r.file_id, r.page_id,'DETAILED')
    AS page_info;
GO

It will return the pages that are being latched in tempdb.  #>

<# Execute lines 48-50. This will enable in-memory optimization for tempdb and restart the SQL Server service #>

Invoke-Sqlcmd -ServerInstance $instance -Database master -InputFile .\optimizetempdb.sql;

Restart-Service -Name $service -Force;

<# Execute line 54.  This will run 50 threads, each of which will create a temp table 5000 times. #>

.\ostress.exe -Q"exec letsgosox" -n50 -r5000 -dChicagoWhiteSox -S"localhost";


<# While ostress is running, execute this query from SSMS:

USE tempdb;
GO
SELECT object_name(page_info.object_id) AS object_name, d.wait_type, page_info.* 
FROM sys.dm_exec_requests AS d 
  CROSS APPLY sys.fn_PageResCracker(d.page_resource) AS r
  CROSS APPLY sys.dm_db_page_info(r.db_id, r.file_id, r.page_id,'DETAILED')
    AS page_info;
GO

Because the tempdb metadata tables are in memory, you will not see any pages being latched.  

Finally, execute the following query in SSMS.  It will show you the memory-optimized tables in
the tempdb database.  Confirm that you see object sysschobjs and note the count of row_update_attempts. #>
