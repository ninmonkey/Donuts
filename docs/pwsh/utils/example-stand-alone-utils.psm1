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

#region Environment Variables

# fzf
$ENV:FZF_DEFAULT_OPTS = '-m --layout=reverse --cycle --info inline'
# $ENV:FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'

#region Environment Variables


#region utils for text

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


function JoinSep {
    param(
       [int] $Depth = 0,
       [string] $Prefix = '',

       [string] $Separator = "`n"
    )
    $DepthStr = '  ' * $Depth -join ''
    $Start = "${DepthStr}${Prefix}"
    $template = "${Start}" + '{0}'
    $Input | Join-String -f $Template -sep $Separator
}

function JoinUL {
    <#
    .EXAMPLE
        > 0..2 | JoinUL
        - 0
        - 1
        - 2
    #>
    param()
    $Input | JoinSep -Prefix '- '
}

function SplitNL {
    <#
    .SYNOPSIS
        Split pipeline strings by newlines
    .EXAMPLE
        # allows you to fix single string commands like
        > 0..2 | JoinUL | JoinUL            # only prefixes as one line
        > 0..2 | JoinUL | SplitNL | JoinUL  # works on all lines
    #>
    $Input -split '\r?\n'
}

#endregion utils for text

#region utils for cli commands
function Invoke.NativeApp {
    <#
    .synopsis
        Invoke native CLI command and log the command ran
    .description
        See 'mintils' for more features. this is a simple, inline, no features version.
    .link
        Mintils\Mint.Invoke-AppWithConfirm
    .link
        Mintils\Mint.Invoke-App
    .example
        # Test what command would run, without actually running. Shows extra debug info:
        Invoke.NativeApp ipconfig /all -DryRun

        # Sometimes you need an explicit start in order to use the short syntax plus (Get-Item) inline
        Invoke.NativeApp git -Args '-C', (gi .), status -DryRun
    .example
        # some expressions let you use a string without quotes or commas, like
        Invoke.NativeApp ipconfig /?
        Invoke.NativeApp ipconfig /all

        # or even variables. The commas might not be needed here?
        Invoke.NativeApp -AppName 'git' -ArgumentList log, -n, $t
        otalNum, --format=oneline, --abbrev-commit, --color=always| echo
    .example
        # you can even force ansi colors when piping to echo, like
        Invoke.NativeApp -AppName 'git' -ArgumentList log, -n, 3, --format=oneline, --abbrev-commit, --color=always | echo
    #>
    param(
        # Command or path
        [Alias('Command', 'Path', 'File', 'Exe')]
        [Parameter(mandatory)]
        $AppName,

        # args for command
        [Alias('BinArgs', 'ArgsList', 'CommandLineArgs')]
        [Parameter()]
        [object[]] $ArgumentList = @(),

        # Do not run command, just log what would have ran
        [Alias('WhatIf', 'TestOnly')]
        [Parameter()]
        [switch] $DryRun,

        # Even when running without DryRun, always prompt the user with yes/no confirmation
        [Alias('Confirm')]
        [switch] $RequiresConfirm,

        # Do not echo the command line used from the command
        [Alias('WithoutEcho')]
        [switch] $WithoutPSHost,

        [Parameter(ValueFromPipeline)]
        [object[]] $InputObject
    )

    begin { 
        [Collections.Generic.List[Object]] $InputItems = @()
    }
    process {
        # if from pipeline add to list,
        # otherwise if parameter only then add to list
        write-warning 'nyi: param -InputObject'
    }
    end { 
        $maybeBin = Get-Command $AppName -CommandType Application -ErrorAction stop
        #optional: -totalCount 1 -UseAbbreviationExpansion:$false
        $logArgsMessage = $ArgumentList | Join-String -sep ' ' | JoinPre "Invoke.NativeApp => ${AppName} "   
    
        if( $RequiresConfirm ) { throw 'todo(NYI): add minimal ShouldProcess support' }
        if( $DryRun ) { 
            @(
                'Invoke.NativeApp: -DryRun'
                $AppName | JoinPre 'Name: ' | JoinIndent 1
                $maybeBin.Source | JoinPre 'Path: ' | JoinIndent 1
                $ArgumentList | Join-String -sep ' ' | JoinPre "Cmd => ${AppName} " | JoinIndent 1
            ) | WriteInfo
            return
        } 
        # write headers at the start, and end
        if( -not $WithoutPSHost ) { 
            $logArgsMessage | WriteInfo | Write-Host 
            'nyi: write terminal scrollback point' | Write-Debug -Debug
        }
        & $maybeBin @ArgumentList
        if( -not $WithoutPSHost ) { 
            $logArgsMessage | WriteInfo | Write-Host 
            'nyi: write terminal scrollback point' | Write-Debug -Debug
        }
    }
}

