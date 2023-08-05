Describe "My PowerShell Function" {
    It "Returns the correct output" {
        $result = Invoke-MyFunction
        $result | Should -Be "Expected Output"
    }
}
