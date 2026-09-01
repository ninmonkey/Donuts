<#
.notes
    from: https://learn.microsoft.com/en-us/powershell/scripting/dev-cross-plat/performance/script-authoring-considerations?view=powershell-7.6#use-ordereddictionary-to-dynamically-create-new-objects
#>

$tests = @{

    '[ordered] into [pscustomobject] cast' = {
        param([int] $Iterations, [string[]] $Props)

        foreach ($i in 1..$Iterations) {
            $obj = [ordered]@{}
            foreach ($prop in $Props) {
                $obj[$prop] = $i
            }
            [pscustomobject] $obj
        }
    }
    'Add-Member'                           = {
        param([int] $Iterations, [string[]] $Props)

        foreach ($i in 1..$Iterations) {
            $obj = [psobject]::new()
            foreach ($prop in $Props) {
                $obj | Add-Member -MemberType NoteProperty -Name $prop -Value $i
            }
            $obj
        }
    }
    'PSObject.Properties.Add'              = {
        param([int] $Iterations, [string[]] $Props)

        # this is how, behind the scenes, `Add-Member` attaches
        # new properties to our PSObject.
        # Worth having it here for performance comparison

        foreach ($i in 1..$Iterations) {
            $obj = [psobject]::new()
            foreach ($prop in $Props) {
                $obj.psobject.Properties.Add(
                    [psnoteproperty]::new($prop, $i))
            }
            $obj
        }
    }
}

$properties = 'Prop1', 'Prop2', 'Prop3', 'Prop4', 'Prop5'

1kb, 10kb, 100kb | ForEach-Object {
    $groupResult = foreach ($test in $tests.GetEnumerator()) {
        $ms = Measure-Command { & $test.Value -Iterations $_ -Props $properties }

        [pscustomobject]@{
            Iterations        = $_
            Test              = $test.Key
            TotalMilliseconds = [Math]::Round($ms.TotalMilliseconds, 2)
        }

        [GC]::Collect()
        [GC]::WaitForPendingFinalizers()
    }

    $groupResult = $groupResult | Sort-Object TotalMilliseconds
    $groupResult | Select-Object *, @{
        Name       = 'RelativeSpeed'
        Expression = {
            $relativeSpeed = $_.TotalMilliseconds / $groupResult[0].TotalMilliseconds
            [Math]::Round($relativeSpeed, 2).ToString() + 'x'
        }
    }
}
