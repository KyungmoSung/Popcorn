/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

extension ListCollectionContext {
    public func dequeueReusableCell<T: UICollectionViewCell>(withReuseIdentifier reuseIdentifier: String, for sectionController: ListSectionController, at index: Int) -> T {
        guard let cell = self.dequeueReusableCell(of: T.self, withReuseIdentifier: reuseIdentifier, for: sectionController, at: index) as? T else {
            fatalError()
        }

        return cell
    }

    public func dequeueReusableCell<T: UICollectionViewCell>(for sectionController: ListSectionController, at index: Int) -> T {
        guard let cell = self.dequeueReusableCell(of: T.self, for: sectionController, at: index) as? T else {
            fatalError()
        }

        return cell
    }
    
    public func dequeueReusableXibCell<T: UICollectionViewCell>(for sectionController: ListSectionController, at index: Int) -> T {
        guard let cell = self.dequeueReusableCell(withNibName: T.className, bundle: nil, for: sectionController, at: index) as? T else {
            fatalError()
        }
        return cell
    }
    
    public func dequeueReusableSupplementaryXibView<T: UICollectionViewCell>(ofKind elementKind: String, for sectionController: ListSectionController, at index: Int) -> T {
        guard let view  = self.dequeueReusableSupplementaryView(ofKind: elementKind, for: sectionController, nibName: T.className, bundle: nil, at: index) as? T else {
            fatalError()
        }
        return view
    }
}
