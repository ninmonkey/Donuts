#requires -Modules Pansies
<#
.synopsis
    Example using 24bit colors on Windows Powershell 5.1 and Powershell 7
#>
function WriteLog {
    <#
    .synopsis
        This logs the time, severity, an optional color, and optional data from the pipeline. It converts it to json.
    #>
    param(
        # Severity level
        # [ArgumentCompletions('Error', 'Warn', 'Info')] # enable this if you're pwsh 7 for optional completions, but still allowing free-form labels
        [string] $Severity = 'Info',

        # optional title
        [string] $Title = '',

        # lets you pipe to other streams like verbose or even files
        [switch] $PassThru
    )
    $Message =  $Input  | ConvertTo-Json -Depth 3 -Compress -wa ignore -ea ignore

    $render = @(
        ( Get-Date ).ToString('u') |
            New-Text -fg '#505879' -bg '#282c3b'

        $Severity |
            New-Text -fg 'violet'

        $Title | New-Text -fg 'salmon'
        $Message
    ) -join ' '
    if( $PassThru ) { return $render }
    $render | Write-Host
}

# Piping different kinds of things. Strings, objects, hashtables, etc.
$PSCommandPath |
    WriteLog -Severity Info 'Enter => '

$PSVersionTable.PSVersion.ToString() |
    WriteLog -Severity Info 'Pwsh Version'

@{ user = 'bob'; id = '234' } |
    WriteLog -Severity Error 'User failed to login'

# You can even use colors with 'Write-Verbose'! Or 'Set-Content'
@{ user = 'bob'; id = '234' } |
    WriteLog -Severity Error 'User failed to login' -PassThru |
    Write-Verbose -Verbose
