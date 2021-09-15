#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["Dotnet.Docker.Api.csproj", "."]
RUN dotnet restore "./Dotnet.Docker.Api.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Dotnet.Docker.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Dotnet.Docker.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
#ENTRYPOINT ["dotnet", "Dotnet.Docker.Api.dll"]
CMD  ASPNETCORE_URLS=http://*:$PORT dotnet Dotnet.Docker.Api.dll