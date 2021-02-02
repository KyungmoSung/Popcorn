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
        webView.scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    func loadYouTube(key: String) {
        // 웹뷰 로딩이 완료되기 전에 스크롤뷰 버벅거리는 현상을 방지
        DispatchQueue.global(qos: .default).async(execute: {
            DispatchQueue.main.async {
                if let url = URL(string: AppConstants.Domain.youtubeEmbed + key) {
                    let request = URLRequest(url: url)
                    self.webView.scrollView.isScrollEnabled = false
                    self.webView.load(request)
                }
            }
        })
    }
}

extension MediaVideoCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        let scriptFontSizeAdjustment = "document.body.style.zoom = '0.8'"
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
