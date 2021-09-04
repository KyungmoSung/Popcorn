//
//  NukeExtension.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/12/08.
//

import UIKit
import Nuke
import RxSwift

extension ImageLoadingOptions {
    static let fadeIn = ImageLoadingOptions(
        transition: .fadeIn(duration: 0.3)
    )
}

extension ImagePipeline: ReactiveCompatible {}

public extension Reactive where Base: ImagePipeline {
    /// Loads an image with a given url. Emits the value synchronously if the
    /// image was found in memory cache.
    func loadImage(with url: URL) -> Single<ImageResponse> {
        return self.loadImage(with: ImageRequest(url: url))
    }

    /// Loads an image with a given request. Emits the value synchronously if the
    /// image was found in memory cache.
    func loadImage(with request: ImageRequest) -> Single<ImageResponse> {
        return Single<ImageResponse>.create { single in
            if let image = self.base.cache[request] {
                single(.success(ImageResponse(container: image))) // return synchronously
                return Disposables.create() // nop
            } else {
                let task = self.base.loadImage(with: request, completion: { result in
                    switch result {
                    case let .success(response):
                        single(.success(response))
                    case let .failure(error):
                        single(.error(error))
                    }
                })
                return Disposables.create { task.cancel() }
            }
        }
    }
}
