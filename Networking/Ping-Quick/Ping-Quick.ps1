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
    Sends an ICMP request to hosts 'github.com' and '111.222.333.444'
    and outputs results of the reply if there is one and the error
    if there is none.
.INPUTS
    [System.String[]]
.OUTPUTS
    PSObject
.NOTES
    N/A
#>
function Ping-Quick {
    [CmdletBinding()]
    [OutputType([psobject])]
    param(
        [Parameter(
            Mandatory = $true, 
            HelpMessage = "Enter host or IP address. Ex: Ping-Quick -ComputerName 'github.com', '111.222.333.444'",
            ValueFromPipeline,
            Position = 0
        )]
        [string[]]$ComputerName
    ) #param block end
    begin {
        Write-Verbose -Message "Begin block..."
    } #begin block end
    process {
        Write-Verbose -Message "Process block..."
        foreach ($comp in $ComputerName) {
            try {
                [void]([System.Net.Dns]::Resolve($comp))
                $PingObj = [System.Net.NetworkInformation.Ping]::New()
                $Ping = $PingObj.Send($comp) 
                if ($Ping.Status -eq "Success") {
                    [PSCustomObject]@{
                        Status   = $Ping.Status
                        IP       = $Ping.Address
                        Hostname = $comp
                        Time     = $Ping.RoundtripTime
                        TTL      = $Ping.Options.Ttl 
                    }
                }
                else {
                    [PSCustomObject]@{
                        Status   = $Ping.Status
                        IP       = $Ping.Address
                        Hostname = $comp
                        Time     = $Ping.RoundtripTime
                        TTL      = $Ping.Options.Ttl 
                    }
                }
            } #try end
            catch [System.Net.Sockets.SocketException] {
                [PSCustomObject]@{
                    Status   = $_.exception.message
                    IP       = $null
                    Hostname = $comp
                    Time     = $null
                    TTL      = $null 
                }
            } #catch end
            finally {
                $PingObj.Dispose()
            }
            
        } #foreach end
    } #process block end
    end { 
        Write-Verbose -Message "End block..."
    } #end block end
} #function end