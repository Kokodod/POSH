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
                $PingObj = New-Object System.Net.NetworkInformation.Ping
                $Ping = $PingObj.Send($Computer)
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
                $PingObj.Dispose()
            } #try end
            catch [System.Net.Sockets.SocketException] {
                #$errormsg = $_.exception.message
                #Write-Error -Message "$($errormsg) $($Computer.ToUpper())"
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