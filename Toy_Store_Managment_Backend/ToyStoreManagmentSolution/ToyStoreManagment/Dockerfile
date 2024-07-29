#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# Base stage for running the app
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Install SQL Server
RUN apt-get update && \
    apt-get install -y curl gnupg && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-2019.list | tee /etc/apt/sources.list.d/mssql-server.list && \
    apt-get update && \
    apt-get install -y mssql-server

# Set environment variables for SQL Server
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=YourStrong@Passw0rd

# Configure SQL Server
RUN /opt/mssql/bin/mssql-conf set sqlagent.enabled true
RUN /opt/mssql/bin/mssql-conf set memory.memorylimitmb 2048
RUN /opt/mssql/bin/mssql-conf set sqlagent.startupstate Manual

# Build stage for building the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["ToyStoreManagment/ToyStoreManagment.csproj", "ToyStoreManagment/"]
RUN dotnet restore "./ToyStoreManagment/ToyStoreManagment.csproj"
COPY . .
WORKDIR "/src/ToyStoreManagment"
RUN dotnet build "./ToyStoreManagment.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Publish stage for publishing the app
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./ToyStoreManagment.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Final stage to run the app and SQL Server
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Create a script to start SQL Server and the .NET application
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
