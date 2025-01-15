# First Stage (Build)
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . /src
RUN dotnet publish dotnet-folder.csproj -c release -o app/publish

# Second Stage (Final)
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
EXPOSE 80

# Copy published app from build stage
COPY --from=build /src/app/publish .

# Copy entrypoint script
COPY entrypoint.sh ./

# Run as root user to install dependencies
USER root
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends dialog \
    && apt-get install -y --no-install-recommends openssh-server \
    && echo "root:Docker!" | chpasswd \
    && chmod u+x ./entrypoint.sh

# Copy sshd_config
COPY sshd_config /etc/ssh/

# Create necessary directories for sshd
RUN mkdir -p /run/sshd && chmod 700 /run/sshd

# Switch to non-root user for running the app
RUN adduser --disabled-password --gecos '' non-root && \
    chown -R non-root /app
USER non-root

# Expose additional ports for SSH and the application
EXPOSE 8000 2222

# Set entrypoint for container
ENTRYPOINT ["./entrypoint.sh"]
