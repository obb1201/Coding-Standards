# Builds one zip per skill folder, ready to upload on claude.ai.
# A skill folder is any top-level folder that contains SKILL.md.
# Output: dist/<skill-name>.zip, where <skill-name> is the "name:" in the SKILL.md frontmatter.
#
# Usage (from the repo root):  powershell -ExecutionPolicy Bypass -File scripts/package-skills.ps1

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$repoRoot = Split-Path -Parent $PSScriptRoot
$distDir = Join-Path $repoRoot 'dist'
New-Item -ItemType Directory -Force -Path $distDir | Out-Null

$skillFiles = Get-ChildItem -Path $repoRoot -Directory |
    Where-Object { $_.Name -notin @('dist', 'docs', 'scripts', '.git') } |
    ForEach-Object { Join-Path $_.FullName 'SKILL.md' } |
    Where-Object { Test-Path $_ }

foreach ($skillFile in $skillFiles)
{
    $skillDir = Split-Path -Parent $skillFile
    $text = [System.IO.File]::ReadAllText($skillFile)

    # Check the frontmatter before packaging, so a bad file fails here instead of on upload.
    if ($text -notmatch '(?s)^---\r?\n(.*?)\r?\n---')
    {
        throw "$skillFile has no YAML frontmatter (--- ... ---)."
    }
    $frontmatter = $Matches[1]
    if ($frontmatter -notmatch '(?m)^name:\s*([a-z0-9-]+)\s*$')
    {
        throw "$skillFile frontmatter has no valid 'name:' (lowercase letters, digits and hyphens only)."
    }
    $skillName = $Matches[1]
    if ($frontmatter -notmatch '(?m)^description:')
    {
        throw "$skillFile frontmatter has no 'description:'."
    }

    $zipPath = Join-Path $distDir "$skillName.zip"
    if (Test-Path $zipPath)
    {
        Remove-Item $zipPath -Force
    }

    # Entries use forward slashes and sit under a <skill-name>/ folder, which claude.ai expects.
    $zip = [System.IO.Compression.ZipFile]::Open($zipPath, 'Create')
    try
    {
        foreach ($file in Get-ChildItem -Path $skillDir -Recurse -File)
        {
            $relativePath = $file.FullName.Substring($skillDir.Length + 1).Replace('\', '/')
            $entryName = "$skillName/$relativePath"
            [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $file.FullName, $entryName) | Out-Null
        }
    }
    finally
    {
        $zip.Dispose()
    }

    Write-Output "Built $zipPath"
}
