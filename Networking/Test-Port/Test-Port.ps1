<#
.SYNOPSIS
    Tests TCP ports.
.DESCRIPTION
    Tests TCP ports by trying to connect asynchronously 
    to the specified host and port. ConnectAsync method is used
    instead of default constructor because you can specify 
    a timeout which is desirable seeing as it's much faster
    than having the default constructor timeout. 
.EXAMPLE
    PS C:\> Test-Port -ComputerName 'google.com', '1.1.1.1' -Port 80, 1337
    Tries to connect to the specified hosts using the specified ports.
.INPUTS
    Computers/hosts and port numbers. 
.OUTPUTS
    PSCustomObject containing info about the connection reuslt.
.NOTES
    N/A
#>
function Test-Port {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true, 
            HelpMessage = "Enter computer name(s), ex: Test-TcpPort -ComputerName 'comp1', 'comp2', 'comp3'",
            ValueFromPipeline,
            Position = 1
        )]
        [string[]]$ComputerName,
        [Parameter(
            Mandatory = $true, 
            HelpMessage = "Enter port(s), ex: Test-TcpPort -ComputerName 'comp1' -Port 80",
            ValueFromPipeline,
            Position = 2
        )]
        [int[]]$Port
    ) #Param block end
    begin { 
        Write-Verbose -Message "Begin block..."
    } #begin block end
    process {
        Write-Verbose -Message "Process block..."
        foreach ($computer in $ComputerName) {
            foreach ($p in $Port) {
                try {
                    $ResolutionTest = [System.Net.Dns]::Resolve($computer)
                    $TcpClient = [System.Net.Sockets.TcpClient]::New().ConnectAsync($computer, $p).Wait(1000)
                    #Start-Sleep -Milliseconds 100
                    if ($TcpClient -eq $true) {
                        [PSCustomObject]@{
                            Hostname = $computer
                            IP       = $ResolutionTest.AddressList.IPAddressToString
                            Port     = $p 
                            Success  = $TcpClient
                            Message  = $null
                        }
                    }
                    else {
                        [PSCustomObject]@{
                            Hostname = $computer
                            IP       = $ResolutionTest.AddressList.IPAddressToString
                            Port     = $p
                            Success  = $TcpClient
                            Message  = $null
                        }
                    }
                    #$TcpClient.Dispose()
                } #try end
                catch [System.Net.Sockets.SocketException] {
                    #$errormsg = $_.exception.message
                    #Write-Host -Message "$($errormsg) $($Computer.ToUpper())" -ForegroundColor 'Red'
                    [PSCustomObject]@{
                        Hostname  = $computer
                        IP        = $null
                        Port      = $p
                        Connected = $TcpClient
                        Message   = $_.exception.message
                    }
                } #catch end
            } #foreach port end
        } #foreach computer end
    } #process block end
    end {
        Write-Verbose -Message "End block..."
    } #end block end
} #function end