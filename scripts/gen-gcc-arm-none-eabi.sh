VER_NOPREP=10.3-2021.10-9
VER=15:$VER_NOPREP
URL=https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2
echo "Creating gcc-arm-none-eabi package version $VER"

echo "Entering temporary directory..."
cd /tmp

echo "Downloading..."
curl -fSL -A "Mozilla/4.0" -o gcc-arm-none-eabi.tar "$URL"

echo "Extracting..."
tar -xf gcc-arm-none-eabi.tar
rm gcc-arm-none-eabi.tar

echo "Generating package..."
mkdir gcc-arm-none-eabi
mkdir gcc-arm-none-eabi/DEBIAN
mkdir gcc-arm-none-eabi/usr
echo "Package: gcc-arm-none-eabi"          >  gcc-arm-none-eabi/DEBIAN/control
echo "Version: $VER"                       >> gcc-arm-none-eabi/DEBIAN/control
echo "Architecture: amd64"                 >> gcc-arm-none-eabi/DEBIAN/control
echo "Maintainer: maintainer"              >> gcc-arm-none-eabi/DEBIAN/control
echo "Description: Arm Embedded toolchain" >> gcc-arm-none-eabi/DEBIAN/control
mv gcc-arm-none-eabi-*/* gcc-arm-none-eabi/usr/
dpkg-deb --build gcc-arm-none-eabi

mv gcc-arm-none-eabi.deb ~/gcc-arm-none-eabi-$VER_NOPREP.deb
echo "Removing temporary files..."
rm -r gcc-arm-none-eabi*

echo "Done."