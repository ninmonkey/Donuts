## For **WinPS 5.1** the encodings used are

| Cmd                             | Encoding                                                       |
| ------------------------------- | -------------------------------------------------------------- |
| Set-Content (default)           | env - uses system code page ex ansi                            |
| Tee-Object (default)            | utf16-le                                                       |
| New-Item (default)              | UTf8NoBOM                                                      |
| Get-Content (default)           | env - system                                                   |
| Get-Content -Encoding Byte -Raw | none - if using Powershell.exe 5.1 <br/>returns raw byte array |
| Get-Content  -AsByteStream -Raw | none - if using Pwsh.exe 7</br/>returns raw byte array         |


| Get-Content -AsByteStream | none - read raw bytes |
| Get-Content -Raw | decides if you split on newlines,<br/> different from encoding |

> [!NOTE]
> Ps 5.1 vs 7 change params to read raw bytes