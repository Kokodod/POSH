function Test-Port {
<#
.SYNOPSIS
    Tests TCP ports.
.DESCRIPTION
    Tests TCP ports by trying to connect to the specified 
    host and port. ConnectAsync method is used
    instead of default constructor because you can specify 
    a timeout which is desirable seeing as it's much faster
    than having the default method timeout. 
.EXAMPLE
    PS C:\> Test-Port -ComputerName 'google.com', '1.1.1.1' -Port 80, 1337
    Tries to connect to the specified hosts using the specified ports.
.INPUTS
    [System.String[]], [System.Int32[]] 
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
            HelpMessage = "Enter hostname or IP, default port is 80. Ex: Test-Port -ComputerName 'server', '1.2.3.4'",
            ValueFromPipeline,
            Position = 0
        )]
        [string[]]$ComputerName,
        [Parameter( 
            HelpMessage = "Enter port, default port is 80. Ex: Test-Port -ComputerName 'server', '1.2.3.4' -Port 80",
            ValueFromPipeline,
            Position = 1
        )]
        [int[]]$Port = 80
    ) #Param block end
    
    begin { 
        Write-Verbose -Message "Begin block..."
    } #begin block end
    
    process {
        Write-Verbose -Message "Process block..."
        
        foreach ( $Comp in $ComputerName ) {
            
            foreach ( $P in $Port ) {

                try {

                    $HostName = [System.Net.Dns]::Resolve( $Comp )
                    $TcpClientObj = [System.Net.Sockets.TcpClient]::New()
                    $TcpCon = $TcpClientObj.ConnectAsync( $Comp, $P )

                    if ( $TcpCon.Wait(1000) -eq $true ) {
                        
                        [PSCustomObject]@{
                            ComputerName = $HostName.HostName
                            IP           = $HostName.AddressList.IPAddressToString
                            Port         = $P 
                            Success      = $TcpClientObj.Connected
                            Message      = $null
                        }

                    }
                    else {
                        
                        [PSCustomObject]@{
                            ComputerName = $HostName.HostName
                            IP           = $HostName.AddressList.IPAddressToString
                            Port         = $P
                            Success      = $TcpClientObj.Connected
                            Message      = $null
                        }

                    }

                } #try end

                catch [System.Net.Sockets.SocketException] {
                    [PSCustomObject]@{
                        ComputerName = $Comp
                        IP           = $null
                        Port         = $P
                        Success      = $TcpClientObj.Connected
                        Message      = $_.Exception.Message
                    }
                } #catch end
                
                finally {

                    $TcpClientObj.Dispose()
                    
                } #finally end

            } #foreach port end

        } #foreach Comp end

    } #process block end
    
    end {
        Write-Verbose -Message "End block..."
    } #end block end

} #function end