<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
#>

function AvoidLongLines {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param (
        # An AST node.
        [Parameter(Mandatory = $True, ValueFromPipeline = $true)]
        [System.Management.Automation.Language.ScriptBlockAst]
        $ast
        ,
        # Maximum number of characters per line
        [Parameter(Mandatory = $False, ValueFromPipeline = $False)]
        [int]
        $LineLength = '115'
    )

    Add-Type -Path "$PSScriptRoot/../../Private/ExtendedScriptPosition.cs"
    $LineNumber = $ast.Extent.StartLineNumber
    $offset = $ast.Extent.StartOffset


    # Iterate through each line of text
    $Ast.Extent.Text.Split("`n") | ForEach-Object {
        # Last position plus `n.
        $offset += 1

        if ( $_.Length -gt $LineLength ) {
            $StartScriptPosition = New-Object ScriptAnalyzer.PracticeAndStyle.ExtendedScriptPosition -ArgumentList (
                $ast.Extent.File,
                $LineNumber,
                1,
                $_,
                $offset,
                $ast.Extent.ToString())
            $EndScriptPosition = New-Object ScriptAnalyzer.PracticeAndStyle.ExtendedScriptPosition -ArgumentList (
                $ast.Extent.File,
                $LineNumber,
                $_.Length,
                $_,
                ($offset + $_.Length),
                $ast.Extent.ToString())
            $Extent = New-Object ScriptAnalyzer.PracticeAndStyle.ExtendedScriptExtent -ArgumentList (
                $StartScriptPosition,
                $EndScriptPosition)

            [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                Message  = "Line length exceeds $LineLength characters"
                Extent   = $Extent
                RuleName = $MyInvocation.MyCommand.Name
                Severity = 'Warning'
            }
        }

        $LineNumber += 1
        $offset += $_.Length
    }
}