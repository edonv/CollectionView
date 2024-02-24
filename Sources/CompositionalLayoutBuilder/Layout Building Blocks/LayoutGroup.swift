//
//  LayoutGroup.swift
//
//
//  Created by Edon Valdman on 2/24/24.
//

import SwiftUI

/// A proxy type for [`NSCollectionLayoutGroup`](https://developer.apple.com/documentation/uikit/nscollectionlayoutgroup).
public struct LayoutGroup {
    public let group: NSCollectionLayoutGroup
    
    public init(
        _ axis: Axis,
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension,
        @CollectionLayoutGroupBuilder builder: () -> [NSCollectionLayoutItem]
    ) {
        switch axis {
        case .horizontal:
            self.group = .horizontal(layoutSize: .init(widthDimension: width, heightDimension: height),
                                     subitems: builder())
        case .vertical:
            self.group = .vertical(layoutSize: .init(widthDimension: width, heightDimension: height),
                                   subitems: builder())
        }
    }
    
    public init(
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension,
        customItemProvider itemProvider: @escaping NSCollectionLayoutGroupCustomItemProvider
    ) {
        self.group = .custom(layoutSize: .init(widthDimension: width, heightDimension: height),
                             itemProvider: itemProvider)
    }
    
    /// Returns a string with an ASCII representation of the group.
    public func visualDescription() -> String {
        group.visualDescription()
    }
    
    /// Sets the amount of space between the items in the group.
    public func interItemSpacing(_ spacing: NSCollectionLayoutSpacing) -> Self {
        let new = self
        new.group.interItemSpacing = spacing
        return new
    }
    
    // MARK: - Configuring spacing and insets
    
    /// Sets the amount of space added around the boundaries of the item between other items and this item's container.
    ///
    /// For more details, see: [edgeSpacing](https://developer.apple.com/documentation/uikit/nscollectionlayoutitem/3199085-edgespacing)
    public func edgeSpacing(_ spacing: NSCollectionLayoutEdgeSpacing) -> Self {
        let new = self
        new.group.edgeSpacing = spacing
        return new
    }
    
    /// The amount of space added around the content of the item to adjust its final size after its position is computed.
    ///
    /// For more details, see: [contentInsets](https://developer.apple.com/documentation/uikit/nscollectionlayoutitem/3199084-contentinsets)
    public func contentInsets(_ insets: EdgeInsets) -> Self {
        let new = self
        new.group.contentInsets = .init(insets)
        return new
    }
}
