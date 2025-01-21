# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . /src
RUN dotnet publish dotnet-folder.csproj -c release -o /src/app/publish

# Final Stage
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app

# Create a non-root user with UID and GID
ARG USERNAME=user-devops
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

# Install OpenSSH server and necessary utilities
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        openssh-server \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Configure SSH: Allow non-root user to log in
RUN echo "root:Docker!" | chpasswd \
    && mkdir /var/run/sshd \
    && chmod 700 /var/run/sshd \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "AllowUsers $USERNAME" >> /etc/ssh/sshd_config

# Ensure sshd service can run in the container
COPY sshd_config /etc/ssh/sshd_config  # Ensure custom sshd_config is copied, if needed

# Copy the published application from the build stage
COPY --from=build /src/app/publish . 

# Copy and make entrypoint.sh executable
COPY entrypoint.sh ./ 
RUN chmod +x ./entrypoint.sh

# Set permissions for the app and switch user to non-root user
RUN chown -R $USERNAME:$USERNAME /app
USER $USERNAME

# Expose SSH and application ports
EXPOSE 22 80

# Entry point for the container (handles starting SSH and the app)
ENTRYPOINT ["./entrypoint.sh"]

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

# Stage 1: Build the application
# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /src
 
# # Copy everything and build the app
# COPY . /src
# RUN dotnet publish dotnet-folder.csproj -c release -o app/publish
 
# # Stage 2: Create a zip of the published app and push to Azure Blob Storage
# FROM alpine:3.16 AS zip
# WORKDIR /src
 
# # Install necessary tools
# RUN apk add --no-cache zip unzip
 
# # Copy the published files from the build stage
# COPY --from=build /src/app/publish /src/app/publish
 
# # Zip the published folder
# RUN zip -r app.zip /src/app/publish

# RUN unzip -l app.zip

# # Upload the zip file to Azure Blob Storage using curl
# # Replace <storage-account-name>, <container-name>, and <SAS-token> with your own details
# # RUN curl -X PUT -T app.zip \
# # "https://.blob.core.windows.net//app.zip?<SAS-token>"
 
# # Stage 3: Final stage to run the application
# FROM mcr.microsoft.com/dotnet/aspnet:6.0-jammy AS final
# WORKDIR /app
 
# # Copy the published application from the build stage
# COPY --from=build /src/app/publish .
 
# # Copy the entrypoint script and SSH config
# COPY entrypoint.sh ./
# COPY sshd_config /etc/ssh/
 
# # Install SSH and other necessary dependencies
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends dialog \
#     && apt-get install -y --no-install-recommends openssh-server \
#     && echo "root:Docker!" | chpasswd \
# && chmod u+x ./entrypoint.sh
 
# # Expose ports for HTTP (80) and SSH (2222)
# EXPOSE 80 2222
 
# # Start the application using your entrypoint script
# ENTRYPOINT [ "./entrypoint.sh" ]

# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /src
# COPY . /src
# RUN dotnet publish dotnet-folder.csproj -c release -o app/publish

# # Second Stage (Final)
# FROM mcr.microsoft.com/dotnet/aspnet:6.0-jammy AS final
# WORKDIR /app
# EXPOSE 80
# COPY --from=build /src/app/publish .
# COPY entrypoint.sh ./
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends dialog \
#     && apt-get install -y --no-install-recommends openssh-server \
#     && echo "root:Docker!" | chpasswd \
#     && chmod u+x ./entrypoint.sh \
#     && apt-get install zip unzip -y
# COPY sshd_config /etc/ssh/
# EXPOSE 80 2222
# ENTRYPOINT [ "./entrypoint.sh" ]

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

