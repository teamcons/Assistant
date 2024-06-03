@{


    TopLeftOverview = @{
        Enabled             = $true
        reactivity          = 400
        sensitivity         = 30
    }

    WindowsButton   = @{
        Enabled             = $false
        reactivity          = 500
        sensitivity         = 50
    }

    KeepAwake       = @{
        Enabled             = $true
    }

    Clipboard       = @{
        Enabled             = $true
        reactivity          = 1000      # In milliseconds. Time to check for cliboard content
        remembereditems     = 5       # How many entries to keep
    }

    Timer       = @{
        Duration             = 30       # In minutes. Time before notification
    }

}