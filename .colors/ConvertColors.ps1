# PowerShell Script to regenerate color values from configs to XML/Lua files
$branch = (git branch --show-current) -replace "(-Dev|-Main)", ""
$colorFile = ".\$($branch).txt"

if (-not (Test-Path $colorFile -PathType Leaf)) {
    $colorFile = ".\Colorize.txt"
    if (-not (Test-Path $colorFile -PathType Leaf)) {
        Write-Warning "Color config file not found for branch '$branch' and no Colorize.txt fallback exists."
        return
    }
    Write-Host "Branch-specific color config not found. Falling back to Colorize.txt..."
} else {
    Write-Host "Using color configuration file: $colorFile"
}

$colormap = @{}

# Helper function to resolve alias to hex color with cycle protection
function Resolve-ColorValue($key, $value) {
    $visited = @{ $key = $true }
    while (-not ($value -match "^[0-9A-F]{6}$")) {
        if ($null -eq $value) {
            Write-Error "Unresolved color alias for '$key'"
            return $null
        }
        if ($visited.ContainsKey($value)) {
            Write-Error "Circular color mapping dependency detected for '$key' -> '$value'"
            return $null
        }
        $visited[$value] = $true
        $value = $colormap[$value]
    }
    return $value
}

# Read Primary Color Mappings
foreach ($line in Get-Content .\Primary.txt) {
    $kvp = $line.split('=')
    if (2 -eq $kvp.length) {
        $key = $kvp[0].trim()
        $value = $kvp[1].trim()
        
        $resolved = Resolve-ColorValue -key $key -value $value
        if ($null -ne $resolved) {
            $colormap[$key] = $resolved
        }
    }
}

# Read Edition Color Mappings
foreach ($line in Get-Content $colorFile) {
    $kvp = $line.split('=')
    if (2 -eq $kvp.length) {
        $key = $kvp[0].trim()
        $value = $kvp[1].trim()
        
        $resolved = Resolve-ColorValue -key $key -value $value
        if ($null -ne $resolved) {
            $colormap[$key] = $resolved
        }
    }
}

Push-Location ..
$files = Get-ChildItem -Path .\*.xml -Recurse -Force
foreach ($file in $files) {
    $content = Get-Content $file
    $updated = $false
    for ($index = 0; $index -lt $content.Length; ++$index) {
        $line = $content[$index]
        if ($line -match "<!-- Replaceable Color: ([\w ]+) -->") {
            $colorName = $Matches.1
            if ($null -eq $colormap[$colorName]) {
                Write-Warning "Color '$colorName' not found in colormap (File: $($file.FullName), Line: $($index + 1))"
            } else {
                $content[$index] = $line -replace "[0-9A-F]{6}", $colormap[$colorName]
                $updated = $true
            }
        }
    }

    if ($updated) {
        Set-Content -Path $file -Value $content
    }
}

$managerpath = ".\scripts\manager_color_2.lua"
$content = Get-Content $managerpath
$updated = $false
for ($index = 0; $index -lt $content.Length; ++$index) {
    $line = $content[$index]
    if ($line -match "-- Replaceable Color: ([\w ]+)$") {
        $colorName = $Matches.1
        if ($null -eq $colormap[$colorName]) {
            Write-Warning "Color '$colorName' not found in colormap (File: $managerpath, Line: $($index + 1))"
        } else {
            $content[$index] = $line -replace "[0-9A-F]{6}", $colormap[$colorName]
            $updated = $true
        }
    }
    elif ($line -match "-- Replaceable Channels: ([\w ]+)$") {
        $colorName = $Matches.1
        if ($null -eq $colormap[$colorName]) {
            Write-Warning "Color '$colorName' not found in colormap (File: $managerpath, Line: $($index + 1))"
        } else {
            $hex = $colormap[$colorName]
            $red = [System.Convert]::ToInt32($hex.substring(0, 2), 16)
            $green = [System.Convert]::ToInt32($hex.substring(2, 2), 16)
            $blue = [System.Convert]::ToInt32($hex.substring(4, 2), 16)
            $channels = "{ r = $($red), g = $($green), b = $($blue) }"
            $content[$index] = $line -replace "\{ ?r ?= ?\d{1,3}, ?g ?= ?\d{1,3}, ?b ?= ?\d{1,3} ?\}", $channels
            $updated = $true
        }
    }
}

if ($updated) {
    Set-Content -Path $managerpath -Value $content
}

Pop-Location