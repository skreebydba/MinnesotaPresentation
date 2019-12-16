$password = 'JuanS0t022';
$containername = 'sqlserver2019';
$port = 1435;
$image = 'mcr.microsoft.com/mssql/server:2019-GA-ubuntu-16.04';
docker pull $image;
docker run -e 'ACCEPT_EULA=Y' -e "SA_PASSWORD=$password"  --name $containername -p "$port`:1433" -d $image;

docker exec -it $containername mkdir /var/opt/mssql/backup;
docker cp C:\Backup\WideWorldImporters-Full.bak "$containername`:/var/opt/mssql/backup";

$password = 'JuanS0t022';
$containername = 'sqlserver2017';
$port = 1436;
$image = 'mcr.microsoft.com/mssql/server:2017-latest-ubuntu';
docker pull $image;
docker run -e 'ACCEPT_EULA=Y' -e "SA_PASSWORD=$password"  --name $containername -p "$port`:1433" -d $image

docker exec -it $containername mkdir /var/opt/mssql/backup;
docker cp C:\Backup\WideWorldImporters-Full.bak "$containername`:/var/opt/mssql/data";

docker exec -it $containername /opt/mssql-tools/bin/sqlcmd `
   -S localhost -U SA -P $password `
   -Q "RESTORE DATABASE WideWorldImporters FROM DISK = '/var/opt/mssql/backup/WideWorldImporters-Full.bak' WITH MOVE 'WWI_Primary' TO '/var/opt/mssql/data/WideWorldImporters.mdf', MOVE 'WWI_UserData' TO '/var/opt/mssql/data/WideWorldImporters_userdata.ndf', MOVE 'WWI_Log' TO '/var/opt/mssql/data/WideWorldImporters.ldf', MOVE 'WWI_InMemory_Data_1' TO '/var/opt/mssql/data/WideWorldImporters_InMemory_Data_1'"