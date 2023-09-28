//
//  Initializer Tests.swift
//
//
//  Created by Edon Valdman on 9/28/23.
//

import SwiftUI
import OrderedCollections

enum Sections: String, Hashable {
    case section1
    case section2
}

struct Item: Hashable {
    var title: String
    var subtitle: String
    var systemImageName: String
}

@available(iOS 15.0, *)
struct StandardInitMultipleSelectTest: View {
    @State var items: OrderedDictionary<Sections, [Item]> = [
        .section1: [
            Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
            Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
            Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
            Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
        ],
        .section2: [
            Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
            Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "books.vertical.fill"),
            Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
            Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
        ]
    ]
    
    @State var selection: Set<Item> = []
    
    var body: some View {
        CollectionView(
            $items,
            selection: $selection,
            layout: layout()) { indexPath, item -> UIListContentConfiguration in
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
                contentConfig.imageProperties.preferredSymbolConfiguration = .init(font: .preferredFont(forTextStyle: .largeTitle), scale: .default)
                return contentConfig
            } backgroundConfiguration: { indexPath, _ in
                if indexPath.item == 0 {
                    UIBackgroundConfiguration.listGroupedHeaderFooter()
                } else {
                    UIBackgroundConfiguration.listGroupedCell()
                }
            } cellConfigurationHandler: { cell, _, _ in
                
            }
            .itemSelection(shouldSelectItem: { _, indexPath in
                indexPath.item != 0
            })
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Remove Random") {
                        guard let random = selection.randomElement() else { return }
                        selection.remove(random)
                    }
                }
            }
    }
    
    func layout() -> UICollectionViewCompositionalLayout {
        var listConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfig.headerMode = .firstItemInSection
        return .list(using: listConfig)
    }
}

@available(iOS 15.0, *)
#Preview {
    NavigationView {
        StandardInitMultipleSelectTest()
    }
}
