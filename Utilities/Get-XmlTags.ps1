function Get-XmlTags {
    <#
.SYNOPSIS
    Gets all the tags in an XML file.
.DESCRIPTION
    Finds all the tags in an XML and outputs them as  
.EXAMPLE
    PS C:\> Test-DiskSpeed -DriveLetter "C"
    Runs a test using the function's default parameter arguments. 
.INPUTS
    [System.String[]]
.OUTPUTS
    PSObject and/or .txt file.
.NOTES
    N/A
#>  
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory
            , HelpMessage = 'Enter path of .xml file, ex: "C:\temp\xmlfile.xml"'
        )][string]$Path
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