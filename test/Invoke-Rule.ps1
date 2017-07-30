<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES

.LINK
https://github.com/indented-automation/ScriptAnalyzerRules/ blob/master/CodingConventions/public/Invoke-CodingConventionRule.ps1
#>
function Invoke-Rule {
    [CmdletBinding(DefaultParameterSetName = 'FromPath')]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord])]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'FromPath')]
        [String]$Path,

        [Parameter(Mandatory = $true, ParameterSetName = 'FromScriptBlock')]
        [ScriptBlock]$ScriptBlock,

        [Parameter(Mandatory = $true, ParameterSetName = 'FromCommandName')]
        [String]$CommandName,

        [Parameter(Mandatory = $true, Position = 2)]
        [String]$RuleName
    )

    switch ($pscmdlet.ParameterSetName) {
        'FromPath' {
            $Path = $pscmdlet.GetUnresolvedProviderPathFromPSPath($Path)

            $ast = [System.Management.Automation.Language.Parser]::ParseInput(
                (Get-Content $Path -Raw),
                $Path,
                [Ref]$null,
                [Ref]$null
            )
        }
        'FromScriptBlock' {
            $ast = $ScriptBlock.Ast
        }
        'FromCommandName' {
            try {
                $command = Get-Command $CommandName -ErrorAction Stop
                if ($command.CommandType -notin 'ExternalScript', 'Function') {
                    throw [InvalidOperationException]::new(
                        'The command "{0}" is not a script or function.' -f $CommandName)
                }
                $ast = $command.ScriptBlock.Ast
            }
            catch {
                $pscmdlet.ThrowTerminatingError(
                    [System.Management.Automation.ErrorRecord]::new(
                        $_.Exception,
                        'InvalidCommand',
                        'OperationStopped',
                        $CommandName
                    )
                )
            }
        }
    }

    # Acquire the type to test
    try {
        $astType = (Get-Command $RuleName -ErrorAction Stop).Parameters['ast'].ParameterType
    }
    catch {
        $pscmdlet.ThrowTerminatingError(
            [System.Management.Automation.ErrorRecord]::new(
                [InvalidOperationException]::new('The name "{0}" is not a valid rule' -f $RuleName, $_.Exception),
                'InvalidRuleName',
                'OperationStopped',
                $RuleName
            )
        )
    }

    $predicate = [ScriptBlock]::Create(('param ( $ast ); $ast -is [{0}]' -f $astType.FullName))
    $ast.FindAll($predicate, $true) | & $RuleName
}