# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /src
# COPY . /src
# RUN dotnet publish dotnet-folder.csproj -c release -o app/publish
# RUN cd app/publish && ls
# FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
# WORKDIR /app
# COPY add_hosts_entry.sh /usr/local/bin/
# COPY --from=build /src/app/publish .
# RUN apt update && apt install -y vim  
# EXPOSE 80
# COPY entrypoint.sh /usr/local/bin/
# RUN chmod +x /usr/local/bin/add_hosts_entry.sh
# RUN ls
# CMD ["dotnet", "dotnet-folder.dll"]
# Stage 1: Build stage
# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /src
# COPY . .
# RUN dotnet publish dotnet-folder.csproj -c release -o /app/publish 

# # Stage 2: Runtime stage
# FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
# WORKDIR /app
# COPY add_hosts_entry.sh /usr/local/bin/
# RUN chmod +x /usr/local/bin/add_hosts_entry.sh \
#     && apt-get update \
#     && apt-get install -y openssh-server vim \
#     && rm -rf /var/lib/apt/lists/*
# EXPOSE 80
# EXPOSE 22
# COPY --from=build /src/app/publish .
# CMD ["bash", "-c", "service ssh start && dotnet dotnet-folder.dll"]

# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /src
# COPY . /src
# RUN dotnet publish dotnet-folder.csproj -c release -o app/publish
# RUN cd app/publish && ls
# FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
# WORKDIR /app
# COPY add_hosts_entry.sh /usr/local/bin/
# RUN chmod +x /usr/local/bin/add_hosts_entry.sh \
#     && apt-get update \
#     && apt-get install -y openssh-server openssh-client vim \
#     && rm -rf /var/lib/apt/lists/*
# EXPOSE 80
# EXPOSE 22
# COPY --from=build /src/app/publish .
# RUN ls
# First Stage (Build)

# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /src
# COPY . /src
# RUN dotnet publish dotnet-folder.csproj -c release -o app/publish

# # Second Stage (Final)
# FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
# WORKDIR /app
# COPY --from=build /src/app/publish .
# COPY entrypoint.sh ./
# RUN apt-get update \ 
#     && apt-get install -y --no-install-recommends dialog \
#     && apt-get install -y --no-install-recommends openssh-server \
#     && echo "root:Docker!" | chpasswd \
#     && chmod u+x ./entrypoint.sh
# COPY sshd_config /etc/ssh/
# EXPOSE 80 2222
# ENTRYPOINT ["dotnet", "dotnet-folder.dll"]

## Working ######################
# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /src
# COPY . /src
# RUN dotnet publish dotnet-folder.csproj -c release -o app/publish

# # Second Stage (Final)
# FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine AS final
# WORKDIR /app
# COPY --from=build /src/app/publish .
# COPY backendentrypoint.sh ./
# EXPOSE 80
# ENTRYPOINT [ "./backendentrypoint.sh" ]

FROM mcr.microsoft.com/dotnet/sdk:6.0.425-1 AS build
WORKDIR /src
COPY . /src
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --only-upgrade bash && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN dotnet publish dotnet-folder.csproj -c release -o app/publish
# Second Stage (Final)
FROM mcr.microsoft.com/dotnet/aspnet:6.0.33-jammy AS final 
WORKDIR /app
COPY --from=build /src/app/publish .
COPY entrypoint.sh ./
RUN apt-get update && \
    chmod u+x ./entrypoint.sh
# COPY sshd_config /etc/ssh/
EXPOSE 80
ENTRYPOINT [ "./entrypoint.sh" ]

# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /src
# COPY . .
# RUN dotnet publish dotnet-folder.csproj -c release -o /app/publish

# # Stage 2: Create the final image
# FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
# WORKDIR /app
# COPY --from=build /src/app/publish .
# EXPOSE 80
# ENTRYPOINT ["dotnet", "dotnet-folder.dll"]

######## Working ######################


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

