# YYCurvedTabbar

A curved tabbar with animation.

## Preview

![iPhone8](https://github.com/ChuanqingYang/YYCurvedTabbar/blob/main/preview.png)
![Video](https://github.com/ChuanqingYang/YYCurvedTabbar/blob/main/animation.gif)

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

