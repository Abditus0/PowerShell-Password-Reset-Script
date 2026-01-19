# PasswordReset.ps1
# Batch password reset script for Active Directory users
# Forces users to change password at next logon

# Custom function to handle both screen output and file logging
function Write-Log {
	param([string]$Message)
	Write-Host $Message
	Add-Content -Path "C:\PasswordReset.log" -Value $Message
}

# Path to CSV file with usernames
$csvPath = "C:\Users\administrator\Desktop\Users.csv"

# Check if the CSV exists before importing
if (-not (Test-Path $csvPath)) {
	Write-Log "CSV file not at path: $csvPath"
	exit
}

# Import users from CSV
$users = Import-Csv $csvPath

# Ask user for confirmation before proceeding with password resets
$answer = Read-Host "You are about to reset the password for $($users.Count) users. Continue? (Yes/No)"
if ($answer -eq "yes") {
} else {
exit
}

# Loop through each user in the CSV file
foreach ($user in $users) {
    $username = $user.Username

    # Generate a random 12-character password with 1 special char
    Add-Type -AssemblyName System.Web
    $newPassword = [System.Web.Security.Membership]::GeneratePassword(12,1)

    try {
        # Reset password in Active Directory
        Set-ADAccountPassword -Identity $username -Reset -NewPassword (ConvertTo-SecureString $newPassword -AsPlainText -Force)

        # Force password change at next login
        Set-ADUser -Identity $username -ChangePasswordAtLogon $true

        # Output confirmation (don’t expose password)
        Write-Log "[SUCCESS] Password for $username has been reset on $(Get-Date -Format 'dd-MM-yyyy HH:mm:ss'). User must change it at next login."
    }
    catch {
	# Handle any errors that occur during password reset
	Write-Log "[ERROR] Failed to reset password for $username - $($_.Exception.Message)"
    }
}
