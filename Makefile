# Prefix recipes with spaces rather than tabs to avoid editor havoc
# (non-standard GNU make extension)
.RECIPEPREFIX +=

WORKDIR = fme/work
TMP = fme/tmp
PAMPHLET = tangle_book.tex

TANGLE = bin/tangle.pl
# TANGLE = bin/tangle.py
# TANGLE = bin/tangle.sh
# TANGLE = java -cp bin/tangle.jar org.merizen.tangle.Tangle

EXTRACT = ${TANGLE} ${PAMPHLET}

install: extract java
    cp ${WORKDIR}/tangle.* bin
    cp ${WORKDIR}/java/target/*.jar bin/tangle.jar

reset:
    cp germ/* bin

.PHONY: install extract java update_makefile reset

update_makefile:
    ${EXTRACT} Makefile Makefile

JAVA_MAIN = ${TMP}/java/src/main/java/org/merizen/tangle
JAVA_TEST = ${TMP}/java/src/test/java/org/merizen/tangle

extract:
    rm -rf ${TMP}
    ${EXTRACT} \
        shell/tangle.sh ${TMP}/tangle.sh \
        perl/tangle.pl ${TMP}/tangle.pl \
        python/tangle.py ${TMP}/tangle.py \
        java/pom.xml  ${TMP}/java/pom.xml \
        java/Tangle.java ${JAVA_MAIN}/Tangle.java \
        java/ChunkReaderTest.java ${JAVA_TEST}/ChunkReaderTest.java \
        java/DumpingFragmentStateTest.java ${JAVA_TEST}/DumpingFragmentStateTest.java \
        java/LatexExtractorTest.java ${JAVA_TEST}/LatexExtractorTest.java \
        java/TangleTest.java ${JAVA_TEST}/TangleTest.java
    mkdir -p ${WORKDIR}
    rsync -a ${TMP}/ ${WORKDIR}
    rm -rf ${TMP}

java: extract
    cd ${WORKDIR}/java; mvn clean install
