
- [Visualizing Encoding Errors](#visualizing-encoding-errors)
  - [Main Code](#main-code)
- [Interactive Mode](#interactive-mode)
- [Troubleshooting and tips](#troubleshooting-and-tips)
  - [Save `UTF8` as `UTF8WithBOM`](#save-utf8-as-utf8withbom)

# Visualizing Encoding Errors

I wrote functions that lets you visualize the difference between encoding errors you can run across in Powershell 5.1. 

This started as a reply about errors when using [default encoding errors using Powershell 5.1 and a japanese culture](https://www.reddit.com/r/PowerShell/comments/1vtb7q2/getcontent_encoding_utf8_fixed_four_of_my_log/)


This started as a reply to this thread: 
> [!Note]
> Errors from mixing the wrong encodings occur in any language. The defaults in Powershell 5.1 make it a little harder to deal with than Pwsh 7 or other languages. But it's not specific to powershell or platform. 


## Main Code

This script can run stand-alone: [Compare-Encode-Decode-Errors-on-Powershell-5.1.ps1](Compare-Encode-Decode-Errors-On-PowerShell-5.1.ps1)

![screenshot-test-many](img/Screenshot.CompareEncoding-Many-Powershell-5.1.png)




# Interactive Mode

To user helpers just dotsource the script.

![screenshot-single-test](img/Screenshot.CompareEncoding-Manual-Testing.png)

```powershell
. ./Compare-Encode-Decode-Errors-On-PowerShell-5.1.ps1
$enc.Utf8.GetString( $enc.Utf8.GetBytes( '🐒' ))
# prints: '🐒'

$enc.Utf8.GetBytes( '🐒' ) | ShowHex
# prints: 'f0 9f 90 92'

# to remember the names:
Encoding.Summary
```
It prints:

| HashKey  | BodyName    | EncodingName               | HeaderName   | WebName      | WindowsCodePage | CodePage |
| -------- | ----------- | -------------------------- | ------------ | ------------ | --------------- | -------- |
| ShiftJis | iso-2022-jp | Japanese (Shift-JIS)       | iso-2022-jp  | shift_jis    | 932             | 932      |
| Utf8     | utf-8       | Unicode (UTF-8)            | utf-8        | utf-8        | 1200            | 65001    |
| Utf16le  | utf-16      | Unicode                    | utf-16       | utf-16       | 1200            | 1200     |
| Default5 | iso-8859-1  | Western European (Windows) | Windows-1252 | Windows-1252 | 1252            | 1252     |


# Troubleshooting and tips

## Save `UTF8` as `UTF8WithBOM`

> [!IMPORTANT]
> If you copy the code, make sure you save the file as `UTF8WithBOM` . Then `PowerShell.exe` will automatically support `utf-8` string literals in the source file itself ( In `Powershell 5.1` )





```powershell
Here's code to compare encoding and decoding behavior in PowerShell 5.1, highlighting potential issues with mojibake and ensuring that the output remains consistent.

.SYNOPSIS
    Runs on Powershell 5.1. Pretty print encoding errors and assert the full output is exactly the same
.DESCRIPTION


The short is Strings correctly encoded as ShiftJis
But then decoded using utf-8 will break many codepoints because they are not valid in that encoding.
You can use 'default' or 'ascii' -- but then it can indirectly break things like parsing json, quotes, commas etc
.link
    https://github.com/ninmonkey/Donuts/tree/main/docs/pwsh/vanilla/Encoding/Compare-Encoding-Breaking-Emojibake/readme.md
```