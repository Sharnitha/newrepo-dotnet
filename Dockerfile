FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . /src
RUN apt-get update -y \
    && apt-get install git -y
RUN dotnet publish dotnet-folder.csproj -c release -o app/publish

# Second Stage (Final)
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine AS final
WORKDIR /app
EXPOSE 80
COPY --from=build /src/app/publish . 
COPY backendentrypoint.sh ./ 
RUN apk update \
    && apk add --no-cache openssh-server \
    && echo "root:Docker!" | chpasswd \
    && chmod u+x ./backendentrypoint.sh \
    && rm -rf /var/cache/apk/*
COPY sshd_config /etc/ssh/
EXPOSE 2222
ENTRYPOINT [ "./backendentrypoint.sh" ]


# Dockerfile for a .NET Core container with SSH server
# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /src
# COPY . /src
# RUN dotnet publish dotnet-folder.csproj -c release -o app/publish

# # Create a new image for the final runtime environment
# FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
# WORKDIR /app

# # Install SSH server and other utilities
# RUN apt-get update && apt-get install -y openssh-server vim

# # Expose ports
# EXPOSE 80
# EXPOSE 22

# # Copy the published .NET Core app
# COPY --from=build /src/app/publish .

# # Start the SSH server and the .NET Core app
# CMD ["/bin/bash", "-c", "service ssh start && dotnet dotnet-folder.dll"]


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

