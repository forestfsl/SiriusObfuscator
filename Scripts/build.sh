#!/bin/bash

projects=(
  "FileExtractor"
  "VerificationSuite"
  "SymbolExtractorAndRenamer"
)
for i in ${!projects[@]}; do
  echo "BUILD: cd ${projects[$i]} && /bin/bash Scripts/build.sh"
  cd ${projects[$i]} 
  /bin/bash Scripts/build.sh
  cd ..
done

echo "Recreating bin directory"
rm -r bin
mkdir -p bin

echo "Installing FileExtractor"
tar -xf FileExtractor/file-extractor-1.0.0-osx.tar.gz -C .
mv file-extractor-1.0.0-osx/* bin/

echo "Installing SymbolExtractor"
cp -r -p SymbolExtractorAndRenamer/build/Ninja-ReleaseAssert/swift-macosx-x86_64/bin/obfuscator-symbol-extractor bin/symbol-extractor

echo "Installing NameMapper"
cp -r -p SymbolExtractorAndRenamer/build/Ninja-ReleaseAssert/swift-macosx-x86_64/bin/obfuscator-name-mapper bin/name-mapper

echo "Installing Renamer"
cp -r -p SymbolExtractorAndRenamer/build/Ninja-ReleaseAssert/swift-macosx-x86_64/bin/obfuscator-renamer bin/renamer

echo "Copying Swift compiler lib catalog"
rm -r lib
mkdir lib
cp -r -p SymbolExtractorAndRenamer/build/Ninja-ReleaseAssert/swift-macosx-x86_64/lib/swift ./lib/swift

echo "Installing VerificationSuite"
cp -r -p VerificationSuite/VerificationSuite bin/verification-suite

echo "Installing Sirius"
swift build -c release -Xswiftc -static-stdlib
cp -r -p $(swift build -c release --show-bin-path)/Sirius bin/sirius

