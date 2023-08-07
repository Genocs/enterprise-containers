# **********************************************************
# **                                                      **
# ** PLEASE: RUN THIS SCRIPT FROM ROOT FOLDER USING       **
# ** .\setup\monitoring.ps1                               **
# **                                                      **
# **********************************************************


# Deploy Application components
Write-Host "Deploying Application Components" -ForegroundColor Green
.\Powershell\deployAll.ps1

# Deploy Elasticsearch, Fluend, Kibana
Write-Host "Deploying EFK stack" -ForegroundColor Green
.\Powershell\deployEFK.ps1

# Install Prometheus using promtheus-kube-stack
Write-Host "Deploying Prometheus stack" -ForegroundColor Green
.\Powershell\deployPrometheus.ps1

Write-Host "Enabling service monitor" -ForegroundColor Green
Set-Location .\k8s\Prometheus
kubectl apply -R -f .
# Jump back to the root
Set-Location ..\..

# Open new tab with port forward to Kibana
Write-Host "Port forwarding Kibana" -ForegroundColor Green
wt -w 0 new-tab --title kibana -p "PowerShell Core" kubectl port-forward --namespace default svc/kibana 5601:5601

# Open new tab with port forward to Grafana
Write-Host "Port forwarding Grafana" -ForegroundColor Green
wt -w 0 new-tab --title grafana -p "PowerShell Core" kubectl port-forward --namespace monitoring svc/prometheus-grafana 80:80

# Open new tab for watchers
wt -w 0 new-tab --title watchers -p "PowerShell Core" split-pane -V kgpow; split-pane -V -p "PowerShell Core" kgdepw