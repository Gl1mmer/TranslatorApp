//
//  HomeViewController.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 19.12.2025.
//

import UIKit

final class HomeViewController: UIViewController {
        
    var output: HomeViewOutput!
    
    private lazy var translationInputView = TranslationBoxView(mode: .input, delegate: self)
    
    private lazy var translationOutputView = TranslationBoxView(mode: .output, delegate: self)
    
    private let favouriteLabel: UILabel = {
        $0.text = "Favourite"
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let favouriteTableView: UITableView = {
        $0.showsVerticalScrollIndicator = false
        $0.register(FavoritesCell.self, forCellReuseIdentifier: FavoritesCell.identifier)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView())
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "DevHouse iOS"
        setupUI()
        output.viewIsReady()
        
        favouriteTableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension HomeViewController {
    private func setupUI() {
        view.addSubview(translationInputView)
        view.addSubview(translationOutputView)
        view.addSubview(favouriteLabel)
        view.addSubview(favouriteTableView)

        NSLayoutConstraint.activate([
            translationInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13),
            translationInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13),
            translationInputView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            translationInputView.heightAnchor.constraint(equalToConstant: 200),
            
            translationOutputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13),
            translationOutputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13),
            translationOutputView.topAnchor.constraint(equalTo: translationInputView.bottomAnchor, constant: 5),
            translationOutputView.heightAnchor.constraint(equalToConstant: 200),
            
            favouriteLabel.topAnchor.constraint(equalTo: translationOutputView.bottomAnchor, constant: 27),
            favouriteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            favouriteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            favouriteTableView.topAnchor.constraint(equalTo: favouriteLabel.bottomAnchor, constant: 5),
            favouriteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            favouriteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            favouriteTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func makeLanguageMenu(for mode: TranslationBoxMode, with languages: [Language]) -> UIMenu {
        let actions = languages.map { language in
            UIAction(title: language.title) { [weak self] _ in
                self?.output.changeLanguage(of: mode, to: language)
            }
        }
        return UIMenu(title: "Choose language", children: actions)
    }

}

extension HomeViewController: HomeViewInput {
    func setFavouriteEnabled(_ enabled: Bool) {
        translationInputView.setFavouriteEnabled(enabled)
    }
    
    func updateFavouriteButton(isFavourite: Bool) {
        translationInputView.updateFavouriteButton(isFavourite)
    }
    
    func setFavouriteTextToInputBox(text: String) {
        translationInputView.setText(text)
    }
    
    func configureLanguages(_ languages: [Language]) {
        translationInputView.configureLanguageMenu(makeLanguageMenu(for: .input, with: languages))
        translationOutputView.configureLanguageMenu(makeLanguageMenu(for: .output, with: languages))
    }
    func updateInputLanguage(_ language: Language) {
        translationInputView.setLanguageTitle(language.title)
        translationInputView.setPlaceholder(language.placeholder)
    }
    
    func updateOutputLanguage(_ language: Language) {
        translationOutputView.setLanguageTitle(language.title)
        translationOutputView.setPlaceholder(language.placeholder)
    }
    func showTranslatedText(_ text: String) {
        translationOutputView.setText(text)
    }
    func reloadData() {
        favouriteTableView.reloadData()
    }
}

extension HomeViewController: TranslationBoxProtocol {
    func favouriteButtonTapped() {
        output.toggleFavourite()
    }
    
    func translationBoxDidChangeText(text: String) {
        output.translate(text: text)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesCell.identifier, for: indexPath) as? FavoritesCell else { return UITableViewCell()}
        let indexReversed = output.numberOfItems - indexPath.row - 1
        cell.configure(with: output.item(at: indexReversed), delegate: self, index: indexReversed)
        return cell
    }
}

extension HomeViewController: FavoritesCellProtocol {
    func didTapOpen(at index: Int) {
        output.getFavorite(at: index)
    }
}
