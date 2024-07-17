# Arcade-Check-In

Before starting make sure to update all paths in the code for the files and folders that need to be used.

## Steps & Descriptions

### Startup
Put **_StartupLaunch.bat_** into **_shell:startup_** folder to launch the main Form script with -Hidden style for powershell console window (it will show up underneath the form otherwise)

---

### Main script
The main script will show a maximized form which triggers ShutDown/LogOut if it loses focus (Alt + Tab, Closing etc.). 

If the user enters proper credentials and has time remaining, hide the form, write **logon time to file** and schedule shutdown to be after remaining minutes from the database.

---

### Shutdown script
Add script to Group Policy which sends shutdown timestamp, so that remaining minutes can be updated (_check out gpedit.msc Shutdown Scripts.txt for guide_). 

This script should append the current time (shutdown/logout time) to the **logon time file**, calculate the difference and send that to the database to update remaining minutes.
