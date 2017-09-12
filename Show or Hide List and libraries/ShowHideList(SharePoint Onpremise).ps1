
function ShowHideList($siteUrl, $listName, $showHideValue)
{
    $web = Get-SPWeb $siteUrl
    #Get the List
    $list = $web.Lists[$listName]
 
    #Set the Hidden Property to show or hide
    $list.Hidden = $showHideValue
    $list.Update()

    if ($showHideValue -eq $true)
        {
            Write-Host "$listName hidden successfully!"
        }else{
            Write-Host "$listName enabled/shown successfully!"
        }
    $web.Dispose()
}

#function call
#site URL, List/Library name, $true/$false
ShowHideList "https://sharepoint2016" "Internal Documents" $true