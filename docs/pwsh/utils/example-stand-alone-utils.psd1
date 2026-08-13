@{
    # Version number of this module.
    ModuleVersion = '1.0.0'
    PrivateData      = @{
        PSData = @{
            # The prerelease portion of a semantic version. Blank for releases
            Prerelease   = ''
            ReleaseNotes = ''

            Tags         = @('example', 'utils', 'ninmonkey', 'snippets', 'console', 'color')

            # LicenseUri = ''
            # ProjectUri = ''
            # IconUri = ''

            # Modules that aren't in the same PowerShellGallery
            # ExternalModuleDependencies = @()
        } # End of PSData hashtable
    } # End of PrivateData hashtable

    Description          = 'Snippets that you can use'
    ScriptsToProcess     = @()
    FunctionsToExport    = @( '*' ) # don't wildcard in production
    # CmdletsToExport      = @('Get-Snippet', 'Add-Snippet', 'Format-Code')
    VariablesToExport    = @()
    AliasesToExport      = @()
    NestedModules        = @()
    RequiredModules      = @(
        'Pansies'
        # @{ ModuleName = "Theme.PSReadLine"; ModuleVersion = "0.3.0" }
        # @{ ModuleName = "Yayaml";           ModuleVersion = "0.5.0" }
        # @{ ModuleName = "Pansies" }
        # @{ ModuleName = "PowerShellRun";    ModuleVersion = "0.12.0" }
    )
    # TypesToProcess       = @('ModuleName.types.ps1xml')
    # FormatsToProcess     = @('ModuleName.format.ps1xml')

    # Script module or binary module file associated with this manifest.
    RootModule           = 'example-stand-alone-utils.psm1'
    GUID                 = '367fb226-547b-4970-8c49-9359bc520782'
    Author               = "Jake Bolton (ninmonkey)"
    CompanyName          = 'ninmonkey.com'
    Copyright            = '(c) Jake Bolton 2026. All rights reserved.'
    CompatiblePSEditions = @('Core')

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion    = '7.0'
}
