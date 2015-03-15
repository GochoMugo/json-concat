@echo off

:args
if not "%1"=="" (
    call :%1
    shift
    goto args
)
goto :eof


:dist
mkdir -p dist
coffee --no-header --output dist --compile src/*.coffee
cp README.md LICENSE package.json dist/
echo "Dist ready !"


:clean
rm -rf dist
echo "Cleaned !"

