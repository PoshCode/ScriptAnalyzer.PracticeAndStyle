[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope = '*', Target = 'SuppressImportModule')]
$SuppressImportModule = $False

. $PSScriptRoot\..\Shared.ps1


# InModuleScope $ModuleName {

Describe AvoidUsingLongLines {
    BeforeAll {
        $ruleName = @{ RuleName = 'AvoidLongLines' }
    }

    Context 'Present' {
        It 'Present, returns record' {
            $script = {
                $Var = '01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789'
            }

            $record = Invoke-Rule -ScriptBlock $script @ruleName
            $record | Should Not BeNullOrEmpty
            @($record).Count | Should Be 1
        }

        It 'Present, returns single record' {
            $script = {
                function Test {
                    $Var = '01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789'
                }
            }

            $record = Invoke-Rule -ScriptBlock $script @ruleName
            $record | Should Not BeNullOrEmpty
            @($record).Count | Should Be 1
        }

        It 'Present but disabled' {

            $script = {
                function name {
                    # [System.Diagnostics.CodeAnalysis.SuppressMessage("AvoidLongLines", "")]
                    param (
                        [String]$string
                    )

                    process {
                        Get-Process | Sort-Object | Select-Object * | Sort-Object -Descending | Select-Object ProcessID | Where-Object { $_.ProcessID }
                    }
                }
            }

            Invoke-Rule -ScriptBlock $script @ruleName | Should BeNullOrEmpty


        }

        It 'Present with different line length' { }

    }

    Context 'Absent' {
        It 'Add-Type absent, returns null' {
            $script = {
                $Var = '0123456789im'
            }

            Invoke-Rule -ScriptBlock $script @ruleName | Should BeNullOrEmpty
        }
    }
}
# }
