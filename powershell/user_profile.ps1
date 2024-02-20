# Install scoop
# C:\Users\User> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# C:\Users\User> Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# scoop install ripgrep

# Install neovim
# scoop install neovim

# Prompt
# Import-Module oh-my-posh
# Set-PoshPrompt Paradox

#oh-my-posh
#oh-my-posh init pwsh | Invoke-Expression
#oh-my-posh init pwsh --config 'C:\Users\Admin\Documents\PowerShell\clean-detailed.omp.json' | Invoke-Expression
oh-my-posh init pwsh --config  "C:\Users\User\AppData\Local\Programs\oh-my-posh\themes\blue-owl.omp.json" | Invoke-Expression
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

# Write to file all locations that contain tekla
# (Get-ChildItem -Path *Tekla* -Recurse -Depth 1).FullName | Out-File -FilePath C:\Users\User\.config\OutTeklaPath.txt
#
# Read from file and then pipe it into fzf
# Get-Content C:\Users\User\.config\OutTeklaPath.txt | Get-Childitem -Recurse | fzf
# Get-Content C:\Users\User\.config\OutTeklaPath.txt | Split-Path | Get-Childitem -Depth 4 | fzf
# (Get-Content C:\Users\User\.config\OutTeklaPath.txt | Get-Childitem -Depth 2).FullName | fzf -i
