# CollectionView

`CollectionView` is a SwiftUI wrapper of [`UICollectionView`](https://developer.apple.com/documentation/uikit/uicollectionview).

Have you ever wanted to make an app solely in SwiftUI, but the processing tradeoff of using [`Grid`](https://developer.apple.com/documentation/swiftui/grid), [`Lazy_Stack`](https://developer.apple.com/documentation/swiftui/grouping-data-with-lazy-stack-views), and [`Lazy_Grid`](https://developer.apple.com/documentation/swiftui/layout-fundamentals#dynamically-arranging-views-in-two-dimensions) are too significant? Wish you could stick with SwiftUI but still get the processing power of [`UICollectionView`](https://developer.apple.com/documentation/uikit/uicollectionview)? Then try out CollectionView!

It’s a SwiftUI wrapper for `UICollectionView` that exposes all [`UICollectionViewDelegate`](https://developer.apple.com/documentation/uikit/uicollectionviewdelegate)/[`UICollectionViewDataSourcePrefetching`](https://developer.apple.com/documentation/uikit/uicollectionviewdatasourceprefetching) delegate functions (via view modifiers). Plus, on iOS 16+, you can utilize [`UIHostingConfiguration`](https://developer.apple.com/documentation/swiftui/uihostingconfiguration) to use SwiftUI views for the cells.

Plus, by passing your data source as a `Binding`, it updates changes to the view using [`UICollectionViewDiffableDataSource`](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource). This also means it doesn't fully reload the view on every change, but rather, they're reloaded internally by the `UICollectionView`.

It’s still a work in progress (especially with testing everything + documentation), but please give it a try and send feedback my way!

## Usage

- Make sure to use `.ignoresSafeArea()` if it's meant to be full-screen.

## To-Do's

- [ ] Implement `UICellConfigurationState`.
- [ ] Finish documenting view modifiers.
- [ ] Work on more concrete example for README/DocC articles.
