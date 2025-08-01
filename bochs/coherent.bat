@echo off
rem Bochs doesn't like spaces and quotation marks.
rem Change path to installation folder:
set BOCHS_INSTALL=C:\Progra~1\Bochs
%BOCHS_INSTALL%\bochs.exe -q -f %~dp0\coherent.bxrc
