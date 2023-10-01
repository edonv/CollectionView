//
//  CollectionView.swift
//  
//
//  Created by Edon Valdman on 9/25/23.
//

import SwiftUI
import OrderedCollections

public struct CollectionView<Section, Item, Cell, CollectionLayout, ContentConfiguration>
    where Section: Sendable & Hashable, Item: Sendable & Hashable, Cell: UICollectionViewCell, CollectionLayout: UICollectionViewLayout, ContentConfiguration: UIContentConfiguration {
    
    public typealias ItemCollection = OrderedDictionary<Section, [Item]>
    typealias CellRegistration = UICollectionView.CellRegistration<Cell, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private var singleSelection: Bool
    private var multipleSelection: Bool
    
    /// The data for populating the list.
    @Binding internal var data: ItemCollection
    
    /// A binding to a set that represents selected items.
    @Binding internal var selection: Set<Item>
    
    /// The layout object to use for organizing items.
    internal var layout: CollectionLayout
    
    /// A closure for creating a [`UIContentConfiguration`](https://developer.apple.com/documentation/uikit/uicontentconfiguration) for each item's cell.
    internal var contentConfiguration: (IndexPath, Item) -> ContentConfiguration
    
    // MARK: - Standard Init, Multiple Select
    
    /// An optional closure for creating a [`UIBackgroundConfiguration`](https://developer.apple.com/documentation/uikit/uibackgroundconfiguration) for each item's cell.
    internal var backgroundConfiguration: ((IndexPath, Item) -> UIBackgroundConfiguration)?
    /// An optional closure for configuring properties of each item's cell.
    ///
    /// One possible use can be to set the cell's [`configurationUpdateHandler`] (https://developer.apple.com/documentation/uikit/uicollectionviewcell/3751733-configurationupdatehandler) property.
    public private(set) var cellConfigurationHandler: ((Cell, IndexPath, Item) -> Void)?
    
    /// Creates a collection view that allows users to select multiple items.
    ///
    /// If you'd like to allow multiple selection, but don't need to keep track of the selections, use `.constant([])` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a set that represents selected items.
    ///   - layout: The layout object to use for organizing items.
    ///   - cellType: A subclass of `UICollectionViewCell` that the collection view should use. It defaults to `UICollectionViewCell`.
    ///   - contentConfiguration: A closure for creating a [`UIContentConfiguration`](https://developer.apple.com/documentation/uikit/uicontentconfiguration) for each item's cell.
    ///   - backgroundConfiguration: An optional closure for creating a [`UIBackgroundConfiguration`](https://developer.apple.com/documentation/uikit/uibackgroundconfiguration) for each item's cell.
    ///   - cellConfigurationHandler: An optional closure for configuring properties of each item's cell. See more here: ``CollectionView/CollectionView/cellConfigurationHandler``.
    public init(
        _ data: Binding<ItemCollection>,
        selection: Binding<Set<Item>>,
        layout: CollectionLayout,
        cellType: Cell.Type = UICollectionViewCell.self,
        contentConfiguration: @escaping (IndexPath, Item) -> ContentConfiguration,
        backgroundConfiguration: ((IndexPath, Item) -> UIBackgroundConfiguration)?,
        cellConfigurationHandler: ((Cell, IndexPath, Item) -> Void)? = nil
    ) {
        self._data = data
        self._selection = selection
        self.singleSelection = true
        self.multipleSelection = true
        self.layout = layout
        self.contentConfiguration = contentConfiguration
        self.backgroundConfiguration = backgroundConfiguration
        self.cellConfigurationHandler = cellConfigurationHandler
    }
    
    // MARK: - Standard Init, Single/No Select
    
    /// Creates a collection view that optionally allows users to select a single item.
    ///
    /// If you'd like to allow single selection, but don't need to keep track of the selection, use `.constant(nil)` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a selected value, if provided. Otherwise, no selection will be allowed.
    ///   - layout: The layout object to use for organizing items.
    ///   - cellType: A subclass of `UICollectionViewCell` that the collection view should use. It defaults to `UICollectionViewCell`.
    ///   - contentConfiguration: A closure for creating a [`UIContentConfiguration`](https://developer.apple.com/documentation/uikit/uicontentconfiguration) for each item's cell.
    ///   - backgroundConfiguration: An optional closure for creating a [`UIBackgroundConfiguration`](https://developer.apple.com/documentation/uikit/uibackgroundconfiguration) for each item's cell.
    ///   - cellConfigurationHandler: An optional closure for configuring properties of each item's cell. See more here: ``CollectionView/CollectionView/cellConfigurationHandler``.
    public init(
        _ data: Binding<ItemCollection>,
        selection: Binding<Item?>? = nil,
        layout: CollectionLayout,
        cellType: Cell.Type = UICollectionViewCell.self,
        contentConfiguration: @escaping (IndexPath, Item) -> ContentConfiguration,
        backgroundConfiguration: ((IndexPath, Item) -> UIBackgroundConfiguration)?,
        cellConfigurationHandler: ((Cell, IndexPath, Item) -> Void)? = nil
    ) {
        self._data = data
        
        if let selection {
            self._selection = .init(get: {
                if let item = selection.wrappedValue { [item] } else { [] }
            }, set: { selectedItems in
                selection.wrappedValue = selectedItems.first
            })
        } else {
            self._selection = .constant([])
        }
        
        self.singleSelection = selection != nil
        self.multipleSelection = false
        self.layout = layout
        self.contentConfiguration = contentConfiguration
        self.backgroundConfiguration = backgroundConfiguration
        self.cellConfigurationHandler = cellConfigurationHandler
    }
    
    // MARK: - View Modifier Properties
    
    public typealias CollectionViewBoolCallback = (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Bool
    public typealias CollectionViewVoidCallback = (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Void
    
    // Single Selection
    
    internal var shouldSelectItemHandler: CollectionViewBoolCallback? = nil
    internal var shouldDeselectItemHandler: CollectionViewBoolCallback? = nil
    
    // Multiple Selection
    
    internal var shouldBeginMultipleSelectionInteractionHandler: CollectionViewBoolCallback? = nil
    internal var didBeginMultipleSelectionInteractionHandler: CollectionViewVoidCallback? = nil
    internal var didEndMultipleSelectionInteractionHandler: (() -> Void)? = nil
    
    // Highlighting
    
    internal var shouldHighlightItemHandler: CollectionViewBoolCallback? = nil
    internal var didHighlightItemHandler: CollectionViewVoidCallback? = nil
    internal var didUnhighlightItemHandler: CollectionViewVoidCallback? = nil
    
    // Displaying Cells
    
    internal var willDisplayCellHandler: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)? = nil
    internal var didEndDisplayingCellHandler: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)? = nil
    
    // Context Menu
    
    internal var willDisplayContextMenu: ((_ configuration: UIContextMenuConfiguration, UIContextMenuInteractionAnimating?) -> Void)? = nil
    internal var willEndContextMenuInteraction: ((_ configuration: UIContextMenuConfiguration, UIContextMenuInteractionAnimating?) -> Void)? = nil
    internal var willPerformPreviewAction: ((_ configuration: UIContextMenuConfiguration, UIContextMenuInteractionAnimating?) -> Void)? = nil
    internal var contextMenuConfigHandler: ((_ indexPaths: [IndexPath], _ point: CGPoint) -> UIContextMenuConfiguration?)? = nil
    
    // Prefetch
    
    internal var prefetchItemsHandler: ((_ indexPaths: [IndexPath]) -> Void)? = nil
    internal var cancelPrefetchingHandler: ((_ indexPaths: [IndexPath]) -> Void)? = nil
}

