Function Get-BoxUser{
    Param ([string]$email,[string]$userID)

    if ($email) {
$user = box users --filter=$email --json | ConvertFrom-Json
if ($user) {
    write-host "Found Box user matching email address $email"
    return $user
            }
else {
    write-host "Error: User with email address $email was not found in Box" -ForegroundColor Red
    }
}
if ($userID) {
    $user = box users:get $userID --json | ConvertFrom-Json
    if ($user) {
        write-host "Found Box user matching userID $userID"
        return $user
                }
    else {
        write-host "Error: User with userID  $userID was not found in Box" -ForegroundColor Red
        }
    }

<#
.SYNOPSIS
Gets the Box User details from an email address or UserID.

.DESCRIPTION
Gets the Box User details from an email address or UserID using Box CLI.
Get the user directly using User ID, or search using their email address. Returns an object with all the Box user details.

.PARAMETER email
Specifies the users email address

.PARAMETER userID
Specifies the users Box ID

.INPUTS
Email address, Box UserID

.OUTPUTS
Object containing details of the Box user.

Properties:

type
id
name
login
created_at
modified_at
language
timezone
space_amount
space_used
max_upload_size
status
job_title
phone
address
avatar_url
notification_email

.EXAMPLE
PS> Get-BoxUser -email "user@domain.com"

.EXAMPLE
PS> Get-BoxUser -userID "11111"

#>
}

Function Get-BoxAllUsers{

box users --filter= --json | ConvertFrom-Json

<#
.SYNOPSIS
Gets all Box users.

.DESCRIPTION
Gets all Box users.

.INPUTS
None

.OUTPUTS
Array containing all Box users.

Properties:

id
name
login
created_at
modified_at
language
timezone
space_amount
space_used
max_upload_size
status
job_title

.EXAMPLE
PS> Get-BoxUsers | ft

.EXAMPLE
PS> $users = Get-BoxUsers
$users | ft

#>
}


Function Remove-BoxUser{
    Param ([Parameter(Mandatory=$true)][string]$userID,[bool]$force)

if ($force) {
    box users:delete $userID --json --force | ConvertFrom-Json
}
else { 
    box users:delete $userID --json | ConvertFrom-Json
}

<#
.SYNOPSIS
Deletes a Box User account using the Box UserID. Default is not to force delete if the user still has files.

.DESCRIPTION
Deletes a Box User account using the Box UserID. Adding -force $true will force delete, even if the user still has files. 

.PARAMETER userID
Specifies the users Box ID (mandatory).

.PARAMETER force
If set to true forces deletion, even if the user has files.

.INPUTS
Box UserID

.OUTPUTS
None

.EXAMPLE
PS> Remove-BoxUser -userID "11111" -force $true

#>
}

Function Get-BoxGroup{
    Param ([string]$groupID)

    $group = box groups:get $groupID --json | ConvertFrom-Json
    if ($group) {
        write-host "Found Box group $groupID"
        return $group
                }
    else {
        write-host "Error: Group with ID  $groupID was not found in Box" -ForegroundColor Red
        exit
        }


<#
.SYNOPSIS
Gets the Box Group details from a group ID. 

.DESCRIPTION
Gets the Box Group details from a group ID using Box CLI.
Use Get-BoxGroups to get all box groups and find the ID first.

.PARAMETER groupID
Specifies the group ID

.INPUTS
groupID

.OUTPUTS
Object containing details of the Box group.

.EXAMPLE
PS> Get-BoxGroup -groupID "11111"

#>
}


Function Get-BoxGroups{

    $groups = box groups --json | ConvertFrom-Json
    if ($groups) {
        return $groups
                }
    else {
        write-host "Error: No groups found" -ForegroundColor Red
        exit
        }

<#
.SYNOPSIS
Gets all Box Groups

.DESCRIPTION
Gets all Box Group using Box CLI.
There are no input parameters.

.OUTPUTS
Object containing details of all Box groups.

.EXAMPLE
PS> Get-BoxGroups

#>
}

Function Add-BoxGroupMember{
    Param ([string]$userID,[string]$groupID)
    box groups:memberships:add $userID $groupID --json | ConvertFrom-Json

<#
.SYNOPSIS
Adds a user to a group

.DESCRIPTION
Adds a user to a group
Requires userid ad groupid

.PARAMETER userID
Specifies the Box user ID

.PARAMETER groupID
Specifies the Box group ID

.INPUTS
groupID

.INPUTS
userID

.OUTPUTS
Object containing details of the Box group.

.EXAMPLE
PS> Add-BoxGroupMember -userID "11111" -groupID "22222"

#>
}


