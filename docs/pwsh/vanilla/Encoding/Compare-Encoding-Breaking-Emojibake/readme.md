



# About

I wrote functions that lets you visualize the difference between encoding errors you can run across in Powershell 5.1. 
I [started this as a reply to a reddit thread about japanese encoding issues](This started as a reply to this thread: https://www.reddit.com/r/PowerShell/comments/1vtb7q2/getcontent_encoding_utf8_fixed_four_of_my_log/)

> [!Note]
> These encoding errors can occur in any language. The defaults in Powershell 5.1 make it a little more complicated than Pwsh 7 or other languages. But it's not specific to powershell or windows.


## Example: Using the helpers to compare results in the shell

![screenshot-single-test](img/Screenshot.CompareEncoding-Manual-Testing.png)

## Main Code

here's a stand alone script: [Compare-Encode-Decode-Errors-on-Powershell-5.1.ps1](Compare-Encode-Decode-Errors-On-PowerShell-5.1.ps1)

## Troubleshooting and tips

> [INFO:] 
> If you copy the code, make sure you save it as `UTF8WithBOM` . That makes it easier to run with unicode strings in the `.ps1` file
> otherwise you could insert them as char offsets

![screenshot-test-many](img/Screenshot.CompareEncoding-Many-Powershell-5.1.png)



```ps1
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