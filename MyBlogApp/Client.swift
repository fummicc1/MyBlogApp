//
//  Client.swift
//  MyBlogApp
//
//  Created by Fumiya Tanaka on 2019/12/19.
//  Copyright © 2019 Fumiya Tanaka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HTTPRepository {
    func post(blog: Blog) -> Single<Void>
}

class Client: HTTPRepository {
    
    enum Status {
        case success
        case fail(String)
    }
    
    func post(blog: Blog) -> Single<Void> {
        .create { (singleEvent) -> Disposable in
            
            let session = URLSession.shared
            let urlStr: String = PrivateConfig.baseURL + "/blog"
            let url = URL(string: urlStr)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try? JSONEncoder().encode(blog)
            session.dataTask(with: request) { (_, _, error) in
                if let error = error {
                    singleEvent(.error(error))
                    return
                }
                singleEvent(SingleEvent.success(()))
            }.resume()
            
            return Disposables.create()
        }
    }
}
