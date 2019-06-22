# HyperHW ![GitHub release](https://img.shields.io/badge/release-v1.0.0-blue.svg)
[Flickr 공개피드](https://www.flickr.com/services/feeds/docs/photos_public/)의 이미지를 하나씩 보여주는 전자앨범

## How to download source code
download source
```bash
$ git clone https://github.com/seankim2/HyperHW.git
```

## Cocoapod install
move to project root directory and podfile install
```bash
$ cd HyperHW
$ pod install
Analyzing dependencies
Downloading dependencies
Installing Alamofire (4.8.2)
Installing ReachabilitySwift (4.3.1)
Installing SDWebImage (5.0.1)
Installing SwiftLint (0.31.0)
Generating Pods project
Integrating client project
Sending stats
Pod installation complete! There are 4 dependencies from the Podfile and 4 total pods installed.
```

## Project open and compile
```bash
$ open HyperHW.xcworkspace/
```

## Requirements
- Swift 4.2 or above
- Depolyment target >= 10.0
- Supporting Portrait / Landscape
- Supporting universal app
- Supporting iphone notch

## Using library
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [ReachabilitySwift](https://github.com/ashleymills/Reachability.swift)
- [SDWebImage](https://github.com/SDWebImage/SDWebImage)
- [SwiftLint](https://github.com/realm/SwiftLint)
