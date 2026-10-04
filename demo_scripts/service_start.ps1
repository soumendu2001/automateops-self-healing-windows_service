$Headers = @{
    Authorization = "Bearer tj8wlEZoMipoO6KzONlrBosj4ywdnw"
    "Content-Type" = "application/json"
}


$Body = @"
{
  "extra_vars": {
    "services": [
      {
        "name": "Spooler",
        "validation_type": "service"
      },
      {
        "name": "W32Time",
        "validation_type": "service"
      },
      {
        "name": "W3SVC",
        "validation_type": "port",
        "validation_port": 80
      }
    ]
  }
}
"@
`

$response = Invoke-RestMethod `
    -Uri "http://34.232.178.199:32013/api/v2/job_templates/11/launch/" `
    -Method POST `
    -Headers $Headers `
    -Body $Body

Write-Host "AWX Job Triggered"
Write-Host "Job ID:" $response.job
