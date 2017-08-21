if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) 
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

$sitename= "http://Sp2016"
$sitelogo= "/siteAssets/NewLogo.jpg"
$site=new-object Microsoft.SharePoint.SPSite($sitename)
foreach($web in $site.Allwebs) {
    $web.SiteLogoUrl=$sitelogo
    $web.Update()
}
$site.Dispose() 
