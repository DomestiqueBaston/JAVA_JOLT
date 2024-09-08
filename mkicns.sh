#!/bin/sh -e

src=JJ.png

mkdir appicon.iconset

sips -z 16 16    $src --out appicon.iconset/icon_16x16.png
sips -z 32 32    $src --out appicon.iconset/icon_16x16@2x.png
sips -z 32 32    $src --out appicon.iconset/icon_32x32.png
sips -z 64 64    $src --out appicon.iconset/icon_32x32@2x.png
sips -z 64 64    $src --out appicon.iconset/icon_64x64.png
sips -z 128 128  $src --out appicon.iconset/icon_64x64@2x.png
sips -z 128 128  $src --out appicon.iconset/icon_128x128.png
cp $src appicon.iconset/icon_128x128@2x.png
cp $src appicon.iconset/icon_256x256.png

iconutil -c icns -o JJ.icns appicon.iconset
