//
//  main.swift
//  FileRenameHelper
//
//  Created by Ting Yen Kuo on 2021/6/30.
//

import Foundation

// <Scene>
// [Your folderPath]
// - A00001.jpeg
// - A00002.jpeg
// - ....jpeg
// - A00294.jpeg

// <Demo>
let folderPath = "/Users/tk/Desktop/Book"
let fileNumberWorker = FilePageNumberRenameWorker(folderPath: folderPath, filePrefix: "A00", fileExtension: ".jpeg")

let pages = (1...294)
let missingPageNumbers = fileNumberWorker.checkMissingNumbers(range: pages)
print("#### missingNumbers: \(missingPageNumbers)")

// If you missing 061, then pull 062-end to targetFolder, then #addNumber(1).
fileNumberWorker.addNumber(9)
