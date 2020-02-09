//
//  FileWorker.swift
//  FileWorker
//
//  Created by Pini Che on 29/12/2019.
//  Copyright © 2019 Pinich. All rights reserved.
//

import Foundation

class FileWorkerP {
    let file: FileHandle!
    
    init(_ filePath: String) {
        self.file = FileHandle(forReadingAtPath: filePath)
        
    }

    func startReading() -> String {
        if self.file != nil {
            // Read all the data
            let data = file?.readDataToEndOfFile()

            // Close the file
            file?.closeFile()

            // Convert our data to string
            let str = String(data: data!, encoding: .utf8)!
            let dict = self.convertToDictionary(str)
            
            let res = createEnumStr(dict)
            
            print("🟢 Finished runninbg dict.count = \(dict.count)")
            return res
        }
        else {
            print("Ooops! Something went wrong!")
            return ""
        }
    }

    private func createEnumStr(_ dict: [(key: String, value: String)]) -> String {
        var resultStr = "enum LocalizeStr: String {\n"
        for elm in dict {
            let caseStr = "    case \(elm.key) // \(elm.value.replacingOccurrences(of: "\n", with: "\\n"))\n"
            resultStr.append(caseStr)
        }
        resultStr.append("""

            public func localized() -> String {
                return self.rawValue.localized()
            }
        }
        """)
        return resultStr
    }

    private func convertToDictionary(_ str: String) -> [(key: String, value: String)] {
        
        var dict: Dictionary = [String: String]()
        _ = str.components(separatedBy: ";\n").map { (line) -> String in
            var result = line
            if line.starts(with: "/*") {
                // Remove Until the last */ Sign
                result = line.components(separatedBy: "*/\n").last!
            }
            return result
        }.filter { (line) -> Bool in
            if line.starts(with: "\"") {
                return true
            }
            return false
        }.map { line in
            let keyValDirty = line.components(separatedBy: "\" = \"")
            guard keyValDirty.count > 1 && keyValDirty[0].first! == "\"" else {
                return
            }
            let keyVal = elementCleaner(keyDirty: keyValDirty[0], valDirty: keyValDirty[1])
            dict[keyVal.0] = keyVal.1
        }
        let sorted = dict.sorted { (arg0, arg1) -> Bool in
            let (rkey, rvalue) = arg1
            let (lkey, lvalue) = arg0
            return lkey.lowercased() < rkey.lowercased() ? true : false
        }
        return sorted
    }

    private func elementCleaner(keyDirty: String, valDirty: String) -> (String, String) {
        var key = keyDirty
        key.removeFirst()
        var val = valDirty
        val.removeLast()
        return (key, val)
    }
/*
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
*/
    
    public static func writeToFile(_ str: String, _ path: String) {
        do {
            // Write contents to file
            try str.write(toFile: path, atomically: false, encoding: .utf8)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
}
