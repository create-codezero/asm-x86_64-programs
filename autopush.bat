@echo off
cd /d "E:\mainProject\os-project"
git add .
git commit -m "Auto update %date% %time%"
git push origin main
@REM for first upload comment above line and uncomment below line
@REM git push origin master
pause