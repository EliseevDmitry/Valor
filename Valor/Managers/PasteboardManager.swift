//
//  PasteboardManager.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 22.08.2025.
//

import UIKit

/// Protocol defining the interface for interacting with the clipboard.
/// Provides methods to copy, retrieve, and remove data.
protocol IPasteboardManager {
    func copyID(id: String)
    func showID() -> String?
    func remove()
}

/// Clipboard manager implementing IPasteboardManager.
/// Uses UIPasteboard.general to work with the system-wide iOS clipboard.
final class PasteboardManager: IPasteboardManager {
    private var pasteBoard: UIPasteboard
    
    init(pasteBoard: UIPasteboard = UIPasteboard.general) {
        self.pasteBoard = pasteBoard
    }
}

// MARK: - Public functions

extension PasteboardManager {
    func copyID(id: String) {
        pasteBoard.string = id
    }
    
    func showID() -> String? {
        return pasteBoard.string
    }
    
    func remove() {
        pasteBoard.string = nil
    }
}
