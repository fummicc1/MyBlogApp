//
//  ViewModel.swift
//  MyBlogApp
//
//  Created by Fumiya Tanaka on 2019/12/18.
//  Copyright © 2019 Fumiya Tanaka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {
    
    let blogObservable: Observable<Client.Status>
    let client: HTTPRepository
    
    init(title: Observable<String>, body: Observable<String>, buttonTap: Observable<Void>, client: HTTPRepository = Client()) {
        let titleAndBody = Observable.combineLatest(title, body)
        let request = buttonTap.withLatestFrom(titleAndBody).flatMapLatest { (title, body) -> Observable<Void> in
            let blog = Blog(title: title, body: body)
            return client.post(blog: blog).asObservable()
        }
        blogObservable = request.flatMap { _ -> Observable<Client.Status> in
            return .just(.success)
        }.catchError { error -> Observable<Client.Status> in
            return .just(.fail("\(error)"))
        }
        self.client = client
    }
    
}
