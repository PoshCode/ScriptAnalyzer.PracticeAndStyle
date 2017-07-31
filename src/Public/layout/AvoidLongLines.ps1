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

    $LineNumber = 1
    # Iterate through each line of text
    $Ast.Extent.Text.Split("`n") | ForEach-Object {

        if ( $_.Length -gt $LineLength ) {

            $StartScriptPosition = New-Object System.Management.Automation.Language.ScriptPosition -ArgumentList (
                $Null, $LineNumber, 1, '')
            $EndScriptPosition = New-Object System.Management.Automation.Language.ScriptPosition -ArgumentList (
                $Null, $LineNumber, 1, '')
            $Extent = New-Object System.Management.Automation.Language.ScriptExtent -ArgumentList (
                $StartScriptPosition, $EndScriptPosition)

            [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                Message  = "Line length exceeds $LineLength characters"
                Extent   = $Extent
                RuleName = $MyInvocation.MyCommand.Name
                Severity = 'Warning'
            }
        }

        $LineNumber += 1
    }

}