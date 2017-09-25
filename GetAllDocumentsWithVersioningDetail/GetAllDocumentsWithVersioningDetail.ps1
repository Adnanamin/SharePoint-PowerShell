if((Get-PSSnapin | Where {$_.Name -eq "Microsoft.SharePoint.PowerShell"}) -eq $null) 
{
	Add-PSSnapin Microsoft.SharePoint.PowerShell;
}

function GetAllDocInventoryWithVersion([string]$siteUrl, $documentLibrary) {

$SPWeb = Get-SPWeb $siteUrl #Change the SharePoint site name here#
write-host SPWeb.Title
$List = $SPWeb.Lists[$documentLibrary] #Change the document library name here#
$ItemsColl = $List.Items
$tableau =@();

foreach ($item in $ItemsColl) 
{
    $itemFileSize = $item.File.Length/1KB
    $o = new-object psobject
  
    $o | Add-Member -MemberType noteproperty -Name "ItemID" -value $item.ID;
    $o | Add-Member -MemberType noteproperty -Name "Item Title" -value $item.Title;
    $o | Add-Member -MemberType noteproperty -Name "Version" -value  "";#$item.Versions.Count;
    $o | Add-Member -MemberType noteproperty -Name "Item URL" -value $item.Url;    
    $o | Add-Member -MemberType noteproperty -Name "Comments" -value  $item.CheckInComment;
    $o | Add-Member -MemberType noteproperty -Name "File Size (KB)" -value $itemFileSize ;
    $o | Add-Member -MemberType noteproperty -Name "Created Date" -value $item["Created"]
    $o | Add-Member -MemberType noteproperty -Name "Created By" -value $item["Author"]
    $o | Add-Member -MemberType noteproperty -Name "Modifed Date" -value $item["Created"]
    $o | Add-Member -MemberType noteproperty -Name "Modifed By" -value $item["Editor"]
    $tableau += $o;
    
    foreach($Ver in $item.Versions)
     {
        $verFileSize = $item.File.Versions.GetVersionFromLabel($Ver.VersionLabel).Size/1KB
        $v = new-object psobject
        $comment = $item.File.Versions.GetVersionFromLabel($Ver.VersionLabel).CheckInComment
           
        $v | Add-Member -MemberType noteproperty -Name "ItemID" -value $item.ID;
        $v | Add-Member -MemberType noteproperty -Name "Item Title" -value $item.Title;
        $v | Add-Member -MemberType noteproperty -Name "Version" -value  $Ver.VersionLabel;
        $v | Add-Member -MemberType noteproperty -Name "Item URL" -value $Ver.Url;
        $v | Add-Member -MemberType noteproperty -Name "Comments" -value  $comment;    
        $v | Add-Member -MemberType noteproperty -Name "File Size (KB)" -value $verFileSize;
        $v | Add-Member -MemberType noteproperty -Name "Created Date" -value $Ver["Created"]
        $v | Add-Member -MemberType noteproperty -Name "Created By" -value $Ver["Author"]
        $v | Add-Member -MemberType noteproperty -Name "Modifed Date" -value $Ver["Created"]
        $v | Add-Member -MemberType noteproperty -Name "Modifed By" -value $Ver["Editor"]
        $tableau += $v;
       
     }
}

$SPWeb.Dispose();
#$tableau| Out-GridView
return $tableau
}





#GetAllDocInventoryWithVersion "https://SharePoint2013" "Program Management"| Out-GridView
#GetAllDocInventoryWithVersion "https://SharePoint2013" "Program Management" Out-File "E:\Reports\DocumentLibraryInventory.csv"