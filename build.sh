#!/bin/bash

sudo yum -y groupinstall "Development Tools"

mkdir -p ~/tmp/{usr,etc,var,libs,install,downloads,tar}

wget -P ~/tmp/downloads \
         http://downloads.sourceforge.net/freetype/freetype-2.6.1.tar.bz2 \
         http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.11.1.tar.bz2 \
         http://xmlsoft.org/sources/libxml2-2.9.2.tar.gz \
         http://poppler.freedesktop.org/poppler-0.37.0.tar.xz \
&& ls ~/tmp/downloads/*.tar.* | xargs -i tar xf {} -C ~/tmp/libs/

pushd .

####################################
cd ~/tmp/libs/freetype*
sed -e "/AUX.*.gxvalid/s@^# @@" \
    -e "/AUX.*.otvalid/s@^# @@" \
    -i modules.cfg              &&

sed -e 's:.*\(#.*SUBPIXEL.*\) .*:\1:' \
    -i include/freetype/config/ftoption.h  &&

./configure --prefix=/home/ec2-user/tmp/usr --disable-static &&
make
make install 

####################################
cd ~/tmp/libs/libxml*
PKG_CONFIG_PATH=~/tmp/usr/lib/pkgconfig/:$PKG_CONFIG_PATH \
./configure --prefix=/home/ec2-user/tmp/usr --disable-static --with-history &&
make
make install

####################################
cd ~/tmp/libs/fontconfig*
export FONTCONFIG_PKG=`pwd`

PKG_CONFIG_PATH=~/tmp/usr/lib/pkgconfig/:$PKG_CONFIG_PATH \
./configure --prefix=/home/ec2-user/tmp/usr        \
            --sysconfdir=/home/ec2-user/tmp/etc    \
            --localstatedir=/var \
            --disable-docs       \
            --enable-libxml2 &&
make
make install

####################################
cd ~/tmp/libs/poppler*
PKG_CONFIG_PATH=~/tmp/usr/lib/pkgconfig/:$FONTCONFIG_PKG:$PKG_CONFIG_PATH \
./configure --prefix=/var/task      \
            --sysconfdir=/var/task/etc           \
            --enable-build-type=release \
            --enable-cmyk               \
            --enable-xpdf-headers && make

make install DESTDIR="/home/ec2-user/tmp/install"

unset FONTCONFIG_PKG
popd

tar -C ~/tmp/install/var/task \
    --exclude='include' \
    --exclude='share'   \
    -zcvf ~/tmp/tar/poppler.tar.gz .

aws s3 cp ~/tmp/tar/poppler.tar.gz s3://"${S3BUCKET}"/poppler.tar.gz
