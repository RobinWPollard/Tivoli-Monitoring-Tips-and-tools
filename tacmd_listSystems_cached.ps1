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
