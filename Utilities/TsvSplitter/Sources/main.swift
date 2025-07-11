import Foundation

// Function to read and split the TSV file into multiple files
func splitTSV(inputFile: String) throws {
    // Step 1: Read the input TSV file
    let fileURL = URL(fileURLWithPath: inputFile)
    
    // Get the parent directory of the input file
    let parentDirectory = fileURL.deletingLastPathComponent()
    
    let fileContent = try String(contentsOf: fileURL, encoding: .utf8)
    
    // Step 2: Split file content by lines
    let lines = fileContent.split(separator: "\n").map { String($0) }
    
    // Step 3: Check for empty lines and handle them
    guard !lines.isEmpty else { return }
    
    // Step 4: Handle the header row by skipping the first two columns
    let headerRow = lines[0]
    let headerColumns = headerRow.split(separator: "\t").map { String($0) }
    let headerRowWithoutFirstTwo = headerColumns.dropFirst(2).joined(separator: "\t")
    
    // Step 5: Process each row after the header
    var fileHandles: [String: FileHandle] = [:] // Dictionary to hold file handles for each file
    
    for line in lines.dropFirst() {  // Skip the header row
        let columns = line.components(separatedBy: "\t")
        
        // Ensure row has at least 3 columns (to have a filename and data)
        guard columns.count > 2 else { continue }
        
        let filename = columns[0] // First column is the filename
        
        // Step 6: Write the header to new files if not already written
        if fileHandles[filename] == nil {
            // Create the full URL for the output file, which will be in the same parent directory as the input file
            let outputFileURL = parentDirectory.appendingPathComponent("\(filename).app.v06.20250703.intake.tsv")
            
            // Ensure the parent directory exists
            let outputDirectory = outputFileURL.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: outputDirectory, withIntermediateDirectories: true, attributes: nil)
            
            // Create the file if it doesn't exist
            if !FileManager.default.fileExists(atPath: outputFileURL.path) {
                FileManager.default.createFile(atPath: outputFileURL.path, contents: nil, attributes: nil)
            }
            
            // Open the file for writing (this will create the file and allow appending)
            let fileHandle = try FileHandle(forWritingTo: outputFileURL)
            fileHandles[filename] = fileHandle
            
            // Write the modified header row to the file only once (excluding the first two columns)
            try headerRowWithoutFirstTwo.appendLineToURL(fileURL: outputFileURL)
        }
        
        // Step 7: Write the data for the current row to the corresponding file
        if let fileHandle = fileHandles[filename] {
            // Append data at the end of the file to prevent overwriting
            fileHandle.seekToEndOfFile()
            
            // Join all columns starting from index 2 (i.e., skip first two columns) and write to the file
            let rowData = columns[2...].joined(separator: "\t")
            let dataWithNewline = rowData + "\n"
            fileHandle.write(dataWithNewline.data(using: .utf8)!)
        }
    }
    
    // Step 8: Close all file handles
    for fileHandle in fileHandles.values {
        fileHandle.closeFile()
    }
    
    print("TSV file split successfully!")
}

// Extension to append text to a file URL
extension String {
    func appendLineToURL(fileURL: URL) throws {
        let data = (self + "\n").data(using: .utf8)!
        
        // Simply write the data (the file will be created if it doesn't exist)
        try data.write(to: fileURL)
    }
}

// Example usage
do {
    let inputFile = "path/to/your/input.tsv" // Provide the path to the input TSV file
    try splitTSV(inputFile: inputFile)
} catch {
    print("Error: \(error)")
}

//if CommandLine.argc < 2 {
//    print("Please provide the path to the input TSV file.")
//    exit(1)
//}
//
//let inputFile = CommandLine.arguments[1]
//try splitTSV(inputFile: inputFile)
