# EverythingSearch

Many queries use features added after `v1.5.0`

#  Colorize by Group

# Operators

## Wildcards

> [!NOTE]
> ref: [search_syntax](https://www.voidtools.com/support/everything/search_syntax/#syntax)

| Operator | Desc |
| - | - |
| `*` | 	Matches zero or more characters (except `\` ) | 
| `**` | 	Matches zero or more characters | 
| `?` | 	Matches one character (except `\` ) |

## Entities, Escaped Literals

| Escape | Desc |
| - | - |
| `&sp:` |	Literal space (` `) |
| `&vert:` |	Literal vertical line (`\|`) |
| `&excl:` |	Literal exclamation mark (`!`) |
| `&lt:` |	Literal less than (`<`) |
| `&gt:` |	Literal greater than (`>`) |
| `&quot:` |	Literal double quote (`"`) |
| `&#<n>:` |	Literal Unicode character `<n>` in **decimal**. |
| `&#x<n>:` |	Literal Unicode character `<n>` in **hexadecimal**. |


