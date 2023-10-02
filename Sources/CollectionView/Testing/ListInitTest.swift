//
//  ListInitTest.swift
//
//
//  Created by Edon Valdman on 10/2/23.
//

import SwiftUI
import OrderedCollections

struct ListInitTest: View {
    @State
    var items: OrderedDictionary<Testing.Sections, [Testing.Item]> = .dummyData
    
    @State var selection: Testing.Item? = nil
    
    var body: some View {
        CollectionView(
            $items,
            selection: $selection,
            listAppearance: .insetGrouped) { indexPath, state, item in
                let isHeader = indexPath.item == 0
                var contentConfig: UIListContentConfiguration
                if isHeader {
                    contentConfig = UIListContentConfiguration.groupedHeader()
                } else {
                    contentConfig = UIListContentConfiguration.valueCell()
                    contentConfig.secondaryText = item.subtitle
                }
                
                contentConfig.text = item.title
                contentConfig.image = UIImage(systemName: item.systemImageName)
                contentConfig.secondaryTextProperties.color = .label
                contentConfig.imageProperties.cornerRadius = 10
                
                
                return contentConfig
            } backgroundConfiguration: { indexPath, state, item in
                if indexPath.item == 0 {
                    UIBackgroundConfiguration.listGroupedHeaderFooter()
                } else {
                    UIBackgroundConfiguration.listGroupedCell()
                }
            } cellConfigurationHandler: { cell, indexPath, state, _ in
//                if indexPath.item == 1 {
                    cell.indentationLevel = indexPath.item
//                }
            } listConfigurationHandler: { config in
                config.headerMode = .firstItemInSection
            }
            .itemSelection(shouldSelectItem: { _, indexPath in
                indexPath.item != 0
            })
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Select First Item") {
                        selection = items[.section1]?[1]
                    }
                }
            }
    }
    
    func listLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout.list(using: .init(appearance: .insetGrouped))
    }
}

@available(iOS 16, *)
#Preview {
    NavigationStack {
        ListInitTest()
    }
}
