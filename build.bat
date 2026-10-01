@echo off
REM ========================================================
REM  Blinkit Food Ordering System - Build & Package Script
REM ========================================================

echo [1/3] Checking Java environment...
where javac >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    if exist "C:\Users\LENOVO\.jdks\openjdk-25\bin\javac.exe" (
        set "JAVA_BIN=C:\Users\LENOVO\.jdks\openjdk-25\bin"
    ) else (
        echo Error: javac not found in PATH or standard location.
        exit /b 1
    )
) else (
    set "JAVA_BIN="
)

if defined JAVA_BIN (
    set "JAVAC=%JAVA_BIN%\javac.exe"
    set "JAR=%JAVA_BIN%\jar.exe"
) else (
    set "JAVAC=javac"
    set "JAR=jar"
)

echo [2/3] Compiling Java source files...
if not exist "target\classes" mkdir "target\classes"
if not exist "target\food-ordering-system\WEB-INF\lib" mkdir "target\food-ordering-system\WEB-INF\lib"
if not exist "target\food-ordering-system\WEB-INF\classes" mkdir "target\food-ordering-system\WEB-INF\classes"

copy /Y "src\main\resources\db.properties" "target\classes\db.properties" >nul

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$jars = (Get-ChildItem -Path 'C:\Users\LENOVO\.m2\repository', 'WEB-INF\lib' -Filter '*.jar' -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'gson|mysql|jstl|servlet' } | Select-Object -ExpandProperty FullName) -join ';'; ^
   $src = (Get-ChildItem -Path 'src\main\java' -Filter '*.java' -Recurse | Select-Object -ExpandProperty FullName); ^
   & '%JAVAC%' -cp $jars -d 'target\classes' $src"

if %ERRORLEVEL% NEQ 0 (
    echo Compilation failed!
    exit /b %ERRORLEVEL%
)

echo [3/3] Packaging target\food-ordering-system.war...
xcopy /E /I /Y "target\classes\*" "target\food-ordering-system\WEB-INF\classes\" >nul
xcopy /E /I /Y "src\main\webapp\*" "target\food-ordering-system\" >nul

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "Get-ChildItem -Path 'C:\Users\LENOVO\.m2\repository' -Filter '*.jar' -Recurse | Where-Object { $_.Name -match 'gson-2.10.1|mysql-connector-j-8.3.0|jakarta.servlet.jsp.jstl-api-3.0.0|jakarta.servlet.jsp.jstl-3.0.1' } | ForEach-Object { Copy-Item $_.FullName 'target\food-ordering-system\WEB-INF\lib\' -Force }"

"%JAR%" -cvf "target\food-ordering-system.war" -C "target\food-ordering-system" . >nul

echo ========================================================
echo SUCCESS: target\food-ordering-system.war ready for Tomcat 10!
echo ========================================================
