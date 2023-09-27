//
//  CollectionView+ViewModifiers.swift
//
//
//  Created by Edon Valdman on 9/27/23.
//

import SwiftUI

extension CollectionView {
    // MARK: - Prefetching
    
    public func prefetching(
        prefetchItems: ((_ indexPaths: [IndexPath]) -> Void)? = nil,
        cancelPrefetchingItems: ((_ indexPaths: [IndexPath]) -> Void)? = nil
    ) -> CollectionView {
        var new = self
        new.prefetchItemsHandler = prefetchItems
        new.cancelPrefetchingHandler = cancelPrefetchingItems
        return new
    }
}
