//
//  FileRepository.swift
//  ZipViewer
//
//  Created by uhimania on 2026/08/26.
//

import Foundation

protocol FileRepository {
    func getEntries(of url: URL) throws -> [any FileEntry]
}

class DefaultFileRepository: FileRepository {
    private let source: ZipDataSource
    
    init(_ source: ZipDataSource) {
        self.source = source
    }
    
    func getEntries(of url: URL) throws -> [any FileEntry] {
        try source.getEntries(of: url)
    }
}
