//
//  LayoutItem.swift
//  
//
//  Created by Edon Valdman on 2/24/24.
//

import SwiftUI

/// A proxy type for [`NSCollectionLayoutItem`](https://developer.apple.com/documentation/uikit/nscollectionlayoutitem).
public struct LayoutItem {
    public let item: NSCollectionLayoutItem
    
    // MARK: - Creating an item
    
    public init(
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension
    ) {
        self.item = .init(layoutSize: .init(widthDimension: width, heightDimension: height))
    }
    
    /// Creates an array that repeats this item a certain number of times.
    public func repeating(count: Int) -> [LayoutItem] {
        .init(repeating: self, count: count)
    }
    
    // TODO: supplementary items
    
    
    // MARK: - Configuring spacing and insets
    
    /// The amount of space added around the boundaries of the item between other items and this item's container.
    ///
    /// For more details, see: [edgeSpacing](https://developer.apple.com/documentation/uikit/nscollectionlayoutitem/3199085-edgespacing)
    public func edgeSpacing(_ spacing: NSCollectionLayoutEdgeSpacing) -> Self {
        let new = self
        new.item.edgeSpacing = spacing
        return new
    }
    
    /// The amount of space added around the content of the item to adjust its final size after its position is computed.
    ///
    /// For more details, see: [contentInsets](https://developer.apple.com/documentation/uikit/nscollectionlayoutitem/3199084-contentinsets)
    public func contentInsets(_ insets: EdgeInsets) -> Self {
        let new = self
        new.item.contentInsets = .init(insets)
        return new
    }
}
