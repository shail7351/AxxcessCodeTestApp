//
//  Webservice.swift
//  AxxessCodeTestApp
//
//  Created by Shailesh Gole on 13/08/20.
//  Copyright © 2020 ShaileshG. All rights reserved.
//

import Foundation
import Alamofire

enum AppError: Error {
  case ServerResponseError
  case ServerDataError
  case DataParsingError
  case NetworkError
}

class Webservice {
  
  func getArticles(_ completion: @escaping ([Article]?, Error?) -> Void) {
    let url = URL(string: "https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/master/challenge.json")!
    
    Alamofire.request(url).response { (response) in
      do {
        if response.error != nil {
          completion(nil, AppError.ServerResponseError)
        }
        guard let responseData = response.data else {
          completion(nil, AppError.ServerDataError)
          return
        }
        let article = try? JSONDecoder().decode(Articles.self, from: responseData)
        completion(article, nil)
      }
    }
  }
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
