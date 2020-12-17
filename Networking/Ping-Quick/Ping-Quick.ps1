<#
.SYNOPSIS
    Pings the spcified IP/host(s).
.DESCRIPTION
    Pings the specified IP/host(s) using the Ping class
    and builds/outputs an object with the results.
    Mainly wrote this to check hosts quicker than the
    Test-NetConnection cmdlet and the usual ping utility. 
.EXAMPLE
    Ping-Quick -ComputerName 'github.com', '111.222.333.444'
    Explanation of what the example does
.INPUTS
    Hostname(s) or IP address(es).
.OUTPUTS
    Host info and ping results.
.NOTES
    N/A
#>
function Ping-Quick {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true, 
            HelpMessage = "Enter hostname(s) or IP address(es). Ex: Ping-Quick -ComputerName 'comp1', 'comp2', 'comp3'",
            ValueFromPipeline,
            Position = 1
        )]
        [string[]]$ComputerName
    ) #param block end
    begin {
        Write-Verbose -Message "Begin block..."
    } #begin block end
    process {
        Write-Verbose -Message "Process block..."
        foreach ($Computer in $ComputerName) {
            try {
                [void]([System.Net.Dns]::Resolve($Computer))
                $Ping = [System.Net.NetworkInformation.Ping]::New().Send($computer)
                if ($Ping.Status -eq "Success") {
                    [PSCustomObject]@{
                        Status   = $Ping.Status
                        IP       = $Ping.Address
                        Hostname = $Computer
                        Time     = $Ping.RoundtripTime
                        TTL      = $Ping.Options.Ttl 
                    }
                }
                else {
                    [PSCustomObject]@{
                        Status   = $Ping.Status
                        IP       = $Ping.Address
                        Hostname = $Computer
                        Time     = $Ping.RoundtripTime
                        TTL      = $Ping.Options.Ttl 
                    }
                }
            } #try end
            catch [System.Net.Sockets.SocketException] {
                [PSCustomObject]@{
                    Status   = $_.exception.message
                    IP       = $null
                    Hostname = $Computer
                    Time     = $null
                    TTL      = $null 
                }
            } #catch end
        } #foreach end
    } #process block end
    end { 
        Write-Verbose -Message "End block..."
    } #end block end
} #function end
Ping-Quick -ComputerName 'google.com', 'github.com', '1.1.1.1'