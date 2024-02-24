//
//  BuilderTesting.swift
//  
//
//  Created by Edon Valdman on 2/24/24.
//

import SwiftUI
import CompositionalLayoutBuilder
import OrderedCollections

#if os(iOS)
@available(iOS 16, *)
private struct LayoutBuilderTest: View {
    @State
    var items: OrderedDictionary<Testing.Sections, [Testing.Item]> = .dummyData
    
    @State var selection: Testing.Item? = nil
    
    var body: some View {
        CollectionView($items, selection: $selection) { indexPath, state, item in
            VStack {
                Image(systemName: item.systemImageName)
                Text(item.title)
                Text(item.subtitle)
            }
            .font(.body)
            .foregroundStyle(state.isSelected ? .blue : .primary)
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
            .padding()
            .background(.yellow)
        } layout: {
            CompositionalSection {
                CompositionalGroup(.horizontal, width: .fractionalWidth(1), height: .absolute(200)) {
                    CompositionalGroup(.vertical, width: .fractionalWidth(0.75), height: .fractionalHeight(1)) {
                        CompositionalItem(width: .fractionalWidth(1), height: .fractionalHeight(0.5))
                            .repeating(count: 2)
                    }
                    
                    CompositionalItem(width: .fractionalWidth(0.25), height: .fractionalHeight(1))
                }
            }
            
            CompositionalSection {
                CompositionalGroup(.horizontal, width: .fractionalWidth(1), height: .absolute(100)) {
                    CompositionalItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1))
                }
            }
            .orthogonalScrollingBehavior(.continuous)
        }
//        .backgroundStyle(.green)
    }
}

@available(iOS 16, *)
#Preview {
    LayoutBuilderTest()
}
#endif
