INNO_VERSION=6.2.0
TEMP_DIR=/tmp/schedule-tar
USR_SHARE=deb-struct/usr/share
BUNDLE_DIR=build/linux/${ARCH}/release/bundle
MIRRORLIST=${PWD}/build/mirrorlist

tar:
	mkdir -p $(TEMP_DIR)\
    && cp -r $(BUNDLE_DIR)/* $(TEMP_DIR)\
    && cp linux/schedule.desktop $(TEMP_DIR)\
    && cp assets/images/logo.png $(TEMP_DIR)\
    && tar -cJf build/schedule-linux-${VERSION}-${PKG_ARCH}.tar.xz -C $(TEMP_DIR) .\
    && rm -rf $(TEMP_DIR)

inno:
	powershell .\build\iscc\iscc.exe scripts\windows-setup-creator.iss

innoinstall:
	powershell mkdir build
	powershell curl -o build/installer.exe https://files.jrsoftware.org/is/6/innosetup-${INNO_VERSION}.exe
	powershell git clone https://github.com/DomGries/InnoDependencyInstaller.git  build/inno-depend
	powershell build/installer.exe /verysilent /allusers /dir=build/iscc

choco:
	powershell cp dist/schedule-windows-x86_64-setup.exe windows/choco-struct/tools
	powershell choco pack ./windows/choco-struct/schedule.nuspec  --outputdirectory dist
