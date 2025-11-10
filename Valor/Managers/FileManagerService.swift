//
//  FileManager.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 05.11.2025.
//

import Foundation
import UIKit

/// Protocol for managing image caching in memory and on disk.
protocol IFileManager {
    func addImage(image: UIImage, url: String) throws
    func getImage(url: URL) -> UIImage?
}

/// Service handling image caching with NSCache and file system persistence.
final class FileManagerService{
    enum Consts {
        static let dirName = "Valor"
        static let imageFileCompression: CGFloat = 0.8
    }
    
    private let memoryCache = NSCache<NSString, UIImage>()
}

// MARK: - Public functions

extension FileManagerService: IFileManager  {
    /// Adds image to memory cache and disk if not already saved.
    /// Prevents overwriting existing files.
    func addImage(image: UIImage, url: String) throws {
        addImageInCache(image: image, url: url)
        guard
            let url = URL(string: url),
            let fileName = extractName(from: url.absoluteString),
            let valorDir = getCacheDirectory()
        else { return }
        try createNewFolder(urlDirectory: valorDir)
        let fileURL = valorDir.appendingPathComponent(fileName)
        guard !FileManager.default.fileExists(atPath: fileURL.path),
              let data = image.jpegData(compressionQuality: Consts.imageFileCompression)
        else { return }
        try data.write(to: fileURL, options: [.atomic])
    }
    
    /// Retrieves image from memory cache or loads it from disk and caches it.
    func getImage(url: URL) -> UIImage? {
        if let image = getImageInCache(url: url.absoluteString) {
            return image
        }
        guard
            let fileName = extractName(from: url.absoluteString),
            let valorDir = getCacheDirectory()
        else { return nil }
        let fileURL = valorDir.appendingPathComponent(fileName)
        guard FileManager.default.fileExists(atPath: fileURL.path),
              let image = UIImage(contentsOfFile: fileURL.path)
        else { return nil }
        addImageInCache(
            image: image,
            url: url.absoluteString
        )
        return image
    }
}

// MARK: - Private functions

extension FileManagerService {
    /// Extracts a unique file name from a given URL string.
    /// Example:
    /// "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp"
    /// -> "essence-mascara-lash-princess"
    private func extractName(from url: String) -> String? {
        guard let url = URL(string: url) else { return nil }
        let pathComponents = url.pathComponents
        guard pathComponents.count >= 2 else { return nil }
        let fileName = pathComponents[pathComponents.count - 2]
        return fileName
    }
    
    /// Returns the cache directory URL for storing images under `Consts.dirName`.
    private func getCacheDirectory() -> URL? {
        guard let cacheDir = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first else { return nil }
        let directory = cacheDir.appendingPathComponent(
            Consts.dirName,
            isDirectory: true
        )
        return directory
    }
    
    /// Creates a directory at the specified URL if it does not exist.
    private func createNewFolder(urlDirectory: URL) throws {
        if !FileManager.default.fileExists(atPath: urlDirectory.path) {
            try FileManager.default.createDirectory(
                at: urlDirectory,
                withIntermediateDirectories: true
            )
        }
    }
    
    /// Retrieves an image from memory cache if available.
    private func getImageInCache(url: String) -> UIImage? {
        memoryCache.object(forKey: url as NSString)
    }
    
    /// Adds an image to memory cache for faster subsequent access.
    private func addImageInCache(image: UIImage, url: String) {
        memoryCache.setObject(image, forKey: url as NSString)
    }
}
