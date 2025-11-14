//
//  SidebarView.swift
//  ZipViewer
//
//  Created by uhimania on 2025/11/14.
//

import SwiftUI

struct SidebarView: View {
    @Binding var items: [ZipItem]
    @Binding var selected: ZipItem?
    
    var body: some View {
        List(items, selection: $selected) { item in
            NavigationLink(value: item) {
                Spacer()
                VStack {
                    if let img = item.image {
                        Image(image: img)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                    Text(item.filename)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    @Previewable @State var items: [ZipItem] = []
    @Previewable @State var selected: ZipItem? = nil
    SidebarView(items: $items, selected: $selected)
}
