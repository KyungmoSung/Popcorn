//
//  ImageItemViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/06.
//

import Foundation

final class ImageItemViewModel: RowViewModel {
    let imageURL: URL?
    let aspectRatio: Double
    
    init(with imageInfo: ImageInfo) {
        if let url = URL(string: AppConstants.Domain.tmdbImage + imageInfo.filePath) {
            self.imageURL = url
        } else {
            self.imageURL = nil
        }
        
        self.aspectRatio = imageInfo.aspectRatio
        
        super.init(identity: imageInfo.filePath)
    }
}
