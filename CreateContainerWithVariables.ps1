$password = 'Th1s1s@P@$$w0rd';
$containername = 'mycontainer';
$port = 1437;
$image = 'mcr.microsoft.com/mssql/server:2017-CU8-ubuntu';
docker run -e 'ACCEPT_EULA=Y' -e "SA_PASSWORD=$password" --name $containername -p "$port:1433" -d $image