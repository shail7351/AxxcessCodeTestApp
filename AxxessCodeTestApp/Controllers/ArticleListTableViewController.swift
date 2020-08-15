//
//  ArticleListTableViewController.swift
//  AxxessCodeTestApp
//
//  Created by Shailesh Gole on 14/08/20.
//  Copyright © 2020 ShaileshG. All rights reserved.
//

import UIKit
import CoreData
import SnapKit

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
    
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.color = .gray
    self.view.addSubview(activityIndicator)
    
    activityIndicator.snp.makeConstraints { (make) in
      make.centerX.equalTo(self.view.snp.centerX)
      make.centerY.equalTo(self.view.snp.centerY)
    }
    if !Connectivity.isConnectedToInternet() {
      if !fetchArticles()
      {
        let alert = UIAlertController(title: nil, message: "Please check your internet connectivitiy.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
      } else {
        self.tableView.reloadData()
      }
      return
    }
    activityIndicator.startAnimating()
    Webservice().getArticles { [weak self] (responseArticles, error) in
      DispatchQueue.main.async {
        activityIndicator.stopAnimating()
      }
      if let articles = responseArticles {
        DispatchQueue.main.async {
          self?.clearStorage()
        }
        self?.formatToDisplayArticle(articles)
      }//cnbd
    }
  }
  
  private func formatToDisplayArticle(_ articles: Articles) {
    var allArticles: [Articles] = []
    let allArticleType = Set(articles.compactMap({ $0.type }))
    for item in allArticleType {
      let typeArticles = articles.filter({ $0.type == item})
      allArticles.append(typeArticles)
    }
    self.articleListVM = ArticleListViewModel(articles: allArticles)
    DispatchQueue.main.async {
      self.tableView.reloadData()
      self.prepareToSaveArticleToCD(articles)
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
  func fetchArticles() -> Bool {
    var isArticlesAvialable = false
    var articles: Articles = []
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticleEntity")
    let sortDescriptor = NSSortDescriptor(key: "type", ascending: true)
    request.sortDescriptors = [sortDescriptor]
    request.returnsObjectsAsFaults = false
    do {
      let records = try appdelegate.persistentContainer.viewContext.fetch(request)
      if records.count > 0 {
        isArticlesAvialable = true
        for record in records as! [NSManagedObject] {
          if let id = record.value(forKey: "id") as? String, let type = record.value(forKey: "type") as? String {
            let data = record.value(forKey: "data") as? String
            let date = record.value(forKey: "date") as? String
            let article = Article(id: id, type: type, date: date, data: data)
            articles.append(article)
          }
        }
        self.formatToDisplayArticle(articles)
      }
    } catch {
      print("Fetching data Failed")
    }
    return isArticlesAvialable
  }
}

extension ArticleListTableViewController {
  func clearStorage() {
    let managedObjectContext = appdelegate.persistentContainer.viewContext
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"ArticleEntity")
      let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      do {
          try managedObjectContext.execute(batchDeleteRequest)
      } catch let error as NSError {
          print(error)
      }
  }
}
