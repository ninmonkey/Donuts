# [11] rendering longer than screen lines
$Delim = "`u{2400}"
$renderProc ??= $proc | Select -First 40 | %{ $_ | Join-string -p { $_.Id, $_.Name, $_.CommandLine } -sep $Delim }
$longRender = $renderProc | Sort -Property Length -Descending -Top 4
$longRender
| fzf -m

# [10] of transformed list, search nth element
$Delim = "`u{2400}"
$renderProc ??= $proc | Select -First 40 | %{ $_ | Join-string -p { $_.Id, $_.Name, $_.CommandLine } -sep $Delim }
$longRender = $renderProc | Sort -Property Length -Descending -Top 4
$renderProc | fzf -m  '--with-nth=2,1' <# display: Name, Pid #> --nth=1  <# of them, search 1st #>


# [9] Select fields out-of order, and drop some
# input fields[3] : Id, Name, CommandLine
$Delim = "`u{2400}"
$renderProc ??= $proc | Select -First 40 | %{ $_ | Join-string -p { $_.Id, $_.Name, $_.CommandLine } -sep $Delim }
$renderProc | fzf -m  '--with-nth=2,1' # display: Name, Pid
$renderProc | fzf -m  '--with-nth=1,2' # display: Pid, Name


# [8] emit data ID without showing it to the user
$Delim = "; "
$strs = get-culture -ListAvailable | %{ $_.Name, $_.DisplayName -join $delim }
$res = $strs | fzf -m "--delimiter=${delim}" --with-nth=2 <# search by english #>
<# Only display, and search by the 2nd field

user sees:
    "English"

output of $res includes hidden column: Could use a distinct ID to preserve object choice.
    "en; English"

#>



# [7] with field number
$Delim = "; "
$strs = get-culture -ListAvailable | %{ $_.Name, $_.DisplayName -join $delim }
$strs | fzf -m "--delimiter=${delim}" --nth=1 <# search by en-us #>
$strs | fzf -m "--delimiter=${delim}" --nth=2 <# search by english #>

# [6] with initial filter
'a'..'f'
| fzf -m --cycle --footer foot --layout=reverse --header "Cult" --header-first --input-border rounded --gap=1 --gap-line="$(New-Text '-' -fg gray30)" --info=inline '--prompt=' --query=4
<# --no-input #> <# --tac #> <# --header-border=rounded #>
<#  --exit-0 #> # exit when no match
<# --select-1  #> # only select 1 total
<# --no-multi-line #> # disable mult-line display when using --read0
<# --read0   #>       # Read input delimited by ASCII NUL characters
<# --print0  #>       # Print output delimited by ASCII NUL characters


# [5] prompt equals ''
'a'..'f'
| fzf -m --cycle --footer foot --layout=reverse --header "Cult" --header-first --input-border rounded --gap=1 --gap-line="$(New-Text '-' -fg gray30)" --info=inline '--prompt='
<# --no-input #> <# --tac #>

# [4] with inline + prefix
'a'..'f'
| fzf -m --cycle --footer foot --layout=reverse --header "Cult" --header-first --input-border rounded --gap=1 --gap-line="$(New-Text '-' -fg gray30)" --info=inline

# [3] with inline
'a'..'f'
| fzf -m --cycle --footer foot --layout=reverse --header "Cult" --header-first --input-border rounded --gap=1 --gap-line="$(New-Text '-' -fg gray30)" '--info=inline:pre '

# [2] same but sort

'a'..'f'
| fzf -m --cycle --footer foot --layout=reverse --header "Cult" --header-first --input-border rounded --gap=1 --gap-line="$(New-Text '-' -fg gray30)" <# --no-input #> <# --tac #>

# [1] inline text

'a'..'f'
| fzf -m --tac --cycle --footer foot --layout=reverse --header "Cult" --header-first --input-border rounded --gap=1 --gap-line="$(New-Text '-' -fg gray30)" <# --no-input #>

# [0] padded lines between options
Get-culture -ListAvailable
| fzf -m --tac --cycle --footer foot --layout=reverse --header "Property 'foo' " --header-first --input-border rounded --no-input  --gap=1 --gap-line="$(New-Text '-' -fg gray30)"
