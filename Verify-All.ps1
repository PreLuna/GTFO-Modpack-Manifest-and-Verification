param([string]$CheckoutRoot=(Split-Path $PSScriptRoot -Parent),[switch]$AllowUnpinned)
$ErrorActionPreference='Stop'
$manifest=Get-Content -LiteralPath (Join-Path $PSScriptRoot 'integration.json') -Raw|ConvertFrom-Json
$tool=Join-Path $CheckoutRoot 'GTFO-Mod-Build-and-Verification-Tools'
& (Join-Path $tool 'tools/Verify-Repository.ps1') -RepositoryRoot $PSScriptRoot
foreach($entry in $manifest.Repositories){
 $repo=Join-Path $CheckoutRoot $entry.Repository
 if((Get-FileHash -LiteralPath (Join-Path $repo 'maintenance.lock.json')).Hash -cne $entry.SourceLockSHA256){throw ('Lock mismatch: '+$entry.Repository)}
 & (Join-Path $tool 'tools/Verify-Repository.ps1') -RepositoryRoot $repo
 if(!$AllowUnpinned){
  if($entry.Commit -notmatch '^[a-fA-F0-9]{40}$'){throw ('Missing published commit: '+$entry.Repository)}
  $head=& git -C $repo rev-parse HEAD
  if($LASTEXITCODE -ne 0 -or $head -cne $entry.Commit){throw ('Checkout commit mismatch: '+$entry.Repository)}
  if(@(& git -C $repo status --porcelain).Count){throw ('Checkout has local changes: '+$entry.Repository)}
 }
}
Write-Output ('PASS: '+$manifest.Repositories.Count+' source checkouts; PublishedCommitChecks='+(!$AllowUnpinned)+'; GameplayTested=False; LegacyDeletionAllowed=False')
