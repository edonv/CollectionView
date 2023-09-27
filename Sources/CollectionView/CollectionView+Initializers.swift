//
//  CollectionView+Initializers.swift
//
//
//  Created by Edon Valdman on 9/26/23.
//

import SwiftUI

// MARK: - UIHostingConfiguration

@available(iOS 16, macCatalyst 16, tvOS 16, visionOS 1, *)
extension CollectionView {
    public init<Content>(
        collection: Binding<ItemCollection>,
        selection: Binding<Set<Item>>,
        layout: CollectionLayout,
        @ViewBuilder cellContent: @escaping (IndexPath, Item) -> Content,
        cellConfigurationHandler: ((UICollectionViewCell, IndexPath, Item) -> Void)? = nil
    ) where Content: View, ContentConfiguration == UIHostingConfiguration<Content, EmptyView> {
        self.init(collection: collection, selection: selection, layout: layout, contentConfiguration: { indexPath, item in
            UIHostingConfiguration {
                cellContent(indexPath, item)
            }
        }, backgroundConfiguration: nil, cellConfigurationHandler: cellConfigurationHandler)
    }
    
    public init<Content, Background>(
        collection: Binding<ItemCollection>,
        selection: Binding<Set<Item>>,
        layout: CollectionLayout,
        @ViewBuilder cellContent: @escaping (IndexPath, Item) -> Content,
        @ViewBuilder cellBackground: @escaping (IndexPath, Item) -> Background,
        cellConfigurationHandler: ((UICollectionViewCell, IndexPath, Item) -> Void)? = nil
    ) where Content: View, Background: View, ContentConfiguration == UIHostingConfiguration<Content, Background> {
        self.init(collection: collection, selection: selection, layout: layout, contentConfiguration: { indexPath, item in
            UIHostingConfiguration {
                cellContent(indexPath, item)
            }
            .background {
                cellBackground(indexPath, item)
            }
        }, backgroundConfiguration: nil, cellConfigurationHandler: cellConfigurationHandler)
    }
    
    public init<Content, S>(
        collection: Binding<ItemCollection>,
        selection: Binding<Set<Item>>,
        layout: CollectionLayout,
        @ViewBuilder cellContent: @escaping (IndexPath, Item) -> Content,
        cellBackground: S,
        cellConfigurationHandler: ((UICollectionViewCell, IndexPath, Item) -> Void)? = nil
    ) where Content: View, S: ShapeStyle, ContentConfiguration == UIHostingConfiguration<Content, _UIHostingConfigurationBackgroundView<S>> {
        self.init(collection: collection, selection: selection, layout: layout, contentConfiguration: { indexPath, item in
            UIHostingConfiguration {
                cellContent(indexPath, item)
            }
            .background(cellBackground)
        }, backgroundConfiguration: nil, cellConfigurationHandler: cellConfigurationHandler)
    }
}

// MARK: - UICollectionLayoutListConfiguration

extension CollectionView where CollectionLayout == UICollectionViewCompositionalLayout, ContentConfiguration == UIListContentConfiguration {
    public init(
        collection: Binding<ItemCollection>,
        selection: Binding<Set<Item>>,
        listAppearance: UICollectionLayoutListConfiguration.Appearance,
        listConfigurationHandler: ((_ config: inout UICollectionLayoutListConfiguration) -> Void)? = nil,
        contentConfiguration: @escaping (IndexPath, Item) -> ContentConfiguration,
        backgroundConfiguration: ((IndexPath, Item) -> UIBackgroundConfiguration)?,
        cellConfigurationHandler: ((UICollectionViewCell, IndexPath, Item) -> Void)? = nil
    ) {
        var listConfig = UICollectionLayoutListConfiguration(appearance: listAppearance)
        listConfigurationHandler?(&listConfig)
        
        self.init(collection: collection,
                  selection: selection,
                  layout: UICollectionViewCompositionalLayout.list(using: listConfig),
                  contentConfiguration: contentConfiguration,
                  backgroundConfiguration: backgroundConfiguration,
                  cellConfigurationHandler: cellConfigurationHandler)
    }
}
