# Install scoop
# C:\Users\User> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# C:\Users\User> Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# Install neovim
# scoop install neovim

# Prompt
# Import-Module oh-my-posh
# Set-PoshPrompt Paradox

#oh-my-posh
#oh-my-posh init pwsh | Invoke-Expression
#oh-my-posh init pwsh --config 'C:\Users\Admin\Documents\PowerShell\clean-detailed.omp.json' | Invoke-Expression
oh-my-posh init pwsh --config  $env:USERPROFILE"\AppData\Local\Programs\oh-my-posh\themes\blue-owl.omp.json" | Invoke-Expression
#oh-my-posh init pwsh --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/bubbles.omp.json" | Invoke-Expression

# Z module for fast Cd
# Install-Module -Name z

# Alias
Set-Alias ll ls
Set-ALias g git
Set-ALias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'


$env:XDG_CONFIG_HOME = $env:USERPROFILE+"\.config\"
# Functions
function whereis($command){
	Get-Command -Name $command -ErrorAction SilentlyContinue |
	Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
	}
function msbuild2022($path) {
    Invoke-Expression "C:\'Program Files (x86)'\'Microsoft Visual Studio'\2022\BuildTools\MSBuild\Current\Bin\amd64\MSBuild.exe "+$path
}

function Build-Project {
    param (
        [string]$customProjectFile = $null
    )

    if ($customProjectFile -eq $null -or $customProjectFile -eq "") {
        # Find the first .csproj file in the current directory
        $projectFile = Get-ChildItem -Filter *.csproj | Select-Object -First 1

        # Check if a .csproj file is found
        if ($projectFile -eq $null) {
            Write-Host "No .csproj file found in the current directory."
            return
        }
    } else {
        # Use the custom project file provided as an argument
        $projectFile = Get-Item $customProjectFile

        # Check if the specified file exists
        if (-not $projectFile.Exists) {
            Write-Host "Specified project file does not exist: $customProjectFile"
            return
        }
    }

    # Build the MSBuild command
    $msbuildPath = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\amd64\MSBuild.exe"
    $msbuildCommand = "& ""$msbuildPath"" ""$($projectFile.FullName)"""

    # Execute MSBuild
    Invoke-Expression -Command $msbuildCommand
}

#function prompt {
#  $loc = $executionContext.SessionState.Path.CurrentLocation;
#
#  $out = ""
#  if ($loc.Provider.Name -eq "FileSystem") {
#    $out += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
#  }
#  $out += "PS $loc$('>' * ($nestedPromptLevel + 1)) ";
#  return $out
#}

#Terminal Icons
#Import-Module Terminal-Icons

#PSReadline
#Install-Module PSReadLine
Import-Module PSReadLine
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource HistoryAndPlugin 
Set-PSReadLineOption -PredictionViewStyle ListView

# Predictior for PSReadline
# Install-Module -Name CompletionPredictor
Import-Module CompletionPredictor

# Fzf
# scoop install fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

function Build-Project2 {
    param (
        [string]$customProjectFile = $null
    )

    if ($customProjectFile -eq $null -or $customProjectFile -eq "") {
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
    } else {
        # Use the custom project file provided as an argument
        $customFile = Get-Item $customProjectFile

        # Check if the specified file exists
        if (-not $customFile.Exists) {
            Write-Host "Specified project file does not exist: $customProjectFile"
            return
        }

        # Build the MSBuild command for the custom project file
        $msbuildPath = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\amd64\MSBuild.exe"
        $msbuildCommand = "& ""$msbuildPath"" ""$($customFile.FullName)"""
    }

    # Execute MSBuild
    Invoke-Expression -Command $msbuildCommand
}

# Call the function with a custom project file as an argument
# Build-Project -customProjectFile "Path\To\YourProject.csproj"

function Build-And-Run-Project {
    param (
        [string]$customProjectFile = $null,
        [switch]$searchInSubfolders
    )

    # Build the project
    Build-Project -customProjectFile $customProjectFile

    # Check if the build was successful before attempting to run the output
    if ($LASTEXITCODE -eq 0) {
        # Get the output executable path(s) (adjust as needed based on your project structure)
        $executablePaths = Get-ChildItem -Filter *.exe -Recurse:$searchInSubfolders

        # Check if any executable files are found
        if ($executablePaths -ne $null) {
            foreach ($executablePath in $executablePaths) {
                # Execute each found executable file
                Start-Process -FilePath $executablePath.FullName -Wait
            }
        } else {
            Write-Host "No executable files (.exe) found after build."
        }
    } else {
        Write-Host "Build failed. Unable to run the project."
    }
}

