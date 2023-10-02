//
//  HostingInitTest.swift
//  
//
//  Created by Edon Valdman on 10/1/23.
//

import SwiftUI
import OrderedCollections

@available(iOS 16, *)
struct HostingInitTest: View {
    @State
    var items: OrderedDictionary<Testing.Sections, [Testing.Item]> = .dummyData
    
    @State var selection: Testing.Item? = nil
    
    var body: some View {
        CollectionView(
            $items,
            selection: $selection,
            layout: listLayout()) { indexPath, state, item in
                VStack {
                    Image(systemName: item.systemImageName)
                    Text(item.title)
                    Text(item.subtitle)
                }
                .font(state.isSelected ? .title : .body)
                .disabled(indexPath.item == 0)
                .swipeActions {
                    Button(role: .destructive) {
                        print("Test")
                    } label: {
                        Label("", systemImage: "trash")
                    }
                    Button(role: .destructive) {
                        print("Test")
                    } label: {
                        Label("", systemImage: "trash")
                    }
                    .tint(.blue)
                }
                .swipeActions(edge: .leading) {
                    Button(role: .destructive) {
                        print("Test")
                    } label: {
                        Label("", systemImage: "trash")
                    }
                    Button(role: .destructive) {
                        print("Test")
                    } label: {
                        Label("", systemImage: "trash")
                    }
                    .tint(.blue)
                }
            } cellBackground: { _, state, _ in
                Text("BACKGROUND")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .background(state.isSwiped ? .orange : .yellow)
            } cellConfigurationHandler: { cell, indexPath, _, _ in
                if indexPath.item == 1 {
                    
                }
            }
//            .itemSelection(shouldSelectItem: { _, indexPath in
//                indexPath.item != 0
//            })
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Select First Item") {
                        selection = items[.section1]?.first
                    }
                }
            }
    }
    
    func listLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout.list(using: .init(appearance: .insetGrouped))
    }
    
    func compositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let leadingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                                   heightDimension: .fractionalHeight(1.0)))
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let trailingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.3)))
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            let trailingGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitem: trailingItem, count: 2)
            
            let nestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.4)),
                subitems: [leadingItem, trailingGroup])
            let section = NSCollectionLayoutSection(group: nestedGroup)
            section.orthogonalScrollingBehavior = .continuous
            return section
            
        }
        return layout
    }
}

@available(iOS 16, *)
#Preview {
    NavigationStack {
        HostingInitTest()
            .navigationTitle("Test")
    }
}
