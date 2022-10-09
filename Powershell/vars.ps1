$currentWorkingDirectory = (Get-Location).Path | Split-Path -Parent
#$currentWorkingDirectory = ./

$helmRootDirectory = Join-Path $currentWorkingDirectory "helm"
$projectRootDirectory = Join-Path $currentWorkingDirectory "k8s"
$applicationProducerRootDirectory = Join-Path $projectRootDirectory "ApplicationProducer"
$applicationConsumerRootDirectory = Join-Path $projectRootDirectory "ApplicationConsumer"
$autoScalerRootDirectory = Join-Path $projectRootDirectory "AutoScaledConsumer"