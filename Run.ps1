$executablePath = Get-ChildItem -Filter *.exe -Recurse | Select-Object -First 1

$myCommand = "& ""$($executablePath.FullName)"""
Invoke-Expression -Command $myCommand

# Execute each found executable file
# Start-Process -FilePath $executablePath.FullName 
