//
//  VideoItemViewModel.swift
//  
//
//  Created by Front-Artist on 2021/09/06.
//

import Foundation

final class VideoItemViewModel: RowViewModel {
    let videoURL: URL?
    
    init(with videoInfo: VideoInfo) {
        if let url = URL(string: AppConstants.Domain.youtubeEmbed + videoInfo.key) {
            self.videoURL = url
        } else {
            self.videoURL = nil
        }
        
        super.init(identity: videoInfo.key)
    }
}
