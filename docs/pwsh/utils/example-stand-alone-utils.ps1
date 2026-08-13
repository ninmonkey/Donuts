#requires -PSEdition Core
#requires -Modules Pansies
<#
.synopsis
    Mostly stand-alone snippets that can be reusable or used in small files to make examples easier to view, like sharing a gist
.notes
    Some require Mintils
.example
    | JoinPre 'Characteristics: '
    | WriteInfo -depth 0 -bg 'gray70'
#>

function JoinPre {
    <#
    .synopsis
        prefix and pipe
    .EXAMPLE
        # basic indent depth 2
        > 0..3 | JoinPre

        # basic with labels
        > gci . | JoinPre -Prefix 'file: '
        > gci . | JoinPre 'file: '

    .EXAMPLE
        # with prefix
        gci . -Directory
            | % Name
            | JoinPre -Prefix ' - [ dir] ' -Depth 1

        gci . -File
            | % Name
            | JoinPre -Prefix ' - [file] ' -Depth 1
    .EXAMPLE
        # tree
        'parent'   | JoinPre -Depth 0 -Prefix '[+] '
        'child d1' | JoinPre -Depth 2
        'child d2' | JoinPre -Depth 3
        'child d1' | JoinPre -Depth 2
    #>
    param(
        # [Alias('Label', 'Name')]
        # [Parameter()]
        [string] $Prefix = '',

        [int] $Depth = 0,
        [string] $IndentString = '  ',
        [switch] $NoSeparator
    )
    [string] $Template = $IndentString * $Depth -join ''

    [string] $fStr   = "${Template}${Prefix}" + '{0}'
    $joinSplat = @{
        FormatString = $fStr
    }
    if( -not $NoSeparator ) {
        $joinSplat['Separator'] = "`n"
    }

    $Input | Join-String @joinSplat
}

function JoinIndent {
    <#
    .SYNOPSIS
        Essentially shorthand alias for 'JoinPre' if you only want indentation and nothing else
    .EXAMPLE
        # predents by '  '
        > 'a'..'c' | JoinIndent 1
        # predents by '     '
        > 'a'..'c' | JoinIndent 2
    .EXAMPLE
        > 'name' | JoinIndent 3 -IndentString '-'
        # out: --3name

    .EXAMPLE
        the default is essentially a no-op
        > 'foo' | JoinIndent
        > 'foo' | JoinIndent -Depth 0
    #>
    param(
        # How many? Default: 0
        [int] $Depth = 0,

        # customize what crumb segment to use. Default is two spaces: '  '
        [ArgumentCompletions("'  '", '"`n"', "'--'")]
        [string] $IndentString = '  '
    )
    $Input | JoinPre -Depth $Depth -IndentString $IndentString
}
function WriteInfo {
    <#
    .synopsis
        prefix colorize etc
    .EXAMPLE
    > $msg | WriteInfo -WithoutHighContrast -Bg '#ce624d'
    > $msg | WriteInfo -WithoutHighContrast
    > $msg | WriteInfo -Bg '#ce624d'
    > $msg | WriteInfo
    #>
    param(
        [RgbColor] $BgColor =
            'darkgray',
            # 'yellow',
                    # '#085732',
        [switch] $WithoutHighContrast,

        [int] $Depth = 0
    )

    $complement = Pansies\Get-Complement -Color $BgColor -HighContrast:( -not $WithoutHighContrast )
    $Input
    | Pansies\New-Text -bg $BgColor -fg $complement
    | JoinPre -Depth $Depth
}

function WriteContrast {
    # [CmdletBinding()]
    param(
        # [Parameter(Mandatory)]
        [Alias('BgColor')]
        [RgbColor] $Color,
        [switch] $PassThru
    )
    $fg = Pansies\Get-Complement $Color -HighContrast

    if( $PassThru )  {
        $Input | New-Text -fg $fg  -bg $Color
        return
    }
    $Input | New-Text -fg $fg  -bg $Color | Write-Host
}
