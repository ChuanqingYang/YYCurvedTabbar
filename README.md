# YYCurvedTabbar

A curved tabbar with animation.

## Preview

![iPhone8](https://https://github.com/ChuanqingYang/YYCurvedTabbar/iPhone-8.png)
![iPhone14](https://https://github.com/ChuanqingYang/YYCurvedTabbar/iPhone-14.png)
![Video](https://https://github.com/ChuanqingYang/YYCurvedTabbar/animation.mp4)

## Features
- Custom selection animation `YYTabbarConfiguration.SelectionStyle`
- Custom background `YYTabbarConfiguration.ContentStyle`
- Custom Curve `YYTabbarConfiguration.CurveStyle`

and more...

## Usage
``` swift
VStack {
    Text(items[selection].title)
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
}
.overlay(alignment: .bottom) {
  YYCurvedTabbar(items: items, selection: $selection)
}
.ignoresSafeArea()
```

