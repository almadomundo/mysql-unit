@echo off
set DIR=%CD%

echo|set /p=Checking 'mysql' CLI .. 
set MYSQLCLI=
for %%e in (%PATHEXT%) do (
  for %%X in (mysql%%e) do (
    if not defined MYSQLCLI (
      set MYSQLCLI=%%~$PATH:X
    )
  )
)
if ["%MYSQLCLI%"] == [""] (
   echo failure
   exit /b
) else (
   echo ok
)
set /p DATABASE=Enter database, to which mysql-unit will be installed: 
set /p USERNAME=Enter user name, which will execute install scripts: 
powershell -Command $pword = read-host "Enter password for %USERNAME% " -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword) ; ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR) > .tmp.txt 
set /p PASSWORD=<.tmp.txt & del .tmp.txt

echo|set /p=Checking %USERNAME% generic access .. 
mysql -u %USERNAME% -p%PASSWORD% %DATABASE% -e "" >nul 2>&1
if errorlevel 1 (
   echo failure
   echo Installation failed: user '%USERNAME%' has no access to database '%DATABASE%' or password was wrong
   exit /b
) else (
   echo ok
)

echo Installing tests storage

for %%s in (%DIR%\..\..\Storage\Main\*.sql) do (
   echo|set /p=Processing: %%s .. 
   mysql -u %USERNAME% -p%PASSWORD% %DATABASE% < %%s >nul 2>&1
   if errorlevel 1 (
      echo failure
	  echo Installation failed: SQL command failed for user '%USERNAME%' on database '%DATABASE%' for file %%s
	  exit /b
   ) else (
      echo ok
   )
)

echo Installing tests API

for /D %%d in (%DIR%\..\..\Invoke\*) do (
   for %%s in (%%d\*.sql) do (
      echo|set /p=Processing: %%s .. 
      mysql -u %USERNAME% -p%PASSWORD% %DATABASE% < %%s >nul 2>&1
      if errorlevel 1 (
         echo failure
	     echo Installation failed: SQL command failed for user '%USERNAME%' on database '%DATABASE%' for file %%s
	     exit /b
      ) else (
         echo ok
      )
   )
)

echo mysql-unit successfully installed into database '%DATABASE%'
echo Thank you for using mysql-unit
echo Please, send feedback to <eugen.alter@gmail.com>

