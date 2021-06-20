#!/bin/sh

errorExit() {
	echo "*** $*" 1>&2
	exit 1
}

THEME=blingbling
PACKAGE=enlightenment-theme-${THEME}-e20
VERSION="`grep 'item:  *"theme/version"' ${THEME}.edc | head -1 | awk '{ print $3 }' | tr -d '";'`"
echo "$VERSION" | egrep -q '^[0-9]+\.[0-9]+\.[0-9]+$' || errorExit "Error detecting version, got '$VERSION'."
echo "Building rpm for '${THEME}' theme version '${VERSION}'..."

CMD="tar --transform 's|^\.|${PACKAGE}-${VERSION}|' --exclude=./build --exclude='*.tar.gz' --exclude='.git*' -czhf ${PACKAGE}-${VERSION}.tar.gz ./*"
echo "$CMD"
eval "$CMD" || errorExit "Error '$CMD'."

CMD="mkdir -p build"
echo "$CMD"
$CMD || errorExit "Error '$CMD'."

BASEDIR="`pwd`"
CMD="cd build"
echo "$CMD"
$CMD || errorExit "Error '$CMD'."

BUILDDIR="`pwd`"
CMD="rm -rf *"
echo "$CMD"
eval "$CMD" || errorExit "Error '$CMD'."

CMD="sed "s/@VERSION@/${VERSION}/" ../theme.spec.in >${PACKAGE}.spec"
echo "$CMD"
eval "$CMD" || errorExit "Error '$CMD'."

CMD="rpmbuild --define='_topdir ${BUILDDIR}' --define='_sourcedir ${BASEDIR}' --define='_specdir ${BUILDDIR}' -ba ${PACKAGE}.spec"
echo "$CMD"
eval "$CMD" || errorExit "Error '$CMD'."

CMD="cd ${BASEDIR}"
echo "$CMD"
$CMD || errorExit "Error '$CMD'."

CMD="rm ${PACKAGE}-${VERSION}.tar.gz"
echo "$CMD"
$CMD || errorExit "Error '$CMD'."

echo "RPM file build successful, the rpms can be found under 'build/SRPMS' and 'build/RPMS/noarch'."
