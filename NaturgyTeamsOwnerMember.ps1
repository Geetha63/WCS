﻿# This script will provide Teams Owner and member details using teams module cmdlets
$logfile = ".\TeamsOwnerMembersdetailslog_$(get-date -format `"yyyyMMdd_hhmmsstt`").txt"

adding one line
If(Get-Module -ListAvailable -Name MicrosoftTeams) 
 { 
 Write-Host "MicrosoftTeams Already Installed" 
 } 
 else { 
 try { Install-Module -Name MicrosoftTeams
 Write-Host "Installed MicrosoftTeams"
 }
 catch{
        $_.Exception.Message | out-file -Filepath $logfile -append
 }
 }
connect-microsoftteams

$Teams = get-team 
foreach ($team in $Teams) 
    {
        $groupid = $team.Groupid
        $displayname = $team.DisplayName
        $Teammember = get-teamuser -GroupId "$groupid" -Role Member
        $TeamOwner = get-teamuser -GroupId "$groupid" -Role Owner 
        $Members = [string]::Join("; ",$Teammember.User)
        $Owner = [string]::Join("; ",$TeamOwner.User) 

       
            $file = New-Object psobject
            $file | add-member -MemberType NoteProperty -Name Teamid $groupid
            $file | add-member -MemberType NoteProperty -Name TeamDisplayname $displayname
            $file | add-member -MemberType NoteProperty -Name Owner  $Owner
            $file | add-member -MemberType NoteProperty -Name Member $Members
            $file | export-csv -path ".\abcdef.csv" -NoTypeInformation -Append
      }
      
    
$end = [system.datetime]::Now
$resultTime = $end - $start
Write-Host "Execution took : $($resultTime.TotalSeconds) seconds." -ForegroundColor Cyan   
#end of script
