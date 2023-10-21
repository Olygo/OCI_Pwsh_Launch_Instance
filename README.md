# OCI PowerShell 7 Launch Instance


## Overview

This PowerShell script allows you to create a compute instance on OCI using the OCI PowerShell 7 Modules. 

It provides two methods for using cloud-init scripts to configure your instance and includes detailed instructions on how to use the script.

## Prerequisites

Before using this script, make sure you have the following prerequisites in place:

- **[Install PowerShell 7](https://github.com/PowerShell/PowerShell/releases/)**
- **[Install OCI.PSModules 7](https://www.powershellgallery.com/packages/OCI.PSModules/)**

		Install-Module -Name OCI.PSModules -Force

- **[Create a dynamic group](https://docs.oracle.com/en-us/iaas/Content/Identity/dynamicgroups/To_create_a_dynamic_group.htm)**

- **Set a matching rule** identifying either a compartment (all the instances in it) or a single instance OCID.

- **[Create a policy](https://docs.oracle.com/en-us/iaas/Content/Identity/policymgmt/managingpolicies_topic-To_create_a_policy.htm)**
	
	If [your tenancy uses Identity Domains](https://docs.oracle.com/en/cloud/paas/application-integration/oracle-integration-oci/setting-users-groups-and-policies1.html#GUID-E6A80629-A6CA-4E9F-8681-20D31F909EC7):

		Allow dynamic-group 'YOUR-IDCS-DOMAIN-NAME'/'YOUR-DG-NAME' to manage all-resources in compartment YOUR-COMPARTMENT

	If [your tenancy doesn't use Identity Domains](https://docs.oracle.com/en/cloud/paas/application-integration/oracle-integration-oci/setting-users-groups-and-policies1.html#GUID-E6A80629-A6CA-4E9F-8681-20D31F909EC7):

		Allow dynamic-group YOUR-DG-NAME to manage all-resources in compartment YOUR-COMPARTMENT

	Feel free to adapt your [policy statements](https://docs.oracle.com/en-us/iaas/Content/Identity/policyreference/policyreference.htm) based on your project and security requirements, for example:

		Allow dynamic-group YOUR-DG-NAME to manage instance-family in compartment YOUR-COMPARTMENT
		Allow dynamic-group YOUR-DG-NAME to manage virtual-network-family in compartment YOUR-COMPARTMENT
		Allow dynamic-group YOUR-DG-NAME to manage volume-network-family in compartment YOUR-COMPARTMENT
		Allow dynamic-group YOUR-DG-NAME to read secret-family in compartment YOUR-COMPARTMENT where target.vault.id='YOUR_VAULT_OCID'
		Allow dynamic-group YOUR-DG-NAME to read objectstorage-namespaces in tenancy
		Allow dynamic-group YOUR-DG-NAME to read buckets in compartment YOUR-COMPARTMENT
		Allow dynamic-group YOUR-DG-NAME to read objects in compartment YOUR-COMPARTMENT where target.bucket.name='YOUR_BUCKET_NAME'
		Allow dynamic-group YOUR-DG-NAME to use ons-topic in compartment YOUR-COMPARTMENT

`$CompartmentId`: Compartment OCID where the instance will be deployed.

`$SubnetId`: Subnet OCID to which the instance will be connected

`$ImageId`: [The OCI image OCID you want to use.](https://docs.oracle.com/en-us/iaas/images/)

	Get-OCIComputeImagesList -CompartmentId $CompartmentId -Auth InstancePrincipal


## Launch an instance using a Cloud-Init script

**Cloud-Init Method #1:** This method involves specifying the path to your local PowerShell script. It reads the content of the specified script and encodes it for use in cloud-init.

		$scriptPath = "C:\users\opc\desktop\script.ps1"
		$cloudInitScript = Get-Content $scriptPath -Raw

**Cloud-Init Method #2:** This method involves directly including the script content within the script using a here-string. You can modify the content as needed.

	$CloudInitScript = @"
	#ps1_sysnative
	
	# Set your TimeZone
	Set-TimeZone -Id "Romance Standard Time"
	
	# Set your language preferences
	Set-WinUserLanguageList -LanguageList fr-FR -Force
	Set-Culture fr-FR
	"@

## Cloud-Init debug information

You can read the Cloudbase log file if something goes wrong.

		C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\cloudbase-init 

## Additional information

**Class LaunchInstanceDetails**

[https://docs.oracle.com/en-us/iaas/tools/dotnet/72.0.0/api/Oci.CoreService.Models.LaunchInstanceDetails.html](https://docs.oracle.com/en-us/iaas/tools/dotnet/72.0.0/api/Oci.CoreService.Models.LaunchInstanceDetails.html)

[https://docs.oracle.com/en-us/iaas/tools/dotnet/72.0.0/api/Oci.CoreService.Models.LaunchInstanceShapeConfigDetails.html](https://docs.oracle.com/en-us/iaas/tools/dotnet/72.0.0/api/Oci.CoreService.Models.LaunchInstanceShapeConfigDetails.html)

[https://github.com/oracle/oci-dotnet-sdk/blob/master/Core/models/LaunchInstanceDetails.cs](https://github.com/oracle/oci-dotnet-sdk/blob/master/Core/models/LaunchInstanceDetails.cs)

**OCI PowerShell Modules**

[https://www.powershellgallery.com/packages?q=oci](https://www.powershellgallery.com/packages?q=oci)

**See Package Details (commands)**

[https://www.powershellgallery.com/packages/OCI.PSModules/](https://www.powershellgallery.com/packages/OCI.PSModules/)
[https://www.powershellgallery.com/packages/OCI.PSModules.Core/](https://www.powershellgallery.com/packages/OCI.PSModules.Core/)
[https://www.powershellgallery.com/packages/OCI.PSModules.Identity/](https://www.powershellgallery.com/packages/OCI.PSModules.Identity/)
[https://www.powershellgallery.com/packages/OCI.PSModules.Identitydomains/](https://www.powershellgallery.com/packages/OCI.PSModules.Identitydomains/)
[https://www.powershellgallery.com/packages/OCI.PSModules.Vault/](https://www.powershellgallery.com/packages/OCI.PSModules.Vault/)
[https://www.powershellgallery.com/packages/OCI.PSModules.Keymanagement/](https://www.powershellgallery.com/packages/OCI.PSModules.Keymanagement/)

**Install all OCI PS Modules (only if used)**

		Install-Module -Name OCI.PSModules -Force

**install most common OCI PS Modules (only if used)**

		Install-Module -Name OCI.PSModules.Core -Force
		Install-Module -Name OCI.PSModules.Identity -Force
		Install-Module -Name OCI.PSModules.Identitydomains -Force
		Install-Module -Name OCI.PSModules.Vault -Force
		Install-Module -Name OCI.PSModules.Keymanagement -Force

**See Package Details about installed OCI PS Modules**

[https://www.powershellgallery.com/packages/OCI.PSModules.Common/](https://www.powershellgallery.com/packages/OCI.PSModules.Common/)
[https://www.powershellgallery.com/packages/OCI.PSModules.Objectstorage/](https://www.powershellgallery.com/packages/OCI.PSModules.Objectstorage/)
[https://www.powershellgallery.com/packages/OCI.PSModules.Secrets/](https://www.powershellgallery.com/packages/OCI.PSModules.Secrets/)
[https://www.powershellgallery.com/packages/OCI.PSModules.Ons/](https://www.powershellgallery.com/packages/OCI.PSModules.Ons/)

## License

This script is provided under the [MIT License](LICENSE). You are free to use, modify, and distribute it as per the terms of the license.


## Disclaimer
**Please test properly on test resources, before using it on production resources to prevent unwanted outages or unwanted bills.**


## Questions ?
Please feel free to reach out for any clarifications or assistance in using this script in your OCI CloudShell environment.

**_olygo.git@gmail.com_**