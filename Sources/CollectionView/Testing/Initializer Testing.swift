//
//  Initializer Testing.swift
//  
//
//  Created by Edon Valdman on 10/1/23.
//

import Foundation
import OrderedCollections

enum Testing {
    enum Sections: String, Hashable {
        case section1
        case section2
    }
    
    struct Item: Hashable {
        var title: String
        var subtitle: String
        var systemImageName: String
    }
}

extension OrderedDictionary where Key == Testing.Sections, Value == [Testing.Item] {
    internal static var dummyData: Self {
        [
            .section1: [
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill")
            ],
            .section2: [
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "books.vertical.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
            ]
        ]
    }
}
