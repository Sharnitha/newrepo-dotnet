FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . /src
RUN dotnet publish dotnet-folder.csproj -c release -o app/publish
RUN cd app/publish && ls
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
RUN apt update && apt-get install -y iputils-ping
RUN apt install telnet -y
EXPOSE 80
COPY --from=build /src/app/publish .
ENTRYPOINT ["dotnet", "dotnet-folder.dll"]
