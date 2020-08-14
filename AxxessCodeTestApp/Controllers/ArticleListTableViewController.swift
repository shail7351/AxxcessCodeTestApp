//
//  ArticleListTableViewController.swift
//  AxxessCodeTestApp
//
//  Created by Shailesh Gole on 14/08/20.
//  Copyright © 2020 ShaileshG. All rights reserved.
//

import UIKit
import CoreData

class ArticleListTableViewController: UITableViewController {
  
  var articleListVM: ArticleListViewModel!
  let appdelegate = UIApplication.shared.delegate as! AppDelegate
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  /// This method will call websevice and organize our articleListViewModel
  private func setup() {
    self.title = "Axxess Code Test"
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ArticleTableViewCellIdentifier")
    Webservice().getArticles { [weak self] (responseArticles, error) in
      if let articles = responseArticles {
//        DispatchQueue.main.async {
//          self?.prepareToSaveArticleToCD(articles)
//        }
        var allArticles: [Articles] = []
        let allArticleType = Set(articles.compactMap({ $0.type }))
        for item in allArticleType {
          let typeArticles = articles.filter({ $0.type == item})
          allArticles.append(typeArticles)
        }
        self?.articleListVM = ArticleListViewModel(articles: allArticles)
      }
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
  }
  
  /// This method will have the number of section in a tableview
  /// - Parameter tableView: tableview
  /// - Returns: Int: the number of section
  override func numberOfSections(in tableView: UITableView) -> Int {
    return self.articleListVM == nil ? 0 : self.articleListVM.numberOfSections
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.articleListVM.numberOfRowsInSection(section)
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return self.articleListVM.titleForHeaderInSection(section)?.uppercased()
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ArticleTableViewCellIdentifier")
    let articleVM = self.articleListVM.articleAtIndex(indexPath.section, index: indexPath.row)
    cell.textLabel?.text = articleVM.id
    cell.detailTextLabel?.text = articleVM.date
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let articleVM = self.articleListVM.articleAtIndex(indexPath.section, index: indexPath.row)
    let vc = ArticleDetailViewController()
    vc.article = articleVM
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

extension ArticleListTableViewController {
  func prepareToSaveArticleToCD(_ articles: Articles) {
    _ = articles.map({ self.articleToSave( $0 )})
    saveData()
  }
  
  func articleToSave(_ article: Article) -> ArticleEntity? {
    let articleEntity = ArticleEntity(context: appdelegate.persistentContainer.viewContext)
    articleEntity.id = article.id
    articleEntity.type = article.type
    articleEntity.data = article.data
    articleEntity.date = article.date
    return articleEntity
  }
  
  func saveData() {
    appdelegate.saveContext()
  }
}

extension ArticleListTableViewController {
  func fetchArticles() {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticleEntity")
    request.returnsObjectsAsFaults = false
    do {
      let result = try appdelegate.persistentContainer.viewContext.fetch(request)
      for data in result as! [NSManagedObject] {
        
      }
    } catch {
      print("Fetching data Failed")
    }
  }
}
