#!/bin/bash
set -e

# Localiza o sqlcmd — SQL Server 2022 usa /opt/mssql-tools18
if [ -f "/opt/mssql-tools18/bin/sqlcmd" ]; then
  SQLCMD="/opt/mssql-tools18/bin/sqlcmd"
elif [ -f "/opt/mssql-tools/bin/sqlcmd" ]; then
  SQLCMD="/opt/mssql-tools/bin/sqlcmd"
else
  echo "ERROR: sqlcmd not found"
  exit 1
fi

# Inicia SQL Server em background
/opt/mssql/bin/sqlservr &
MSSQL_PID=$!

# Aguarda SQL Server ficar pronto (até 60s)
echo "Waiting for SQL Server to start..."
for i in $(seq 1 12); do
  if $SQLCMD -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -Q "SELECT 1" -C -N o &>/dev/null; then
    echo "SQL Server is ready."
    break
  fi
  if [ "$i" -eq 12 ]; then
    echo "ERROR: SQL Server did not become ready in time"
    exit 1
  fi
  sleep 5
done

BAK_FILE="/var/opt/mssql/backup/aw.bak"

if [ ! -f "$BAK_FILE" ]; then
  echo "ERROR: backup file not found at $BAK_FILE"
  exit 1
fi

# Verifica se banco já existe (idempotência)
DB_EXISTS=$($SQLCMD -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -N o \
  -Q "SET NOCOUNT ON; SELECT COUNT(*) FROM sys.databases WHERE name='AdventureWorks2022'" -h -1 2>/dev/null | tr -d ' \r\n')

if [ "$DB_EXISTS" = "1" ]; then
  echo "AdventureWorks2022 already exists, skipping restore."
else
  echo "Restoring AdventureWorks2022..."
  $SQLCMD -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -N o -Q \
    "RESTORE DATABASE AdventureWorks2022 FROM DISK='$BAK_FILE' WITH MOVE 'AdventureWorks2022' TO '/var/opt/mssql/data/AdventureWorks2022.mdf', MOVE 'AdventureWorks2022_log' TO '/var/opt/mssql/data/AdventureWorks2022_log.ldf', REPLACE"
  echo "Restore complete."
fi

wait $MSSQL_PID
