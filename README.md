# Active Directory Password Reset Script

A PowerShell script for performing batch password resets in Active Directory environments with built-in safety features and comprehensive logging.

## Features
* Batch Processing: Reset multiple user passwords from a CSV file
* Safety Confirmation: Prompts user to confirm before making any changes
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

### 2. Update the script path:
  
  * Modify the $csvPath variable to point to your CSV file location
  * Default: C:\Users\administrator\Desktop\Users.csv

### Usage
    
1. Place your CSV file in the specified location
2. Run the script in PowerShell:

   .\PasswordReset.ps1
3. Review the number of users to be processed
4. Type "yes" to confirm and proceed, or anything else to cancel
5. Monitor the output for success/failure messages
6. Check the log file for a complete record: C:\PasswordReset.log
   
## Output 

### The script provides:

* Screen Output: Real-time status of each password reset
* Log File: Permanent record with timestamps of all operations
* Success Messages: Confirmation when passwords are reset successfully
* Error Messages: Detailed information when operations fail 

### Example Output

You are about to reset the password for 3 users. Continue? (Yes/No): yes

[SUCCESS] Password for john.doe has been reset on 17-09-2025 22:08:56. User must change it at next login.

[SUCCESS] Password for jane.smith has been reset on 17-09-2025 22:08:57. User must change it at next login.

[ERROR] Failed to reset password for mike.johnson - The specified account does not exist

### Security Notes
* Generated passwords are 12 characters long with at least 1 special character
* Temporary passwords are never displayed or logged for security
* Users are forced to change passwords at next login
* All operations are logged for audit purposes

### Error Handling

The script handles common scenarios:
* Missing or inaccessible CSV files
* Non-existent user accounts
* Permission-related errors

### Author

Created as part of a PowerShell learning portfolio to demonstrate:
* Active Directory management
* Error handling and logging
* User input validation
* Security best practices
  
### License

This project is open source and available under the MIT License.
