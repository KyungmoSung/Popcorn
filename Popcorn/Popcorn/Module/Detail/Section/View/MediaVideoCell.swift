//
//  MediaVideoCell.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import UIKit
import WebKit

class MediaVideoCell: UICollectionViewCell {
    
    @IBOutlet weak var mWebView: WKWebView!
    @IBOutlet weak var mIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        mWebView.navigationDelegate = self
    }
    
    func loadYouTube(key: String) {
        if let url = URL(string: AppConstants.Domain.youtubeEmbed + key) {
            let request = URLRequest(url: url)
            mWebView.scrollView.isScrollEnabled = false
            mWebView.load(request)
        }
    }
}

extension MediaVideoCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        mIndicator.isHidden = false
        mIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        mIndicator.isHidden = true
        mIndicator.stopAnimating()
        webView.isHidden = false
    }
}
