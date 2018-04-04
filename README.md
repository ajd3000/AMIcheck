This powershell script is used to check for the most current Windows 2012r2, 2016, Amazon Linux and 
Ubuntu AWS AMIs. Once the list has been compiled it will send an email with the Name, ImageID and 
the CreationDate of each AMI.

There is also a checkAMI.sh script which can be used with cron.

Example crontab entry
0 10 * * 1,3,5 ~/scripts/checkAMI/checkAMI.sh

Requirements:
Powershell (Windows)
Powershell Core Edition (Linux/Mac)
AWS Tools for PowerShell (Windows)
AWS Tools for PowerShell Core Edition (Linux/Mac)
SES username and password

Setup steps
1. Clone this repo
2. Run the createKey.ps1 file
3. Modify the createPWfile.ps1 (Note you must have the SES password for user arn:aws:iam::<AWS_ACCOUNT>:user/<ses-smtp-user>)
4. Run createPWfile.ps1
5. Change email address ($email="<user@email.com>" and $emailCC="<user2@email.com>")
6. Change the aws_access_key_id for the ses-smtp-user 
6. Run AMIcheck.ps1

Steps for cron job
1. Follow steps 1-5 from above
2. Set crontab entry (crontab -e)
3. Wait for cronjob to execute