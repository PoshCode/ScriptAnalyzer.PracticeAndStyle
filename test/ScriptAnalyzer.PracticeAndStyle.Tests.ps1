[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $true
. $PSScriptRoot\Shared.ps1

Describe 'Module Manifest' -Tag Unit {

    Context 'Validation' {

        $Script:manifest = $Null

        It "has a valid manifest" {
            {
                $script:manifest = Test-ModuleManifest -Path $ModuleManifestPath -ErrorAction Stop -WarningAction SilentlyContinue
            } | Should Not Throw
        }

        It "has a valid name in the manifest" {
            $script:manifest.Name | Should Be $ModuleName
        }

        It 'has a valid root module' {
            $script:manifest.RootModule | Should Be "$ModuleName.psm1"
        }

        It "has a valid version in the manifest" {
            $script:manifest.Version -as [Version] | Should Not BeNullOrEmpty
        }

        It 'has a valid description' {
            $script:manifest.Description | Should Not BeNullOrEmpty
        }

        It 'has a valid author' {
            $script:manifest.Author | Should Not BeNullOrEmpty
        }

        It 'has a valid guid' {
            {
                [guid]::Parse($script:manifest.Guid)
            } | Should Not throw
        }

        It 'has a valid copyright' {
            $script:manifest.CopyRight | Should Not BeNullOrEmpty
        }


    }
}

Describe 'Project Files' -Tag Unit {
    Context 'Release Notes' {

        $script:ReleaseNotes = $null

        It "has a valid version in the changelog" {
            foreach ($line in (Get-Content $ReleaseNotesPath)) {
                if ($line -match "^\D*(?<Version>(\d+\.){1,3}\d+)") {
                    $script:ReleaseNotes = $matches.Version
                    break
                }
            }
            $script:ReleaseNotes                | Should Not BeNullOrEmpty
            $script:ReleaseNotes -as [Version]  | Should Not BeNullOrEmpty
        }

        It "changelog and manifest versions are the same" {
            $script:ReleaseNotes -as [Version] | Should be ( $script:manifest.Version -as [Version] )
        }
    }
}

"Private", "Public" | ForEach-Object {
    $Visibility = $_
    Describe "$Visibility Module Functions" -Tag Unit {

        foreach ( $FunctionFile in get-Item -Path "$PSScriptRoot\..\src\$Visibility\*.ps1"){

            Context "Function $($FunctionFile.Name)" {

                It "Is valid PowerShell code" {
                    Test-PowerShellSyntax -Path $FunctionFile | Should be $True
                }

                It "Should be an Advanced Function" {
                    $FunctionFile | Should Contain 'function'
                    $FunctionFile | Should contain 'cmdletbinding'
                    $FunctionFile | Should contain 'param'
                }

                It 'Should have comments' {
                    $FunctionFile | Should contain '<#'
                    $FunctionFile | Should contain '#>'
                    $FunctionFile | Should contain '.SYNOPSIS'
                    $FunctionFile | Should contain '.DESCRIPTION'
                    $FunctionFile | Should contain '.EXAMPLE'
                }

                It 'Should be verbose' {
                    $FunctionFile | Should contain 'Write-Verbose'
                }

            } # Context
        } #foreach
    } # Describe
} # ForEach-Object


