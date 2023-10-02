//
//  CollectionView+ViewModifiers.swift
//
//
//  Created by Edon Valdman on 9/27/23.
//

import SwiftUI

extension CollectionView {
    // MARK: - Misc Properties
    
    /// Sets the view’s background to a color.
    /// - Parameter color: An instance of a color that is drawn behind the modified view.
    /// - Returns: A view with the specified color drawn behind it.
    public func backgroundColor(
        _ color: UIColor
    ) -> CollectionView {
        var new = self
        new.collectionViewBackgroundColor = if #available(iOS 15.0, *) {
            Color(uiColor: color)
        } else {
            Color(color)
        }
        return new
    }
    
    /// Sets the view’s background to a color.
    /// - Parameter color: An instance of a color that is drawn behind the modified view.
    /// - Returns: A view with the specified color drawn behind it.
    public func backgroundColor(
        _ color: Color?
    ) -> CollectionView {
        var new = self
        new.collectionViewBackgroundColor = color
        return new
    }
    
    /// Sets the view’s background to a style.
    /// - Parameter style: An instance of a color that is drawn behind the modified view.
    /// - Returns: A view with the specified color drawn behind it.
    @available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
    public func backgroundStyle<S>(
        _ style: S
    ) -> some View where S: ShapeStyle {
        self.backgroundView {
            Rectangle().fill(BackgroundStyle.background)
        }
    }
    
    /// Layers the given view behind this view.
    /// - Parameters:
    ///   - background: The view to draw behind this view.
    ///   - alignment: The alignment with a default value of [`center`](https://developer.apple.com/documentation/swiftui/alignment/center) that you use to position the background view.
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
    
    /// Layers the views that you specify behind this view.
    /// - Parameters:
    ///   - alignment: The alignment that the modifier uses to position the implicit [`ZStack`](https://developer.apple.com/documentation/swiftui/zstack) that groups the background views. The default is [`center`](https://developer.apple.com/documentation/swiftui/alignment/center).
    ///   - content: A [`ViewBuilder`](https://developer.apple.com/documentation/swiftui/viewbuilder) that you use to declare the views to draw behind this view, stacked in a cascading order from bottom to top. The last view that you list appears at the front of the stack.
    /// - Returns: A view that uses the specified content as a background.
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
    
    /// Adds a modifier for this view that fires an action when a cell is selected.
    /// - Parameters:
    ///   - handler: A closure to run when the cell is selected.
    ///   - indexPath: The index path of the cell that was selected.
    /// - Returns: A view that fires an action when a cell is selected.
    public func onSelect(
        _ handler: CollectionViewVoidCallback?
    ) -> CollectionView {
        var new = self
        new.didSelectItemHandler = handler
        return new
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
