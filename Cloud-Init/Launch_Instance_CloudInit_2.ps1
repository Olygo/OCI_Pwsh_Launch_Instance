## READ THE README...

Import-Module OCI.PSModules.Core
$auth_type = 'InstancePrincipal'

## Cloud-Init script content example
$CloudInitScript = @"
#ps1_sysnative

# Disable Windows Defender firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled false

# Set your TimeZone
Set-TimeZone -Id "Romance Standard Time"

# Set your language preferences
Set-WinUserLanguageList -LanguageList fr-FR -Force
Set-Culture fr-FR

# Enable Remote Desktop
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "Administrator"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "opc"

# Disable "Require computers to use Network Level Authentication to connect"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Value 0

# Disable IE Protection mode
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0

# Show hidden files and folders
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name Hidden -Value 1
# Show file extensions
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name HideFileExt -Value 0
# Show empty drives
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name ShowDrivesWithNoVolumeLabel -Value 1
# Show protected operating system files
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name ShowSuperHidden -Value 1

# install Windows Update Modules 
Get-PSRepository
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name PSWindowsUpdate -Force -AllowClobber
Import-Module PSWindowsUpdate
Get-WindowsUpdate -MicrosoftUpdate -Verbose
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot -Verbose

"@

## Base64 encode Cloud-Init script
$encodedUserData = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($CloudInitScript))
Write-Host $encodedUserData

## Create a metadata dictionary
$metadata = New-Object 'System.Collections.Generic.Dictionary[System.String,System.String]'

## Add user_data to metadata dic
$metadata.Add('user_data', $encodedUserData)

## Set instance details
$CompartmentId = 'ocid1.compartment.oc1..XXXX'
$AvailabilityDomains = Get-OCIIdentityAvailabilityDomainsList -Auth InstancePrincipal -CompartmentId $CompartmentId
$AvailabilityDomain = $AvailabilityDomains.Name[0] # $AvailabilityDomains.Name[1] $AvailabilityDomains.Name[2]
$SubnetId = 'ocid1.subnet.oc1.REGION.XXXX'
$ImageId = 'ocid1.image.oc1.REGION.XXXX'

$DisplayName = 'Win-OCI-PWSH'
$Shape = 'VM.Standard.E5.Flex'
$ocpuCount = 4
$memoryInGB = 16

## Create ShapeConfig object and set properties
$ShapeConfig = New-Object Oci.CoreService.Models.LaunchInstanceShapeConfigDetails
$ShapeConfig.Ocpus = $ocpuCount
$ShapeConfig.MemoryInGBs = $memoryInGB

## Create LaunchInstanceDetails object
$LaunchDetails = New-Object -TypeName Oci.CoreService.Models.LaunchInstanceDetails
$LaunchDetails.AvailabilityDomain = $AvailabilityDomain
$LaunchDetails.CompartmentId = $CompartmentId
$LaunchDetails.ImageId = $ImageId
$LaunchDetails.SubnetId = $SubnetId
$LaunchDetails.DisplayName = $DisplayName
$LaunchDetails.ShapeConfig = $ShapeConfig
$LaunchDetails.Shape = $Shape
$LaunchDetails.Metadata = $metadata

## Print LaunchDetails for verification
$LaunchDetails

## Create the compute instance
$ComputeInstance = New-OCIComputeInstance -LaunchInstanceDetails $LaunchDetails -WaitForStatus Succeeded -MaxWaitAttempts 20 -Debug -AuthType $auth_type
