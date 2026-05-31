#!/usr/bin/env bash

# Reproducible JDK 9+ JAR generation script
# Downloads OpenJDK, extracts modules and creates rt.jar

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Configuration
DOWNLOAD_LINK="https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz"
FILENAME="jdk.tar.gz"
EXPECTED_SHA256="0022753d0cceecacdd3a795dd4cea2bd7ffdf9dc06e22ffd1be98411742fbb44"

# Download JDK if not exists
[ ! -f "$FILENAME" ] && wget "$DOWNLOAD_LINK" -O "$FILENAME"

# Verify SHA256 checksum
echo "$EXPECTED_SHA256 $FILENAME" | sha256sum -c || exit 1

# Extract JDK to temp directory
rm -rf temp && mkdir temp
tar -xzf "$FILENAME" --strip-components=1 -C temp

cd temp

# Extract all .jmod files directly to temp directory
mkdir extracted
for jmod in jmods/*.jmod; do
    ./bin/jmod extract --dir extracted "$jmod"
done

# Package classes into rt.jar
./bin/jar -cf rt.jar -C extracted/classes .

# Copy output files and cleanup
cp rt.jar lib/jrt-fs.jar release ../
cd .. && rm -rf temp "$FILENAME"

echo "Generated: rt.jar ($(du -h rt.jar | cut -f1))"
echo "Generated: jrt-fs.jar ($(du -h jrt-fs.jar | cut -f1))"
echo "Generated: release ($(du -h release | cut -f1))"
