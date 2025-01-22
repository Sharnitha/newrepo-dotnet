FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . /src
RUN dotnet publish dotnet-folder.csproj -c release -o app/publish

# Final Stage
FROM mcr.microsoft.com/dotnet/aspnet:6.0-jammy AS final
WORKDIR /app
COPY entrypoint.sh .
COPY --from=build /src/app/publish .
RUN apt-get update \
    && apt-get install -y --no-install-recommends dialog \
    && apt-get install -y --no-install-recommends openssh-server \
    && echo "root:Docker!" | chpasswd \
    && chmod u+x entrypoint.sh 
RUN ls
COPY sshd_config /etc/ssh/
EXPOSE 80
ENTRYPOINT [ "./entrypoint.sh" ]


# -------------------
# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /src
# COPY . /src
# RUN dotnet publish dotnet-folder.csproj -c release -o app/publish

# # Final Stage
# FROM mcr.microsoft.com/dotnet/aspnet:6.0-jammy AS final
# WORKDIR /app

# # Create non-root user
# ARG USERNAME=devops-non
# ARG USER_UID=1000
# ARG USER_GID=$USER_UID

# # Create the user and group, and install necessary utilities
# RUN groupadd --gid $USER_GID $USERNAME \
#     && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
#     && apt-get update \
#     && apt-get install -y ca-certificates \
#     && rm -rf /var/lib/apt/lists/*

# # Copy the published application from the build stage
# COPY --from=build /src/app/publish .

# # Copy and make entrypoint.sh executable
# COPY entrypoint.sh ./
# RUN chmod +x ./entrypoint.sh

# # Remove sudo package and lock the user account (disable sudo)
# RUN usermod -L $USERNAME  # Lock the user to prevent sudo access

# # Set ownership of app directory
# RUN chown -R $USERNAME:$USERNAME /app

# # Switch to non-root user
# USER $USERNAME

# # Expose port for the application
# EXPOSE 80

# # Set the entrypoint to the shell script (if any)
# ENTRYPOINT [ "./entrypoint.sh" ]
