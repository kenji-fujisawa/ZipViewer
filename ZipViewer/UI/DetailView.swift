//
//  DetailView.swift
//  ZipViewer
//
//  Created by uhimania on 2025/11/14.
//

import SwiftUI

struct DetailView: View {
    let entry: ZipViewModel.Entry?
    @Binding var width: CGFloat
    @FocusState private var focused: Bool
    
    var body: some View {
        if let entry = entry,
           let img = entry.image {
            ScrollViewReader { proxy in
                ScrollView([.horizontal, .vertical]) {
                    Image(image: img)
                        .resizable()
                        .scaledToFit()
                        .frame(width: width)
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
    @Previewable @State var width: CGFloat = 500
    let entry = FakeFileEntry(filename: "")
    DetailView(entry: ZipViewModel.Entry(entry: entry), width: $width)
}

private class FakeFileEntry: FileEntry {
    var filename: String
    var image: OSImage?
    
    init(filename: String, image: OSImage? = nil) {
        self.filename = filename
        self.image = image
    }
}
