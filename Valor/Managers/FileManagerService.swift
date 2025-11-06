//
//  FileManager.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 05.11.2025.
//

import Foundation
import UIKit

protocol IFileManager {
    func addImage(image: UIImage, url: String) throws
    func getImage(url: URL) -> UIImage?
}

final class FileManagerService{ }

// MARK: - Public functions

extension FileManagerService: IFileManager  {
    
    func addImage(image: UIImage, url: String) throws {
        guard
            let url = URL(string: url),
            let fileName = extractName(from: url.absoluteString)
        else { return }
        
        // Путь к папке Valor в кэше
        guard let cacheDir = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first else { return }
        
        let valorDir = cacheDir.appendingPathComponent("Valor", isDirectory: true)
        
        // Проверяем, существует ли папка "Valor" — если нет, создаём
        if !FileManager.default.fileExists(atPath: valorDir.path) {
            try FileManager.default.createDirectory(
                at: valorDir,
                withIntermediateDirectories: true
            )
        }
        
        // Полный путь к файлу внутри папки Valor
        let fileURL = valorDir.appendingPathComponent(fileName)
        
        // Если файл уже есть — не сохраняем
        guard !FileManager.default.fileExists(atPath: fileURL.path),
              let data = image.jpegData(compressionQuality: 1)
        else { return }
        
        // Сохраняем файл
        try data.write(to: fileURL, options: [.atomic])
    }
    
    
    
    func getImage(url: URL) -> UIImage? {
        guard
            let fileName = extractName(from: url.absoluteString)
        else { return nil }
        
        guard let cacheDir = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first else { return nil }
        
        // Путь к папке Valor
        let valorDir = cacheDir.appendingPathComponent("Valor", isDirectory: true)
        
        // Полный путь к файлу внутри Valor
        let fileURL = valorDir.appendingPathComponent(fileName)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        
        return UIImage(contentsOfFile: fileURL.path)
    }
    
}

// MARK: - Private functions

extension FileManagerService {
    
    /// Получение имени для файла
    /// "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp"
    /// -> "essence-mascara-lash-princess"
    private func extractName(from url: String) -> String? {
        guard let url = URL(string: url) else { return nil }
        let pathComponents = url.pathComponents
        guard pathComponents.count >= 2 else { return nil }
        let fileName = pathComponents[pathComponents.count - 2]
        return fileName
    }
}
