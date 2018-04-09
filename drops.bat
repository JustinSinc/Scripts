@echo off
REM Thanks to user MC ND on stackoverflow.com (https://stackoverflow.com/questions/24906268/ping-with-timestamp) for the original template
REM A script to output timestamped pings to a file on the user's desktop
IF [%1]==[] echo Usage: drops ^<ip_address^> & exit /b
IF NOT [%2]==[] echo Too many arguments & exit /b
ping -t %1|cmd /q /v /c "(pause&pause)>nul & for /l %%a in () do (set /p "data=" && echo(!date! !time! !data!)&ping -n 2 localhost>nul" >> %userprofile%\Desktop\droppedpings-%1.txt
