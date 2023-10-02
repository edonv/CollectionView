//
//  CollectionView+ViewModifiers.swift
//
//
//  Created by Edon Valdman on 9/27/23.
//

import SwiftUI

extension CollectionView {
    // MARK: - Misc Properties
    
    /// <#Description#>
    /// - Parameter color: <#color description#>
    /// - Returns: <#description#>
    public func backgroundColor(
        _ color: UIColor?
    ) -> CollectionView {
        var new = self
        new.collectionViewBackgroundColor = if let color {
            if #available(iOS 15.0, *) {
                Color(uiColor: color)
            } else {
                Color(color)
            }
        } else {
            nil
        }
        return new
    }
    
    public func backgroundColor(
        _ color: Color?
    ) -> CollectionView {
        var new = self
        new.collectionViewBackgroundColor = color
        return new
    }
    
    @available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
    public func backgroundStyle<S>(
        _ style: S
    ) -> some View where S: ShapeStyle {
        self.backgroundView {
            Rectangle().fill(BackgroundStyle.background)
        }
    }
    
    @available(iOS, deprecated: 14, obsoleted: 15)
    @available(macOS, deprecated: 11, obsoleted: 12)
    @available(macCatalyst, deprecated: 14, obsoleted: 15)
    @available(tvOS, deprecated: 14, obsoleted: 15)
    @available(watchOS, deprecated: 7, obsoleted: 8)
    public func backgroundView<Background>(
        _ background: Background,
        alignment: Alignment = .center
    ) -> some View where Background: View {
        var new = self
        new.collectionViewBackgroundColor = nil
        return new.background(background, alignment: alignment)
    }
    
    @available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
    public func backgroundView<V>(
        alignment: Alignment = .center,
        @ViewBuilder content: () -> V
    ) -> some View where V: View {
        var new = self
        new.collectionViewBackgroundColor = nil
        return new.background(alignment: alignment, content: content)
    }
    
    // MARK: - Delegate Callbacks
    
    
    
    // MARK: - Single Selection
    
    @ViewBuilder
    public func onSelect(perform action: @escaping (_ selectedItem: Item) -> Void) -> some View {
        if #available(iOS 17, macCatalyst 17, macOS 14, tvOS 17, watchOS 10, visionOS 1, *) {
            self.onChange(of: selection) { oldValue, newValue in
                guard let newSelection = newValue.subtracting(oldValue).first else { return }
                action(newSelection)
            }
        } else {
            self.onChange(of: selection) { [selection] newValue in
                guard let newSelection = newValue.subtracting(selection).first else { return }
                action(newSelection)
            }
        }
    }
    
    public func itemSelection(
        shouldSelectItem: CollectionViewBoolCallback? = nil,
        shouldDeselectItem: CollectionViewBoolCallback? = nil
    ) -> CollectionView {
        var new = self
        new.shouldSelectItemHandler = shouldSelectItem
        new.shouldDeselectItemHandler = shouldDeselectItem
        return new
    }
    
    public func shouldAllowSelection(
        _ allowed: Bool
    ) -> CollectionView {
        var new = self
        new.shouldSelectItemHandler = { _, _ in allowed }
        return new
    }
    
    // MARK: - Multiple Selection
    
    public func shouldBeginMultipleSelectionInteraction(
        _ handler: CollectionViewBoolCallback?
    ) -> CollectionView {
        var new = self
        new.shouldBeginMultipleSelectionInteractionHandler = handler
        return new
    }
    
    public func shouldAllowTwoFingerMultipleSelectionInteraction(
        _ allowed: Bool
    ) -> CollectionView {
        var new = self
        new.shouldBeginMultipleSelectionInteractionHandler = { _, _ in allowed }
        return new
    }
    
    public func didBeginMultipleSelectionInteraction(
        _ handler: CollectionViewVoidCallback?
    ) -> CollectionView {
        var new = self
        new.didBeginMultipleSelectionInteractionHandler = handler
        return new
    }
    
    public func didEndMultipleSelectionInteraction(
        _ handler: (() -> Void)?
    ) -> CollectionView {
        var new = self
        new.didEndMultipleSelectionInteractionHandler = handler
        return new
    }
    
    // MARK: - Highlighting
    
    public func shouldHighlightItem(
        _ handler: CollectionViewBoolCallback?
    ) -> CollectionView {
        var new = self
        new.shouldHighlightItemHandler = handler
        return new
    }
    
    public func shouldAllowHighlighting(
        _ allowed: Bool
    ) -> CollectionView {
        var new = self
        new.shouldHighlightItemHandler = { _, _ in allowed }
        return new
    }
    
    public func didHighlightItem(
        _ handler: CollectionViewVoidCallback?
    ) -> CollectionView {
        var new = self
        new.didHighlightItemHandler = handler
        return new
    }
    
    public func didUnhighlightItem(
        _ handler: CollectionViewVoidCallback?
    ) -> CollectionView {
        var new = self
        new.didUnhighlightItemHandler = handler
        return new
    }
    
    // MARK: - Displaying Cells
    
    public func willDisplayCell(
        _ handler: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)?
    ) -> CollectionView {
        var new = self
        new.willDisplayCellHandler = handler
        return new
    }
    
    public func didEndDisplayingCell(
        _ handler: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)?
    ) -> CollectionView {
        var new = self
        new.didEndDisplayingCellHandler = handler
        return new
    }
    
    // MARK: - Context Menu
    
    public func willDisplayContextMenu(
        _ handler: ((_ configuration: UIContextMenuConfiguration, UIContextMenuInteractionAnimating?) -> Void)?
    ) -> CollectionView {
        var new = self
        new.willDisplayContextMenu = handler
        return new
    }
    
    public func willEndContextMenuInteraction(
        _ handler: ((_ configuration: UIContextMenuConfiguration, UIContextMenuInteractionAnimating?) -> Void)?
    ) -> CollectionView {
        var new = self
        new.willEndContextMenuInteraction = handler
        return new
    }
    
    public func onContextMenuPreviewTap(
        _ handler: ((_ configuration: UIContextMenuConfiguration, UIContextMenuInteractionAnimating?) -> Void)?
    ) -> CollectionView {
        var new = self
        new.willPerformPreviewAction = handler
        return new
    }
    
    public func contextMenu<Preview: View>(
        menuIdentifier: NSCopying? = nil,
        swiftUIProvider previewProvider: @escaping (_ indexPaths: [IndexPath], _ point: CGPoint) -> Preview?,
        actionProvider: ((_ indexPaths: [IndexPath], _ point: CGPoint, [UIMenuElement]) -> UIMenu?)? = nil
    ) -> CollectionView {
        var new = self
        new.contextMenuConfigHandler = { indexPaths, point in
            UIContextMenuConfiguration(
                identifier: menuIdentifier,
                previewProvider: {
                    guard let preview = previewProvider(indexPaths, point) else { return nil }
                    return UIHostingController(rootView: preview)
                },
                actionProvider: { menuElements in
                    actionProvider?(indexPaths, point, menuElements)
                }
            )
        }
        return new
    }
    
    public func contextMenu(
        menuIdentifier: NSCopying? = nil,
        uiKitProvider previewProvider: @escaping (_ indexPaths: [IndexPath], _ point: CGPoint) -> UIViewController?,
        actionProvider: ((_ indexPaths: [IndexPath], _ point: CGPoint, [UIMenuElement]) -> UIMenu?)? = nil
    ) -> CollectionView {
        var new = self
        new.contextMenuConfigHandler = { indexPaths, point in
            UIContextMenuConfiguration(
                identifier: menuIdentifier,
                previewProvider: {
                    previewProvider(indexPaths, point)
                },
                actionProvider: { menuElements in
                    actionProvider?(indexPaths, point, menuElements)
                }
            )
        }
        return new
    }
    
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
