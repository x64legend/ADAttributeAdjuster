# Retrieves the desired user
$userSamAccountName = Read-host "Enter the samaccountname of a user that needs to have their proxyaddresses and other mail attributes updated"
$path = Read-Host "Please assign a path"

# Stores previous attibutes
Write-Host "Storing previous attributes for safe keeping..."
$previousAttributes = Get-ADuser $userSamAccountName -Properties *
$previousAttributes | Export-Csv "$path\$userSamAccountName-PreviousGroups.csv" -NoTypeInformation

# Displays previous attributes
Get-ADuser $userSamAccountName -properties DisplayName,SamAccountName,Mail,MailNickname,Proxyaddresses | Select-Object DisplayName,SamAccountName,Mail,MailNickname,Proxyaddresses

# Switch to indicate whether attributes should be adjusted or not
$userInput = Read-Host "Attributes retrieved. Would you like to set the attibutes of this user to match the samaccountname? (y/n)" 
switch ($userInput) {
    "y" { # Sets the attibutes
        Write-Host "Adjusting mailnickname..." -ForegroundColor Yellow
        Set-ADUser $userSamAccountName -Replace @{MailNickname="$userSamAccountName"} 
        Write-Host "Done!" -ForegroundColor Green

        Write-Host "Adjusting Proxyaddresses..." -ForegroundColor Yellow
        Set-ADUser $userSamAccountName -Replace @{ProxyAddresses="SMTP:$userSamAccountName@octanner.com,smtp:$usersamaccountname@octanner365.onmicrosoft.com" -split ","} 
        Write-Host "Done!" -ForegroundColor Green

        
        Write-Host "Adjusting mail..." -ForegroundColor Yellow
        Set-ADUser $userSamAccountName -Replace @{mail="$userSamAccountName@octanner.com"} 
        Write-Host "Done!" -ForegroundColor Green        

        Write-Host "New Attribtues..." -ForegroundColor Blue
        Get-ADuser $userSamAccountName -properties DisplayName,SamAccountName,Mail,MailNickname,Proxyaddresses | Select-Object DisplayName,SamAccountName,Mail,MailNickname,Proxyaddresses
      }
    "n" { # Does not set the attributes
        Write-Host "No action taken!"
    }
    Default { # Default response
        Write-Host "Please enter a valid selection!"
    }
}