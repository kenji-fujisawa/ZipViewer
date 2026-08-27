//
//  SidebarView.swift
//  ZipViewer
//
//  Created by uhimania on 2025/11/14.
//

import SwiftUI

struct SidebarView: View {
    @Bindable var viewModel: ZipViewModel
    
    var body: some View {
        List(viewModel.entries, selection: $viewModel.selected) { entry in
            NavigationLink(value: entry) {
                Spacer()
                LazyVStack {
                    if let img = entry.image {
                        Image(image: img)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                    Text(entry.filename)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    let repository = FakeFileRepository()
    let viewModel = ZipViewModel(repository)
    SidebarView(viewModel: viewModel)
}

private class FakeFileRepository: FileRepository {
    func getEntries(of url: URL) throws -> [any FileEntry] { [] }
}
