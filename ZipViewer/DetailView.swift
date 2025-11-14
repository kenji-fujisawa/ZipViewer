//
//  DetailView.swift
//  ZipViewer
//
//  Created by uhimania on 2025/11/14.
//

import SwiftUI

struct DetailView: View {
    @Binding var item: ZipItem?
    
    var body: some View {
        if let item = item,
           let img = item.image {
            ScrollView {
                Image(image: img)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    @Previewable @State var item: ZipItem? = nil
    DetailView(item: $item)
}
