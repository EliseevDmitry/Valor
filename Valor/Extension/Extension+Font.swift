//
//  Extension+Font.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import SwiftUICore
import UIKit

extension Font {
    static let aBeeZeeRegular = UIFont(name: "ABeeZee-Regular", size: 18) ?? .systemFont(ofSize: 18)
    
    static func titleABeeZeeRegular18() -> Font {
        return Font(aBeeZeeRegular)
    }
    
    static func titleABeeZeeRegular14() -> Font {
        return Font.custom("ABeeZee-Regular", size: 14)
    }

    static func titleSFProRegular18() -> Font {
        return Font.custom("SFProDisplay-Regular", size: 18)
    }
    
    static let titleSFProRegular = UIFont(name: "SFProDisplay-Regular", size: 14) ?? .systemFont(ofSize: 18)
    
    static func titleSFProRegular14() -> Font {
        return Font(titleSFProRegular)
    }
    
    static func titleSFProRegular16() -> Font {
        return Font.custom("SFProDisplay-Regular", size: 16)
    }
 
}
