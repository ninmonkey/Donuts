#requires -PSEdition Desktop

$OutRoot = Get-Item $PSScriptRoot
$Enc = [ordered]@{
    ShiftJIS = [System.Text.Encoding]::GetEncoding("Shift_JIS")
    Utf8Strict = [System.Text.UTF8Encoding]::new(
        <# shouldEmitUtf8BOM #> $false, <# should throw on decode error #> $true )

    AsciiStrict = [System.Text.Encoding]::GetEncoding(
        <# codepage: #> 'us-ascii',
        <# encoderFallback: #> ([System.Text.EncoderExceptionFallback]::new()),
        <# decoderFallback: #> ([System.Text.DecoderExceptionFallback]::new()) )
}


$Example = @{
    ShiftJIS_Json = [byte[]] @( 123, 13, 10, 32, 32, 32, 32, 34, 73, 100, 34, 58, 32, 32, 34, 51, 99, 98, 51, 52, 101, 53, 53, 45, 100, 56, 49, 57, 45, 52, 51, 56, 50, 45, 56, 49, 49, 101, 45, 55, 97, 102, 53, 51, 51, 101, 56, 97, 56, 54, 100, 34, 44, 13, 10, 32, 32, 32, 32, 34, 77, 101, 115, 115, 97, 103, 101, 34, 58, 32, 32, 34, 130, 177, 130, 241, 130, 201, 130, 191, 130, 205, 144, 162, 138, 69, 34, 13, 10, 125 )

    JsonLiteral = '{
    "Id":  "3cb34e55-d819-4382-811e-7af533e8a86d",
    "Message":  "こんにちは世界"
    }'
}

# [a] this is expected to silently have errors
[System.IO.File]::WriteAllText(
    ( Join-Path $OutRoot 'expect_silently_fail.txt' ),
    $Example.JsonLiteral, [System.Text.Encoding]::ASCII)


# [b] expect errors
function Test-AsciiEncodeError {
    param( [string] $Text )
    try {
        $bytes = $Enc.AsciiStrict.GetBytes( $Text )

        [System.IO.File]::WriteAllBytes(
            ( Join-Path $OutRoot 'expect_errors.txt' ),
            $bytes )
        return $false
    } catch {
        return $true
    }
}
