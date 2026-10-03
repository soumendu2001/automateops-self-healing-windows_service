$Headers = @{
    Authorization = "Bearer <TOKEN>"
    "Content-Type" = "application/json"
}

$Body = @"
{
  "extra_vars": {
    "target_host": "windows1",
    "target_service": "Spooler",
    "validation_type": "service"
  }
}
"@

$response = Invoke-RestMethod `
    -Uri "http://<AWX-IP>:<PORT>/api/v2/job_templates/<JOB_ID>/launch/" `
    -Method POST `
    -Headers $Headers `
    -Body $Body

Write-Host "AWX Job Triggered"
Write-Host "Job ID:" $response.job
