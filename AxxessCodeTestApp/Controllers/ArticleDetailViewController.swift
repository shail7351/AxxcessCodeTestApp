//
//  ArticleDetailViewController.swift
//  AxxessCodeTestApp
//
//  Created by Shailesh Gole on 14/08/20.
//  Copyright © 2020 ShaileshG. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class ArticleDetailViewController: UIViewController {
  
  var article: ArticleViewModel?
  
  override func loadView() {
    super.loadView()
    view.backgroundColor = .white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let article = article {
      switch article.type {
      case "text", "other":
        prepareToDisplayText(article)
      case "image":
        prepareToDisplayImage(article)
      default:
        print("wrong type")
      }
    }
  }
  
  /// This function is responsible for render label to show the text
  /// - Parameter article: extract article to display text from data property
  private func prepareToDisplayText(_ article: ArticleViewModel) {
    let superview = self.view
    let label = UILabel()
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.font = UIFont.systemFont(ofSize: 16.0)
    label.text = article.data
    superview?.addSubview(label)
    label.snp.makeConstraints { (make) in //
      make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
      make.leading.equalTo(20)
      make.trailing.equalTo(-20)
    }
  }
  
  /// This function is responsible for creating the imageview and rendering the downloaded image
  /// - Parameter article: extract article to fetch image from the url mentioned in data property
  private func prepareToDisplayImage(_ article: ArticleViewModel) {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    let indicator = UIActivityIndicatorView(style: .medium)
    self.view.addSubview(indicator)
    indicator.snp.makeConstraints { (make) in
      make.centerX.equalTo(self.view.snp.centerX)
      make.centerY.equalTo(self.view.snp.centerY)
    }
    indicator.startAnimating()
    if let imagePath = article.data, let url = URL(string: imagePath) {
      imageView.sd_setImage(with: url, placeholderImage: nil, options: []) { (image, error, _, url) in
        indicator.stopAnimating()
        if error != nil {
          let alert = UIAlertController(title: nil, message: "Failed to download image", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
          self.present(alert, animated: true)
          return
        }
        if image != nil {
          imageView.image = image
        }
      }
    }
    self.view.addSubview(imageView)
    imageView.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
}

extension UIView {
  var safeArea : ConstraintLayoutGuideDSL {
    return safeAreaLayoutGuide.snp
  }
}
