function Get-XmlTags {
    <#
.SYNOPSIS
    Gets all tag names in an XML file.
.DESCRIPTION
    Gets all tag names in an XML file.  
.EXAMPLE
    PS C:\> Get-Xmltags -Path "C:\temp\xmlfile.xml"
    Outputs all tags from the XML file. 
.INPUTS
    [System.String].
.OUTPUTS
    [System.String].
.NOTES
    WIP
#>  
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory
            , HelpMessage = 'Enter path of .xml file, ex: "C:\temp\xmlfile.xml"'
        )]
        [string]$Path
    )

    begin {

        Write-Verbose -Message "Begin block..."
        Write-Verbose -Message "Validating path/file..."
        if ($false -eq (Test-Path -Path $Path)) {
            Write-Error -Message "File not found" -ErrorAction Stop
        } #if end

    } #begin block end
    process {

        Write-Verbose -Message "Process block..."
        Write-Verbose -Message "Importing XML file..."
        [XML]$xml = get-content -Path $Path
        [string[]]$alltags = $xml.GetElementsByTagName('*').name
        [Linq.Enumerable]::Distinct($alltags)

    } #process block end
    end {
        Write-Verbose -Message "End block..."
    }#end block end

}