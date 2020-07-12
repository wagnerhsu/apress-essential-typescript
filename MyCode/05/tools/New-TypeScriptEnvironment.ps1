[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $DirectoryName
)
$MyCode = @"
using System;
using System.IO;
using System.Text.RegularExpressions;
public class ProjectJsonUpdater
{
    public static void Update(string fileName)
    {
        var newContent = @"'scripts': {
'start': 'tsc-watch --onsuccess \'node dist/index.js\''
}";
        string content = File.ReadAllText(fileName);
        var pattern = "\"scripts\"\\:\\s\\{.*?\\}";

        var result = Regex.Replace(content, pattern, newContent.Replace("\'", "\""), RegexOptions.Singleline);
        File.WriteAllText(fileName, result);
    }
}
"@
Add-Type -TypeDefinition $MyCode -Language CSharp

Set-Location $DirectoryName
npm init -y

$jsonFile = Join-Path -Path $DirectoryName 'package.json';
[ProjectJsonUpdater]::Update($jsonFile)
npm install -D typescript
npm install -D tsc-watch
tsc --init --rootDir ./src --outDir ./lib
New-Item -ItemType Directory "src"
Set-Location "src"
New-Item index.ts -ItemType File -Value "console.log('Hello');"


