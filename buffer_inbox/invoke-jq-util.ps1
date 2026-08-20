
function Invoke-Jq {
    param( 
       [string] $Query,
       [Alias('Path', 'From')] [string] $JsonFile
	)

    'other switches: PassThru (asObject), from stdin, color, format, paging ' | write-host 
    jq $Query $FromPath    
}
'function Jq.ShowTopKey: pick selection then only show that key nothing else. also first -N if it is an array'
filter Jq.FindKey { 
   <#
   .example
       $jsonPath | Jq.FindKey
   #>
   param( $Query = 'keys' ) 
   $SrcPath = $_
   jq $Query $srcPath | ConvertFrom-Json
}