Function Get-BoxGroupMember{
    Param ([string]$groupID)
    $users = box groups:memberships $groupID --json | ConvertFrom-Json
if (!$users) {write-host "No group members found"} else {return $users}
<#
.SYNOPSIS
Gets the members of a Box group

.DESCRIPTION
Gets the members of a Box group using the BoxCLI

.PARAMETER groupID
Specifies the Box group ID

.INPUTS
groupID

.OUTPUTS
Object containing details of the Box group members.

.EXAMPLE
PS> Get-BoxGroupMember -groupID "11111"

#>
}


Function Remove-BoxGroupMember{
    Param ([string]$membershipID)
    box groups:memberships:remove $membershipID --json | ConvertFrom-Json

<#
.SYNOPSIS
Removes a user from a group

.DESCRIPTION
Removes a user from a group
Requires the membership ID, suggest to get this when you add the user to the group

.PARAMETER membershipID
Specifies the ID of the group membership

.INPUTS
membershipID

.OUTPUTS

.EXAMPLE
PS> $addgroup = Add-BoxGroupMember -userID $boxuser.id -GroupID "5736585174"
PS> Remove-BoxGroupMember -membershipID $addgroup.id

#>
}

Function Get-BoxFolder{
    Param ([Parameter(Mandatory=$true)][string]$folderID,[string]$asuserID)

    if ($asuserID) {
$folder = box folders:get $folderID --as-user=$asuserID --json | ConvertFrom-Json
}
else {
    $folder = box folders:get $folderID --json | ConvertFrom-Json
}
if ($folder) {
    write-host "Found Box folder $folderID"
    return $folder
            }
else {
    write-host "Error: The Box folder $folderID was not found" -ForegroundColor Red
    }
<#
.SYNOPSIS
Gets a Box folder info from the ID using Box CLI.

.DESCRIPTION
Gets a Box folder info from the ID using Box CLI.
Requires the Box folder ID and the optionally the asuserID as inputs.

.PARAMETER folderID
Specifies the Box folder ID (mandatory).

.PARAMETER asuserID
Specifies the Box user ID (optional).

.INPUTS
Box Folder ID, Box As-User ID.

.OUTPUTS
Returns an arrary containg the Box folder info.

.EXAMPLE
PS> Get-BoxFolder -folderID "11111" -asuserID "22222"

#>
}


Function Remove-BoxFolderSharingLink{
    Param ([Parameter(Mandatory=$true)][string]$folderID,[string]$asuserID)

    if ($asuserID) {
$folder = box folders:unshare $folderID --as-user=$asuserID --json | ConvertFrom-Json
}
else {
    $folder = box folders:unshare $folderID --json | ConvertFrom-Json
}

<#
.SYNOPSIS
Removes a sharing link from a Box folder.

.DESCRIPTION
Removes a sharing link from a Box folder.
Requires the Box folder ID and optionally the AsUserID

.PARAMETER folderID
Specifies the Box folder ID (mandatory).

.PARAMETER asuserID
Specifies the Box as-user ID (optional).

.INPUTS
Box Folder ID, Box As-User ID.

.OUTPUTS
None

.EXAMPLE
PS> Remove-BoxFolderSharingLink -folderID "11111" -asuserID "22222"

#>
}

Function Remove-BoxFileSharingLink{
    Param ([Parameter(Mandatory=$true)][string]$fileID,[string]$asuserID)

    if ($asuserID) {
$file = box files:unshare $fileID --as-user=$asuserID --json | ConvertFrom-Json
}
else {
    $file = box files:unshare $fileID --json | ConvertFrom-Json
}

<#
.SYNOPSIS
Removes a sharing link from a Box file.

.DESCRIPTION
Removes a sharing link from a Box file.
Requires the Box folder ID.

.PARAMETER folderID
Specifies the Box file ID (mandatory).

.PARAMETER asuserID
Specifies the Box as-user ID (optional).

.INPUTS
Box file ID, Box As-User ID.

.OUTPUTS
None

.EXAMPLE
PS> Remove-BoxFileSharingLink -folderID "11111" -asuserID "22222"

#>
}

