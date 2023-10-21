#ps1_sysnative

# Disable Windows Defender firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled false

# Set your TimeZone
Set-TimeZone -Id "Romance Standard Time"

# Set your language preferences
Set-WinUserLanguageList -LanguageList fr-FR -Force
Set-Culture fr-FR