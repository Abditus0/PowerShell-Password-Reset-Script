# Active Directory Password Reset Script

A PowerShell script for performing batch password resets in Active Directory environments with built-in safety features and comprehensive logging.

## Features
* Batch Processing: Reset multiple user passwords from a CSV file
* Safety Confirmation: Prompts user to confirm before making any changes <img width="600" height="39" alt="490798461-de013f04-8384-431c-ad4e-96673ec5b9f1" src="https://github.com/user-attachments/assets/3723b41e-993e-4ccf-894a-5814c16461ca" />  


* Comprehensive Logging: All actions are logged with timestamps to a file
* Error Handling: Gracefully handles and logs any failures during password reset
* Security Focus: Generated passwords are not displayed or logged
* Force Password Change: Users must change their password at next login

## Prerequisites

* Windows PowerShell 5.1 or PowerShell 7+
* Active Directory PowerShell module
* Administrator privileges on the domain
* CSV file with user accounts to process

## Setup

### 1. Prepare your CSV file:
   * Create a CSV file with a "Username" column header
   * List one username per row
   * Example format:

     Username

     john.doe
   
     jane.smith
   
     mike.johnson
     
<img width="294" height="383" alt="490798173-83576c7b-fd6b-4278-87bd-642c7297303d" src="https://github.com/user-attachments/assets/9aa26bc4-4168-4bc1-a9cb-349f7eb87657" />  


### 2. Update the script path:
  
  * Modify the $csvPath variable to point to your CSV file location
  * Default: C:\Users\administrator\Desktop\Users.csv

## Usage
    
1. Place your CSV file in the specified location
2. Run the script in PowerShell:

   .\PasswordReset.ps1
3. Review the number of users to be processed
4. Type "yes" to confirm and proceed, or anything else to cancel
5. Monitor the output for success/failure messages   <img width="941" height="245" alt="490800538-b8004834-c49e-47e8-ac9a-3e6661b1416f" src="https://github.com/user-attachments/assets/e1821bd0-39cd-465c-a589-9da00924b676" />  

6. Check the log file for a complete record: C:\PasswordReset.log  
   
  <img width="411" height="314" alt="490800934-fe00eb41-9da6-4a24-aa0d-ab667e485827" src="https://github.com/user-attachments/assets/903796f3-091b-405b-95bd-8574b218af0e" />  
  
  <img width="1004" height="332" alt="490800987-a1466825-94dc-4b59-9929-83c2eb54c6c6" src="https://github.com/user-attachments/assets/aa98789a-1d21-4357-a5fa-6686d7b6f804" />  



## Output 

### The script provides:

* Screen Output: Real-time status of each password reset
* Log File: Permanent record with timestamps of all operations
* Success Messages: Confirmation when passwords are reset successfully
* Error Messages: Detailed information when operations fail 

## Example Output

You are about to reset the password for 3 users. Continue? (Yes/No): yes

[SUCCESS] Password for john.doe has been reset on 17-09-2025 22:08:56. User must change it at next login.

[SUCCESS] Password for jane.smith has been reset on 17-09-2025 22:08:57. User must change it at next login.

[ERROR] Failed to reset password for mike.johnson - The specified account does not exist

## Security Notes
* Generated passwords are 12 characters long with at least 1 special character
* Temporary passwords are never displayed or logged for security
* Users are forced to change passwords at next login
* All operations are logged for audit purposes

## Error Handling

The script handles common scenarios:
* Missing or inaccessible CSV files
* Non-existent user accounts
* Permission-related errors

## Author

Created as part of a PowerShell learning portfolio to demonstrate:
* Active Directory management
* Error handling and logging
* User input validation
* Security best practices
  
## License

This project is open source and available under the MIT License.