Function Get-BoxFolderContents{
    Param ([Parameter(Mandatory=$true)][string]$folderID,[string]$asuserID)
if ($asuserID) {
    box folders:items $folderID --as-user $asuserID --json | ConvertFrom-Json
}
else {
    box folders:items $folderID --json | ConvertFrom-Json
}
<#
.SYNOPSIS
Gets the contents of a Box folder from the folder ID using Box CLI.

.DESCRIPTION
Gets the contents of a Box folder from the ID using Box CLI.

.PARAMETER folderID
Specifies the Box folder ID (mandatory).

.PARAMETER asuserID
Specifies the Box as-user ID (optional).

.INPUTS
Box Folder ID

.OUTPUTS
Returns an arrary containg the Box folder contents

.EXAMPLE
PS> Get-BoxFolderContents -folderID "11111"

.EXAMPLE
PS> Get-BoxFolderContents -folderID "11111" -asuserID "22222"

#>
}
Function New-BoxFolder{
    Param ([Parameter(Mandatory=$true)][string]$parentID,[Parameter(Mandatory=$true)][string]$Name)

    box folders:create $parentID $Name --json | ConvertFrom-Json
<#
.SYNOPSIS
Creates a new Box folder using parent folder ID and Name

.DESCRIPTION
Creates a new Box folder using parent folder ID and Name

.PARAMETER parentID
Specifies the parent Box folder ID (mandatory).

.PARAMETER Name
Specifies the name of the folder to create

.INPUTS
Parent Folder ID, Name

.OUTPUTS
Returns an arrary containg the Box folder info.

.EXAMPLE
PS> New-BoxFolder -parentID "11111" -Name "New folder"

#>
}


Function Remove-BoxShare{
    Param ([Parameter(Mandatory=$true)][string]$folderID,[string]$asuserID)

    if ($asuserID) {
    box folders:unshare $folderID --as-user=$asuserID --json | ConvertFrom-Json
}
else {
    box folders:unshare $folderID --json | ConvertFrom-Json
}

<#
.SYNOPSIS
Removes any shared links for a folder.

.DESCRIPTION
Removes any shared links for a folder.
Requires the Box folder ID and the user ID as inputs.

.PARAMETER folderID
Specifies the Box folder ID (mandatory).

.PARAMETER asuserID
Specifies the Box user ID. 0 is the default (current user) (optional).

.INPUTS
Box Folder ID, Box As-User ID.

.OUTPUTS
None

.EXAMPLE
PS> Remove-BoxShare -folderID "11111" -asuserID "22222"

#>
}

Function Get-BoxFolderCollaborations{
    Param ([Parameter(Mandatory=$true)][string]$folderID,[string]$asuserID)
if ($asuserID) {
$folder = box folders:collaborations $folderID --as-user=$asuserID --json | ConvertFrom-Json
}
else {
    $folder = box folders:collaborations $folderID --json | ConvertFrom-Json
}
if ($folder) {
    return $folder
            }
else {
    write-host "Error: No collaborations were found on folder $folderID" -ForegroundColor Red
    #exit
    }
<#
.SYNOPSIS
Gets the collaborations on a Box folder info from the ID using Box CLI.

.DESCRIPTION
Gets the collaborations on a Box folder info from the ID using Box CLI.
Requires the Box folder ID, optionally as-user.

.PARAMETER folderID
Specifies the Box folder ID (mandatory).

.PARAMETER asuserID
Specifies the Box user ID. 0 is the default (current user) (optional).

.INPUTS
Box Folder ID, Box As-User ID.

.OUTPUTS
Returns an arrary containg the Box folder collaborations

.EXAMPLE
PS> Get-BoxFolderCollaborations -folderID "11111" -asuserID "22222"

.EXAMPLE
PS> Get-BoxFolderCollaborations -folderID "11111" -asuserID "22222" | Where-Object {$_.accessible_by -like "*user@domain.com*"}

#>
}

Function Add-BoxCollaboration{
    Param ([Parameter(Mandatory=$true)][string]$folderID,[Parameter(Mandatory=$true)][string]$role,$userID,$groupID,$asuserID)
if ($userID) {
    if ($asuserID) {
    box folders:collaborations:add $folderID --role $role --user-id $userID --as-user $asuserID
}
else {
    box folders:collaborations:add $folderID --role $role --user-id $userID 
}
}
elseif ($groupID) {
    if ($asuserID) {
        box folders:collaborations:add $folderID --role $role --group-id $groupID --as-user $asuserID
    }
        else {
            box folders:collaborations:add $folderID --role $role --group-id $groupID
        }
}
}

Function Get-BoxFileCollaborations{
    Param ([Parameter(Mandatory=$true)][string]$fileID,[string]$asuserID)
if ($asuserID) {
$file = box files:collaborations $fileID --as-user=$asuserID --json | ConvertFrom-Json
}
else {
    $file = box files:collaborations $fileID --json | ConvertFrom-Json
}
if ($file) {
    return $file
            }
else {
    write-host "Error: The Box file $fileID was not found" -ForegroundColor Red
    exit
    }
<#
.SYNOPSIS
Gets the collaborations on a Box file info from the ID using Box CLI.

.DESCRIPTION
Gets the collaborations on a Box file info from the ID using Box CLI.
Requires the Box folder ID, optionally as-user.

.PARAMETER folderID
Specifies the Box file ID (mandatory).

.PARAMETER asuserID
Specifies the Box user ID. 0 is the default (current user) (optional).

.INPUTS
Box file ID, Box As-User ID.

.OUTPUTS
Returns an arrary containg the Box file collaborations

.EXAMPLE
PS> Get-BoxFileCollaborations -folderID "11111" -asuserID "22222"

.EXAMPLE
PS> Get-BoxFileCollaborations -folderID "11111" -asuserID "22222" | Where-Object {$_.accessible_by -like "*user@domain.com*"}

#>
}

