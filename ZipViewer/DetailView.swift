//
//  DetailView.swift
//  ZipViewer
//
//  Created by uhimania on 2025/11/14.
//

import SwiftUI

struct DetailView: View {
    @Binding var item: ZipItem?
    @FocusState private var focused: Bool
    
    var body: some View {
        if let item = item,
           let img = item.image {
            ScrollViewReader { proxy in
                ScrollView {
                    Image(image: img)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .id("image")
                }
                .focusable()
                .focused($focused)
                .onKeyPress { press in
                    if press.key == .upArrow {
                        proxy.scrollTo("image", anchor: .top)
                        return .handled
                    } else if press.key == .downArrow {
                        proxy.scrollTo("image", anchor: .bottom)
                        return .handled
                    }
                    return .ignored
                }
                .onAppear {
                    focused = true
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var item: ZipItem? = nil
    DetailView(item: $item)
}
