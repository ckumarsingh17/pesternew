
$scriptPath = "C:\GIT\pesternew\test1\Scan-SensitiveInformation.ps1"
. $scriptPath

Import-Module -Name Pester -Version 5.1.1

Describe "Scan-SensitiveInformation" {
    It "Detects passwords, secrets, and tokens in code" {
        $testFile = @"
        # Some sample code with sensitive information
        password=mysecretpassword
        secret=mysecretvalue
        token=myaccesstoken
"@

        $filePath = "TestFile.ps1"
        $testFile | Out-File -FilePath $filePath -Force

        $results = Scan-SensitiveInformation -FilePath $filePath

        $results.Count | Should Be 3
        $results | Should Contain @{ Type = "Password"; Match = "password=mysecretpassword"; FilePath = $filePath; LineNumber = 1 }
        $results | Should Contain @{ Type = "Secret"; Match = "secret=mysecretvalue"; FilePath = $filePath; LineNumber = 2 }
        $results | Should Contain @{ Type = "Token"; Match = "token=myaccesstoken"; FilePath = $filePath; LineNumber = 3 }

        Remove-Item $filePath -Force
    }
}
