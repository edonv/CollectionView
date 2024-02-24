//
//  Builder Inits.swift
//
//
//  Created by Edon Valdman on 2/24/24.
//

import SwiftUI

public typealias CollectionViewLayout = UICollectionViewCompositionalLayout
public typealias CollectionViewLayoutHandler = () -> CollectionViewLayout

@available(iOS 16, macCatalyst 16, tvOS 16, visionOS 1, *)
extension CollectionView where Cell == UICollectionViewCell, CollectionLayout == CollectionViewLayout {
    init<Content>(
        _ data: Binding<ItemCollection>,
        selection: Binding<Set<Item>>,
        @ViewBuilder cellContent: @escaping (IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Content,
        @CollectionLayoutBuilder
        layout: @escaping CollectionViewLayoutHandler
    ) where Content: View {
        self.init(
            data,
            selection: selection,
            layout: layout(),
            cellContent: cellContent
        )
    }
    
    init<Content>(
        _ data: Binding<ItemCollection>,
        selection: Binding<Item?>? = nil,
        @ViewBuilder cellContent: @escaping (IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Content,
        @CollectionLayoutBuilder
        layout: @escaping CollectionViewLayoutHandler
    ) where Content: View {
        self.init(
            data,
            selection: selection,
            layout: layout(),
            cellContent: cellContent
        )
    }
}
