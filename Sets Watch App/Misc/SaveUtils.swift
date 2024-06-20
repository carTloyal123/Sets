//
//  SaveUtils.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/16/24.
//

import Foundation


class SaveUtils {
    
    static let shared = SaveUtils()
    
    
    // Private initializer to prevent instantiation from other classes
    private init() {
        print("Started Save utils single instance!")
    }
    
    func GetFileName(for fileName: String) -> String
    {
        return fileName + ".json"
    }
    
    // Function to serialize and save data to a specific directory
    func SaveToDevice<T: Codable>(data: T, to directoryName: String?, filename: String) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(data)

        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            var save_dir = directory
            if let folder = directoryName
            {
                save_dir = directory.appendingPathComponent(folder)
            }
            
            // Create the directory if it doesn't exist
            if !FileManager.default.fileExists(atPath: save_dir.path) {
                try FileManager.default.createDirectory(at: save_dir, withIntermediateDirectories: true, attributes: nil)
            }
            
            let fileURL = save_dir.appendingPathComponent(filename)
            try data.write(to: fileURL)
            print("Saved file to: \(fileURL)")
        } else {
            throw NSError(domain: "FileError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to locate directory in documents directory"])
        }
    }
    
    // Function to deserialize and load data from a specific directory
    func LoadFromDirectory<T: Codable>(from directoryName: String, filename: String) throws -> T {
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(directoryName) {
            let fileURL = directory.appendingPathComponent(filename)
            let data = try Data(contentsOf: fileURL)
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } else {
            throw NSError(domain: "FileError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to locate directory in documents directory"])
        }
    }

    // Function to deserialize and load data from the device
    func LoadFromDevice<T: Codable>(from filename: String) throws -> T {
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = directory.appendingPathComponent(filename)
            let data = try Data(contentsOf: fileURL)
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        }
        throw NSError(domain: "FileError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to locate file in documents directory"])
    }
    
    // Function to load all files from a directory and deserialize them
    func LoadDirectory<T: Codable>(from directoryName: String) throws -> [T] {
        var results = [T]()
        
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(directoryName) {
            
            // Create the directory if it doesn't exist
            if !FileManager.default.fileExists(atPath: directory.path) {
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            }
            
            let fileURLs = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            
            let decoder = JSONDecoder()
            
            for fileURL in fileURLs {
                let data = try Data(contentsOf: fileURL)
                let decodedObject = try decoder.decode(T.self, from: data)
                results.append(decodedObject)
            }
        } else {
            throw NSError(domain: "FileError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to locate directory in documents directory"])
        }
        
        return results
    }
    
    func RemoveFile(named filename: String, from folder: String) {
        // Get the URL of the document directory
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to locate the document directory")
            return
        }
        
        // Append the folder and filename to the document directory URL
        let folderURL = documentDirectory.appendingPathComponent(folder)
        let fileURL = folderURL.appendingPathComponent(filename)
        
        // Check if the file exists
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // Attempt to delete the file
                try FileManager.default.removeItem(at: fileURL)
                print("File deleted successfully")
            } catch {
                // Handle any errors
                print("Failed to delete file: \(error.localizedDescription)")
            }
        } else {
            print("File does not exist at path: \(fileURL.path)")
        }
    }
    
    func RemoveFolder(named folder: String) {
        // Get the URL of the document directory
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to locate the document directory")
            return
        }
        
        // Append the folder path to the document directory URL
        let folderURL = documentDirectory.appendingPathComponent(folder)
        
        // Check if the folder exists
        if FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                // Attempt to delete the folder
                try FileManager.default.removeItem(at: folderURL)
                print("Folder deleted successfully")
            } catch {
                // Handle any errors
                print("Failed to delete folder: \(error.localizedDescription)")
            }
        } else {
            print("Folder does not exist at path: \(folderURL.path)")
        }
    }
}
