sqlcmd -Usa -PJu@nS0t022 -ioptimizetempdb.sql -Slocalhost,1445
docker stop sqlopttempdb
docker start sqlopttempdb