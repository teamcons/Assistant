

# Stop EVERYTHING
function Stop-Tree {
    Param([int]$ppid)
    Get-CimInstance Win32_Process | Where-Object { $_.ParentProcessId -eq $ppid } | ForEach-Object { Stop-Tree $_.ProcessId }
    Stop-Process -Id $ppid
}