function Get.NativeApp { 
    <#
    .synopsis
        Get and return a native command without executing
    .EXAMPLE
        $bin = Get.NativeApp fzf; 0..3 | & $bin -m
        0..3 | & ( Get.NativeApp fzf ) -m
    .link
        Invoke.NativeApp
    #>
    param ( 
        [Alias('Name', 'Command')]
        [string] $Path
    )
    $app = gcm $Path -CommandType Application -ErrorAction stop -TotalCount 1
    $app
}
function Invoke.Zoxide.PickAddPath {
    <#
    .synopsis
        Pick a path from fzf and add it to zoxide
    .description
        shorthand for: $paths | fzf -m | %{ zoxide add $_ }  
    .link
        Invoke.NativeApp
    #>
    param()

    $fzf = Get.NativeApp 'fzf'
    $zoxide = Get.NativeApp 'zoxide'

    $Input 
        | & $fzf -m
        | %{ 
            & $zoxide add $_
        } 
}

#endregion utils for cli commands

#region utils for finding things
function Find.GitRepo {
    param(
        [string] $BaseDirectory = '.'
    )
    Invoke.NativeApp -App 'fd' -Args @(
        '^\.git$',
        '--base-directory', (Get-Item -ea 'stop' $BaseDirectory),
        '-HI', '--absolute-path'
    ) | Split-Path | Get-Item
    # was: fd '^\.git$' --base-directory (Get-Item -ea 'stop' $BaseDirectory) -HI --absolute-path | Split-Path | Get-Item
}
function Find.Workspace {
    <#
    .synopsis
        Find VsCode "*.code-workspace" files or directories that contain "/.vscode" folders 
    .example
        Find.Workspace
        Find.Workspace -BaseDirectory '. ' -WithoutVsCodeFolders -MaxDepth 4
    .link
        Mintils\Mint.Find-CodeWorkspace
    #>
    param(
        [string[]] $BaseDirectory = @('c:\2025','c:\2026'),
        [switch] $WithoutVsCodeFolders,
        [int]$MaxDepth = 4
    )
    foreach( $dir in $BaseDirectory ) {
        if( -not (Test-Path $dir) ) { continue }
        Mint.Find-CodeWorkspace -BaseDirectory $dir -MaxDepth $MaxDepth -IncludeVsCodeFolders:$( -not $WithoutVsCodeFolders )
    }
}

#endregion utils for finding things
    
#region utils unsorted misc
function GetModule.Exports.Commands {
    <#
    .synopsis
        Coerce and drill down (Get-Module) info to get the clean table of exported function commands
    .example
        # You can pipe a module instance or string
        > Get-Module 'pansies' | GetModule.Exports.Commands
        > 'pansies' | GetModule.Exports.Commands
    .example
        # Iterate directly from imports
        > Import-Module 'ugit' -PassThru | GetModule.Exports.Commands
    #> 
    process {
        $item = $_
        [PSModuleInfo] $info = ( $item -is [PSModuleInfo] ) ? $item : ( get-module $item )
        $info.ExportedCommands.Values    
    }
}



#endregion utils unsorted misc