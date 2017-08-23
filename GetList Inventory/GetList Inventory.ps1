if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) 
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

function GetListInventory($siteUrl)
{
    $webApp = Get-SPWebApplication $siteUrl
   
    $SiteDetail = @();

    Foreach ($web in $webApp | Get-SPSite -Limit All | Get-SPWeb -Limit All)
    {
       Write-host "Processing site $web.Name..."

            foreach($list in $web.lists)
            { 
             $row = new-object PSObject
                Add-member -inputObject $row -memberType NoteProperty -Name "Site Name" -value $web.Name
                Add-member -inputObject $row -memberType NoteProperty -Name "URL" -value $web.Url
                Add-member -inputObject $row -memberType NoteProperty -Name "List Title" -value $List.Title
                Add-member -inputObject $row -memberType NoteProperty -Name "List Item Count" -value $list.ItemCount
				#Add-member -inputObject $row -memberType NoteProperty -Name "List Item Count" -value $list.Items.Count 
                Add-member -inputObject $row -memberType NoteProperty -Name "Last Modified Date" -value $List.LastItemModifiedDate
                if ($list.EnableVersioning -eq $TRUE) 
                {
                Add-member -inputObject $row -memberType NoteProperty -Name "Versioning" -value "Yes"
                }else
                {
                Add-member -inputObject $row -memberType NoteProperty -Name "Versioning" -value "No"
                
                } 
                $SiteDetail += $row;

            }

        

    }
    $SiteDetail 
}

GetListInventory "http://SPFarm2016" | Out-GridView 
#GetListInventory "http://SPFarm2016" |  Out-File "E:\FMT\ListInventory.csv"