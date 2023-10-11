#!/bin/bash
YMK_VERSION=4.4.0

YMKFullFramework=./Frameworks/YandexMapsMobile-$YMK_VERSION-full.xcframework
if [ ! -d "$YMKFullFramework" ]
then
    mkdir Frameworks/Temp
    curl --remote-name --output-dir Frameworks/Temp https://maps-ios-pods-public.s3.yandex.net/YandexMapsMobile-$YMK_VERSION-full.framework.zip
    unzip Frameworks/Temp/YandexMapsMobile-$YMK_VERSION-full.framework.zip -d Frameworks/Temp
    mv Frameworks/Temp/YandexMapsMobile.xcframework Frameworks/YandexMapsMobile-$YMK_VERSION-full.xcframework
    rm -rfv Frameworks/Temp
fi

YMKLiteFramework=./Frameworks/YandexMapsMobile-$YMK_VERSION-lite.xcframework
if [ ! -d "$YMKLiteFramework" ]
then
    mkdir Frameworks/Temp
    curl --remote-name --output-dir Frameworks/Temp https://maps-ios-pods-public.s3.yandex.net/YandexMapsMobile-$YMK_VERSION-lite.framework.zip
    unzip Frameworks/Temp/YandexMapsMobile-$YMK_VERSION-lite.framework.zip -d Frameworks/Temp
    mv Frameworks/Temp/YandexMapsMobile.xcframework Frameworks/YandexMapsMobile-$YMK_VERSION-lite.xcframework
    rm -rfv Frameworks/Temp
fi