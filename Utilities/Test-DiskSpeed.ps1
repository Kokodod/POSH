function Test-DiskSpeed {
    <#
.SYNOPSIS
    Wrapper for the Microsoft DiskSpd utility.
.DESCRIPTION
    Test storage IO performance and outputs to a file.  
.EXAMPLE
    PS C:\> Test-DiskSpeed -DriveLetter "C"
    Runs a test using the function's default parameter arguments. 
.INPUTS
    [System.String[]], [System.Int32[]] 
.OUTPUTS
    .txt file.
.NOTES
    N/A
#>
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory
            , HelpMessage = 'Enter the designated letter of the drive to be tested, ex: C'
        )]
        [ValidatePattern("[a-zA-Z]")]
        [string]$DriveLetter,
        [Parameter(
            HelpMessage = 'Enter a number between 0 and 100. Default is 50, 0 equals 100% reads.'
        )]
        [ValidatePattern("^([0-9]|[1-9][0-9]|100)$")]
        [Int]$WritePercentage = 50,
        [Parameter(
            HelpMessage = 'Enter size of test file, ex: 2.'
        )]
        [String]$TestFileSize = 2, 
        [ValidatePattern("^([0-9]|[1-9][0-9]|[1-9][0-9][0-9])$")]
        [Parameter(
            HelpMessage = 'Enter warm up time in seconds before main test is run. Default is 5, max is 999'
        )]
        [Int]$WarmUpTime = 5,
        [Parameter(
            HelpMessage = 'Specify if the file created for the test is to be removed after the test is done. Default is $false'
        )]
        [Bool]$RemoveTestFile = $false
    )

    if ( $DriveLetter -notin ( Get-Volume ).DriveLetter ) {
        Write-Error "Volume '$( $DriveLetter.ToUpper() )' not found" -ErrorAction Stop
    }
        
    $hostname = $env:COMPUTERNAME
    $date = Get-Date -Format "yyyyMMddHHmm"
    $drive = ( Get-Volume ).where( { $_.DriveLetter -eq "$DriveLetter" } )
    $threads = "-t{0}" -f ( Get-WmiObject win32_processor ).ThreadCount
    $writes = "-w{0}" -f $WritePercentage
    $warmup = "-W{0}" -f $WarmUpTime
    $filesize = "-c{0}" -f $TestFileSize
    $archivepath = "C:\StorageTestArchive\{0}_{1}" -f $drive.DriveLetter, $drive.FileSystemLabel
    $testfilepath = "{0}:\StorageTest\IOTestFile.dat" -f $drive.DriveLetter
    $formatresult = @(
        $archivepath
        $hostname, 
        $drive.FileSystemLabel, 
        $drive.DriveLetter, 
        $date
    )
    $resultfilepath = "{0}\diskspd_resultfile_{1}_{2}_{3}_{4}.txt" -f $formatresult

    if ($true -ne (Test-Path -Path $archivepath)) {
        [void](New-Item -Path $archivepath -ItemType Directory)
    }

    #https://github.com/Microsoft/diskspd/wiki/Command-line-and-parameters
    C:\DiskSpd\diskspd.exe -b8K -d15 -h -L -o32 $threads $warmup -r $writes $filesize $testfilepath > $resultfilepath

    if ( $true -eq $RemoveTestFile ) {
        Write-Verbose "Removing $testfile..."
        [void](Remove-Item -Path $testfile)
    }
}