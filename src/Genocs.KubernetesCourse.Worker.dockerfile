FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build-env

WORKDIR /app

COPY Genocs.KubernetesCourse.Worker /Genocs.KubernetesCourse.Worker/
COPY Genocs.KubernetesCourse.Contracts /Genocs.KubernetesCourse.Contracts/

# COPY NuGet.config ./

WORKDIR /Genocs.KubernetesCourse.Worker
RUN dotnet restore

#COPY . ./

RUN dotnet publish --configuration Release --output releaseOutput --no-restore

#build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine

WORKDIR /Genocs.KubernetesCourse.Worker

COPY --from=build-env /Genocs.KubernetesCourse.Worker/releaseOutput ./

#run the container as non-root user
#USER 1000

ENTRYPOINT ["dotnet", "Genocs.KubernetesCourse.Worker.dll"]
