#requires -PSEdition Core
#requires -Modules Pansies

<#
final output:

## Vars ##
    PathFile        C:\data\example.log
    PathUri.AbsPath C:/data/example.log
    maybeUnc        \\NIN8\Users\Public\desktop.ini
    FromUnc         file://nin8/Users/Public/desktop.ini

## From Get-Item ##

    $PStyle  -> ␛]8;;file:///C:/data/example.log␛\path␛]8;;␛\
    Pansies  -> ␛]8;;file:///C:/data/example.log␇path␛]8;;␇
    Trackd   -> ␛]8;;file:///C:/data/example.log␛\path␛]8;;␛\

## From Unc ##

    $PStyle  -> ␛]8;;file://nin8/Users/Public/desktop.ini␛\unc␛]8;;␛\
    Pansies  -> ␛]8;;file://nin8/Users/Public/desktop.ini␇unc␛]8;;␇
    Trackd   -> ␛]8;;␛\unc␛]8;;␛\

#>

function New-TrackUrl {
    # added type conversion which auto enables passing Get-Item without param binding errors
        # original: param([uri]$uri, [string]$title)
    param( [uri] [string] $uri, [string]$title)
    if (!$title) {
        $title = $uri.ToString()
    }
    $e = [char]27
    return "$e]8;;$uri$e\$title$e]8;;$e\"
}

filter Prefix {
    param( [string] $Prefix = '' )
    $Input | Join-String -op "${Prefix} "
}
filter ShowCc {
    param( [string] $Title = '' )
    $line = $_
    if( -not $line -is [string] ) { return $line }
    ($line).ToString()?.EnumerateRunes() | ForEach-Object {
        if ( $_.Value -le 0x1f ) {
            [Text.Rune]::new( $_.Value + 0x2400 )
        }
        else { $_ }
    } | Join-String -sep '' -op "${Title}  -> "
}
function H1 {
    param( [string] $Title )
    $Title | Join-String -f "`n## {0} ##`n" | Write-host -fg 'salmon'
}


$name = 'path'
$pathFile = 'C:\data\example.log'
$pathUri = [uri] ( Get-item -ea 'stop'  $PathFile ).FullName

h1 'From Get-Item'
$PSStyle.FormatHyperlink( $name, $pathUri )       | ShowCc '$PStyle'
Pansies\New-Hyperlink -Uri $pathUri -Object $name | ShowCc 'Pansies'
New-TrackUrl -uri $pathUri -title $name           | ShowCC 'Trackd '

h1 'From Unc'
$maybeUnc = '\\NIN8\Users\Public\desktop.ini'
$fromUnc = ( [System.Uri] $maybeUnc ).AbsoluteUri # not sure if this is right?
$name = 'unc'

$PSStyle.FormatHyperlink( $name, $fromUnc ) | ShowCc '$PStyle'
Pansies\New-Hyperlink -Uri $fromUnc $name   | ShowCc 'Pansies'
New-TrackUrl -Uri $formUnc -Title $name     | ShowCC 'Trackd '

H1 'Vars'
$PathFile             | Prefix 'PathFile       '
$pathUri.AbsolutePath | Prefix 'PathUri.AbsPath'
$maybeUnc             | Prefix 'maybeUnc       '
$fromUnc              | Prefix 'FromUnc        '
