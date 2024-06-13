FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . /src
RUN dotnet publish dotnet-folder.csproj -c release -o app/publish
RUN cd app/publish && ls
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
COPY add_hosts_entry.sh /usr/local/bin/
COPY --from=build /src/app/publish .
RUN apt update && apt install -y vim
EXPOSE 80
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/add_hosts_entry.sh
RUN ls
ENTRYPOINT ["entrypoint.sh"]
CMD ["dotnet", "dotnet-folder.dll"]

# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /src
# COPY . /src
# RUN dotnet publish dotnet-folder.csproj -c release -o app/publish
# RUN cd app/publish && ls
# FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
# WORKDIR /app
# COPY add_hosts_entry.sh /usr/local/bin/
# RUN chmod +x /usr/local/bin/add_hosts_entry.sh
# RUN apt update && apt install -y vim
# EXPOSE 80
# COPY --from=build /src/app/publish .
# RUN ls
# CMD sh /usr/local/bin/add_hosts_entry.sh
# ENTRYPOINT ["dotnet", "dotnet-folder.dll"]

# # Stage 1: Build the application
# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /src
# COPY . .
# RUN dotnet publish dotnet-folder.csproj -c release -o /app/publish

# # Stage 2: Create the final image
# FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
# WORKDIR /app
# COPY --from=build /src/app/publish .
# COPY add_hosts_entry.sh /usr/local/bin/
# RUN chmod +x /usr/local/bin/add_hosts_entry.sh
# RUN apt update && apt install -y vim # Added -y flag to automatically confirm installations
# EXPOSE 80
# CMD ["add_hosts_entry.sh"] # Run the script as CMD
# ENTRYPOINT ["dotnet", "dotnet-folder.dll"]

