//
//  main.swift
//  FileWorker
//
//  Created by Pini Che on 29/12/2019.
//  Copyright © 2019 Pinich. All rights reserved.
//

import Foundation

var filePath = ""
var destinationPath = ""
if CommandLine.arguments.count > 1 {
    filePath = CommandLine.arguments[1]
    let range = filePath[filePath.startIndex..<filePath.lastIndex(of: "/")!].description
    destinationPath = range.description + "/LocalizeStr.swift"
} else {
    print("Not Strings argument sent")
    exit(0)
}


let fileWorker = FileWorkerP(filePath)
// Generate Enum from input file
let enumSTR = fileWorker.startReading()
// Save the file
FileWorkerP.writeToFile(enumSTR, destinationPath)
