@echo off
setlocal ENABLEEXTENSIONS

:: Title
echo.
echo =====================================
echo     WP Medra Toolkit - Dev Medra
echo           Version: 1.2.0
echo            Persian Gulf
echo =====================================
echo.
echo 1. Install WordPress
echo 2. Update WordPress
echo 0. Exit
echo.

set /p choice="Select an option: "

if "%choice%"=="1" goto install
if "%choice%"=="2" goto update
if "%choice%"=="0" exit

echo Invalid choice.
pause
exit

:install
echo Downloading the latest version of WordPress...
curl -o wordpress.zip https://wordpress.org/latest.zip

if exist wordpress.zip (
    echo WordPress downloaded successfully.

    echo Extracting files...
    powershell -Command "Expand-Archive -Force 'wordpress.zip' '.'"

    if exist wordpress\ (
        echo Moving files from 'wordpress' to current directory...
        xcopy /E /Y /Q wordpress\* .\

        echo Cleaning up...
        rmdir /S /Q wordpress
        del wordpress.zip

        echo ✅ WordPress is ready to use!
    ) else (
        echo ❌ Error: Extraction failed. Folder 'wordpress' not found.
    )
) else (
    echo ❌ Error: Download failed.
)
pause
exit

:update
echo Downloading latest WordPress for update...
curl -o wordpress.zip https://wordpress.org/latest.zip

if exist wordpress.zip (
    echo Extracting update files to temp folder...
    powershell -Command "Expand-Archive -Force 'wordpress.zip' 'wp-update-temp'"

    if exist wp-update-temp\wordpress\ (
        echo Updating files (excluding wp-content and wp-config.php)...

        robocopy wp-update-temp\wordpress . /E /NFL /NDL /NJH /NJS /XO /XD wp-content /XF wp-config.php >nul

        echo Cleaning up temp files...
        rmdir /S /Q wp-update-temp
        del wordpress.zip

        echo ✅ WordPress update complete (wp-content & wp-config preserved)
    ) else (
        echo ❌ Error: Update extraction failed.
    )
) else (
    echo ❌ Error: Download failed.
)
pause
exit
