//
//  LayoutSection.swift
//
//
//  Created by Edon Valdman on 2/24/24.
//

import SwiftUI

/// A proxy type for [`NSCollectionLayoutSection`](https://developer.apple.com/documentation/uikit/nscollectionlayoutsection).
public struct LayoutSection {
    #if canImport(AppKit)
    /// The scrolling behavior of the layout's sections in relation to the main layout axis.
    ///
    /// For more details, see: [NSCollectionLayoutSectionOrthogonalScrollingBehavior](https://developer.apple.com/documentation/appkit/nscollectionlayoutsectionorthogonalscrollingbehavior)
    public typealias OrthogonalScrollingBehavior = NSCollectionLayoutSectionOrthogonalScrollingBehavior
    #else
    /// The scrolling behavior of the layout's sections in relation to the main layout axis.
    ///
    /// For more details, see: [UICollectionLayoutSectionOrthogonalScrollingBehavior](https://developer.apple.com/documentation/uikit/uicollectionlayoutsectionorthogonalscrollingbehavior)
    public typealias OrthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehavior
    #endif
    
    public let section: NSCollectionLayoutSection
    
    // MARK: - Creating a section
    
    public init(group: @escaping () -> LayoutGroup) {
        self.section = .init(group: group().group)
    }
    
    // MARK: - Specifying scrolling behavior
    
    /// Sets the section's scrolling behavior in relation to the main layout axis.
    ///
    /// For more details, see: [orthogonalScrollingBehavior](https://developer.apple.com/documentation/uikit/nscollectionlayoutsection/3199094-orthogonalscrollingbehavior)
    public func orthogonalScrollingBehavior(_ behavior: OrthogonalScrollingBehavior) -> Self {
        let new = self
        new.section.orthogonalScrollingBehavior = behavior
        return new
    }
    
    /// Can set the section orthogonal scrolling properties.
    ///
    /// For more details, see: [orthogonalScrollingProperties](https://developer.apple.com/documentation/uikit/nscollectionlayoutsection/4134809-orthogonalscrollingproperties)
    @available(iOS 17, macCatalyst 17, tvOS 17, visionOS 1, *)
    public func orthogonalScrollingProperties(
        _ propertiesHandler: (_ properties: UICollectionLayoutSectionOrthogonalScrollingProperties) -> Void
    ) -> Self {
        let new = self
        propertiesHandler(new.section.orthogonalScrollingProperties)
        return new
    }
    
    // MARK: - Configuring section spacing
    
    /// The amount of space between the groups in the section.
    public func interItemSpacing(_ spacing: CGFloat) -> Self {
        let new = self
        new.section.interGroupSpacing = spacing
        return new
    }
    
    /// The amount of space between the content of the section and its boundaries.
    public func contentInsets(_ insets: EdgeInsets) -> Self {
        let new = self
        new.section.contentInsets = .init(insets)
        return new
    }
    
    /// The boundary to reference when defining content insets.
    ///
    /// For more details, see: [contentInsetsReference](https://developer.apple.com/documentation/uikit/nscollectionlayoutitem/3199084-contentinsets)
    @available(iOS 14, macCatalyst 14, tvOS 14, visionOS 1, *)
    public func contentInsetsReference(
        _ insetsHandler: (_ contentInsetsReference: inout UIContentInsetsReference) -> Void
    ) -> Self {
        let new = self
        insetsHandler(&new.section.contentInsetsReference)
        return new
    }
    
    // TODO: supplementary items
    
    // iOS 13-16 use this: https://developer.apple.com/documentation/uikit/nscollectionlayoutsection/3199095-supplementariesfollowcontentinse
    
//    /// The reference boundary for content insets on boundary supplementary items.
//    ///
//    /// For more details, see: [supplementaryContentInsetsReference](https://developer.apple.com/documentation/uikit/nscollectionlayoutsection/3967511-supplementarycontentinsetsrefere)
//    @available(iOS 16, macCatalyst 16, tvOS 16, visionOS 1, *)
//    public func supplementaryContentInsetsReference(
//        _ insetsHandler: (_ supplementaryContentInsetsReference: inout UIContentInsetsReference) -> Void
//    ) -> Self {
//        let new = self
//        insetsHandler(&new.section.supplementaryContentInsetsReference)
//        return new
//    }
    
    // TODO: https://developer.apple.com/documentation/uikit/nscollectionlayoutsection/3199089-boundarysupplementaryitems
    // TODO: https://developer.apple.com/documentation/uikit/nscollectionlayoutsection/3199091-decorationitems
    
    // MARK: - Rendering items
    
    /// The boundary to reference when defining content insets.
    ///
    /// For more details, see: [contentInsetsReference](https://developer.apple.com/documentation/uikit/nscollectionlayoutitem/3199084-contentinsets)
    @available(iOS 14, macCatalyst 14, tvOS 14, visionOS 1, *)
    public func visibleItemsInvalidationHandler(
        _ handler: NSCollectionLayoutSectionVisibleItemsInvalidationHandler?
    ) -> Self {
        let new = self
        new.section.visibleItemsInvalidationHandler = handler
        return new
    }
}
