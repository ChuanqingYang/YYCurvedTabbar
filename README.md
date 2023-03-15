# YYCurvedTabbar

A curved tabbar with animation.

## Preview

<div>
    <img src="https://github.com/ChuanqingYang/YYCurvedTabbar/blob/main/preview.png" height="450">
    <img src="https://github.com/ChuanqingYang/YYCurvedTabbar/blob/main/animation.gif" width="250" height="450">
</div>

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

