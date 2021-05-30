function Get-XmlNode {
    <#
.SYNOPSIS
    Gets all Nodes along with content and info about them in an XML file.
.DESCRIPTION
    Gets all Nodes in an XML file along with content and info about them
    by iterating through the file using the XmlReader class.  
.EXAMPLE
    PS C:\> Get-XmlNode -Path "C:\temp\xmlfile.xml" -AllNodes $true
    Outputs all tags from the XML file. 
.INPUTS
    [System.String].
.OUTPUTS
    [PSObject].
.NOTES
    Very working in progress.
#>  
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory
            , HelpMessage = 'Enter path of .xml file, ex: "C:\temp\xmlfile.xml"'
        )]
        [string]$Path,
        #[string[]]$TagName,
        [bool]$AllNodes = $false
    )

    begin {

        Write-Verbose -Message "Begin block..."
        
        Write-Verbose -Message "Validating path/file..."

        $readersettings = [System.Xml.XmlReaderSettings]::new()
        $readersettings.IgnoreWhitespace = $true
        
        try {

            $reader = [System.Xml.XmlReader]::Create( $Path, $readersettings )

        }
        catch [System.IO.FileNotFoundException] {

            Write-Error -Message $_.Exception.Message

        }
        
        #if ($false -eq (Test-Path -Path $Path)) {

        #Write-Error -Message "File not found" -ErrorAction Stop

        #} #if end

        #[XML]$xml = get-content -Path $Path

        #[Linq.Enumerable]::Distinct($alltags)

    } #begin block end
    process {

        Write-Verbose -Message "Process block..."
        
        Write-Verbose -Message "Importing XML file..."
        
        if ( $true -eq $AllNodes ) {

            while ( $reader.Read() ) {
    
                #$reader.NodeType
                if ( $true -eq $reader.HasAttributes ) {
            
                    $atrcount = $reader.AttributeCount
                    
                    for ( $i = 0; $i -lt $atrcount; $i++ ) {
                        
                        $reader.MoveToAttribute( $i )
                        [PSCustomObject]@{
                            Tag      = $reader.Name
                            NodeType = $reader.NodeType
                            Content  = $reader.Value
                        } #PSO end
                        #$reader.GetAttribute($i)
            
                    }
            
                }
                else {
            
                    switch ( $reader.NodeType ) {
                        
                        "XmlDeclaration" { 
                            [PSCustomObject]@{
                                Tag      = $reader.Name
                                NodeType = $reader.NodeType
                                Content  = $reader.Value
                            } #PSO end
                        }
                        "Element" { 
                            [PSCustomObject]@{
                                Tag      = $reader.Name
                                NodeType = $reader.NodeType
                                Content  = $reader.Value
                            } #PSO end
                        }
                        "Text" { 
                            [PSCustomObject]@{
                                Tag      = $reader.Name
                                NodeType = $reader.NodeType
                                Content  = $reader.Value
                            } #PSO end
                        }
                        Default { 
                            "Nope" 
                        }
                    
                    }
                
                }
            
            }
        
        } #if $AllTags end
        
        else {
            
            Write-Host "Else"
        
        } #else $AllTags end

    } #process block end
    end {

        Write-Verbose -Message "End block..."
    
    }#end block end

}


