# Winget List

- [Winget List](#winget-list)
  - [Configure Defaults: `settings.json`](#configure-defaults-settingsjson)
  - [Sorting](#sorting)
    - [By Property](#by-property)
    - [By Multiple Properties](#by-multiple-properties)
- [Docs:](#docs)

## Configure Defaults: `settings.json`

You can configure default sorting order using your [settings.json](https://github.com/microsoft/winget-cli/blob/master/doc/Settings.md)


You can select any amount of properties:
```json
{
    "output": {
        "sortDirection": "descending",
        "sortOrder": [ "available", "id", "name", "relevance", "source", "version" ]
    }
}
```

> [!TIP]
> When enabled vscode will autocomplete `.json` keys for you using `json schema`. 
>
> You may need to enable: `json.schemaDownload.enable`  and `json.schemaDownload.trustedDomains`

## Sorting 

| Param               | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| `--sort <property>` | **Repeatable**. Sort the list by a property                  |
| `--asc` / `--desc`  | Sort in ascending / descending order. ( Default: ascending ) |

Property names are `Available`, `Id`, `Name`, `Source`, `Version`, etc.

### By Property

property name and `--asc` vs `--desc` 
```powershell
# sort by column: Id
winget list winget --sort id
# sort by column: Available descending
winget list winget --sort available --desc
```
```
Name                                       Id                                                                        Version             Available           Source
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
zoxide                                     ajeetdsouza.zoxide                                                        0.10.0                                  winget
xsv                                        BurntSushi.xsv.MSVC                                                       0.13.0                                  winget
SysInternals                               ARP\User\X64\Microsoft.Sysinternals_Microsoft.Winget.Source_8wekyb3d8bbwe 2024-07-23
Windows Package Manager Source (winget) V2 MSIX\Microsoft.Winget.Source_2026.829.1735.17_neutral__8wekyb3d8bbwe      2026.829.1735.17
Process Explorer                           Microsoft.Sysinternals.ProcessExplorer                                    17.06               17.13               winget
```

### By Multiple Properties

```powershell
# sort by columns: available, name as descending
winget list winget --sort available --sort name --desc
```
```
Name                                       Id                                                                        Version             Available           Source
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
zoxide                                     ajeetdsouza.zoxide                                                        0.10.0                                  winget
xsv                                        BurntSushi.xsv.MSVC                                                       0.13.0                                  winget
Windows Package Manager Source (winget) V2 MSIX\Microsoft.Winget.Source_2026.829.1735.17_neutral__8wekyb3d8bbwe      2026.829.1735.17
SysInternals                               ARP\User\X64\Microsoft.Sysinternals_Microsoft.Winget.Source_8wekyb3d8bbwe 2024-07-23
```


# Docs:

> [!NOTE]
> The [docs don't seem to mention sorting](https://learn.microsoft.com/en-us/windows/package-manager/winget/list), but if you run `winget list --help` it does explain them. The direct repo does mention them at [microsoft/winget-cli/../list.md](https://github.com/microsoft/winget-cli/blob/master/doc/windows/package-manager/winget/list.md)


**microsoft docs**:
- [winget list](https://learn.microsoft.com/en-us/windows/package-manager/winget/list)
