//
//  FilePageNumberRenameWorker.swift
//  FileNumberRenameWorker
//
//  Created by TK on 2021/7/1.
//

import Foundation

class FilePageNumberRenameWorker {
    private var fileFinder: FileFinderWorker!
    private let filePrefix: String
    private let fileExtension: String
    private let fileManager: FileManager

    init(folderPath: String,
         filePrefix: String,
         fileExtension: String,
         fileManager: FileManager = .default) {
        self.fileFinder = FileFinderWorker(folderPath: folderPath)
        self.filePrefix = filePrefix
        self.fileExtension = fileExtension
        self.fileManager = fileManager
    }
    
    var files: [URL] { fileFinder.getFiles() }
    
    var fileNumbers: [Int] {
        files.compactMap {
            parseNumber(raw: $0.lastPathComponent,
                        deletedTexts: [filePrefix, fileExtension])
        }
    }
    
    func checkMissingNumbers(range: ClosedRange<Int>) -> [Int] {
        let rangeNumbers = Set(Array(range))
        let numbers = Set(fileNumbers)

        return Array(rangeNumbers.subtracting(numbers)).sorted()
    }

    func addNumber(_ appendingNumber: Int) {
        zip(files, fileNumbers).forEach { file, number in
            let originPath = file.absoluteString
            let originNumberText = number.text
            let newPath = originPath.replacingOccurrences(of: originNumberText, with: (number + appendingNumber).text)
            
            print("#### =============================================")
            print("#### originPath: \(originPath)")
            print("#### newPath: \(newPath)")
            print("#### rename result: \(rename(origin: originPath, new: newPath))")
        }
    }

    private func rename(origin: String, new: String) -> Bool {
        do {
            guard let oldUrl = URL(string: origin), let newUrl = URL(string: new) else { return false }
            try fileManager.moveItem(at: oldUrl, to: newUrl)
            return true
        } catch {
            return false
        }
    }
    
    // <Result> deletedTexts = ["A00", ".jpeg"]
    // "A00001.jpeg" -> 1
    func parseNumber(raw: String, deletedTexts: [String]) -> Int? {
        var result = raw
        deletedTexts.forEach {
            result = result.replacingOccurrences(of: $0, with: "")
        }
        return Int(result)
    }
}

extension Int {
    var text: String {
        return String(format: "%03d", self)
    }
}
