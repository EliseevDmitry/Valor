//
//  CustomImage.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import Foundation

/// Enum providing a centralized and type-safe way to reference image assets.
/// Images are stored in `Assets.xcassets`, with separate folders for each screen.
/// The case names are designed to be concise and meaningful, while the raw values
/// match the exported names from Figma design files for consistency and ease of maintenance.
enum CustomImage: String {
    //Assets images
    case button = "refreshicon"
    case errorView = "illustration-circle-error"
    case emptyView = "illustration-flashlight-guide"
    case burgerPoints = "morehorizontal"
    //systemImages SF
    case photo = "photo"
    case backButton = "chevron.left"
}
