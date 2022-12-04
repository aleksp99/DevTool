$ib = 'C:\Users\admin\Documents\1C\DevTool'; $ibn = 'Администратор'
$repo = 'C:\Users\admin\Documents\GitHub\DevTool'
$updateCF = 'C:\Users\admin\Downloads\Инструменты разработчика Конфигурация 6.54.1.cf'

Clear-Host
Set-Location 'C:\Program Files\1cv8\8.3.22.1709\bin'

$folder = New-Item -ItemType Directory -Path (Join-Path $env:TEMP (New-Guid))

# выгрузка main
Start-Process -FilePath ".\1cv8.exe" -Wait -ArgumentList "DESIGNER /F""$ib"" /N$ibn /DumpConfigToFiles ""$(Join-Path $folder 'ib')"" -Format Plain"
# выгрузка main module
Start-Process -FilePath ".\1cv8.exe" -Wait -ArgumentList "DESIGNER /F""$ib"" /N$ibn /DumpConfigFiles ""$(Join-Path $folder 'main')"" -Module"
# загрузка vendor
Start-Process -FilePath ".\1cv8.exe" -Wait -ArgumentList "DESIGNER /F""$ib"" /N$ibn /LoadCfg ""$(Join-Path $folder "ib\Configuration.ParentConfigurations.ИнструментыРазработчика.cf")"""
# выгрузка vendor
Start-Process -FilePath ".\1cv8.exe" -Wait -ArgumentList "DESIGNER /F""$ib"" /N$ibn /DumpConfigFiles ""$(Join-Path $folder 'vendor')"" -Module"
# загрузка new vendor
Start-Process -FilePath ".\1cv8.exe" -Wait -ArgumentList "DESIGNER /F""$ib"" /N$ibn /LoadCfg ""$updateCF"""
# снятие с поддержки
Start-Process -FilePath ".\1cv8.exe" -Wait -ArgumentList "DESIGNER /F""$ib"" /N$ibn"
# выгрузка new vendor
Start-Process -FilePath ".\1cv8.exe" -Wait -ArgumentList "DESIGNER /F""$ib"" /N$ibn /DumpConfigFiles ""$(Join-Path $folder 'vendorNEW')"" -Module"
# new main
Copy-Item (Join-Path $folder 'vendorNEW') (Join-Path $folder 'mainNEW') -Recurse
# repo
Remove-Item (Join-Path $repo 'src') -Recurse
$_ = New-Item -ItemType Directory -Path (Join-Path $repo 'src')
# merge
$vendor = Get-ChildItem -Path $(Join-Path $folder 'main') | Select-String "PushA" -List | Select Filename
$i = 0; $count = 0; $step = [math]::Ceiling($vendor.Count / 100)
$vendor |
    %{
        $f = $_.Filename
        # status
        IF ($count -eq $step) { $count = 0; $i = $i + 1; } $count = $count + 1
        Write-Progress -Activity "merge.." -Status "$i% module: $f" -PercentComplete $i
        # run merge
        IF (Test-Path (Join-Path $folder "vendorNEW\$f")) {
            Remove-Item (Join-Path $folder "mainNEW\$f")
            Start-Process -FilePath "C:\Program Files\KDiff3\bin\kdiff3.exe" -Wait -ArgumentList """$(Join-Path $folder "vendor\$f")"" ""$(Join-Path $folder "main\$f")"" ""$(Join-Path $folder "vendorNEW\$f")"" -o ""$(Join-Path $folder "mainNEW\$f")"" --auto"
			Copy-Item (Join-Path $folder "mainNEW\$f") (Join-Path $repo "src\$f")
        } ELSE {
            'not found is new vender - $f'
        }
    }
# загрузка new main
Start-Process -FilePath ".\1cv8.exe" -Wait -ArgumentList "DESIGNER /F""$ib"" /N$ibn /LoadConfigFiles ""$(Join-Path $folder 'mainNEW')"" -Module /UpdateDBCfg"
# delete folder
Remove-Item $folder -Recurse
# run
.\1cv8.exe DESIGNER /F"$ib" /N$ibn