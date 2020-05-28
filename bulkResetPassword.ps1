<#  
.SYNOPSIS  
    Resets password for multiple user accounts.  
 .INPUTS
    \e$\PowerShell_Scripts\input\BulkResetPW.csv
#>

Import-Module ActiveDirectory

$Users = Import-csv \\wnsvrmgt\e$\PowerShell_Scripts\input\BulkResetPW.csv


$minLength = 16  # characters
$maxLength = 20  # characters
$length = get-random -Minimum $minLength -Maximum $maxLength #get a random length between the minimum and max lengths
$nonAlphaChars = 5 
#generate pseudo random password
$password = [System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars)
#convert from plain text to secure string / encrypted string
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force

#$password = ConvertTo-SecureString (Read-Host "Enter a password 15 chars with CAPS, lower case, numbers & symbols") -AsPlainText -force

foreach ($item in $Users) {

    $login = $item.username
    Set-AdAccountPassword -Identity $login -Reset -NewPassword $securePassword
    Set-AdUser -Identity $login -ChangePasswordAtLogon $false
    #Set-ADUser -CannotChangePassword:$true            
    write-host $login - Password has been reset for $login

    #set a description if needed
    #Set-ADUser -Identity $item.username -Description "Reset password as per Senior IT Manager for security reasons"
}







