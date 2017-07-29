# Dot source this script in any Pester test script that requires the module to be imported.

$ModuleName = 'ScriptAnalyzer.PracticeAndStyle'

$ModuleDefinitionName = "$ModuleName.psm1"
$ModuleManifestName = "$ModuleName.psd1"
$ModuleDefinitionPath = "$PSScriptRoot\..\src\$ModuleDefinitionName"
$ModuleManifestPath = "$PSScriptRoot\..\src\$ModuleManifestName"

Import-Module PSScriptAnalyzer

if (!$SuppressImportModule) {
    # -Scope Global is needed when running tests from inside of psake, otherwise
    # the module's functions cannot be found in the ScriptAnalyzer.PracticeAndStyle\ namespace
    Import-Module $ModuleManifestPath -Scope Global

}

function Test-PowerShellSyntax {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Path
    )

    $contents = Get-Content -Path $Path -ErrorAction Stop

    $errors = $null
    $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)

    return ($errors.Count -eq 0)
}
