#requires -PSEdition Desktop
#requires -Modules Pansies

<#
.SYNOPSIS
    Runs on Powershell 5.1. Pretty print encoding errors and assert the full output is exactly the same
.DESCRIPTION
This started as a reply to this thread: https://www.reddit.com/r/PowerShell/comments/1vtb7q2/getcontent_encoding_utf8_fixed_four_of_my_log/

The short is Strings correctly encoded as ShiftJis
But then decoded using utf-8 will break many codepoints because they are not valid in that encoding.
You can use 'default' or 'ascii' -- but then it can indirectly break things like parsing json, quotes, commas etc
.link
    https://github.com/ninmonkey/Donuts/tree/main/docs/pwsh/vanilla/Encoding/Compare-Encoding-Breaking-Emojibake/readme.md
#>

#region configure and setup
if( $PSVersionTable.PSVersion.Major -gt 5 ) {
    write-warning 'Early exit. this test is intended for PS 5.1 older'
    return
}

if ( $false ) {
    'Using Implicit OutputEncodings. You might need to enable these for your terminal to display the output. It seems optional on win10 using wt. Older versions of windows/terminals might require it' | Write-Host -fg 'yellow'
} else {
    [console]::OutputEncoding = [console]::InputEncoding = $OutputEncoding = [Text.Encoding]::UTF8
}

function Bytes.FromHexStr {
    <#
    .Synopsis
        This enables shorthand like the Pwsh function: [Convert]::FromHexString( '83748340' )
    .EXAMPLE
        Bytes.FromHexStr '83 74 83 40'
        # outputs:
        # [byte[]]@( 0x83, 0x74, 0x83, 0x40 )
    .Example
        # verify they match
        Assert.BytesEqual ( Bytes.FromHexStr '83 74 83 40' ) ( 0x83, 0x74, 0x83, 0x40 )
        # is true
    #>
    param( [Alias('HexString')] [string] $String )
    [byte[]] @(
        $String -split '\s+' ).Foreach({
            [convert]::ToByte( $_, 16)
        }
    )
}

# Hashtables of example data, strings, encodings, and byte[]s
# Script make them accessible to the caller without them having to dotsource it.
# otherwise remove 'script:' and dotsource.
$Str   = [ordered]@{}
$Enc   = [ordered]@{}
$Bytes = [ordered]@{}

$Str.Expected_ValidDecode   = 'ファイルが見つかりません' # Good: it starts like this
$Str.InvalidDecode_mojibake = '繝輔ぃ繧､繝ｫ縺瑚ｦ九▽縺九ｊ縺ｾ縺帙ｓ' # Bad: mixing decoding ended up like this

# Hashtable for encodings we care about
$Enc.ShiftJis = [System.Text.Encoding]::GetEncoding( 932 )
$Enc.Utf8     = [System.Text.Encoding]::UTF8
$Enc.Utf16le  = [System.Text.Encoding]::Unicode
$Enc.Default5 = [System.Text.Encoding]::GetEncoding( 1252 )

# hashtable of [byte[]] examples
$Bytes.Expected_Encode_ShiftJis = Bytes.FromHexStr '83 74 83 40 83 43 83 8b 82 aa 8c a9 82 c2 82 a9 82 e8 82 dc 82 b9 82 f1'

#endregion configure and setup

#region util functions
function ShowHex {
    <#
    .EXAMPLE
        # with color and titles:
        $bytes | ShowHex | LogInfo 'str => utf8'
    .EXAMPLE
        # write a simple
        $bytes | ShowHex

        # rather than:
        $Bytes | % tostring '{0:x2} '
        $bytes.ForEach({ $_.ToString('x') }) -join ' '
    #>
    @(
        $Input | %{
        if ( $_ -is [byte] ) {
            $_.ToString('x')
        } else {
            'not byte: {0}' -f $_.GetType() | Write-Warning
        }
    }) -join ' '
}
filter LogBool {
    if( $_ ) {
        $_ |  New-Text -fg 'green'
    } else {
        $_ | New-Text -fg 'red'
    }
}
function LogHeader {
    <#
    .SYNOPSIS
        'Make a big header'
    #>
    param( [string] $Text = 'header')
    @(
        " ## ${Text} ## ".PadRight(50, ' ' ) |
        Pansies\New-Text -fg Black -bg cyan3
        "`n"
    ) -join '' | Pansies\Write-Host
}

function LogInfo {
    <#
    .EXAMPLE
        $Path | LogInfo 'reading file: '
    #>
    param( [string] $Title )
    @(
        "${Title}`n    " |
        Pansies\New-Text -fg 'gray60'

        @( $Input ) -join "`n" |
        Pansies\New-Text -fg 'blue'
    ) -join '' |
    Pansies\Write-Host

}

function Assert.BytesEqual {
    <#
    .SYNOPSIS
        are two byte[] equal ?
    .EXAMPLE
        Assert.BytesEqual $byte1 $byte2
    .EXAMPLE
       Assert.BytesEqual ( Bytes.FromHexStr '83 74 83 40' ) ( 0x83, 0x74, 0x83, 0x40 )
       # is true
    #>
    param(
        [Parameter(Mandatory)]
        [byte[]] $Byte1,
        [Parameter(Mandatory)]
        [byte[]] $Byte2
    )
    if( $byte1.count -ne $byte2.count ) { return $false }

    # They must be the same length, and every element matches.
    foreach( $i in 0..( $byte1.Length - 1) ) {
        if( $byte1[ $i ] -ne $byte2[ $i ] ) {
            return $false
        }
    }
    return $true
}

