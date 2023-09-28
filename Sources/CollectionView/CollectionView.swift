//
//  CollectionView.swift
//  
//
//  Created by Edon Valdman on 9/25/23.
//

import SwiftUI
import OrderedCollections

// TODO: add sections
// TODO: make the collectionviewcell

public struct CollectionView<Section, Item, CollectionLayout, ContentConfiguration> 
    where Section: Sendable & Hashable, Item: Sendable & Hashable, CollectionLayout: UICollectionViewLayout, ContentConfiguration: UIContentConfiguration {
    
    public typealias ItemCollection = OrderedDictionary<Section, [Item]>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private var singleSelection: Bool
    private var multipleSelection: Bool
    
    @Binding internal var data: ItemCollection
    @Binding internal var selection: Set<Item>
    internal var layout: CollectionLayout
    internal var contentConfiguration: (IndexPath, Item) -> ContentConfiguration
    internal var backgroundConfiguration: ((IndexPath, Item) -> UIBackgroundConfiguration)?
    internal var cellConfigurationHandler: ((UICollectionViewCell, IndexPath, Item) -> Void)?
    
    /// Standard init, multiple select
    public init(
        collection: Binding<ItemCollection>,
        selection: Binding<Set<Item>>,
        layout: CollectionLayout,
        contentConfiguration: @escaping (IndexPath, Item) -> ContentConfiguration,
        backgroundConfiguration: ((IndexPath, Item) -> UIBackgroundConfiguration)?,
        cellConfigurationHandler: ((UICollectionViewCell, IndexPath, Item) -> Void)? = nil
    ) {
        self._data = collection
        self._selection = selection
        self.singleSelection = true
        self.multipleSelection = true
        self.layout = layout
        self.contentConfiguration = contentConfiguration
        self.backgroundConfiguration = backgroundConfiguration
        self.cellConfigurationHandler = cellConfigurationHandler
    }
    
    /// Standard init, single/no select
    public init(
        collection: Binding<ItemCollection>,
        selection: Binding<Item?>?,
        layout: CollectionLayout,
        contentConfiguration: @escaping (IndexPath, Item) -> ContentConfiguration,
        backgroundConfiguration: ((IndexPath, Item) -> UIBackgroundConfiguration)?,
        cellConfigurationHandler: ((UICollectionViewCell, IndexPath, Item) -> Void)? = nil
    ) {
        self._data = collection
        
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
        
        // Update selected cells
        // TODO: add a check that selection is even enabled
        let newSelectedIndexPaths = selection
            .compactMap { context.coordinator.dataSource.indexPath(for: $0) }
        let currentlySelectedIndexPaths = uiView.indexPathsForSelectedItems
        
        if let diff = currentlySelectedIndexPaths?.difference(from: newSelectedIndexPaths),
           !diff.isEmpty {
            for d in diff {
                switch d {
                case .insert(_, let indexPath, _):
                    uiView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                case .remove(_, let indexPath, _):
                    uiView.deselectItem(at: indexPath, animated: true)
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
            CollectionView(collection: $items,
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
