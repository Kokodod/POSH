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
        foreach ($Computer in $ComputerName) {
            foreach ($P in $Port) {
                try {
                    [void]([System.Net.Dns]::Resolve($Computer))
                    $TcpClientObj = New-Object System.Net.Sockets.TcpClient
                    [void]($TcpClientObj.BeginConnect($Computer, $P, $null, $null))
                    Start-Sleep -Milliseconds 100
                    if ($TcpClientObj.Connected -eq $true) {
                        "Create success object"
                    }
                    else {
                        "Create failure object"
                    }
                    $TcpClientObj.Dispose()
                } #try end
                catch [System.Net.Sockets.SocketException] {
                    #$errormsg = $_.exception.message
                    #Write-Host -Message "$($errormsg) $($Computer.ToUpper())" -ForegroundColor 'Red'
                    "Create error object"
                } #catch end
            } #foreach port end
        } #foreach computer end
    } #process block end
    end {
        Write-Verbose -Message "End block..."
    } #end block end
} #function end