function CompareEncDec.FromByte {
     <#
    .SYNOPSIS
        try and preview what the conversions are FromString
        Start with raw byte[] array, before decoding. Preview which ( decode -> encode ) pairs fail and work. pretty print it.
    .example
        CompareEncDec -Text $str.Expected_ValidDecode -EncodeAs $Enc.ShiftJis -DecodeAs $Enc.ShiftJis
    .link
        CompareEncDec.FromString
    .link
        CompareEncDec.FromByte
    #>
    param(
        [Alias('BytesList', 'Data')]
        [Parameter(Mandatory)]
        [byte[]] $ExpectedBytes,

        [Parameter(Mandatory)]
        [System.Text.Encoding] $EncodeAs,

        [Parameter(Mandatory)]
        [System.Text.Encoding] $DecodeAs
    )
    LogHeader "EncDec.FromByte -- dec => $( $DecodeAs.WebName ) enc => $( $EncodeAs.WebName )"
    $text  = $DecodeAs.GetString( $ExpectedBytes )
    $bytes = $EncodeAs.GetBytes( $Text )

    $ExpectedBytes | ShowHex | LogInfo 'ExpectedBytes'
    Assert.BytesEqual $ExpectedBytes $bytes |
        LogBool |
        LogInfo 'Is Equal'

    $bytes | ShowHex | LogInfo 'ActualBytes'
    $Text | LogInfo 'ActualText'
}

function CompareEncDec.FromString {
    <#
    .SYNOPSIS
        Start with a string. Preview what conversions work and fail. pretty print it.
    .example
        CompareEncDec -Text $str.Expected_ValidDecode -EncodeAs $Enc.ShiftJis -DecodeAs $Enc.ShiftJis
    .link
        CompareEncDec.FromString
    .link
        CompareEncDec.FromByte
    #>
    param(
        [Alias('Text', 'String', 'FromString')]
        [Parameter(Mandatory)]
        [string] $ExpectedString,

        [Parameter(Mandatory)]
        [System.Text.Encoding] $EncodeAs,

        [Parameter(Mandatory)]
        [System.Text.Encoding] $DecodeAs
    )
    LogHeader "EncDec.FromString => enc $( $EncodeAs.WebName ) => dec $( $DecodeAs.WebName )"

    $bytes = $EncodeAs.GetBytes( $ExpectedString )
    $text = $DecodeAs.GetString( $Bytes )

    $ExpectedString  | LogInfo 'ExpectedString'
    $text -eq $Str.Expected_ValidDecode |
        LogBool |
        LogInfo 'Is Equal'

    $bytes | ShowHex | LogInfo 'ActualBytes'
    $text | LogInfo 'ActualText'
}
#endregion util functions

#region Show initial config
LogHeader '$Str: inputs'
$Str | Ft -auto

LogHeader '$Enc: Encodings'

function Encoding.Summary {
    <#
    .SYNOPSIS
        Show the important WebNames, CodePage, and WindowsCodePages for all encodings
    #>
    param()
    # silly code, but it's a quick snippet for here
    LogHeader 'Names you can use for the hashtable: $Enc'
    $script:Enc.GetEnumerator() | % {
        $HashKey = $_.Key
        $_.Value |
            Select-Object @{ Name = 'HashKey'; E = { $HashKey } },
            *name*, *page* -ea Ignore
    } | ft -auto # out-string |  write-host -fg 'green'
}


$enc.Values |
        select @{ Name = 'Name'; E = { $_.Key } }, *name*, *page* -ea ignore |
        ft -auto | out-string |  write-host -fg 'green'

LogHeader '$Bytes: Inputs'
$Bytes.GetEnumerator() | %{
    $_.Value | ShowHex | LogInfo $_.Key
}

#endregion Show initial config

#region examples

LogHeader 'Examples Begin'
CompareEncDec.FromString -Text $str.Expected_ValidDecode -EncodeAs $Enc.ShiftJis -DecodeAs $Enc.ShiftJis

CompareEncDec.FromString -Text $str.Expected_ValidDecode -EncodeAs $Enc.ShiftJis -DecodeAs $Enc.Utf8
CompareEncDec.FromString -Text $str.Expected_ValidDecode -EncodeAs $Enc.ShiftJis -DecodeAs $Enc.Utf16le
CompareEncDec.FromString -Text $str.Expected_ValidDecode -EncodeAs $Enc.ShiftJis -DecodeAs $Enc.Default5

# should work
CompareEncDec.FromByte -Bytes $Bytes.Expected_Encode_ShiftJis -DecodeAs $Enc.ShiftJis -EncodeAs $Enc.ShiftJis

# should fail
CompareEncDec.FromByte -Bytes $Bytes.Expected_Encode_ShiftJis -DecodeAs $enc.Utf8 -EncodeAs $enc.Utf8
CompareEncDec.FromByte -Bytes $Bytes.Expected_Encode_ShiftJis -DecodeAs $Enc.Utf16Le -EncodeAs $Enc.ShiftJis
#endregion examples

Encoding.Summary
return

#region manual examples
$CorrectText      = 'ファイルが見つかりません'
$bytes_asShiftJis = $Enc.ShiftJis.GetBytes( $CorrectText )
$text             = $Enc.Utf8.GetString( $bytes_asShiftJis )

$CorrectText | LogInfo 'ExpectedText'
$text | LogInfo 'ActualText'

$bytes_asShiftJis  | ShowHex |
    LogInfo 'good => enc shiftJis => dec utf8 => bad'

#endregion manual examples
