
@{

    # Script module or binary module file associated with this manifest.
    RootModule        = 'ScriptAnalyzer.PracticeAndStyle.psm1'

    # Version number of this module.
    ModuleVersion     = '0.1.0'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID              = '3a6890fe-8e2e-463a-8c28-acb756cb9e70'

    # Author of this module
    Author            = 'PoshCode'

    # Company or vendor of this module
    CompanyName       = 'Poshcode'

    # Copyright statement for this module
    Copyright         = '(c) PoshCode. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'Script Analyzer rules to support the PowerShell Practice and Style repository'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules   = @('PSScriptAnalyzer')

    # Functions to export from this module
    FunctionsToExport = 'AvoidLongLines'


    # List of all files packaged with this module
    FileList          = @(
        'ScriptAnalyzer.PracticeAndStyle.psd1',
        'ScriptAnalyzer.PracticeAndStyle.psm1'
    )


    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData
    # hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            # Tags = @()

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            # ProjectUri = ''

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''

        } # End of PSData hashtable

    } # End of PrivateData hashtable


}


