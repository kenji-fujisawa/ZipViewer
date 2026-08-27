//
//  ZipViewModel.swift
//  ZipViewer
//
//  Created by uhimania on 2026/08/26.
//

import Foundation

@Observable
class ZipViewModel {
    struct Entry: Identifiable, Hashable {
        var id = UUID()
        var entry: FileEntry
        
        var filename: String { entry.filename }
        var image: OSImage? { entry.image }
        
        static func == (lhs: ZipViewModel.Entry, rhs: ZipViewModel.Entry) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
    var entries: [Entry] = []
    var selected: Entry? = nil
    var error: String? = nil
    
    @ObservationIgnored private let repository: FileRepository
    
    init(_ repository: FileRepository) {
        self.repository = repository
    }
    
    func load(url: URL) {
        self.error = nil
        
        do {
            entries = try repository.getEntries(of: url).map { Entry(entry: $0) }
            selected = entries.first
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func moveNext() {
        if let entry = selected,
           let index = entries.firstIndex(of: entry) {
            if index == entries.count - 1 {
                selected = entries.first
            } else {
                selected = entries[index + 1]
            }
        }
    }
    
    func movePrevious() {
        if let entry = selected,
           let index = entries.firstIndex(of: entry) {
            if index == 0 {
                selected = entries.last
            } else {
                selected = entries[index - 1]
            }
        }
    }
}
