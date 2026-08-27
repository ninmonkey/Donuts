## ex 1

( $grads = get-gradient -StartColor 'darkgray' 'red' -Width 8 )
0..( $grads.count - 1 ) | %{
   $_ | New-Text -fg ( $grads[ $_ ] )
}  | write-host


## ex 2



( $grads = get-gradient -StartColor '#000000' '#dddddd' -Width 5 )
0..( $grads.count - 1 ) | %{
   $curGrad = $grads[ $_ ]
   $_ | New-Text -bg  $curGrad -fg ( Pansies\Get-Complement $curGrad -HighContrast )
}  | write-host
