//
//  ZipViewModelTests.swift
//  ZipViewerTests
//
//  Created by uhimania on 2026/08/26.
//

import Foundation
import Testing

@testable import ZipViewer

struct ZipViewModelTests {

    @Test func testLoad() async throws {
        let repository = FakeFileRepository()
        let viewModel = ZipViewModel(repository)
        #expect(viewModel.entries.count == 0)
        
        repository.entries.append(FakeFileEntry(filename: "aaa"))
        repository.entries.append(FakeFileEntry(filename: "bbb"))
        repository.entries.append(FakeFileEntry(filename: "ccc"))
        
        viewModel.load(url: URL(filePath: ""))
        #expect(viewModel.entries.count == 3)
        #expect(viewModel.entries[0].filename == "aaa")
        #expect(viewModel.entries[1].filename == "bbb")
        #expect(viewModel.entries[2].filename == "ccc")
    }
    
    @Test func testMoveNext() async throws {
        let repository = FakeFileRepository()
        let viewModel = ZipViewModel(repository)
        
        repository.entries.append(FakeFileEntry(filename: "aaa"))
        repository.entries.append(FakeFileEntry(filename: "bbb"))
        repository.entries.append(FakeFileEntry(filename: "ccc"))
        
        viewModel.load(url: URL(filePath: ""))
        #expect(viewModel.selected?.filename == "aaa")
        
        viewModel.moveNext()
        #expect(viewModel.selected?.filename == "bbb")
        
        viewModel.moveNext()
        #expect(viewModel.selected?.filename == "ccc")
        
        viewModel.moveNext()
        #expect(viewModel.selected?.filename == "aaa")
    }
    
    @Test func testMovePrevious() async throws {
        let repository = FakeFileRepository()
        let viewModel = ZipViewModel(repository)
        
        repository.entries.append(FakeFileEntry(filename: "aaa"))
        repository.entries.append(FakeFileEntry(filename: "bbb"))
        repository.entries.append(FakeFileEntry(filename: "ccc"))
        
        viewModel.load(url: URL(filePath: ""))
        #expect(viewModel.selected?.filename == "aaa")
        
        viewModel.movePrevious()
        #expect(viewModel.selected?.filename == "ccc")
        
        viewModel.movePrevious()
        #expect(viewModel.selected?.filename == "bbb")
        
        viewModel.movePrevious()
        #expect(viewModel.selected?.filename == "aaa")
    }
    
    class FakeFileEntry: FileEntry {
        var filename: String
        var image: OSImage?
        
        init(filename: String, image: OSImage? = nil) {
            self.filename = filename
            self.image = image
        }
    }
    
    class FakeFileRepository: FileRepository {
        var entries: [FileEntry] = []
        func getEntries(of url: URL) throws -> [any FileEntry] {
            entries
        }
    }
}
