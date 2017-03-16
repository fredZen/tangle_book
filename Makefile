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

install: extract rococo
    cp ${WORKDIR}/tangle.* bin
    cp ${WORKDIR}/rococo/target/*.jar bin/tangle.jar

reset:
    cp germ/* bin

.PHONY: install extract rococo update_makefile reset

update_makefile:
    ${EXTRACT} Makefile Makefile

ROCOCO_MAIN = ${TMP}/rococo/src/main/java/org/merizen/tangle
ROCOCO_TEST = ${TMP}/rococo/src/test/java/org/merizen/tangle

extract:
    rm -rf ${TMP}
    ${EXTRACT} \
        shell/tangle.sh ${TMP}/tangle.sh \
        perl/tangle.pl ${TMP}/tangle.pl \
        python/tangle.py ${TMP}/tangle.py \
        rococo/pom.xml  ${TMP}/rococo/pom.xml \
        rococo/Tangle.java ${ROCOCO_MAIN}/Tangle.java \
        rococo/ChunkReaderTest.java ${ROCOCO_TEST}/ChunkReaderTest.java \
        rococo/DumpingFragmentStateTest.java ${ROCOCO_TEST}/DumpingFragmentStateTest.java \
        rococo/LatexExtractorTest.java ${ROCOCO_TEST}/LatexExtractorTest.java \
        rococo/TangleTest.java ${ROCOCO_TEST}/TangleTest.java
    mkdir -p ${WORKDIR}
    rsync -a ${TMP}/ ${WORKDIR}
    rm -rf ${TMP}

rococo: extract
    cd ${WORKDIR}/rococo; mvn clean install
