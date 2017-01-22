<# 
.SYNOPSIS 
Creates users in Active Directory
.DESCRIPTION
This will create multiple user accounts in Active Directory
.EXAMPLE
$params = @{$FirstName="Ahmad";$Initials="AH";$LastName="Hamad";$ModifiedFullName="HamadAhmad";UserLogonName="ahamad";$Password="password1"} 
& “.\create-active-directory-users .ps1” @params
.PARAMETER $FirstName
.PARAMETER $Initials
.PARAMETER $LastName 
.PARAMETER $ModifiedFullName
Modify Full name to add initials or reverse the order of first and last names
.PARAMETER $UserLogonName 
.PARAMETER $Password

#>

param($FirstName,$Initials,$LastName,$ModifiedFullName,$UserLogonName,$Password)
"Creating user $UserLogonName..."
