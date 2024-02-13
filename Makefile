build-linux:
	bash build_scripts/linux.sh

windows-msix:
	dart run msix:create
windows-zip:
	.\build_scripts/windows.ps1