Function Add-BoxCollaboration{
    Param ([Parameter(Mandatory=$true)][string]$folderID,[Parameter(Mandatory=$true)][string]$role,$userID,$groupID,$asuserID)
if ($userID) {
    if ($asuserID) {
    box folders:collaborations:add $folderID --role $role --user-id $userID --as-user $asuserID
}
else {
    box folders:collaborations:add $folderID --role $role --user-id $userID 
}
}
elseif ($groupID) {
    if ($asuserID) {
        box folders:collaborations:add $folderID --role $role --group-id $groupID --as-user $asuserID
    }
        else {
            box folders:collaborations:add $folderID --role $role --group-id $groupID
        }
}

<#
.SYNOPSIS
Adds a user or group to be a collaborator on a Box folder.

.DESCRIPTION
Adds a user or group to be a collaborator on a Box folder.
Specify target folder, role, userid or groupid to add, and as-user id with existing access.

.PARAMETER folderID
Specifies the Box folder ID (mandatory).

.PARAMETER role
The role to assign to the collaborator (mandatory).
Valid values are:
editor|viewer|previewer|uploader|previewer_uploader|viewer_uploader|co-owner

.PARAMETER userID
Specifies the Box user ID to add as a collaborator (mandatory).

.PARAMETER asuserID
Specifies the as-user Box user ID. 0 is the default (current user) (optional).

.OUTPUTS
Returns an arrary containg the Box folder info.

.EXAMPLE
PS> Add-BoxCollaboration -folderID "11111" -role "viewer" -userID "22222" -asuserID "33333"

.EXAMPLE
PS> Add-BoxCollaboration -folderID "11111" -role "co-owner" -groupID "44444" -asuserID "33333"

#>
}

Function Move-BoxFolder{
    Param ([Parameter(Mandatory=$true)][string]$folderID,[Parameter(Mandatory=$true)][string]$parentID,$asuserID)

    box folders:move $folderID $parentID --as-user $asuserID

<#
.SYNOPSIS
Moves a Box folder to another one.

.DESCRIPTION
Moves a Box folder to another one.
Destination parent folder must already exist.

.PARAMETER folderID
Specifies the Box folder ID (mandatory).

.PARAMETER parentID
The ID of the destination folder. This becomes the new parent.

.PARAMETER asuserID
Specifies the as-user Box user ID (optional).

.OUTPUTS
None

.EXAMPLE
PS> Move-BoxFolder -folderID "11111" -parentID "22222" -asuserID "33333"

#>
}

Function Remove-BoxCollaboration{
    Param ([Parameter(Mandatory=$true)][string]$collaborationID,[string]$asuserID)
if ($asuserID) {
    box collaborations:delete $collaborationID --as-user $asuserID
}
else {
    box collaborations:delete $collaborationID
}
<#
.SYNOPSIS
Deletes a collaboration on files or folders.

.DESCRIPTION
Deletes a collaboration on a file or folder using the collaboration ID.
Get the collaboration using Get-BoxFolderCollaborations

.PARAMETER collaborationID
Specifies the collaboration ID to remove (mandatory).

.PARAMETER asuserID
Specifies the as-user Box user ID (optional).

.OUTPUTS
None

.EXAMPLE
PS> Remove-BoxCollaboration -collaborationID "22222" -asuser "11111"

#>
}

Function Get-BoxFile{
    Param ([Parameter(Mandatory=$true)][string]$fileID,[string]$asuserID)

    if ($asuserID) {
$file = box files:get $fileID --as-user=$asuserID --json | ConvertFrom-Json
}
else {
    $file = box folders:get $fileID --json | ConvertFrom-Json
}
if ($file) {
    write-host "Found Box file $fileID"
    return $file
            }
else {
    write-host "Error: The Box file $fileID was not found" -ForegroundColor Red
    }
<#
.SYNOPSIS
Gets a Box file info from the ID using Box CLI.

.DESCRIPTION
Gets a Box foldfileer info from the ID using Box CLI.
Requires the Box file ID and the user ID as inputs.

.PARAMETER folderID
Specifies the Box folder ID (mandatory).

.PARAMETER asuserID
Specifies the Box user ID (optional).

.INPUTS
Box file ID, Box As-User ID.

.OUTPUTS
Returns an arrary containg the Box file info.

.EXAMPLE
PS> Get-BoxFile -fileID "11111" -asuserID "22222"

#>
}

