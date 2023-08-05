function Scan-SensitiveInformation {
    param (
        [string]$FilePath
    )

    $content = Get-Content -Path $FilePath -Raw
    $results = @()

    # Define regular expressions to search for passwords, secrets, and tokens
    $regexPasswords = '(?i)(password|pwd)=([^\s]+)'
    $regexSecrets = '(?i)secret=([^\s]+)'
    $regexTokens = '(?i)token=([^\s]+)'

    # Scan for passwords
    $passwordMatches = [regex]::Matches($content, $regexPasswords)
    foreach ($match in $passwordMatches) {
        $results += [PSCustomObject]@{
            FilePath = $FilePath
            LineNumber = $content.Substring(0, $match.Index).Split("`n").Count
            Match = $match.Value
            Type = "Password"
        }
    }

    # Scan for secrets
    $secretMatches = [regex]::Matches($content, $regexSecrets)
    foreach ($match in $secretMatches) {
        $results += [PSCustomObject]@{
            FilePath = $FilePath
            LineNumber = $content.Substring(0, $match.Index).Split("`n").Count
            Match = $match.Value
            Type = "Secret"
        }
    }

    # Scan for tokens
    $tokenMatches = [regex]::Matches($content, $regexTokens)
    foreach ($match in $tokenMatches) {
        $results += [PSCustomObject]@{
            FilePath = $FilePath
            LineNumber = $content.Substring(0, $match.Index).Split("`n").Count
            Match = $match.Value
            Type = "Token"
        }
    }

    return $results
}
