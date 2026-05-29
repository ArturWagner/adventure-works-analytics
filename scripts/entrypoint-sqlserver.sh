#!/bin/bash
set -e

# Inicia SQL Server em background
/opt/mssql/bin/sqlservr &
MSSQL_PID=$!

# Aguarda SQL Server ficar pronto (até 60s)
echo "Waiting for SQL Server to start..."
for i in $(seq 1 12); do
  if /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -Q "SELECT 1" &>/dev/null; then
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
DB_EXISTS=$(/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" \
  -Q "SET NOCOUNT ON; SELECT COUNT(*) FROM sys.databases WHERE name='AdventureWorks2022'" -h -1 2>/dev/null | tr -d ' ')

if [ "$DB_EXISTS" = "1" ]; then
  echo "AdventureWorks2022 already exists, skipping restore."
else
  echo "Restoring AdventureWorks2022..."
  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -Q \
    "RESTORE DATABASE AdventureWorks2022 FROM DISK='/var/opt/mssql/backup/aw.bak' WITH MOVE 'AdventureWorksDW2022' TO '/var/opt/mssql/data/AdventureWorks2022.mdf', MOVE 'AdventureWorksDW2022_log' TO '/var/opt/mssql/data/AdventureWorks2022_log.ldf'"
  echo "Restore complete."
fi

wait $MSSQL_PID
