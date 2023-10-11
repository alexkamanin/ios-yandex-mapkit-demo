# Yandex MapKit Demo Application

## About

This is a copy of the yandex mapkit demo [repository](https://github.com/yandex/mapkit-ios-demo) with the following changes:

- As a pull-up of the library dependency XCFramework is used instead of CocoaPods;
- The layout is done entirely by code using SnapKit;
- The project is being built using XCodeGen;
- Minimum OS version raised to iOS 13;
- Added demonstration of the light/dark map theme;
- Added the ability to switch panoramas to historical ones.

## Project specific

To generate `*.xcodeproj`-file use command:

```sh
make generate
```

To generate and open immediately use command:

```sh
make generate open
```

> [!IMPORTANT]  
> Since Github limits the size of stored files to 100 MB, downloading the `*.xcframework` is performed with `make generate` using `curl`.

## API KEY

Set your key in the file `Resources/Configs/YMKConfig.xcconfig`.

```pbxproj
YMK_API_KEY = {YOUR_API_KEY}
```

## Official documentation

* [Documentation](https://yandex.ru/dev/maps/mapkit/doc/intro/concepts/about.html)
* [Quickstart](https://yandex.ru/dev/maps/mapkit/doc/ios-quickstart/concepts/ios/quickstart.html)

## P.S.

For download the XCFramework, use the command in the terminal:

```sh
curl --remote-name https://maps-ios-pods-public.s3.yandex.net/YandexMapsMobile-4.4.0-lite.framework.zip
```

```sh
curl --remote-name https://maps-ios-pods-public.s3.yandex.net/YandexMapsMobile-4.4.0-full.framework.zip
```