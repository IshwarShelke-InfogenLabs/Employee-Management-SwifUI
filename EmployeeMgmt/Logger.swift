import Foundation

let logFileURL =  URL(fileURLWithPath: "/Users/ishwar-shelke/Documents/logfile.log")

func logToFile(message: String) {
    let logMessage = "\(Date()): \(message)\n"
    if let data = logMessage.data(using: .utf8) {
        if let fileHandle = try? FileHandle(forWritingTo: logFileURL) {
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
            fileHandle.closeFile()
        } else {
            try? logMessage.write(to: logFileURL, atomically: true, encoding: .utf8)
        }
    }
}
