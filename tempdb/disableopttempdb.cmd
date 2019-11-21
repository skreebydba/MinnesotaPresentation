sqlcmd -Usa -PJu@nS0t022 -idisableopttempdb.sql -Slocalhost,1445
docker stop sqlopttempdb
docker start sqlopttempdb