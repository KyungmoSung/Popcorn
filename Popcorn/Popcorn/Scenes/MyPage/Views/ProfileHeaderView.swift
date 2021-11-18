//
//  ProfileHeaderView.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/10.
//

import UIKit
import RxSwift

class ProfileHeaderView: UICollectionReusableView {
    var disposeBag = DisposeBag()
    
    @IBOutlet private weak var profileIv: UIImageView!
    @IBOutlet private weak var nameLb: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileIv.cornerRadius = profileIv.frame.height / 2
    }
    
    func bind(_ viewModel: ProfileHeaderViewModel) {
        nameLb.text = viewModel.name
        
        profileIv.kf.setImage(with: viewModel.profileImgURL, placeholder: UIImage(named: "icAvatar"), options: [.transition(.fade(1))])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileIv.kf.cancelDownloadTask()
        profileIv.image = nil
    }
}

class ProfileHeaderViewModel: RowViewModel {
    let name: String?
    let profileImgURL: URL?
    
    init(user: User?) {
        self.name = user?.username
        
        if let hash = user?.avatar?.gravatar?.hash, let url = URL(string: AppConstants.Domain.gravatarImage + "/" + hash) {
            self.profileImgURL = url
        } else {
            self.profileImgURL = nil
        }
        
        super.init(identity: user?.name ?? "")
    }
    
}
