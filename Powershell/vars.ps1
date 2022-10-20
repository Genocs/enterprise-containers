$currentWorkingDirectory = (Get-Location).Path | Split-Path -Parent
#$currentWorkingDirectory = ./

$helmRootDirectory = Join-Path $currentWorkingDirectory "helm"
$projectRootDirectory = Join-Path $currentWorkingDirectory "k8s"
$applicationProducerRootDirectory = Join-Path $projectRootDirectory "ApplicationProducer"
$applicationProducerInternalRootDirectory = Join-Path $projectRootDirectory "ApplicationProducerInternal"
$applicationConsumerRootDirectory = Join-Path $projectRootDirectory "ApplicationConsumer"
$autoScalerRootDirectory = Join-Path $projectRootDirectory "AutoScaledConsumer"
$secretsRootDirectory = Join-Path $projectRootDirectory "Security"
