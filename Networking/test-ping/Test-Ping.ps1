function Test-Ping {
    <#
.SYNOPSIS
    Pings the spcified IP/host(s).
.DESCRIPTION
    Pings the specified IP/host(s) using the Ping class
    and builds/outputs an object with the results.
    Mainly wrote this to check hosts quicker than the
    Test-NetConnection cmdlet and the usual ping utility. 
.EXAMPLE
    Test-Ping -ComputerName 'server', '1.2.3.4'
    Sends an ICMP request to host 'server' and IP address '1.2.3.4'
    and outputs the results of the echo reply if there is one 
    and the error if there is none.
.INPUTS
    [System.String[]]
.OUTPUTS
    PSObject
.NOTES
    N/A
#>
    [CmdletBinding()]
    [OutputType([psobject])]
    param(
        [Parameter(
            Mandatory, 
            HelpMessage = "Enter host or IP address. Ex: Test-Ping -ComputerName 'server', '1.2.3.4",
            ValueFromPipeline,
            Position = 0
        )]
        [string[]]$ComputerName,
        [ValidateRange(500, 50000)]
        [Parameter( 
            HelpMessage = "Enter a timeout (minimum is 500ms) in milliseconds to wait for a reply. Ex: Test-Ping -ComputerName 'server', '1.2.3.4' -TimeOut 1000",
            Position = 1
        )]
        [Int]$TimeOut = 4000
    ) #param block end
    
    begin {
        Write-Verbose -Message "Begin block..."
        
        $PingObj = [System.Net.NetworkInformation.Ping]::New()

    } #begin block end
    
    process {
        Write-Verbose -Message "Process block..."
        
        foreach ( $Comp in $ComputerName ) {

            Write-Verbose -Message "Trying to ping $Comp"
            
            try {
                
                $HostName = [System.Net.Dns]::Resolve( $Comp )
                $PingReply = $PingObj.Send( $Comp, $TimeOut ) 
                
                [PSCustomObject]@{
                    Status        = $PingReply.Status
                    IP            = $PingReply.Address
                    Hostname      = $HostName.HostName
                    RoundTripTime = $PingReply.RoundtripTime
                    TimeToLive    = $PingReply.Options.Ttl
                    TimeOut       = $TimeOut 
                }

            } #try end
            
            catch [System.Net.Sockets.SocketException] {

                [PSCustomObject]@{
                    Status        = $_.Exception.Message
                    IP            = $Comp
                    Hostname      = $Comp
                    RoundTripTime = $null
                    TimeToLive    = $null
                    TimeOut       = $TimeOut 
                }

            } #catch end

        } #foreach end

    } #process block end
    
    end { 
        Write-Verbose -Message "End block..."
       
        $PingObj.Dispose()

    } #end block end

} #function end