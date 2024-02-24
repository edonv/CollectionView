//
//  CollectionLayoutGroupBuilder.swift
//
//
//  Created by Edon Valdman on 2/24/24.
//

import SwiftUI

@resultBuilder
public struct CollectionLayoutGroupBuilder {
    public typealias FinalResult = Component
    public typealias Expression = NSCollectionLayoutItem
    public typealias Component = [NSCollectionLayoutItem]
    
    public static func buildExpression(_ expression: Expression) -> Component {
        [expression]
    }
    
    public static func buildExpression(_ expression: LayoutItem...) -> Component {
        buildExpression(expression)
    }
    
    public static func buildExpression(_ expression: some Sequence<LayoutItem>) -> Component {
        expression.map(\.item)
    }
    
    public static func buildExpression(_ expression: Expression?) -> Component {
        [expression].compactMap { $0 }
    }
    
    public static func buildExpression(_ expression: LayoutGroup) -> Component {
        [expression.group]
    }
    
    public static func buildBlock(_ components: Component...) -> Component {
        buildArray(components)
    }
    
    public static func buildArray(_ components: [Component]) -> Component {
        components.flatMap { $0 }
    }
    
    public static func buildPartialBlock(first: Component) -> Component {
        first
    }
    
    public static func buildPartialBlock(accumulated: Component, next: Component) -> Component {
        accumulated + next
    }
    
    public static func buildOptional(_ component: Component?) -> Component {
        component?.compactMap { $0 } ?? []
    }
    
    public static func buildEither(first component: Component) -> Component {
        component
    }
    
    public static func buildEither(second component: Component) -> Component {
        component
    }
    
    public static func buildLimitedAvailability(_ component: Component) -> Component {
        component
    }
    
    public static func buildFinalResult(_ component: Component) -> FinalResult {
        component
    }
}
