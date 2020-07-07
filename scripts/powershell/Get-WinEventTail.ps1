Function Get-WinEventTail
{
    <#
        .SYNOPSIS
            A tail cmdlet for Eventlogs
        .DESCRIPTION
            This function will allow you to tail Windows Event Logs. You specify
            a Logname for either the original logs, Application, System and Security or 
            the new format for the newer logs Microsoft-Windows-PowerShell/Operational
        .PARAMETER LogName
            Specify a valid Windows Eventlog name
        .PARAMETER ShowExisting
            An integer to show the number of events to start with, the default is 10
        .EXAMPLE
            Get-WinEventTail -LogName Application


               ProviderName: ESENT

            TimeCreated                     Id LevelDisplayName Message                                                                                                                                                                                                      
            -----------                     -- ---------------- -------                                                                                                                                                                                                      
            10/9/2014 11:55:51 AM          102 Information      svchost (7528) Instance: ...
            10/9/2014 11:55:51 AM          105 Information      svchost (7528) Instance: ...
            10/9/2014 11:55:51 AM          326 Information      svchost (7528) Instance: ...
            10/9/2014 12:05:49 PM          327 Information      svchost (7528) Instance: ...
            10/9/2014 12:05:49 PM          103 Information      svchost (7528) Instance: ...

        .NOTES
            FunctionName : Get-WinEventTail
            Created by   : jspatton
            Date Coded   : 10/09/2014 13:20:22
        .LINK
            https://code.google.com/p/mod-posh/wiki/ComputerManagement#Get-WinEventTail
        .LINK
            http://stackoverflow.com/questions/15262196/powershell-tail-windows-event-log-is-it-possible
    #>
    [CmdletBinding()]
    Param
        (
        [string]$LogName = 'System',
        [int]$ShowExisting = 10
        )
    Begin
    {
        if ($ShowExisting -gt 0)
        {
            $Data = Get-WinEvent -LogName $LogName -MaxEvents $ShowExisting
            $Data |Sort-Object -Property RecordId
            $Index1 = $Data[0].RecordId
            }
        else
        {
            $Index1 = (Get-WinEvent -LogName $LogName -MaxEvents 1).RecordId
            }
        }
    Process
    {
        while ($true)
        {
            Start-Sleep -Seconds 1
            $Index2  = (Get-WinEvent -LogName $LogName -MaxEvents 1).RecordId
            if ($Index2 -gt $Index1)
            {
                Get-WinEvent -LogName $LogName -MaxEvents ($Index2 - $Index1) |Sort-Object -Property RecordId
                }
            $Index1 = $Index2
            }
        }
    End
    {
        }
    }