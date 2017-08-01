

# Install prerequisites
Install-Module PSScriptAnalyzer -Scope CurrentUser -Force
Install-Module Pester -Scope CurrentUser -Force



#  Test
Invoke-Pester -Script .\Test\*.tests.ps1


# Blah
