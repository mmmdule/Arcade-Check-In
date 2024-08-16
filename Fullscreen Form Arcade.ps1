#Log console output to log file
Start-Transcript -Path "C:\Logs\PowerShell_Log.txt"

#Used to track logon status
"" | Out-File -FilePath C:\Code\logoff\username.txt -NoNewline

# Load the necessary assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationCore,PresentationFramework

# Create a form
$form = New-Object System.Windows.Forms.Form
$form.WindowState = [System.Windows.Forms.FormWindowState]::Maximized  # Maximize the form
$form.ControlBox = $false  # Hide the control box (minimize, maximize, close buttons)
$form.Text = "" #Removes title bar completely

# Add a panel to hold the controls 				(this can be skipped, controls can be added directly to form)
$panel = New-Object System.Windows.Forms.Panel
$panel.Dock = [System.Windows.Forms.DockStyle]::Fill
$form.Controls.Add($panel)

# Add labels
$labelUsername = New-Object System.Windows.Forms.Label
$labelUsername.Text = "Username:"
$labelUsername.Location = New-Object System.Drawing.Point(20, 20)
$labelUsername.AutoSize = $true
$panel.Controls.Add($labelUsername)

$labelPassword = New-Object System.Windows.Forms.Label
$labelPassword.Text = "Password:"
$labelPassword.Location = New-Object System.Drawing.Point(20, 60)
$labelPassword.AutoSize = $true
$panel.Controls.Add($labelPassword)

# Add textboxes
$textBoxUsername = New-Object System.Windows.Forms.TextBox
$textBoxUsername.Location = New-Object System.Drawing.Point(100, 20)
$textBoxUsername.Width = 250
$panel.Controls.Add($textBoxUsername)

$textBoxPassword = New-Object System.Windows.Forms.TextBox
$textBoxPassword.Location = New-Object System.Drawing.Point(100, 60)
$textBoxPassword.Width = 250
$textBoxPassword.PasswordChar = "*"  # Mask the password input
$panel.Controls.Add($textBoxPassword)

# Add a Submit button
$buttonSubmit = New-Object System.Windows.Forms.Button
$buttonSubmit.Text = "Submit"
$buttonSubmit.Location = New-Object System.Drawing.Point(100, 100)
$panel.Controls.Add($buttonSubmit)

$loggedIn = $false #to track user status

# Event handler for form losing focus
$form.add_Deactivate({
    Write-Host "Form lost focus. Executing code..."
    Write-Host "Logged in boolean value:"
    Write-Host $loggedIn

    $loggedInTxt = Get-Content C:\Code\logoff\username.txt
    Write-Host "Content of username.txt:"
    Write-Host $loggedInTxt
    if(!$loggedInTxt){ #$loggedIn -eq $false){
        ii . #logoff
    }
    # Your code here
})


# Event handler for button click
$buttonSubmit.add_Click({
    
    # Send request to check credentials
    
    # If credentials check out and user has time left
        # Write txt file with user submit time
        #$loginDateTime = Get-Date -format "dd-mm-yyyy HH:mm:ss"
        #$loginDateTime | Out-File -FilePath "D:\Code\ArcadeTimestamp.txt"
        
        
        
        # $form.Hide()
        # Shutdown/Logout Windows after X minutes (minutes based on server response)
        $hash = @{ username = $textBoxUsername.Text; password = $textBoxPassword.Text }

        $JSON = $hash | convertto-json 

        $Response = Invoke-WebRequest -uri "https://crispy-space-umbrella-9rgj7xprq56f76jw-3000.app.github.dev/gameLogin" `
                    -Method POST -Body $JSON -ContentType "application/json"

        Write-Host $Response.Content
        if ($Response.Content -eq 'Valid login.'){
            $loggedIn = $true #To prevent Shutdown/Logout on form losing focus after login
            
            $textBoxUsername.Text | Out-File -FilePath C:\Code\logoff\username.txt -NoNewline

            $msgBody = "Successful login."
            [System.Windows.MessageBox]::Show($msgBody)
            $form.Close()
        }
        else{
            "tmp"| Out-File -FilePath C:\Code\logoff\username.txt -NoNewline #to prevent logoff on failure MsgBox

            $loggedIn = $true
            $msgBody = "Invalid login"
            [System.Windows.MessageBox]::Show($msgBody)
            $loggedIn = $false

            ""| Out-File -FilePath C:\Code\logoff\username.txt -NoNewline
        }
})

# Show the form
$form.ShowDialog()
