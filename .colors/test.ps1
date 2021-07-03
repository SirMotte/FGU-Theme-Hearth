$branch = (git branch --show-current) -replace "(-Dev|-Main)", ""
if(-not (Test-Path ".\$($branch).txt" -PathType Leaf))
{
    return
}

$colormap = @{}

# Read Primary Color Mappings
foreach($line in Get-Content .\Primary.txt)
{
    $kvp = $line.split('=')
    if(2 -eq $kvp.length)
    {
        $key = $kvp[0].trim()
        $value = $kvp[1].trim()
        while(-not ($value -match "[0-9A-F]{6}"))
        {
            $value = $colormap[$value];
        }
        $colormap[$key] = $value
    }
}

# Read Edition Color Mappings
foreach($line in Get-Content ".\$($branch).txt")
{
    $kvp = $line.split('=')
    if(2 -eq $kvp.length)
    {
        $key = $kvp[0].trim()
        $value = $kvp[1].trim()
        while(-not ($value -match "[0-9A-F]{6}"))
        {
            $value = $colormap[$value];
        }
        $colormap[$key] = $value
    }
}

Push-Location ..
$files = Get-ChildItem -Path .\*.xml -Recurse -Force
foreach($file in $files)
{
    $content = Get-Content $file
    $updated = $false
    for($index=0; $index -lt $content.Length; ++$index)
    {
        $line = $content[$index];
        if($line -match "<!-- Replaceable Color: ([\w ]+) -->")
        {
            $content[$index] = $line -replace "[0-9A-F]{6}", $colormap[$Matches.1]
            $updated = $true
        }
    }

    if($updated)
    {
        Set-Content -Path $file -Value $content
    }
}

Pop-Location