# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . .
RUN dotnet publish dotnet-folder.csproj -c release -o /app/publish

# Stage 2: Create the final image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
COPY --from=build /src/app/publish .
COPY add_hosts_entry.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/add_hosts_entry.sh
EXPOSE 80
CMD ["/usr/local/bin/add_hosts_entry.sh"]
ENTRYPOINT ["dotnet", "dotnet-folder.dll"]
