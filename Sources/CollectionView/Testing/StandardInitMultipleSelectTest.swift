//
//  StandardInitMultipleSelectTest.swift
//
//
//  Created by Edon Valdman on 9/28/23.
//

import SwiftUI
import OrderedCollections

@available(iOS 15.0, *)
struct StandardInitMultipleSelectTest: View {
    @State
    var items: OrderedDictionary<Testing.Sections, [Testing.Item]> = .dummyData
    
    @State var selection: Set<Testing.Item> = []
    
    var body: some View {
        CollectionView(
            $items,
            selection: $selection, 
            layout: layout()) { cell, indexPath, item in
                cell.contentConfiguration = {
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
                }()
                
                cell.backgroundConfiguration = {
                    if indexPath.item == 0 {
                        UIBackgroundConfiguration.listGroupedHeaderFooter()
                    } else {
                        UIBackgroundConfiguration.listGroupedCell()
                    }
                }()
            }
            .itemSelection(shouldSelectItem: { _, indexPath in
                indexPath.item != 0
            })
//            .contextMenu<Text>(menuIdentifier: nil, swiftUIProvider: { indexPaths, point in
//                guard let firstIndexPath = indexPaths.first,
//                      let item = self.items[firstIndexPath] else { return nil }
//                
//                return Text(item.title)
//            }, actionProvider: { indexPaths, point, _ in
//                return nil 
//            })
//            .background(.green)
//            .backgroundColor(Color.yellow)
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Remove Random") {
                        guard let random = selection.randomElement() else { return }
                        selection.remove(random)
                    }
                }
            }
//            .onChange(of: selection) { newValue in
//                print(newValue.map(\.title))
//            }
    }
    
    func layout() -> UICollectionViewCompositionalLayout {
        var listConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfig.headerMode = .firstItemInSection
//        listConfig.backgroundColor = .clear
        return .list(using: listConfig)
    }
}

@available(iOS 17.0, *)
#Preview {
    NavigationView {
        StandardInitMultipleSelectTest()
//            .navigationTitle("Test")
    }
}
