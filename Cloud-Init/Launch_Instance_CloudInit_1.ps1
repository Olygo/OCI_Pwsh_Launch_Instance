## READ THE README...

Import-Module OCI.PSModules.Core
$auth_type = 'InstancePrincipal'

## Specify the path to your local PowerShell script
$scriptPath = "C:\users\opc\desktop\cloudinit.ps1"
$cloudInitScript = Get-Content $scriptPath -Raw

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
