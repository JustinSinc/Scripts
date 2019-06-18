## Opens a serial session at a baud rate of 115200.

# You'll need to enable running unsigned local scripts (but require signing for remote execution)
# by running `Set-ExecutionPolicy RemoteSigned` in a privileged Powershell instance once per machine.

# Load messagebox .net assemblies
Add-Type -AssemblyName System.Windows.Forms

# Set the desired executable to KiTTY.exe or PuTTY.exe, in order of preference
# If neither file exists in the current directory, display an error
if (Test-Path KiTTY.exe) {
	$executable = "KiTTY.exe"
} elseif (Test-Path PuTTY.exe) {
	$executable = "PuTTY.exe"
} else {
	[System.Windows.Forms.MessageBox]::Show('No TTY executable found!')
}

# Set port variable to the first available com port
$port = [System.IO.Ports.SerialPort]::getportnames()

# Set serial baud rate to 115200
$baudrate = 115200

# If the port doesn't exist, display an error
# Otherwise, open a serial console session with the specified parameters
if (!$port) {
	[System.Windows.Forms.MessageBox]::Show('No serial port found!')
} else {
	Start-Process $executable "-title $port|$baudrate -serial $port -sercfg $baudrate"
}
