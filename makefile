default:
	@echo please select a target
	false

compress = cd $2/ && \
	   rm -f $1.tar && \
	   tar -cf $1.tar $1 && \
	   rm -f $1.tar.xz && \
	   xz --compress -9 --extreme $1.tar && \
	   rm -r $1/

decompress = cd $2/ && \
	     test ! -d $1/ && \
	     rm -f $1.tar && \
	     xz --decompress $1.tar.xz && \
	     tar -xf $1.tar && \
	     rm $1.tar

clean = cd $2/ && \
	rm -rf $1/ && \
	rm -f $1.tar

ARCHIVE_EXT := tar.xz

CHROMIUM_PATH := chromium
CHROMIUM_BASE := default
CHROMIUM_ARCHIVE := ${CHROMIUM_PATH}/${CHROMIUM_BASE}.${ARCHIVE_EXT}
CHROMIUM_DIR := ${CHROMIUM_PATH}/${CHROMIUM_BASE}/

${CHROMIUM_ARCHIVE}:
	$(call compress,${CHROMIUM_BASE},${CHROMIUM_PATH})

${CHROMIUM_DIR}:
	$(call decompress,${CHROMIUM_BASE},${CHROMIUM_PATH})

chromium-deploy: ${CHROMIUM_DIR}
chromium-package: ${CHROMIUM_ARCHIVE}

FIREFOX_PATH := mozilla/firefox
FIREFOX_BASE := main
FIREFOX_ARCHIVE := ${FIREFOX_PATH}/${FIREFOX_BASE}.${ARCHIVE_EXT}
FIREFOX_DIR := ${FIREFOX_PATH}/${FIREFOX_BASE}/

${FIREFOX_ARCHIVE}:
	$(call compress,${FIREFOX_BASE},${FIREFOX_PATH})

${FIREFOX_DIR}:
	$(call decompress,${FIREFOX_BASE},${FIREFOX_PATH})

firefox-deploy: ${FIREFOX_DIR}
firefox-package: ${FIREFOX_ARCHIVE}

mrproper:
	$(call clean,${CHROMIUM_BASE},${CHROMIUM_PATH})
	$(call clean,${FIREFOX_BASE},${FIREFOX_PATH})
