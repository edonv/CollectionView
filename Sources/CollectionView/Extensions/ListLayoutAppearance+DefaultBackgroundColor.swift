//
//  ListLayoutAppearance+DefaultBackgroundColor.swift
//
//
//  Created by Edon Valdman on 10/2/23.
//

import UIKit

extension UICollectionLayoutListConfiguration.Appearance {
    var defaultBackgroundColor: UIColor {
        switch self {
        case .plain, .sidebarPlain:
                .systemBackground
        case .grouped, .insetGrouped, .sidebar:
                .systemGroupedBackground
        @unknown default:
                .systemBackground
        }
    }
}
