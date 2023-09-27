//
//  CollectionView+Coordinator.swift
//  
//
//  Created by Edon Valdman on 9/26/23.
//

import UIKit

extension CollectionView {
    public class Coordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
        var parent: CollectionView
        var dataSource: DataSource!
        
        init(_ parent: CollectionView) {
            self.parent = parent
        }
        
        func setUpCollectionView(_ collectionView: UICollectionView) {
            let contentConfiguration = parent.contentConfiguration
            let backgroundConfiguration = parent.backgroundConfiguration
            let cellConfigurationHandler = parent.cellConfigurationHandler
            
            let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Item> { cell, indexPath, item in
                cell.contentConfiguration = contentConfiguration(indexPath, item)
                cell.backgroundConfiguration = backgroundConfiguration?(indexPath, item)
                cellConfigurationHandler?(cell, indexPath, item)
            }
            
            self.dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
                collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        }
        
        // MARK: - UICollectionViewDataSourcePrefetching
        
        public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
            
        }
    }
}
