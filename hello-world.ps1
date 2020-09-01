function Set-ConsoleWindow {
    param(
        [int]$Width,
        [int]$Height
    )

    $WindowSize = $Host.UI.RawUI.WindowSize
    $WindowSize.Width = [Math]::Min($Width, $Host.UI.RawUI.BufferSize.Width)
    $WindowSize.Height = $Height

    try {
        $Host.UI.RawUI.WindowSize = $WindowSize
    }
    catch [System.Management.Automation.SetValueInvocationException] {
        $Maxvalue = ($_.Exception.Message | Select-String "\d+").Matches[0].Value
        $WindowSize.Height = $Maxvalue
        $Host.UI.RawUI.WindowSize = $WindowSize
    }
}

(Get-Host).UI.RawUI.WindowTitle = "Stay Awake"

Set-ConsoleWindow -Width 40 -Height 10

#[System.Console]::BufferWidth  = [System.Console]::WindowWidth  = 40
#[System.Console]::BufferHeight = [System.Console]::WindowHeight = 10

$shell = New-Object -ComObject WScript.Shell

$start_time = Get-Date -UFormat %s <# Get the date in MS #>
$current_time = $start_time
$elapsed_time = 0

Clear-Host

#Write-Host "I am awake!"

$count = 0

while ($true) {

    $shell.sendkeys("{NUMLOCK}{NUMLOCK}") <# Fake some input! #>

    if ($count -eq 8) {

        $count = 0
        Clear-Host

    }

    if ($count -eq 0) {

        $current_time = Get-Date -UFormat %s
        $elapsed_time = $current_time - $start_time

        Write-Host "I've been awake for "([System.Math]::Round(($elapsed_time / 60), 2))" minutes!"

    }
    else { Write-Host "Must stay awake..." }

    $count ++

    Start-Sleep -Seconds 55

}