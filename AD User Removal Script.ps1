# Import the Active Directory module
Import-Module ActiveDirectory

# Define colors for messages
$infoColor = "Blue"
$errorColor = "Red"
$warningColor = "Yellow"

# Request the login of the target user
$targetUser = Read-Host "Enter the login of the target user"
Write-Host "User $targetUser will be removed from the specified groups." -ForegroundColor $infoColor

# Get the user object
$user = Get-ADUser -Identity $targetUser -Properties MemberOf

if ($user) {
    Write-Host "User $($user.SamAccountName) found." -ForegroundColor $infoColor
    
    # Get the list of groups the user is a member of
    $userGroups = @()
    foreach ($groupDN in $user.MemberOf) {
        try {
            $group = Get-ADGroup -Identity $groupDN
            $userGroups += $group
        } catch {
            Write-Host "Error retrieving group $groupDN" -ForegroundColor $errorColor
            # Check if the group exists using Get-ADObject
            try {
                $groupObject = Get-ADObject -Identity $groupDN
                if ($groupObject) {
                    Write-Host "Group $groupDN exists but is not an AD group." -ForegroundColor $warningColor
                } else {
                    Write-Host "Error checking existence of group $groupDN" -ForegroundColor $errorColor
                }
            } catch {
                Write-Host "Error checking existence of group $groupDN" -ForegroundColor $errorColor
            }
        }
    }

    # Display a numbered list of groups
    $groupList = @()
    for ($i = 0; $i -lt $userGroups.Count; $i++) {
        $groupList += @{Index = $i + 1; Name = $userGroups[$i].Name}
        Write-Host "$($i + 1): $($userGroups[$i].Name)" -ForegroundColor $infoColor
    }

    # Request group numbers to remove
    Write-Host "Enter the numbers of the groups to remove (separated by commas) or 'n' to cancel:" -ForegroundColor $warningColor
    $groupsToRemoveInput = Read-Host
    
    if ($groupsToRemoveInput -eq 'n') {
        Write-Host "Script operation cancelled." -ForegroundColor $warningColor
        Write-Host "Script completed. Press Enter to exit..." -ForegroundColor $infoColor
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit
    }

    $groupsToRemoveIndexes = $groupsToRemoveInput -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ }

    # Filter groups by entered numbers
    $groupsToRemove = $groupList | Where-Object { $groupsToRemoveIndexes -contains $_.Index } | ForEach-Object { $_.Name }

    if ($groupsToRemove.Count -eq 0) {
        Write-Host "Incorrect group numbers entered. Removal cancelled." -ForegroundColor $warningColor
    } else {
        Write-Host "User $($user.SamAccountName) will be removed from the following groups: $($groupsToRemove -join ', ')" -ForegroundColor $infoColor

        # Request confirmation to remove
        Write-Host "Remove user $($user.SamAccountName) from the selected groups? (y/n)" -ForegroundColor $warningColor
        $confirmation = Read-Host
        if ($confirmation -eq 'y') {
            foreach ($groupName in $groupsToRemove) {
                try {
                    # Remove user from the group
                    Write-Host "Removing user $($user.SamAccountName) from group $groupName..." -ForegroundColor $infoColor
                    Remove-ADGroupMember -Identity $groupName -Members $user -Confirm:$false
                    Write-Host "User $($user.SamAccountName) removed from group $groupName" -ForegroundColor $infoColor
                } catch {
                    Write-Host "Error removing user $($user.SamAccountName) from group ${groupName}: $_" -ForegroundColor $errorColor
                }
            }
        } else {
            Write-Host "Removal cancelled." -ForegroundColor $warningColor
        }
    }
} else {
    Write-Host "User $targetUser not found" -ForegroundColor $errorColor
}

# Confirmation to close after script execution
Write-Host "Script completed. Press Enter to exit..." -ForegroundColor $infoColor
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")