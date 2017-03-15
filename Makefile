# Prefix recipes with spaces rather than tabs to avoid editor havoc
# (non-standard GNU make extension)
.RECIPEPREFIX +=

WORKDIR = fme
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

ROCOCO_MAIN = ${WORKDIR}/rococo/src/main/java/org/merizen/tangle
ROCOCO_TEST = ${WORKDIR}/rococo/src/test/java/org/merizen/tangle

extract:
    rm -rf ${WORKDIR}
    ${EXTRACT} \
        shell/tangle.sh ${WORKDIR}/tangle.sh \
        perl/tangle.pl ${WORKDIR}/tangle.pl \
        python/tangle.py ${WORKDIR}/tangle.py \
        rococo/pom.xml  ${WORKDIR}/rococo/pom.xml \
        rococo/Tangle.java ${ROCOCO_MAIN}/Tangle.java \
        rococo/ChunkReaderTest.java ${ROCOCO_TEST}/ChunkReaderTest.java \
        rococo/OldLatexParserTest.java ${ROCOCO_TEST}/OldLatexParserTest.java \
        rococo/TangleTest.java ${ROCOCO_TEST}/TangleTest.java

rococo: extract
    cd ${WORKDIR}/rococo; mvn clean install
