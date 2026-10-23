param([string]$CheckoutRoot=(Split-Path $PSScriptRoot -Parent),[switch]$AllowUnpinned,[switch]$LocalWorkspace)
$ErrorActionPreference='Stop'
$manifest=Get-Content -LiteralPath (Join-Path $PSScriptRoot 'integration.json') -Raw|ConvertFrom-Json
$tool=Join-Path $CheckoutRoot 'GTFO-Mod-Build-and-Verification-Tools'
& (Join-Path $tool 'tools/Verify-Repository.ps1') -RepositoryRoot $PSScriptRoot
if($LocalWorkspace -and $AllowUnpinned){throw 'Choose LocalWorkspace or AllowUnpinned, not both.'}
$entries=$manifest.Repositories
if($LocalWorkspace){
 if(!$manifest.LocalWorkspace -or $manifest.LocalWorkspace.CommitCreated -or $manifest.LocalWorkspace.Pushed){throw 'A local uncommitted workspace manifest is required.'}
 $entries=$manifest.LocalWorkspace.Repositories
 & (Join-Path $tool 'tools/Check-Commit.ps1') -RepositoryRoot $PSScriptRoot | Out-Null
 $head=& git -C $PSScriptRoot rev-parse HEAD
 if($LASTEXITCODE -ne 0 -or $head -cne $manifest.LocalWorkspace.BaseIntegrationCommit){throw 'Local integration base commit mismatch.'}
}
foreach($entry in $entries){
 $repo=Join-Path $CheckoutRoot $entry.Repository
 if((Get-FileHash -LiteralPath (Join-Path $repo 'maintenance.lock.json')).Hash -cne $entry.SourceLockSHA256){throw ('Lock mismatch: '+$entry.Repository)}
 & (Join-Path $tool 'tools/Verify-Repository.ps1') -RepositoryRoot $repo
 if($LocalWorkspace){
  & (Join-Path $tool 'tools/Check-Commit.ps1') -RepositoryRoot $repo | Out-Null
  $head=& git -C $repo rev-parse HEAD
  if($LASTEXITCODE -ne 0 -or $head -cne $entry.BaseCommit){throw ('Local base commit mismatch: '+$entry.Repository)}
 }elseif(!$AllowUnpinned){
  if($entry.Commit -notmatch '^[a-fA-F0-9]{40}$'){throw ('Missing source commit: '+$entry.Repository)}
  $head=& git -C $repo rev-parse HEAD
  if($LASTEXITCODE -ne 0 -or $head -cne $entry.Commit){throw ('Checkout commit mismatch: '+$entry.Repository)}
  if(@(& git -C $repo status --porcelain).Count){throw ('Checkout has local changes: '+$entry.Repository)}
 }
}
Write-Output ('PASS: '+$entries.Count+' source checkouts; LocalWorkspace='+[bool]$LocalWorkspace+'; SourceCommitChecks='+(!$AllowUnpinned -and !$LocalWorkspace)+'; GameplayTested=False; LegacyDeletionAllowed=False')
