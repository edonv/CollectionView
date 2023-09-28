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
    /// Creates a collection view that computes its cells using a SwiftUI view, also allowing users to select multiple items.
    ///
    /// If you'd like to allow multiple selection, but don't need to keep track of the selections, use `.constant([])` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a set that represents selected items.
    ///   - layout: The layout object to use for organizing items.
    ///   - cellContent: A view builder that creates the view for a single cell in the collection view.
    ///   - cellConfigurationHandler: An optional closure for configuring properties of each item's cell. See more here: ``CollectionView/CollectionView/cellConfigurationHandler``.
    public init<Content>(
        _ data: Binding<ItemCollection>,
        selection: Binding<Set<Item>>,
        layout: CollectionLayout,
        @ViewBuilder cellContent: @escaping (IndexPath, Item) -> Content,
        cellConfigurationHandler: ((UICollectionViewCell, IndexPath, Item) -> Void)? = nil
    ) where Content: View, ContentConfiguration == UIHostingConfiguration<Content, EmptyView> {
        self.init(data, selection: selection, layout: layout, contentConfiguration: { indexPath, item in
            UIHostingConfiguration {
                cellContent(indexPath, item)
            }
        }, backgroundConfiguration: nil, cellConfigurationHandler: cellConfigurationHandler)
    }
    
    /// Creates a collection view that computes its cells using a SwiftUI view, optionally allowing users to select a single item.
    ///
    /// If you'd like to allow single selection, but don't need to keep track of the selection, use `.constant(nil)` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a selected value, if provided. Otherwise, no selection will be allowed.
    ///   - layout: The layout object to use for organizing items.
    ///   - cellContent: A view builder that creates the view for a single cell in the collection view.
    ///   - cellConfigurationHandler: An optional closure for configuring properties of each item's cell. See more here: ``CollectionView/CollectionView/cellConfigurationHandler``.
    public init<Content>(
        _ data: Binding<ItemCollection>,
        selection: Binding<Item?>? = nil,
        layout: CollectionLayout,
        @ViewBuilder cellContent: @escaping (IndexPath, Item) -> Content,
        cellConfigurationHandler: ((UICollectionViewCell, IndexPath, Item) -> Void)? = nil
    ) where Content: View, ContentConfiguration == UIHostingConfiguration<Content, EmptyView> {
        self.init(data, selection: selection, layout: layout, contentConfiguration: { indexPath, item in
            UIHostingConfiguration {
                cellContent(indexPath, item)
            }
        }, backgroundConfiguration: nil, cellConfigurationHandler: cellConfigurationHandler)
    }
    
    /// Creates a collection view that computes its cells and their backgrounds using SwiftUI views, also allowing users to select multiple items.
    ///
    /// If you'd like to allow multiple selection, but don't need to keep track of the selections, use `.constant([])` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a set that represents selected items.
    ///   - layout: The layout object to use for organizing items.
    ///   - cellContent: A view builder that creates the view for a single cell in the collection view.
    ///   - cellBackground: The contents of the SwiftUI hierarchy to be shown inside the background of the cell.
    ///   - cellConfigurationHandler: An optional closure for configuring properties of each item's cell. See more here: ``CollectionView/CollectionView/cellConfigurationHandler``.
    public init<Content, Background>(
        _ data: Binding<ItemCollection>,
        selection: Binding<Set<Item>>,
        layout: CollectionLayout,
        @ViewBuilder cellContent: @escaping (IndexPath, Item) -> Content,
        @ViewBuilder cellBackground: @escaping (IndexPath, Item) -> Background,
        cellConfigurationHandler: ((UICollectionViewCell, IndexPath, Item) -> Void)? = nil
    ) where Content: View, Background: View, ContentConfiguration == UIHostingConfiguration<Content, Background> {
        self.init(data, selection: selection, layout: layout, contentConfiguration: { indexPath, item in
            UIHostingConfiguration {
                cellContent(indexPath, item)
            }
            .background {
                cellBackground(indexPath, item)
            }
        }, backgroundConfiguration: nil, cellConfigurationHandler: cellConfigurationHandler)
    }
    
    /// Creates a collection view that computes its cells and their backgrounds using SwiftUI views, optionally allowing users to select a single item.
    ///
    /// If you'd like to allow single selection, but don't need to keep track of the selection, use `.constant(nil)` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a selected value, if provided. Otherwise, no selection will be allowed.
    ///   - layout: The layout object to use for organizing items.
    ///   - cellContent: A view builder that creates the view for a single cell in the collection view.
    ///   - cellBackground: The contents of the SwiftUI hierarchy to be shown inside the background of the cell.
    ///   - cellConfigurationHandler: An optional closure for configuring properties of each item's cell. See more here: ``CollectionView/CollectionView/cellConfigurationHandler``.
    public init<Content, Background>(
        _ data: Binding<ItemCollection>,
        selection: Binding<Item?>? = nil,
        layout: CollectionLayout,
        @ViewBuilder cellContent: @escaping (IndexPath, Item) -> Content,
        @ViewBuilder cellBackground: @escaping (IndexPath, Item) -> Background,
        cellConfigurationHandler: ((UICollectionViewCell, IndexPath, Item) -> Void)? = nil
    ) where Content: View, Background: View, ContentConfiguration == UIHostingConfiguration<Content, Background> {
        self.init(data, selection: selection, layout: layout, contentConfiguration: { indexPath, item in
            UIHostingConfiguration {
                cellContent(indexPath, item)
            }
            .background {
                cellBackground(indexPath, item)
            }
        }, backgroundConfiguration: nil, cellConfigurationHandler: cellConfigurationHandler)
    }
    
    /// Creates a collection view that computes its cells using SwiftUI views (and their backgrounds from a shape style), also allowing users to select multiple items.
    ///
    /// If you'd like to allow multiple selection, but don't need to keep track of the selections, use `.constant([])` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a set that represents selected items.
    ///   - layout: The layout object to use for organizing items.
    ///   - cellContent: A view builder that creates the view for a single cell in the collection view.
    ///   - cellBackground: The shape style to be used as the background of the cell.
    ///   - cellConfigurationHandler: An optional closure for configuring properties of each item's cell. See more here: ``CollectionView/CollectionView/cellConfigurationHandler``.
    public init<Content, S>(
        _ data: Binding<ItemCollection>,
        selection: Binding<Set<Item>>,
        layout: CollectionLayout,
        @ViewBuilder cellContent: @escaping (IndexPath, Item) -> Content,
        cellBackground: S,
        cellConfigurationHandler: ((UICollectionViewCell, IndexPath, Item) -> Void)? = nil
    ) where Content: View, S: ShapeStyle, ContentConfiguration == UIHostingConfiguration<Content, _UIHostingConfigurationBackgroundView<S>> {
        self.init(data, selection: selection, layout: layout, contentConfiguration: { indexPath, item in
            UIHostingConfiguration {
                cellContent(indexPath, item)
            }
            .background(cellBackground)
        }, backgroundConfiguration: nil, cellConfigurationHandler: cellConfigurationHandler)
    }
    
    /// Creates a collection view that computes its cells using SwiftUI views (and their backgrounds from a shape style), optionally allowing users to select a single item.
    ///
    /// If you'd like to allow single selection, but don't need to keep track of the selection, use `.constant(nil)` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a selected value, if provided. Otherwise, no selection will be allowed.
    ///   - layout: The layout object to use for organizing items.
    ///   - cellContent: A view builder that creates the view for a single cell in the collection view.
    ///   - cellBackground: The shape style to be used as the background of the cell.
    ///   - cellConfigurationHandler: An optional closure for configuring properties of each item's cell. See more here: ``CollectionView/CollectionView/cellConfigurationHandler``.
    public init<Content, S>(
        _ data: Binding<ItemCollection>,
        selection: Binding<Item?>? = nil,
        layout: CollectionLayout,
        @ViewBuilder cellContent: @escaping (IndexPath, Item) -> Content,
        cellBackground: S,
        cellConfigurationHandler: ((UICollectionViewCell, IndexPath, Item) -> Void)? = nil
    ) where Content: View, S: ShapeStyle, ContentConfiguration == UIHostingConfiguration<Content, _UIHostingConfigurationBackgroundView<S>> {
        self.init(data, selection: selection, layout: layout, contentConfiguration: { indexPath, item in
            UIHostingConfiguration {
                cellContent(indexPath, item)
            }
            .background(cellBackground)
        }, backgroundConfiguration: nil, cellConfigurationHandler: cellConfigurationHandler)
    }
}

