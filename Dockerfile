FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . /src
RUN dotnet publish dotnet-folder.csproj -c release -o app/publish
RUN cd app/publish && ls
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
COPY add_hosts_entry.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/add_hosts_entry.sh
EXPOSE 80
COPY --from=build /src/app/publish .
ENTRYPOINT ["dotnet", "dotnet-folder.dll"]
