//
//  HomeViewController.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 19.12.2025.
//

import UIKit

final class HomeViewController: UIViewController {
    
    lazy var output = HomePresenter(delegate: self)
//    var output: HomeViewOutput!
    
    private lazy var from = BoxView(delegate: self, boxType: 1)
    private lazy var to = BoxView(delegate: nil, boxType: 2)
    
    let placeholderText = "Enter your text"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "DevHouse iOS"
        setupUI()
    }
}

extension HomeViewController {
    private func setupUI() {
        view.addSubview(from)
        view.addSubview(to)

        NSLayoutConstraint.activate([
            from.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13),
            from.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13),
            from.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            from.heightAnchor.constraint(equalToConstant: 200),
            
            to.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13),
            to.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13),
            to.topAnchor.constraint(equalTo: from.bottomAnchor, constant: 5),
            to.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension HomeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text ?? "-")
        output.translateText(text: textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholderText
            textView.textColor = .systemGray
        }
        textView.resignFirstResponder()
    }
}

extension HomeViewController: HomeViewInput {
    func updateWithTranslatedText(text: String) {
        to.updateText(text)
    }
}
