
- [About: Visualize Encoding/Decoding Errors](#about-visualize-encodingdecoding-errors)
  - [Example: Using the helpers to compare results in the shell](#example-using-the-helpers-to-compare-results-in-the-shell)
  - [Main Code](#main-code)
  - [Troubleshooting and tips](#troubleshooting-and-tips)
  - [Interactive Mode](#interactive-mode)

# About: Visualize Encoding/Decoding Errors

I wrote functions that lets you visualize the difference between encoding errors you can run across in Powershell 5.1. 

This started as a reply about errors when using [default encoding errors using Powershell 5.1 and a japanese culture](https://www.reddit.com/r/PowerShell/comments/1vtb7q2/getcontent_encoding_utf8_fixed_four_of_my_log/)


This started as a reply to this thread: 
> [!Note]
> Errors from mixing the wrong encodings occur in any language. The defaults in Powershell 5.1 make it a little harder to deal with than Pwsh 7 or other languages. But it's not specific to powershell or platform. 


![screenshot-test-many](img/Screenshot.CompareEncoding-Many-Powershell-5.1.png)


## Example: Using the helpers to compare results in the shell

![screenshot-single-test](img/Screenshot.CompareEncoding-Manual-Testing.png)

## Main Code

here's a stand alone script: [Compare-Encode-Decode-Errors-on-Powershell-5.1.ps1](Compare-Encode-Decode-Errors-On-PowerShell-5.1.ps1)

## Troubleshooting and tips


> [!IMPORTANT]
> If you copy the code, make sure you save the file as `UTF8WithBOM` . Then `PowerShell.exe` will automatically support `utf-8` string literals in the source file itself ( In `Powershell 5.1` )


## Interactive Mode



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