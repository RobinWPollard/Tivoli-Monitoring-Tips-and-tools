# Tivoli-Monitoring-Tips-and-tools
Here I plan to park some handy Tivoli tips and tools

## Impact Server Quick Sort
Quick sort is classically written using recursion. Unfortunately Impact Programing Language (IPL) does not do recursion. IBM ship an example sort but it is bogosort (bubble sort) one of the slowest possible sort routines other than just make random switches until it is sorted. To provide a decent way to sort larger amounts of data I have implemented quicksort using a stack rather than recursion.

To use this function save the library ipl in your ipl folder. Then use the qualified name to address the function and give it your array. The array is sorted in place is sorted in place.

``` 
# library code saved as qsort_lib.ipl
qsort_lib.ipl.qsort(Array);
```
You could also just append the functions to an existing libabrary and call it as

```my_extant_lib.qsort(Array);```

## Cached lookup of server details from tacmd listSystems
``` PowerShell
function cachedLookup {
    # Given a hostname this will use a tacmd listSystems to return one or more of Agent, Type, Version, Status
    # Type is largely superfluous as you gave this as the first paramter. It is there for completeness.
    # The tacmd listSystems is cached so it is only done once. You can send a 'refresh' request to force refresh of the data
    Param (
        [Parameter(Mandatory=$True, Position=0)] $OSType,
        [Parameter(Mandatory=$True, Position=1)] $Target,
        [Parameter(Mandatory=$True, Position=2)] $Objects,
        [Parameter(Mandatory=$False,Position=3)] $Refresh
    )
    Process {
        if ($Iknow.ContainsKey($OSType) -and -not $Refresh) {
            # Write-Host "Agent cache has key $OSType"
        }
        else {
            Write-Host "Looking up $OSType agents"
            $Iknow.$OSType = @{}
            Write-Host "Type added"
            (tacmd listSystems -t $OSType | Select-String -NotMatch 'Managed System').foreach{ 
                ($Agent, $Type, $Version, $status) = $_-split("\s+")
                $name = $Agent-replace ":$OSType",''; 
                $Iknow.$OSType.$name = @{ # Store the record for this host
                      'Agent' = $Agent
                       'Type' = $Type
                    'Version' = $Version
                     'Status' = $Status
                }
            }
        }
        $result = @()
        if ( $Iknow.$OSType.ContainsKey($target) ) {
            foreach ($Item in $Objects) {
                $results += $Iknow.$OSType.$target.$Item
            }
        }
        return $results
    }
}
```
