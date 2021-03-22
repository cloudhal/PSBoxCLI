PSBoxCLI
---------------------------

PowerShell wrapper module for the Box CLI
https://github.com/cloudhal/PSBoxCLI
www.cloudrun.co.uk

PowerShell wrapper module makes the Box CLI easier to use within PowerShell, converting from json and returning objects that you can easily manipulate using PowerShell.
Requires the Box CLI installed and configured as per https://developer.box.com/guides/tooling/sdks/cli/

Using the module
---------------------------

- Install and configure the Box CLI as per https://developer.box.com/guides/tooling/sdks/cli/
- Install this module: Install-Module -Name PSBoxCLI

This module is listed in the PowerShell gallery at https://www.powershellgallery.com/packages/PSBoxCLI/.

Example
---------------------------

Get all users
```
$users = Get-BoxAllUsers
$users | ft
```

Check what commands have been implemented:
```
Get-Command -Module PSBoxCLI
```

Contributing to this module
---------------------------

If you would like to add more commands from the Box CLI, add them to the functions file, copying an existing function as a template and sticking to approved verbs. Check the CLI documentation here for all possible BoxCLI commands  https://github.com/box/boxcli.

1. Clone this repo.
2. Import the module using e.g. Import-Module C:\Users\user\Documents\GitHub\PSBoxCLI
3. Edit the PS files as required.
4. Remove and import the module again and ensure there are no issues. Test your new function.
5. Create a pull request with your changes — we'll review it and get it merged, then update the in the PowerShell Gallery.


Commands implemented so far
---------------------------
- Get-BoxUser
- Get-BoxFolder
- Add-BoxCollaboration
- Move-BoxFolder
- Get-BoxFolderCollaborations
- Get-BoxFileCollaborations
- Remove-BoxCollaboration
- Remove-BoxShare
- Get-Boxfile
- Get-BoxGroup
- Get-BoxGroups
- Add-BoxGroupMember
- Remove-BoxGroupMember
- New-BoxFolder
- Get-BoxFolderContents
- Get-BoxGroupMember
- Get-BoxUsers
- Remove-BoxFolderSharingLink
- Remove-BoxFileSharingLink
- Remove-BoxUser

