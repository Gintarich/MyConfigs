# BuildProject.ps1

# Find the first .sln file in the current directory
$solutionFile = Get-ChildItem -Filter *.sln | Select-Object -First 1

# Check if a .sln file is found
if ($solutionFile -ne $null) {
    # Build the MSBuild command for the solution
    $msbuildPath = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\amd64\MSBuild.exe"
    $msbuildCommand = "& ""$msbuildPath"" ""$($solutionFile.FullName)"""
} else {
    # Find the first .csproj file in the current directory
    $projectFile = Get-ChildItem -Filter *.csproj | Select-Object -First 1

    # Check if a .csproj file is found
    if ($projectFile -eq $null) {
        Write-Host "No .sln or .csproj file found in the current directory."
        return
    }

    # Build the MSBuild command for the .csproj file
    $msbuildPath = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\amd64\MSBuild.exe"
    $msbuildCommand = "& ""$msbuildPath"" ""$($projectFile.FullName)"""
}

# Execute MSBuild
Invoke-Expression -Command $msbuildCommand
