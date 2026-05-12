# Active Directory Password Reset Script

A PowerShell script that takes a CSV file of usernames and resets all their Active Directory passwords in one go. Each user gets a unique 12-character password with at least one special character, gets forced to change it at next login, and the whole run gets logged with timestamps. Passwords themselves never get printed to the screen or written to the log.

I wrote this because resetting passwords one at a time in Active Directory Users and Computers is fine if you have couple of users. It stops being fine the moment you have a lot. A CSV-driven script turns a long manual job into a 30-second batch operation.

## What it does

You give it a CSV with a `Username` column. The script reads the file, tells you how many users it's about to reset, and waits for a confirmation prompt before touching anything. Type "yes" and it goes. Type anything else and it bails out without making changes.

For each user, it generates a strong random password, runs the AD password reset, and forces a change at next login. Successes and failures both get written to a log file with a timestamp. If one user fails (account doesn't exist, locked, permission issue), the script logs the error and moves on. One bad row doesn't kill the whole batch.

The generated passwords are never shown on screen or saved to disk. The admin running the script can't accidentally leak them, and there's no log file to worry about cleaning up later. Users will be locked out until they change their password at first login, which is on purpose. The point of the script is that the password is temporary by design.

## How a run looks

Once you start the script, it counts the rows in the CSV and asks if you want to continue.

<img width="600" height="39" alt="Confirmation prompt before running" src="https://github.com/user-attachments/assets/3723b41e-993e-4ccf-894a-5814c16461ca">

The CSV itself is one column with a `Username` header. One username per row, nothing else needed.

<img width="294" height="383" alt="CSV file with usernames" src="https://github.com/user-attachments/assets/9aa26bc4-4168-4bc1-a9cb-349f7eb87657">

After you confirm, the script processes each user and prints the result line by line. Successes and errors are both visible in the terminal as it runs.

<img width="941" height="245" alt="Script output during a run" src="https://github.com/user-attachments/assets/e1821bd0-39cd-465c-a589-9da00924b676">

Every action also gets written to the log file at `C:\PasswordReset.log`. Every line is timestamped so you have a permanent record of who got reset and when.

<img width="411" height="314" alt="Log file output" src="https://github.com/user-attachments/assets/903796f3-091b-405b-95bd-8574b218af0e">

<img width="1004" height="332" alt="Detailed log entries" src="https://github.com/user-attachments/assets/aa98789a-1d21-4357-a5fa-6686d7b6f804">

Sample log entries:

```
[SUCCESS] Password for john.doe has been reset on 17-09-2025 22:08:56. User must change it at next login.
[SUCCESS] Password for jane.smith has been reset on 17-09-2025 22:08:57. User must change it at next login.
[ERROR] Failed to reset password for mike.johnson - The specified account does not exist
```

## How to use it

1. Create a CSV file with a `Username` column and one username per row.
2. Open the script and set `$csvPath` to the path of your CSV (default is `C:\Users\administrator\Desktop\Users.csv`).
3. Run from PowerShell with domain admin rights: `.\PasswordReset.ps1`
4. Confirm at the prompt.
5. Check the log at `C:\PasswordReset.log` afterwards.

Requires PowerShell 5.1 or 7+ and the Active Directory module installed on the machine you're running it from.

## Problems I had to solve

**Generated passwords showing up in the wrong places.** First version of the script printed the new password to the terminal so I could verify it worked. Then I realized that's a terrible idea because anyone shoulder-surfing the admin sees it, and if you scroll back in PowerShell history later, it's still there. Stripped all password output from both the screen and the log. The point is that nobody knows the password except the user at first login.

**Errors that killed the whole script.** If the script hit a non-existent username or a locked-out account, it would die there and leave the rest of the CSV untouched. Wrapped the reset call in try/catch so errors get logged and the script keeps going. Summary at the end tells you how many failed so you can deal with them after.

**Confirmation prompt was too easy to fly past.** Originally it accepted "y" or just hitting enter. That's the kind of thing where you tab through a script half-asleep at 9am and accidentally reset 200 passwords. Changed it to require typing "yes" in full. A small friction that forces you to think before pulling the trigger.

## What I learned

The biggest thing was how careful you have to be with anything that touches a lot of accounts at once. A script that resets one password is fine. A script that resets 50 passwords needs a confirmation prompt, error handling that doesn't fail the whole batch, and a log file so you can prove what happened later. The blast radius gets bigger the more automation you add.

Other things that came out of this:

- AD's `Set-ADAccountPassword` works fine with a `SecureString`, which means you never have to handle the password as plaintext in memory longer than you need to.
- Forcing a password change at next login (`Set-ADUser -ChangePasswordAtLogon $true`) is one line and should always be paired with a script-generated password. Otherwise the user can keep using whatever you set forever.
- Always log to a file, not just the screen. PowerShell terminal output is gone the moment you close the window. A log file is evidence.

## Why I built it

Mass password resets are one of those things that come up in real IT work and there isn't really a built-in tool for it. You can do it manually in ADUC, but only if you have an afternoon to kill. Most admins end up writing a version of this script eventually. Now I've written one with the safety rails I'd want if I ran it in production: confirmation prompt, no plaintext output, full audit log, errors that don't kill the batch.
