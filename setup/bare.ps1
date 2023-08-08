# **********************************************************
# **                                                      **
# ** PLEASE: RUN THIS SCRIPT FROM ROOT FOLDER USING       **
# ** .\setup\bare.ps1                                     **
# **                                                      **
# **********************************************************


# Deploy Application components
Write-Host "Setup cluster and Application Components" -ForegroundColor Green
.\Powershell\deployAll.ps1


# Open new tab with port forward for RabbitMQ
Write-Host "Port forwarding RabbitMQ" -ForegroundColor Green
wt -w 0 new-tab --title RabbitMQ -p "Azure Cloud Shell" kubectl port-forward --namespace default svc/rabbitmq 15672:15672