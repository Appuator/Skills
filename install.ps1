# Installs the workflow skills for every project:
#  - links each folder in skills/ into ~/.claude/skills/ (directory junctions: no admin rights needed,
#    edits in this repo apply immediately)
#  - adds the block in global/CLAUDE.md to ~/.claude/CLAUDE.md (replaced in place on re-run)
# Run again after adding a skill. Uninstall: .\install.ps1 -Uninstall
param([switch]$Uninstall)

$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot
$claudeDir = Join-Path $HOME '.claude'
$skillsDir = Join-Path $claudeDir 'skills'
$globalMd = Join-Path $claudeDir 'CLAUDE.md'
$begin = '<!-- project-workflow:begin -->'
$end = '<!-- project-workflow:end -->'

New-Item -ItemType Directory -Force $skillsDir | Out-Null

foreach ($skill in Get-ChildItem (Join-Path $repo 'skills') -Directory) {
    $link = Join-Path $skillsDir $skill.Name
    $existing = Get-Item $link -Force -ErrorAction SilentlyContinue
    if ($existing) {
        $isOurs = $existing.LinkType -and ($existing.Target -eq $skill.FullName)
        if (-not $isOurs) { Write-Warning "Skipped $($skill.Name): $link exists and isn't a link to this repo."; continue }
        if ($Uninstall) { $existing.Delete(); Write-Host "Removed $link" }
        else { Write-Host "Already linked: $($skill.Name)" }
        continue
    }
    if (-not $Uninstall) {
        New-Item -ItemType Junction -Path $link -Target $skill.FullName | Out-Null
        Write-Host "Linked $link -> $($skill.FullName)"
    }
}

# Global CLAUDE.md block
$text = if (Test-Path $globalMd) { Get-Content $globalMd -Raw } else { '' }
$pattern = '(?s)\r?\n?' + [regex]::Escape($begin) + '.*?' + [regex]::Escape($end) + '\r?\n?'
$text = [regex]::Replace($text, $pattern, "`n").Trim()
if (-not $Uninstall) {
    $block = (Get-Content (Join-Path $repo 'global/CLAUDE.md') -Raw).Trim()
    $text = if ($text) { "$text`n`n$block" } else { $block }
}
if ($text) { Set-Content -Path $globalMd -Value "$text`n" -Encoding utf8NoBOM -NoNewline }
elseif (Test-Path $globalMd) { Remove-Item $globalMd }
Write-Host ($(if ($Uninstall) { "Removed workflow block from $globalMd" } else { "Updated $globalMd" }))
