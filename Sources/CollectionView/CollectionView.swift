//
//  CollectionView.swift
//  
//
//  Created by Edon Valdman on 9/25/23.
//

import SwiftUI

// TODO: add sections
// TODO: make the collectionviewcell

public struct CollectionView<Section, Item, CollectionLayout, ContentConfiguration> 
    where Section: Sendable & Hashable, Item: Sendable & Hashable, CollectionLayout: UICollectionViewLayout, ContentConfiguration: UIContentConfiguration {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    @Binding public var collection: [Section: [Item]]
    @Binding public var selection: Set<Item>
    var layout: CollectionLayout
    var contentConfiguration: (IndexPath, Item) -> ContentConfiguration
    var backgroundConfiguration: ((IndexPath, Item) -> UIBackgroundConfiguration)?
    var cellConfigurationHandler: ((UICollectionViewCell, IndexPath, Item) -> Void)?
    
    init(
        collection: Binding<[Section: [Item]]>,
        selection: Binding<Set<Item>>,
        layout: CollectionLayout,
        contentConfiguration: @escaping (IndexPath, Item) -> ContentConfiguration,
        backgroundConfiguration: ((IndexPath, Item) -> UIBackgroundConfiguration)?,
        cellConfigurationHandler: ((UICollectionViewCell, IndexPath, Item) -> Void)? = nil
    ) {
        self._collection = collection
        self._selection = selection
        self.layout = layout
        self.contentConfiguration = contentConfiguration
        self.backgroundConfiguration = backgroundConfiguration
        self.cellConfigurationHandler = cellConfigurationHandler
    }
}

// MARK: - UIViewRepresentable

extension CollectionView: UIViewRepresentable {
    public func makeUIView(context: Context) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        context.coordinator.setUpCollectionView(collectionView)
        
        collectionView.delegate = context.coordinator
//        collectionView.prefetchDataSource = context.coordinator
        return collectionView
    }
    
    public func updateUIView(_ uiView: UICollectionView, context: Context) {
        // Check if this calls after initial loading
        updateDataSource(context.coordinator)
    }
    
    private func updateDataSource(_ coordinator: Coordinator) {
        if let dataSource = coordinator.dataSource {
            var snapshot: DataSourceSnapshot = .init()
            
            snapshot.appendSections(Array(collection.keys))
            for (section, items) in collection {
                snapshot.appendItems(items, toSection: section)
            }
            
            dataSource.apply(snapshot, animatingDifferences: !dataSource.snapshot().itemIdentifiers.isEmpty)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
