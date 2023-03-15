# YYCurvedTabbar

A curved tabbar with animation.

## Preview

<img src="https://github.com/ChuanqingYang/YYCurvedTabbar/blob/main/preview.png">
<img src="https://github.com/ChuanqingYang/YYCurvedTabbar/blob/main/animation.gif" width="200" height="250">

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

