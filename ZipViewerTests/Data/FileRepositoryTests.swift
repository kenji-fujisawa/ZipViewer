//
//  FileRepositoryTests.swift
//  ZipViewerTests
//
//  Created by uhimania on 2026/08/26.
//

import Foundation
import Testing

@testable import ZipViewer

struct FileRepositoryTests {

    @Test func testGetEntries() async throws {
        let source = FakeZipDataSource()
        let repository = DefaultFileRepository(source)
        
        source.entries.append(FakeFileEntry(filename: "aaa"))
        source.entries.append(FakeFileEntry(filename: "bbb"))
        source.entries.append(FakeFileEntry(filename: "ccc"))
        
        let url = URL(filePath: "")
        let entries = try repository.getEntries(of: url)
        #expect(entries.count == 3)
        #expect(entries[0].filename == "aaa")
        #expect(entries[1].filename == "bbb")
        #expect(entries[2].filename == "ccc")
        #expect(source.url == url)
    }
    
    class FakeFileEntry: FileEntry {
        var filename: String
        var image: OSImage?
        
        init(filename: String, image: OSImage? = nil) {
            self.filename = filename
            self.image = image
        }
    }
    
    class FakeZipDataSource: ZipDataSource {
        var url: URL? = nil
        var entries: [FileEntry] = []
        func getEntries(of path: URL) throws -> [any FileEntry] {
            url = path
            return entries
        }
    }
}
