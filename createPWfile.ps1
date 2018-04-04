<# NOTE
You must have the SES password for user arn:aws:iam::<AWS_ACCOUNT>:user/<ses-smtp-user>
and place it between the quotes on line 10
#>

$PasswordFile = "PwFile.txt"
$KeyFile = "AES.key"
$Key = Get-Content $KeyFile
# Change ses-smtp-user password
$Password = "INSERT_SES_PASSWORD_HERE" | ConvertTo-SecureString -AsPlainText -Force
$Password | ConvertFrom-SecureString -key $Key | Out-File $PasswordFile