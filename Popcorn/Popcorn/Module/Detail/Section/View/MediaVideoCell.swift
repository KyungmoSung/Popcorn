//
//  MediaVideoCell.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import UIKit
import WebKit

class MediaVideoCell: UICollectionViewCell {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.applyShadow()
        webView.contentMode = .scaleAspectFill
        webView.navigationDelegate = self
    }
    
    func loadYouTube(key: String) {
        if let url = URL(string: AppConstants.Domain.youtubeEmbed + key) {
            let request = URLRequest(url: url)
            webView.scrollView.isScrollEnabled = false
            webView.load(request)
        }
    }
}

extension MediaVideoCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        let scriptFontSizeAdjustment = "document.body.style.zoom = '0.9'"
        webView.evaluateJavaScript(scriptFontSizeAdjustment)
        
        indicatorView.isHidden = false
        indicatorView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicatorView.isHidden = true
        indicatorView.stopAnimating()
        webView.isHidden = false
    }
}
