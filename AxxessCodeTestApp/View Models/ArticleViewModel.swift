//
//  ArticleViewModel.swift
//  AxxessCodeTestApp
//
//  Created by Shailesh Gole on 13/08/20.
//  Copyright © 2020 ShaileshG. All rights reserved.
//

import Foundation

struct ArticleListViewModel {
  let articles: [Articles]
}

extension ArticleListViewModel {
  
  var numberOfSections: Int {
    return articles.count
  }
  
  /// this function is responsible for fetching the title for section
  /// - Parameter section: index of the section
  /// - Returns: number of section for table view
  func titleForHeaderInSection(_ section: Int) -> String? {
    let type = self.articles[section].first?.type
    return type
  }
  
  /// this function is responsible for fetching the number of  rows for each section
  /// - Parameter section: passing section of type Int
  /// - Returns: the number of rows for given section
  func numberOfRowsInSection(_ section: Int) -> Int {
    return self.articles[section].count
  }
  
  /// this function is reponsible to fetch the article which is to be displayed in tableview
  /// - Parameters:
  ///   - section: passing section of type Int
  ///   - index: passing index to get the article lies on the index
  /// - Returns: article to be rendered in tableview
  func articleAtIndex(_ section: Int, index: Int) -> ArticleViewModel {
    let articlesAtSection = self.articles[section]
    let article = articlesAtSection[index]
    return ArticleViewModel(article)
  }
}

struct ArticleViewModel {
  private let article: Article
}

extension ArticleViewModel {
  init(_ article: Article) {
    self.article = article
  }
}

extension ArticleViewModel {
  var id: String {
    return self.article.id
  }
  
  var type: String {
    return self.article.type
  }
  
  var date: String? {
    return self.article.date
  }
  
  var data: String? {
    return self.article.data
  }
}