// MARK: - UIViewRepresentable

extension CollectionView: UIViewRepresentable {
    public func makeUIView(context: Context) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        context.coordinator.setUpCollectionView(collectionView)
        
        collectionView.delegate = context.coordinator
        collectionView.prefetchDataSource = context.coordinator
        collectionView.allowsSelection = singleSelection
        collectionView.allowsMultipleSelection = multipleSelection
        
        return collectionView
    }
    
    public func updateUIView(_ uiView: UICollectionView, context: Context) {
        // Check if this calls after initial loading
        updateDataSource(context.coordinator)
        
        // Update selected cells (if selection is enabled)
        if singleSelection || multipleSelection {
            let newSelectedIndexPaths = Set(selection
                .compactMap { context.coordinator.dataSource.indexPath(for: $0) })
            let currentlySelectedIndexPaths = Set(uiView.indexPathsForSelectedItems ?? [])
            
            if newSelectedIndexPaths != currentlySelectedIndexPaths {
                let removed = currentlySelectedIndexPaths.subtracting(newSelectedIndexPaths)
                removed.forEach {
                    uiView.deselectItem(at: $0, animated: true)
                }
                
                let added = newSelectedIndexPaths.subtracting(currentlySelectedIndexPaths)
                added.forEach {
                    uiView.selectItem(at: $0, animated: true, scrollPosition: .centeredVertically)
                }
            }
        }
    }
    
    private func updateDataSource(_ coordinator: Coordinator) {
        if let dataSource = coordinator.dataSource {
            var snapshot: DataSourceSnapshot = .init()
            
            snapshot.appendSections(Array(data.keys))
            for (section, items) in data {
                snapshot.appendItems(items, toSection: section)
            }
            
            // Animate if there were already items added.
            dataSource.apply(snapshot, animatingDifferences: !dataSource.snapshot().itemIdentifiers.isEmpty)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

private struct TestView: View {
    enum Sections: Hashable {
        case main
    }
    
    @State
    var items: OrderedDictionary = [Sections.main: ["String 1", "String 2", "String 3", "String 4"]]
    
    var body: some View {
        NavigationView {
            CollectionView($items,
                           selection: .constant([]),
                           listAppearance: .sidebar,
                           listConfigurationHandler: { config in
                config.headerMode = .firstItemInSection
            },
                           contentConfiguration: { indexPath, string in
                
                if indexPath.item > 0 {
                    var config = UIListContentConfiguration.sidebarCell()
                    config.image = UIImage(systemName: "speaker.wave.3.fill")
                    config.imageProperties.cornerRadius = 40
                    config.text = string
                    config.secondaryText = string
                    return config
                } else {
                    var config = UIListContentConfiguration.sidebarHeader()
                    config.text = string
                    return config
                }
            }, backgroundConfiguration: { indexPath, _ in
                if indexPath.item > 0 {
                    .listSidebarCell()
                } else {
                    .listGroupedHeaderFooter()
                }
            }, cellConfigurationHandler: { cell, _, _ in
                
            })
            .ignoresSafeArea()
            .navigationTitle("Test")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Test") {
                        items[.main]?.append("Test \(items[.main]?.count ?? 0)")
                    }
                }
            }
        }
    }
}

#Preview("SwiftUI") {
    TestView()
}
