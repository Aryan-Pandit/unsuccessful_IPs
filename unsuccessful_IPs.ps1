$location = Get-Location
$file = "$location\unsuccessful_IPs.txt"
if(Test-Path $file){
    Remove-Item $file
} else {
    Write-Host ""
}
# Prompt the user to enter the start and end IP addresses for the range
Write-Host "Powershell script to find unsuccessful pinged IP addresses from a range that are saved in a txt file."
$startIP = Read-Host "Enter the start IP address"
$endIP = Read-Host "Enter the end IP address"

# Convert the IP addresses to integer values for comparison
$startIPArray = $startIP.Split(".")
$endIPArray = $endIP.Split(".")
$startInt = [convert]::ToInt32($startIPArray[3], 10)
$endInt = [convert]::ToInt32($endIPArray[3], 10)

# Create an empty list to store unsuccessful IP addresses pings
$unsuccessfulIPs = @()

# Ping each IP address in the range
for ($i = $startInt; $i -le $endInt; $i++) {
    $currentIP = "$($startIPArray[0]).$($startIPArray[1]).$($startIPArray[2]).$i"
    Write-Host "Pinging $currentIP..."
    $ping = New-Object System.Net.NetworkInformation.Ping

    $pingReply = $ping.Send($currentIP)
    if ($pingReply.Status -ne 'Success') {
        $unsuccessfulIPs += $currentIP
    }
}

$unsuccessfulIPs | Out-File -FilePath $file -Append