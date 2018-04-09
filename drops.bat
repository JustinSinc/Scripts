@echo off
REM Thanks to user MC ND on stackoverflow.com (https://stackoverflow.com/questions/24906268/ping-with-timestamp) for the original template
REM A script to output timestamped pings to a file on the user's desktop
REM TODO: Support hostname lookup

REM if no arguments were passed, print the command syntax
IF [%1]==[] echo Usage: drops ^<ip_address^> & exit /b

REM if more than one argument was passed, error out
IF NOT [%2]==[] echo Too many arguments & exit /b

REM error out if any input is non-numeric
SET "_invalid=0"&for /f "delims=0123456789." %%i in ("%~1") do set _invalid=1

REM split the input into a set of four octets to check validity of the address
set "input=%1"
for /f "tokens=1,2,3,4 delims=." %%i in ("%input%") do set "octet1=%%i" & set "octet2=%%j" & set "octet3=%%k" & set "octet4=%%l"

REM subnets over 223.x.x.x are reserved for multicast
IF %octet1% GTR 223 Set _invalid=1

REM octets cannot be over 255
for %%o in (%octet2% %octet3% %octet4%) do (IF %%o GTR 255 Set _invalid=1)

REM octets cannot be below 1
for %%o in (%octet1% %octet2% %octet3% %octet4%) do (IF %%o LSS 1 Set _invalid=1)

REM if invalid addresses were found, error and end the script
IF %_invalid% EQU 1 echo Invalid IP address & exit /b

REM if the addresses seem fine, run the script
ping -t %1|cmd /q /v /c "(pause&pause)>nul & for /l %%a in () do (set /p "data=" && echo(!date! !time! !data!)&ping -n 2 localhost>nul" >> %userprofile%\Desktop\droppedpings-%1.txt
