if not exist "C:\Windows\Temp\7z.msi" (
    if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
        powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://www.7-zip.org/a/7z920-x64.msi', 'C:\Windows\Temp\7z.msi')" <NUL
    ) else (
        powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://www.7-zip.org/a/7z920.msi'    , 'C:\Windows\Temp\7z.msi')" <NUL
    )
)
msiexec /qb /i C:\Windows\Temp\7z.msi

if not exist "C:\Windows\Temp\ultradefrag.zip" (
    if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
        set UDEFRAG_DIR="C:\Windows\Temp\ultradefrag-portable-6.1.0.amd64"
        powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://downloads.sourceforge.net/project/ultradefrag/stable-release/6.1.0/ultradefrag-portable-6.1.0.bin.amd64.zip', 'C:\Windows\Temp\ultradefrag.zip')" <NUL
    ) else (
        set UDEFRAG_DIR="C:\Windows\Temp\ultradefrag-portable-6.1.0.i386"
        powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://downloads.sourceforge.net/project/ultradefrag/stable-release/6.1.0/ultradefrag-portable-6.1.0.bin.i386.zip' , 'C:\Windows\Temp\ultradefrag.zip')" <NUL
    )
)

if not exist "%UDEFRAG_DIR%\udefrag.exe" (
	cmd /c ""C:\Program Files\7-Zip\7z.exe" x C:\Windows\Temp\ultradefrag.zip -oC:\Windows\Temp"
)

if not exist "C:\Windows\Temp\SDelete.zip" (
  powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://web.archive.org/web/20140803110527if_/http://download.sysinternals.com/files/SDelete.zip', 'C:\Windows\Temp\SDelete.zip')" <NUL
)

if not exist "C:\Windows\Temp\sdelete.exe" (
	cmd /c ""C:\Program Files\7-Zip\7z.exe" x C:\Windows\Temp\SDelete.zip -oC:\Windows\Temp"
)

msiexec /qb /x C:\Windows\Temp\7z.msi

net stop wuauserv
rmdir /S /Q C:\Windows\SoftwareDistribution\Download
mkdir C:\Windows\SoftwareDistribution\Download
net start wuauserv

cmd /c %UDEFRAG_DIR%\udefrag.exe --optimize --repeat C:

cmd /c %SystemRoot%\System32\reg.exe ADD HKCU\Software\Sysinternals\SDelete /v EulaAccepted /t REG_DWORD /d 1 /f
cmd /c C:\Windows\Temp\sdelete.exe -q -z C:
