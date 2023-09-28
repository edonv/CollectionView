//
//  CollectionView+ViewModifiers.swift
//
//
//  Created by Edon Valdman on 9/27/23.
//

import SwiftUI

extension CollectionView {
    // MARK: - Single Selection
    
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
        previewProvider: ((_ indexPaths: [IndexPath], _ point: CGPoint) -> Preview?)? = nil,
        actionProvider: ((_ indexPaths: [IndexPath], _ point: CGPoint, [UIMenuElement]) -> UIMenu?)? = nil
    ) -> CollectionView {
        var new = self
        new.contextMenuConfigHandler = { indexPaths, point in
            UIContextMenuConfiguration(
                identifier: menuIdentifier,
                previewProvider: {
                    guard let previewProvider else { return nil }
                    return UIHostingController(rootView: previewProvider(indexPaths, point))
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
        previewProvider: ((_ indexPaths: [IndexPath], _ point: CGPoint) -> UIViewController?)? = nil,
        actionProvider: ((_ indexPaths: [IndexPath], _ point: CGPoint, [UIMenuElement]) -> UIMenu?)? = nil
    ) -> CollectionView {
        var new = self
        new.contextMenuConfigHandler = { indexPaths, point in
            UIContextMenuConfiguration(
                identifier: menuIdentifier,
                previewProvider: {
                    previewProvider?(indexPaths, point)
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
