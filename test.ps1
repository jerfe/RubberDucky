Set-executionpolicy unrestricted -force -Scope currentuser
$workingfolder = "C:/PrivateData"
mkdir $workingfolder -ErrorAction SilentlyContinue
curl -usebasicparsing -proxy "http://127.0.0.1:9000" "https://raw.githubusercontent.com/jerfe/RubberDucky/main/WxTCmd.exe" -outfile "$workingfolder/WxTCmd.exe"
$dbs = (gci "$($env:LOCALAPPDATA)\ConnectedDevicesPlatform" -recurse -Include 'ActivitiesCache.db').FullName 
if($dbs.count -eq 0)
{
	Write-Host "No activities found"
}
else {
	$dbs| foreach {
		cp "$_" "$workingfolder/"
		&"$workingfolder/WxTCmd.exe" -f "${workingfolder}/ActivitiesCache.db" --csv "$workingfolder"
	}
}
curl -usebasicparsing -proxy "http://127.0.0.1:9000" "https://raw.githubusercontent.com/jerfe/RubberDucky/main/PCActivity.pbit" -outfile "$workingfolder/PCActivity.pbit"
&"$workingfolder/PCActivity.pbit"
pause
