#FROM mcr.microsoft.com/dotnet/core/sdk:3.0  AS build-env
#FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build-env
# FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build-env
FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build-env

WORKDIR /app

COPY Genocs.KubernetesCourse.Internal.WebApi /Genocs.KubernetesCourse.Internal.WebApi/
COPY Genocs.KubernetesCourse.Contracts /Genocs.KubernetesCourse.Contracts/

# COPY NuGet.config ./

WORKDIR /Genocs.KubernetesCourse.Internal.WebApi
RUN dotnet restore

#COPY . ./

RUN dotnet publish --configuration Release --output releaseOutput --no-restore

#build runtime image
#FROM mcr.microsoft.com/dotnet/core/aspnet:3.0
#FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim
# FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine

WORKDIR /Genocs.KubernetesCourse.Internal.WebApi

COPY --from=build-env /Genocs.KubernetesCourse.Internal.WebApi/releaseOutput ./

#run the container as non-root user
#USER 1000

ENTRYPOINT ["dotnet", "Genocs.KubernetesCourse.Internal.WebApi.dll"]