// MARK: - UICollectionLayoutListConfiguration

extension CollectionView where CollectionLayout == UICollectionViewCompositionalLayout, ContentConfiguration == UIListContentConfiguration {
    /// Creates a collection view with a list layout that allows users to select multiple items.
    ///
    /// If you'd like to allow multiple selection, but don't need to keep track of the selections, use `.constant([])` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a set that represents selected items.
    ///   - listAppearance: The overall appearance of the list.
    ///   - listConfigurationHandler: A closure for configuring the `UICollectionLayoutListConfiguration` of the layout.
    ///   - contentConfiguration: A closure for creating a [`UIContentConfiguration`](https://developer.apple.com/documentation/uikit/uicontentconfiguration) for each item's cell.
    ///   - backgroundConfiguration: An optional closure for creating a [`UIBackgroundConfiguration`](https://developer.apple.com/documentation/uikit/uibackgroundconfiguration) for each item's cell.
    ///   - cellConfigurationHandler: An optional closure for configuring properties of each item's cell. See more here: ``CollectionView/CollectionView/cellConfigurationHandler``.
    public init(
        _ data: Binding<ItemCollection>,
        selection: Binding<Set<Item>>,
        listAppearance: UICollectionLayoutListConfiguration.Appearance,
        listConfigurationHandler: ((_ config: inout UICollectionLayoutListConfiguration) -> Void)? = nil,
        contentConfiguration: @escaping (IndexPath, Item) -> ContentConfiguration,
        backgroundConfiguration: ((IndexPath, Item) -> UIBackgroundConfiguration)?,
        cellConfigurationHandler: ((UICollectionViewCell, IndexPath, Item) -> Void)? = nil
    ) {
        var listConfig = UICollectionLayoutListConfiguration(appearance: listAppearance)
        listConfigurationHandler?(&listConfig)
        
        self.init(data,
                  selection: selection,
                  layout: UICollectionViewCompositionalLayout.list(using: listConfig),
                  contentConfiguration: contentConfiguration,
                  backgroundConfiguration: backgroundConfiguration,
                  cellConfigurationHandler: cellConfigurationHandler)
    }
    
