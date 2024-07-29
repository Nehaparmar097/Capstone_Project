#!/bin/bash

# Start SQL Server in the background
/opt/mssql/bin/sqlservr &

# Wait for SQL Server to start up
echo "Waiting for SQL Server to start..."
sleep 20s

# Check if SQL Server is running
if /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -Q "SELECT 1" > /dev/null 2>&1; then
  echo "SQL Server is up and running."
else
  echo "SQL Server failed to start."
  exit 1
fi

# Start the .NET application
echo "Starting the .NET application..."
dotnet ToyStoreManagment.dll
