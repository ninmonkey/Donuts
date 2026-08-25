#region define utils
$Enc = [ordered]@{
    ShiftJIS = [System.Text.Encoding]::GetEncoding("Shift_JIS")
    Utf8Strict = [System.Text.UTF8Encoding]::new(
        <# shouldEmitUtf8BOM #> $false, <# should throw on decode error #> $true )
}
filter LogFilePath {
    # log clickable filepath as short name
    $file = Get-Item -ea 'stop' $_
    Pansies\New-Hyperlink -Uri ($File.FullName) -Object ( 'Wrote: {0}' -f $File.name )
    # Pansies\New-Hyperlink -Uri ($File.FullName) -Object ($file | Join-String -p Name -op 'Wrote: ') # pwsh 7
}
#endregion define utils

#region demo body

function WriteSampleFile {
    <#
    .SYNOPSIS
        Write a file using 'ShiftJIS' encoding
    #>
    param(
        [alias('Path')]
        [string] $OutFilePath = (Join-Path $PSScriptRoot 'out-file.txt' )
    )

    $json = @{
        Message = 'こんにちは世界'
        Id = New-GUID
    } | ConvertTo-Json

    New-Item -ItemType File -Path $OutFilePath -ea Ignore
    $file = gi -ea 'stop' $OutFilePath

    [System.IO.File]::WriteAllText(
        $file.FullName, $json, $Enc.ShiftJIS
    )
    $file | LogFilePath
}

function Test-ShiftJISDecodeError {
    <#
    .synopsis
        Try decoding a file as utf-8 looking for any decode errors. If it is encoded as ShiftJIS, it will likely have some errors during decode
    #>
    [OutputType( [bool] )]
    param(
        [Alias('Path')]
        [Parameter(mandatory)]
        $FilePath
    )
    $File = Get-Item -ea 'stop' $FilePath

    # now read file as utf8, but catch any decode errors. errors should never be silent.

    $bytes = [System.IO.File]::ReadAllBytes( $File.FullName )
    try {
        [void] $Enc.Utf8Strict.GetString( $bytes )
        return $false
    }
    catch [System.Text.DecoderFallbackException] {
        return $true
    }
}

$Enc.Values | ft -auto

$Dest = Join-Path $PSScriptRoot 'out-file.txt'
WriteSampleFile -OutFilePath $Dest

'Decode Error?: {0}' -f ( Test-ShiftJISDecodeError -FilePath $Dest )

#endregion demo body
