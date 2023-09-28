//
//  OrderedDictionary+IndexPath.swift
//
//
//  Created by Edon Valdman on 9/28/23.
//

import Foundation
import OrderedCollections

extension OrderedDictionary where Value: RandomAccessCollection, Value.Index == Int {
    public subscript(_ indexPath: IndexPath) -> Value.Element? {
        guard let sectionKey = key(for: indexPath.section),
              let value = self[sectionKey],
              value.count > indexPath.item else { return nil }
        return value[indexPath.item]
    }
}

extension OrderedDictionary {
    public func key(for index: Int) -> Key? {
        guard keys.count > index else { return nil }
        return keys[index]
    }
}
