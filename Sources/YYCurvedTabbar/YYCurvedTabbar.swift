//
//  File.swift
//  YYCurvedTabbar
//
//  Created by ChuanqingYang on 2023/3/15.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
public struct YYTabbarItem {
    public var icon:String
    public var title:String
    // if the icon is system icon
    public var system_icon:Bool = true
    public var spacing:CGFloat = 5
    
    public init(icon:String,title:String,system_icon:Bool = true,spacing:CGFloat = 5) {
        self.icon = icon
        self.title = title
        self.system_icon = system_icon
        self.spacing = spacing
    }
}

@available(iOS 15.0, *)
public struct YYTabbarConfiguration {
    
    public var horizontalPadding:CGFloat = 0
    public var contentHeight:CGFloat = 49
    public var curveHeight:CGFloat = 21
    
    public enum CurveStyle {
        case stroke(style:LinearGradient = LinearGradient(colors: [.gray,.clear], startPoint: .top, endPoint: .bottom),width:CGFloat = 1)
        case fill(style:LinearGradient = LinearGradient(colors: [.white], startPoint: .top, endPoint: .bottom))
    }
    public var style:CurveStyle = .stroke()
    
    public struct Shadow {
        public var color:Color = .clear
        public var radius:CGFloat = 4
        public var offset:CGPoint = .init(x: 0, y: -2)
    }
    
    public var shadow:Shadow = .init()
    
    public var animation:Animation = .spring()
    
    
    public var title_font:Font = .caption2
    public var select_color:Color = .primary
    public var normal_color:Color = .primary
    
    public var selection_bg_color:Color = .yellow
    public var selection_bg_padding:CGFloat = 6
    public var selection_bg_offset:CGFloat = -15
    
    public enum SelectionStyle {
        case follow
        case scale
    }
    
    public var selection_style:SelectionStyle = .scale
    
    public enum ContentStyle {
        case blur(style:UIBlurEffect.Style)
        case fill(style:LinearGradient)
    }
    
    public var content_style:ContentStyle = .fill(style: .linearGradient(colors: [.yellow,.yellow.opacity(0.2),.yellow.opacity(0)], startPoint: .bottom, endPoint: .top))
    
    public init() {
        
    }
}

@available(iOS 15.0, *)
public struct YYCurvedTabbar: View {
    public var config:YYTabbarConfiguration = .init()
    public var items:[YYTabbarItem]
    @Binding var currentIndex:Int
    @Namespace private var namespace
    
    public init(config:YYTabbarConfiguration = .init(),items: [YYTabbarItem], selection:Binding<Int>) {
        self.config = config
        self.items = items
        _currentIndex = selection
    }
    
    public var body: some View {
        Rectangle()
            .fill(Color.clear)
            .overlay(alignment:.top) {
                switch self.config.content_style {
                    case let .fill(style):
                        Rectangle()
                            .fill(style)
                    case let .blur(style):
                        BlurEffectView(style: style)
                }
            }
            .clipShape(TabbarBackShape(currentIndex: Double(currentIndex),totalItems:items.count,curveHorizontalPadding:self.config.horizontalPadding,contentHeight: self.config.contentHeight + safe_area.bottom))
            .frame(height: self.config.curveHeight + self.config.contentHeight + safe_area.bottom)
            .overlay(alignment:.top,content: {
                HStack {
                    ForEach(items.indices,id: \.self) { index in
                        let item = items[index]
                        VStack(spacing:item.spacing) {
                            ZStack {
                                if item.system_icon {
                                    Image(systemName: item.icon)
                                        .renderingMode(.template)
                                        .foregroundColor(currentIndex == index ? self.config.select_color : self.config.normal_color)
                                }else {
                                    Image(item.icon)
                                        .renderingMode(.template)
                                        .foregroundColor(currentIndex == index ? self.config.select_color : self.config.normal_color)
                                }
                            }
                            .padding(currentIndex == index ? self.config.selection_bg_padding : 0)
                            .background {
                                switch self.config.selection_style {
                                    case .follow:
                                        if currentIndex == index {
                                            Circle()
                                                .fill(currentIndex == index ? self.config.selection_bg_color : .clear)
                                                .matchedGeometryEffect(id: "CIRCLE", in: namespace)
                                        }
                                    case .scale:
                                        Circle()
                                            .fill(currentIndex == index ? self.config.selection_bg_color : .clear)
                                }
                            }
                            .offset(y: currentIndex == index ? self.config.selection_bg_offset : 0)
                            .frame(height: self.config.contentHeight)
                            .frame(maxWidth: .infinity)
                        }
                        .overlay(alignment: .bottom, content: {
                            Text(LocalizedStringKey(stringLiteral: item.title))
                                .font(self.config.title_font)
                                .foregroundColor(currentIndex == index ? self.config.select_color : self.config.normal_color)
                        })
                        .offset(y: -5)
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(self.config.animation) {
                                currentIndex = index
                            }
                        }
                    }
                }
                .padding(.horizontal,5)
                .offset(y: self.config.curveHeight)
            })
            .overlay(alignment:.top) {
                switch self.config.style {
                    case let .stroke(style, width):
                        TabbarBackShape(currentIndex: Double(currentIndex),totalItems:items.count,curveHorizontalPadding:self.config.horizontalPadding,contentHeight: self.config.contentHeight + safe_area.bottom)
                            .stroke(style, lineWidth: width)
                            .shadow(color: self.config.shadow.color, radius: self.config.shadow.radius, x: self.config.shadow.offset.x, y: self.config.shadow.offset.y)
                    case let .fill(style):
                        TabbarBackShape(currentIndex: Double(currentIndex),totalItems:items.count,curveHorizontalPadding:self.config.horizontalPadding,contentHeight: self.config.contentHeight + safe_area.bottom)
                            .fill(style)
                            .shadow(color: self.config.shadow.color, radius: self.config.shadow.radius, x: self.config.shadow.offset.x, y: self.config.shadow.offset.y)
                }
                
            }
    }
}




