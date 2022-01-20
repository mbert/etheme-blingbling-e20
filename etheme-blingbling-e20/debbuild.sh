#!/bin/sh

errorExit() {
	echo "*** $*" 1>&2
	exit 1
}

THEME=blingbling
PACKAGE=enlightenment-theme-${THEME}-e20
VERSION="`grep 'item:  *"theme/version"' ${THEME}.edc | head -1 | awk '{ print $3 }' | tr -d '";'`"
echo "$VERSION" | egrep -q '^[0-9]+\.[0-9]+\.[0-9]+$' || errorExit "Error detecting version, got '$VERSION'."
echo "Building deb for '${THEME}' theme version '${VERSION}'..."

CMD="./build.sh"
echo "$CMD"
$CMD || errorExit "Error '$CMD'."

DIR=${PACKAGE}_${VERSION}
CMD="mkdir -p ${DIR}/DEBIAN ${DIR}/usr/share/elementary/themes ${DIR}/usr/share/doc/${PACKAGE}"
echo "$CMD"
$CMD || errorExit "Error '$CMD'."

CMD="sed "s/@VERSION@/${VERSION}/" control.in >${DIR}/DEBIAN/control"
echo "$CMD"
eval "$CMD" || errorExit "Error '$CMD'."

CMD="cp ${THEME}.edj ${DIR}/usr/share/elementary/themes/"
echo "$CMD"
eval "$CMD" || errorExit "Error '$CMD'."

CMD="cp README.md LICENSE ${DIR}/usr/share/doc/${PACKAGE}/"
echo "$CMD"
eval "$CMD" || errorExit "Error '$CMD'."

CMD="dpkg -b ${DIR}"
echo "$CMD"
eval "$CMD" || errorExit "Error '$CMD'."

CMD="rm -r ${DIR}"
echo "$CMD"
$CMD || errorExit "Error '$CMD'."

echo "DEB file build successful, the deb can be found in this directory."
