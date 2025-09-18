@echo off
cd /d "E:\mainProject\os-project"
git add .
git commit -m "Auto update %date% %time%"
@REM git push origin main
git push origin master
pause