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