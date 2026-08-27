#requires -PSEdition Core

function Measure-ProcessMemory {
    <#
    .synopsis
        Get Process memory usage
    .link
        https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.process?view=net-10.0#properties
    #>
    param(
        # exact process name
        [string] $ExactName,

        # else by regex patterns
        [string] $RegexName
    )

    if( $ExactName ) {
        $ps = Get-Process -Name $ExactName
    } else {
        $ps = Get-Process | ? Name -match $RegexName
    }
    $propNames64 = @( $ps )[0].psobject.Properties | ? name -Match '64' | % name | Sort-object

    @( foreach( $prop in $propNames64 ) {
        $bytes = ( $ps | Measure-Object -Property $prop -Sum).Sum
        [pscustomobject]@{ Prop = $Prop;
            Gb = $bytes / 1gb | Join-string -f '{0:n1}'
            Mb = $bytes / 1mb | Join-String -f '{0:n1}'
            Bytes = $Bytes
        }
    }) | Sort-Object gb -Descending
}