    /// Creates a collection view with a list layout that optionally allows users to select a single item.
    ///
    /// If you'd like to allow single selection, but don't need to keep track of the selection, use `.constant(nil)` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a selected value, if provided. Otherwise, no selection will be allowed.
    ///   - listAppearance: The overall appearance of the list.
    ///   - listConfigurationHandler: A closure for configuring the `UICollectionLayoutListConfiguration` of the layout.
    ///   - contentConfiguration: A closure for creating a [`UIContentConfiguration`](https://developer.apple.com/documentation/uikit/uicontentconfiguration) for each item's cell.
    ///   - backgroundConfiguration: An optional closure for creating a [`UIBackgroundConfiguration`](https://developer.apple.com/documentation/uikit/uibackgroundconfiguration) for each item's cell.
    ///   - cellConfigurationHandler: An optional closure for configuring properties of each item's cell. See more here: ``CollectionView/CollectionView/cellConfigurationHandler``.
    public init(
        _ data: Binding<ItemCollection>,
        selection: Binding<Item?>? = nil,
        listAppearance: UICollectionLayoutListConfiguration.Appearance,
        listConfigurationHandler: ((_ config: inout UICollectionLayoutListConfiguration) -> Void)? = nil,
        contentConfiguration: @escaping (IndexPath, Item) -> ContentConfiguration,
        backgroundConfiguration: ((IndexPath, Item) -> UIBackgroundConfiguration)?,
        cellConfigurationHandler: ((UICollectionViewCell, IndexPath, Item) -> Void)? = nil
    ) {
        var listConfig = UICollectionLayoutListConfiguration(appearance: listAppearance)
        listConfigurationHandler?(&listConfig)
        
        self.init(data,
                  selection: selection,
                  layout: UICollectionViewCompositionalLayout.list(using: listConfig),
                  contentConfiguration: contentConfiguration,
                  backgroundConfiguration: backgroundConfiguration,
                  cellConfigurationHandler: cellConfigurationHandler)
    }
}
