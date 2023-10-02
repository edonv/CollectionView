//
//  CollectionView+Initializers.swift
//
//
//  Created by Edon Valdman on 9/26/23.
//

import SwiftUI

// MARK: - UIHostingConfiguration

@available(iOS 16, macCatalyst 16, tvOS 16, visionOS 1, *)
extension CollectionView where Cell == UICollectionViewCell {
    // MARK: - SwiftUI Cell, No Background, Multiple Select
    
    /// Creates a collection view that computes its cells using a SwiftUI view, also allowing users to select multiple items.
    ///
    /// - Note: If you'd like to allow multiple selection, but don't need to keep track of the selections, use `.constant([])` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a set that represents selected items.
    ///   - layout: The layout object to use for organizing items.
    ///   - cellContent: A view builder that creates the view for a single cell in the collection view. If using a list layout, it's possible to use [`.swipeActions`](https://developer.apple.com/documentation/swiftui/view/swipeactions(edge:allowsfullswipe:content:)) on the content of this closure and it'll be bridged automatically.
    ///   - cellConfigurationHandler: An optional closure for configuring properties of each item's cell. See more here: ``CollectionView/CollectionView/cellConfigurationHandler``.
    public init<Content>(
        _ data: Binding<ItemCollection>,
        selection: Binding<Set<Item>>,
        layout: CollectionLayout,
        @ViewBuilder cellContent: @escaping (IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Content,
        cellConfigurationHandler: ((Cell, IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Void)? = nil
    ) where Content: View {
        self.init(data, 
                  selection: selection,
                  layout: layout) { cell, indexPath, item in
            cell.configurationUpdateHandler = { cell, state in
                cell.contentConfiguration = UIHostingConfiguration {
                    cellContent(indexPath, state, item)
                }
                cellConfigurationHandler?(cell, indexPath, state, item)
            }
        }
    }
    
    // MARK: - SwiftUI Cell, No Background, Single/No Select
    
    /// Creates a collection view that computes its cells using a SwiftUI view, optionally allowing users to select a single item.
    ///  
    /// - Note: If you'd like to allow single selection, but don't need to keep track of the selection, use `.constant(nil)` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a selected value, if provided. Otherwise, no selection will be allowed.
    ///   - layout: The layout object to use for organizing items.
    ///   - cellContent: A view builder that creates the view for a single cell in the collection view. If using a list layout, it's possible to use [`.swipeActions`](https://developer.apple.com/documentation/swiftui/view/swipeactions(edge:allowsfullswipe:content:)) on the content of this closure and it'll be bridged automatically.
    ///   - cellConfigurationHandler: An optional closure for configuring properties of each item's cell. See more here: ``CollectionView/CollectionView/cellConfigurationHandler``.
    public init<Content>(
        _ data: Binding<ItemCollection>,
        selection: Binding<Item?>? = nil,
        layout: CollectionLayout,
        @ViewBuilder cellContent: @escaping (IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Content,
        cellConfigurationHandler: ((Cell, IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Void)? = nil
    ) where Content: View {
        self.init(data, 
                  selection: selection,
                  layout: layout) { cell, indexPath, item in
            cell.configurationUpdateHandler = { cell, state in
                cell.contentConfiguration = UIHostingConfiguration {
                    cellContent(indexPath, state, item)
                }
                cellConfigurationHandler?(cell, indexPath, state, item)
            }
        }
    }
    
    // MARK: - SwiftUI Cell, Custom View Background, Multiple Select
    
    /// Creates a collection view that computes its cells and their backgrounds using SwiftUI views, also allowing users to select multiple items.
    ///
    /// - Note: If you'd like to allow multiple selection, but don't need to keep track of the selections, use `.constant([])` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a set that represents selected items.
    ///   - layout: The layout object to use for organizing items.
    ///   - cellContent: A view builder that creates the view for a single cell in the collection view. If using a list layout, it's possible to use [`.swipeActions`](https://developer.apple.com/documentation/swiftui/view/swipeactions(edge:allowsfullswipe:content:)) on the content of this closure and it'll be bridged automatically.
    ///   - cellBackground: The contents of the SwiftUI hierarchy to be shown inside the background of the cell.
    ///   - cellConfigurationHandler: An optional closure for configuring properties of each item's cell. See more here: ``CollectionView/CollectionView/cellConfigurationHandler``.
    public init<Content, Background>(
        _ data: Binding<ItemCollection>,
        selection: Binding<Set<Item>>,
        layout: CollectionLayout,
        @ViewBuilder cellContent: @escaping (IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Content,
        @ViewBuilder cellBackground: @escaping (IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Background,
        cellConfigurationHandler: ((Cell, IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Void)? = nil
    ) where Content: View, Background: View {
        self.init(data, 
                  selection: selection,
                  layout: layout) { cell, indexPath, item in
            cell.configurationUpdateHandler = { cell, state in
                cell.contentConfiguration = UIHostingConfiguration {
                    cellContent(indexPath, state, item)
                }
                .background {
                    cellBackground(indexPath, state, item)
                }
                cellConfigurationHandler?(cell, indexPath, state, item)
            }
        }
    }
    
    // MARK: - SwiftUI Cell, Custom View Background, Single/No Select
    
    /// Creates a collection view that computes its cells and their backgrounds using SwiftUI views, optionally allowing users to select a single item.
    ///
    /// - Note: If you'd like to allow single selection, but don't need to keep track of the selection, use `.constant(nil)` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a selected value, if provided. Otherwise, no selection will be allowed.
    ///   - layout: The layout object to use for organizing items.
    ///   - cellContent: A view builder that creates the view for a single cell in the collection view. If using a list layout, it's possible to use [`.swipeActions`](https://developer.apple.com/documentation/swiftui/view/swipeactions(edge:allowsfullswipe:content:)) on the content of this closure and it'll be bridged automatically.
    ///   - cellBackground: The contents of the SwiftUI hierarchy to be shown inside the background of the cell.
    ///   - cellConfigurationHandler: An optional closure for configuring properties of each item's cell. See more here: ``CollectionView/CollectionView/cellConfigurationHandler``.
    public init<Content, Background>(
        _ data: Binding<ItemCollection>,
        selection: Binding<Item?>? = nil,
        layout: CollectionLayout,
        @ViewBuilder cellContent: @escaping (IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Content,
        @ViewBuilder cellBackground: @escaping (IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Background,
        cellConfigurationHandler: ((Cell, IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Void)? = nil
    ) where Content: View, Background: View {
        self.init(data, 
                  selection: selection,
                  layout: layout) { cell, indexPath, item in
            cell.configurationUpdateHandler = { cell, state in
                cell.contentConfiguration = UIHostingConfiguration {
                    cellContent(indexPath, state, item)
                }
                .background {
                    cellBackground(indexPath, state, item)
                }
                cellConfigurationHandler?(cell, indexPath, state, item)
            }
        }
    }
    
    // MARK: - SwiftUI Cell, ShapeStyle Background, Multiple Select
    
    /// Creates a collection view that computes its cells using SwiftUI views (and their backgrounds from a shape style), also allowing users to select multiple items.
    ///
    /// - Note: If you'd like to allow multiple selection, but don't need to keep track of the selections, use `.constant([])` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a set that represents selected items.
    ///   - layout: The layout object to use for organizing items.
    ///   - cellBackground: The shape style to be used as the background of the cell.
    ///   - cellContent: A view builder that creates the view for a single cell in the collection view. If using a list layout, it's possible to use [`.swipeActions`](https://developer.apple.com/documentation/swiftui/view/swipeactions(edge:allowsfullswipe:content:)) on the content of this closure and it'll be bridged automatically.
    ///   - cellConfigurationHandler: An optional closure for configuring properties of each item's cell. See more here: ``CollectionView/CollectionView/cellConfigurationHandler``.
    public init<Content, S>(
        _ data: Binding<ItemCollection>,
        selection: Binding<Set<Item>>,
        layout: CollectionLayout,
        cellBackground: S,
        @ViewBuilder cellContent: @escaping (IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Content,
        cellConfigurationHandler: ((Cell, IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Void)? = nil
    ) where Content: View, S: ShapeStyle {
        self.init(data,
                  selection: selection,
                  layout: layout) { cell, indexPath, item in
            cell.configurationUpdateHandler = { cell, state in
                cell.contentConfiguration = UIHostingConfiguration {
                    cellContent(indexPath, state, item)
                }
                .background(cellBackground)
                cellConfigurationHandler?(cell, indexPath, state, item)
            }
        }
    }
    
    // MARK: - SwiftUI Cell, ShapeStyle Background, Single/No Select
    
    /// Creates a collection view that computes its cells using SwiftUI views (and their backgrounds from a shape style), optionally allowing users to select a single item.
    ///
    /// - Note: If you'd like to allow single selection, but don't need to keep track of the selection, use `.constant(nil)` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a selected value, if provided. Otherwise, no selection will be allowed.
    ///   - layout: The layout object to use for organizing items.
    ///   - cellBackground: The shape style to be used as the background of the cell.
    ///   - cellContent: A view builder that creates the view for a single cell in the collection view. If using a list layout, it's possible to use [`.swipeActions`](https://developer.apple.com/documentation/swiftui/view/swipeactions(edge:allowsfullswipe:content:)) on the content of this closure and it'll be bridged automatically.
    ///   - cellConfigurationHandler: An optional closure for configuring properties of each item's cell. See more here: ``CollectionView/CollectionView/cellConfigurationHandler``.
    public init<Content, S>(
        _ data: Binding<ItemCollection>,
        selection: Binding<Item?>? = nil,
        layout: CollectionLayout,
        cellBackground: S,
        @ViewBuilder cellContent: @escaping (IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Content,
        cellConfigurationHandler: ((Cell, IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Void)? = nil
    ) where Content: View, S: ShapeStyle {
        self.init(data,
                  selection: selection,
                  layout: layout) { cell, indexPath, item in
            cell.configurationUpdateHandler = { cell, state in
                cell.contentConfiguration = UIHostingConfiguration {
                    cellContent(indexPath, state, item)
                }
                .background(cellBackground)
                cellConfigurationHandler?(cell, indexPath, state, item)
            }
        }
    }
}

// MARK: - UICollectionLayoutListConfiguration

extension CollectionView where CollectionLayout == UICollectionViewCompositionalLayout, Cell == UICollectionViewListCell {
    
    // MARK: - List Layout, List Cell, Multiple Select
    
    /// Creates a collection view with a list layout that allows users to select multiple items.
    ///
    /// If you'd like to allow multiple selection, but don't need to keep track of the selections, use `.constant([])` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a set that represents selected items.
    ///   - cellType: A subclass of `UICollectionViewCell` that the collection view should use. It defaults to [`UICollectionViewListCell`](https://developer.apple.com/documentation/uikit/uicollectionviewlistcell).
    ///   - listAppearance: The overall appearance of the list.
    ///   - listConfigurationHandler: A closure for configuring the `UICollectionLayoutListConfiguration` of the layout.
    ///   - contentConfiguration: A closure for creating a [`UIContentConfiguration`](https://developer.apple.com/documentation/uikit/uicontentconfiguration) for each item's cell.
    ///   - backgroundConfiguration: An optional closure for creating a [`UIBackgroundConfiguration`](https://developer.apple.com/documentation/uikit/uibackgroundconfiguration) for each item's cell.
    ///   - cellConfigurationHandler: An optional closure for configuring properties of each item's cell. See more here: ``CollectionView/CollectionView/cellConfigurationHandler``.
    public init(
        _ data: Binding<ItemCollection>,
        selection: Binding<Set<Item>>,
//        cellType: Cell.Type = UICollectionViewListCell.self,
        listAppearance: UICollectionLayoutListConfiguration.Appearance,
        listConfigurationHandler: ((_ config: inout UICollectionLayoutListConfiguration) -> Void)? = nil,
        contentConfiguration: @escaping (IndexPath, _ item: Item) -> UIListContentConfiguration,
        backgroundConfiguration: ((IndexPath, _ item: Item) -> UIBackgroundConfiguration)?,
        cellConfigurationHandler: ((Cell, IndexPath, _ item: Item) -> Void)? = nil
    ) {
        var listConfig = UICollectionLayoutListConfiguration(appearance: listAppearance)
        listConfigurationHandler?(&listConfig)
        
        self.init(data,
                  selection: selection,
                  layout: UICollectionViewCompositionalLayout.list(using: listConfig)) { cell, indexPath, item in
            cell.contentConfiguration = contentConfiguration(indexPath, item)
            cell.backgroundConfiguration = backgroundConfiguration?(indexPath, item)
            cellConfigurationHandler?(cell, indexPath, item)
        }
//                  cellType: cellType.self,
//                  contentConfiguration: contentConfiguration,
//                  backgroundConfiguration: backgroundConfiguration,
//                  cellConfigurationHandler: cellConfigurationHandler)
    }
    
    // MARK: - List Layout, List Cell, Single/No Select
    
    /// Creates a collection view with a list layout that optionally allows users to select a single item.
    ///
    /// If you'd like to allow single selection, but don't need to keep track of the selection, use `.constant(nil)` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a selected value, if provided. Otherwise, no selection will be allowed.
    ///   - cellType: A subclass of `UICollectionViewCell` that the collection view should use. It defaults to [`UICollectionViewListCell`](https://developer.apple.com/documentation/uikit/uicollectionviewlistcell).
    ///   - listAppearance: The overall appearance of the list.
    ///   - listConfigurationHandler: A closure for configuring the `UICollectionLayoutListConfiguration` of the layout.
    ///   - contentConfiguration: A closure for creating a [`UIContentConfiguration`](https://developer.apple.com/documentation/uikit/uicontentconfiguration) for each item's cell.
    ///   - backgroundConfiguration: An optional closure for creating a [`UIBackgroundConfiguration`](https://developer.apple.com/documentation/uikit/uibackgroundconfiguration) for each item's cell.
    ///   - cellConfigurationHandler: An optional closure for configuring properties of each item's cell. See more here: ``CollectionView/CollectionView/cellConfigurationHandler``.
    public init(
        _ data: Binding<ItemCollection>,
        selection: Binding<Item?>? = nil,
//        cellType: Cell.Type = UICollectionViewListCell.self,
        listAppearance: UICollectionLayoutListConfiguration.Appearance,
        listConfigurationHandler: ((_ config: inout UICollectionLayoutListConfiguration) -> Void)? = nil,
        contentConfiguration: @escaping (IndexPath, _ item: Item) -> UIListContentConfiguration,
        backgroundConfiguration: ((IndexPath, _ item: Item) -> UIBackgroundConfiguration)?,
        cellConfigurationHandler: ((Cell, IndexPath, _ item: Item) -> Void)? = nil
    ) {
        var listConfig = UICollectionLayoutListConfiguration(appearance: listAppearance)
        listConfigurationHandler?(&listConfig)
        
        self.init(data,
                  selection: selection,
                  layout: UICollectionViewCompositionalLayout.list(using: listConfig)) { cell, indexPath, item in
            cell.contentConfiguration = contentConfiguration(indexPath, item)
            cell.backgroundConfiguration = backgroundConfiguration?(indexPath, item)
            cellConfigurationHandler?(cell, indexPath, item)
        }
                  
//                  cellType: cellType.self,
//                  contentConfiguration: contentConfiguration,
//                  backgroundConfiguration: backgroundConfiguration,
//                  cellConfigurationHandler: cellConfigurationHandler)
    }
}
