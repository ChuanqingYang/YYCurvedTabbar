//
//  SwiftUIView.swift
//  
//
//  Created by ChuanqingYang on 2023/3/15.
//

import SwiftUI

@available(iOS 15.0, *)
struct SwiftUIView: View {
    let items:[YYTabbarItem] = [.init(icon: "house", title: "Home"),.init(icon: "magnifyingglass", title: "Search"),.init(icon: "plus", title: ""),.init(icon: "paperplane", title: "Explore"),.init(icon: "person", title: "Mine")]
    
    @State private var selection:Int = 0
    var body: some View {
        YYCurvedTabbar(items: items, selection: $selection)
    }
}

@available(iOS 15.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