// MARK: - Shapes
@available(iOS 15.0, *)
public struct TabbarBackShape: Shape {
    
    // current index - double bcz animatable data needed
    var currentIndex:Double
    // items
    var totalItems:Int
    
    // leading-trailing padding
    var curveHorizontalPadding:CGFloat = 10
    var contentHeight:CGFloat = 49
    
    public var animatableData: Double {
        get { currentIndex }
        set {
            if currentIndex < Double(totalItems) {
                currentIndex = newValue
            }
        }
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let topLineStartY = rect.maxY - contentHeight
        
        let itemWidth = rect.width / Double(totalItems)
        
        var index = currentIndex
        
        if index <= 0 {
            index = 0
        }
        
        if index >= Double(totalItems) {
            index = Double(totalItems) - 1
        }
        
        let itemTrailingX = rect.width / Double(totalItems) * (index + 1)
        let curveTopX = itemTrailingX - itemWidth / 2
        let itemLeadingX = itemTrailingX - itemWidth
        let topEndX = itemTrailingX - curveHorizontalPadding
        
        let curveTopPoint = CGPoint(x: curveTopX, y: rect.minY)
        
        let curveEndPoint = CGPoint(x: topEndX, y: topLineStartY)
        
        let curveControlWidth = (curveTopX - itemLeadingX - curveHorizontalPadding) / 2
        let curveControlX = curveTopX - curveControlWidth
        
        
        path.move(to: CGPoint(x: rect.minX, y: topLineStartY))
        
        path.addLine(to: CGPoint(x: itemLeadingX + curveHorizontalPadding , y: topLineStartY))
        
        path.addCurve(to: curveTopPoint, control1: CGPoint(x: curveControlX, y: topLineStartY), control2: CGPoint(x: curveControlX, y: rect.minY))
        
        path.addCurve(to: curveEndPoint, control1: CGPoint(x: curveControlX + curveControlWidth * 2, y: rect.minY), control2: CGPoint(x: curveControlX + curveControlWidth * 2, y: topLineStartY))
        
        path.addLine(to: CGPoint(x: itemTrailingX, y: topLineStartY))
        
        path.addLine(to: CGPoint(x: rect.maxX, y: topLineStartY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        
        
        return path
    }
}
// MARK: - Blur
@available(iOS 15.0, *)
struct BlurEffectView: UIViewRepresentable {
    
    var style:UIBlurEffect.Style = .systemUltraThinMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let blur = UIVisualEffectView(effect: UIBlurEffect.init(style: style))
        return blur
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    
    }
}
// MARK: - Utls

@available(iOS 15.0, *)
var safe_area:UIEdgeInsets = {
    guard let scence = UIApplication.shared.connectedScenes.first as? UIWindowScene else {  return .init()}
    guard let window = scence.windows.first else { return .init() }
    
    return window.safeAreaInsets
}()
