SET YYYY=%date:~0,4%
SET MM=%date:~5,2%
SET DD=%date:~8,2%

::echo %YYYY%-%MM%-%DD%
SET DATE=%YYYY%-%MM%-%DD%
git add *
git commit -m "%DATE%"