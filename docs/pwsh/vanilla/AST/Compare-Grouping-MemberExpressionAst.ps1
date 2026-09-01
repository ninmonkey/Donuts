#requires -PSEdition Core
using namespace System.Management.Automation.Language

$ast = { ( $Null )?.ToString() }.Ast
$find = $ast.FindAll( { param( [Ast] $Ast ) $true }, $false )
$find | % gettype | Join-String Name -f "`n - {0}" -op "From: ( `$null )?.`n"

"`n---`n"

$ast = { ${Null}?.ToString() }.Ast
$find = $ast.FindAll( { param( [Ast] $Ast ) $true }, $false )
$find | % gettype | Join-String Name -f "`n - {0}" -op "From: `${null}?.`n"
