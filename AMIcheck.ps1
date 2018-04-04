#initialize default profile

Initialize-AWSDefaults -ProfileName prod -Region us-east-1

# Change Email address
$email="<user@email.com>"
$emailCC="<user2@email.com>"
$SmtpServer="email-smtp.us-east-1.amazonaws.com"
$SmtpPort=587
$KeyFile = "AES.key"
$key = Get-Content $KeyFile
$PwFile = "PwFile.txt"

$logfile="AMI_output.txt"

#Grab Name/imageID/creation date for each AMI
$AWS_2016=Get-EC2ImageByName -Names WINDOWS_2016_BASE | Select-Object Name, ImageID, CreationDate
#Write-Host $AWS_2016.Name
$AWS_2012R2=Get-EC2ImageByName -Names WINDOWS_2012R2_BASE | Select-Object Name, ImageID, CreationDate
#Write-Host $AWS_2012R2.Name
$AWS_AMZN = Get-EC2Image -Filter @{ Name="name"; Values="amzn-ami-hvm-*-x86_64-gp2" } | where-object {$_.Description -notlike "*Copied*"} | Sort-Object CreationDate -Descending | Select-Object Name, ImageID, CreationDate | Select-Object -First 1
#Write-Host $AWS_AMZN.Name
$AWS_Ubuntu = Get-EC2Image -Filter @{ Name="name"; Value="ubuntu/images/hvm-ssd/ubuntu-xenial-*-amd64-server*" } | Where-Object {$_.Name -notlike "*daily*" -and $_.Name -notlike "*dotnet*"} | Sort-Object CreationDate -Descending | Select-Object Name, ImageID, CreationDate | Select-Object -First 1
#Write-host $AWS_Ubuntu.Name

#Output to logfile to email results
$AWS_2012R2_msg=$AWS_2012R2.Name + "<br>" + $AWS_2012R2.ImageId +"<br>" + [datetime]$AWS_2012R2.CreationDate
$AWS_2016_msg=$AWS_2016.Name + "<br>" + $AWS_2016.ImageId +"<br>" + [datetime]$AWS_2016.CreationDate
$AWS_AMZN_msg=$AWS_AMZN.Name + "<br>" + $AWS_AMZN.ImageId +"<br>" + [datetime]$AWS_AMZN.CreationDate
$AWS_Ubuntu_msg=$AWS_Ubuntu.Name + "<br>" + $AWS_Ubuntu.ImageId +"<br>" + [datetime]$AWS_Ubuntu.CreationDate

Write-Output "Latest Amazon AMIs below:<br><br>"| out-file $logfile
Write-Output "<strong>Windows 2012R2:</strong><br> $AWS_2012R2_msg<br>" | out-file -append $logfile
Write-Output "<strong>Windows 2016:</strong><br> $AWS_2016_msg <br><br>" | out-file -append $logfile
Write-Output "<strong>Amazon Linux:</strong><br> $AWS_AMZN_msg<br>" | out-file -append $logfile
Write-Output "<strong>Ubuntu:</strong><br> $AWS_Ubuntu_msg<br>" | out-file -append $logfile

$body = Get-Content "AMI_output.txt"
$body = $body | Out-String
$smtp = new-object Net.Mail.SmtpClient($SmtpServer, $SmtpPort)
$smtp.EnableSsl = $true
# Change the <aws_access_key_id> to the ses-smtp-user key)
$credentials = new-object Management.Automation.PSCredential -ArgumentList "<aws_access_key_id>", (Get-Content $PwFile | ConvertTo-SecureString -Key $key)
Send-MailMessage -From $email -to $email -cc $emailCC -Subject "AMI Status Check" -SmtpServer $SmtpServer -Port $SmtpPort -Credential $credentials -UseSsl -body $body -bodyashtml