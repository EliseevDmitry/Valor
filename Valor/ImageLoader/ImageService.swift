//
//  ImageService.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 21.08.2025.
//

//import Foundation
//import Kingfisher
//
///// Centralized configuration for image caching limits and expiration.
//enum ImageCacheConfig {
//    static let diskSizeLimit: UInt = 90 * 1024 * 1024
//    static let memorySizeLimit: Int = 50 * 1024 * 1024
//    static let diskExpirationDays: Int = 3
//}
//
///// Marker protocol for image caching/loading services.
///// Allows dependency injection and easy swapping of implementations.
//protocol IImageService { }
//
///// Service responsible for managing image caching and configuration.
//final class ImageService: IImageService {
//    init() {
//        configure()
//    }
//}
//
//// MARK: - Private functions
//extension ImageService {
//    /// Configures Kingfisher's default image cache with custom limits and expiration.
//    private func configure() {
//        let cache = ImageCache.default
//        cache.diskStorage.config.sizeLimit = ImageCacheConfig.diskSizeLimit
//        cache.memoryStorage.config.totalCostLimit = ImageCacheConfig.memorySizeLimit
//        cache.diskStorage.config.expiration = .days(ImageCacheConfig.diskExpirationDays)
//    }
//}
