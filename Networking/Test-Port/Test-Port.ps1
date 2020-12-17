<#
.SYNOPSIS
    Tests TCP ports.
.DESCRIPTION
    Tests TCP ports by trying to connect to the specified 
    host and port. ConnectAsync method is used
    instead of default constructor because you can specify 
    a timeout which is desirable seeing as it's much faster
    than having the default constructor timeout. 
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
function Test-Port {
    [CmdletBinding()]
    [OutputType([psobject])]
    param(
        [Parameter(
            Mandatory = $true, 
            HelpMessage = "Enter comp name(s), ex: Test-TcpPort -ComputerName 'github.com', '111.222.333.444' -Port 80",
            ValueFromPipeline,
            Position = 0
        )]
        [string[]]$ComputerName,
        [Parameter(
            #Mandatory = $true, 
            HelpMessage = "Enter port(s), ex: Test-TcpPort -ComputerName 'github.com', '111.222.333.444' -Port 80",
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
        foreach ($comp in $ComputerName) {
            foreach ($p in $Port) {
                try {
                    $ResolveTest = [System.Net.Dns]::Resolve($comp)
                    $TcpClient = [System.Net.Sockets.TcpClient]::New()
                    $TcpCon = $TcpClient.ConnectAsync($comp, $p)
                    #Start-Sleep -Milliseconds 100
                    if ($TcpCon.Wait(1000) -eq $true) {
                        [PSCustomObject]@{
                            ComputerName = $comp
                            IP           = $ResolveTest.AddressList.IPAddressToString
                            Port         = $p 
                            Success      = $TcpClient.Connected
                            Message      = $null
                        }
                    }
                    else {
                        [PSCustomObject]@{
                            ComputerName = $comp
                            IP           = $ResolveTest.AddressList.IPAddressToString
                            Port         = $p
                            Success      = $TcpClient.Connected
                            Message      = $null
                        }
                    }
                } #try end
                catch [System.Net.Sockets.SocketException] {
                    [PSCustomObject]@{
                        ComputerName = $comp
                        IP           = $null
                        Port         = $p
                        Success      = $TcpClient.Connected
                        Message      = $_.exception.message
                    }
                } #catch end
                finally {
                    $TcpClient.Dispose()
                }
            } #foreach port end
        } #foreach comp end
    } #process block end
    end {
        Write-Verbose -Message "End block..."
    } #end block end
} #function end
Test-Port -ComputerName gp.se -port 500