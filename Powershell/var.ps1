$currentWorkingDirectory = (Get-Location).Path | Split-Path -Parent
#$currentWorkingDirectory = ./

$helmRootDirectory = Join-Path $currentWorkingDirectory "helm"
$projectRootDirectory = Join-Path $currentWorkingDirectory "k8s"
$applicationProducerRootDirectory = Join-Path $projectRootDirectory "ApplicationProducer"
$applicationConsumerRootDirectory = Join-Path $projectRootDirectory "ApplicationConsumer"
$autoScalarRootDirectory = Join-Path $projectRootDirectory "AutoScaledConsumer"
