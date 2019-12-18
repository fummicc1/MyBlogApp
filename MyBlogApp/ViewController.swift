//
//  ViewController.swift
//  MyBlogApp
//
//  Created by Fumiya Tanaka on 2019/12/18.
//  Copyright © 2019 Fumiya Tanaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet private var resultLabel: UILabel!
    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var bodyTextView: UITextView!
    @IBOutlet private var postButton: UIButton!
    
    private var viewModel: ViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure
        let title = titleTextField.rx.text.orEmpty.asObservable()
        let body = bodyTextView.rx.text.orEmpty.asObservable()
        let tap = postButton.rx.tap.asObservable()
        viewModel = ViewModel(title: title, body: body, buttonTap: tap)
        
        viewModel?.blogObservable.observeOn(MainScheduler.instance).subscribe { [weak self] event in
            guard let self = self, let status = event.element else { return }
            switch status {
            case .success:
                self.resultLabel.text = "送信完了😎"
            case .fail(_):
                self.resultLabel.text = "送信失敗😶"
            }
        }.disposed(by: disposeBag)
        
        // add shadow
        postButton.layer.cornerRadius = 16
        postButton.layer.shadowColor = UIColor.black.cgColor
        postButton.layer.shadowRadius = 8
        postButton.layer.shadowOpacity = 0.2
        postButton.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
}

extension ViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
