## READ THE README...

Import-Module OCI.PSModules.Core
$auth_type = 'InstancePrincipal'

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

## Print LaunchDetails for verification
$LaunchDetails

## Create the compute instance
$ComputeInstance = New-OCIComputeInstance -LaunchInstanceDetails $LaunchDetails -WaitForStatus Succeeded -MaxWaitAttempts 20 -Debug -AuthType $auth_type
