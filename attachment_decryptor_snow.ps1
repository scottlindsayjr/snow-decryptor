$IncidentNumber = "INC0010112"

$instance = "dev112485"
$admin = "test_user_1"
$password = "scott1234" | ConvertTo-SecureString -AsPlainText -Force 

$Credential = New-Object pscredential -ArgumentList ($admin,$password)
$Uri = "https://$($instance).service-now.com/api/now/table/incident?sysparm_query=number=$($IncidentNumber)&sysparm_fields=sys_id&sysparm_limit=1"
$IncidentResult = Invoke-RestMethod -Uri $Uri -Method Get -Credential $Credential

if($IncidentResult.result.sys_id -ne $null) {
    $IncidentAttachments = Invoke-RestMethod -Uri "https://$($instance).service-now.com/api/now/attachment?sysparm_query=table_sys_id=$($IncidentResult.result.sys_id)" -Method Get -Credential $Credential
    $IncidentAttachments.result | Select file_name , download_link
}
else{
    "Incident Not Found!"
}

if($IncidentResult.result.sys_id -ne $null) {
    $IncidentAttachments = Invoke-RestMethod -Uri "https://$($instance).service-now.com/api/now/attachment?sysparm_query=table_sys_id=$($IncidentResult.result.sys_id)" -Method Get -Credential $Credential
    $Results = $IncidentAttachments.result | Select file_name , download_link, sys_id
    foreach($Result in $Results) {
        Invoke-RestMethod -Uri "https://$($instance).service-now.com/attachment_decryptor_util.do?attachmentSysId=$($Result.sys_id)" -Method Get -Credential $Credential -OutFile C:\pstest\Downloads\$($Result.file_name)
    }
}
else{
    "Incident Not Found!"
}