$rgname = "fbgsqlhsrg";
$srvname = "fbgsqlhssrv";
$dbname = "wwibc";
$saname = "fbgsqlhssa";
$login = "skreeby";
$password = 'P@$$w0rd1';

$importRequest = New-AzSqlDatabaseImport -ResourceGroupName $rgname `
    -ServerName $srvname -DatabaseName $dbname `
    -DatabaseMaxSizeBytes 1073741824 -StorageKeyType "StorageAccessKey" `
    -StorageKey $(Get-AzStorageAccountKey `
        -ResourceGroupName $rgname -StorageAccountName $saname).Value[0] `
        -StorageUri "https://$saname.blob.core.windows.net/fbgsqlhsbak/WideWorldImporters-Standard.bacpac" `
        -Edition "BusinessCritical" -ServiceObjectiveName "BC_Gen4_1" `
        -AdministratorLogin $login `
        -AdministratorLoginPassword $(ConvertTo-SecureString -String $password -AsPlainText -Force)