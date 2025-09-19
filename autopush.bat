@echo off
cd /d "E:\mainProject\os-project"
git add .
git commit -m "Auto update %date% %time%"
@REM git push origin main
@REM for first upload comment above line and uncomment below line
git push origin master
pause