//
//  ProfileViewController.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 19.12.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    var output: ProfileViewOutput!
    
    private let avatarView: UIImageView = {
        $0.image = UIImage(systemName: "circle.dotted.circle.fill")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 60
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private lazy var nameField = CustomTextField(field: .name, delegate: self)
    private lazy var surnameField = CustomTextField(field: .surname, delegate: self)
    private lazy var phoneNumField = CustomTextField(field: .phoneNumber, delegate: self)
    
    private let stackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private lazy var randomAvatarButton = {
        $0.setTitle("Set random photo", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(randomButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        output.getProfileDataFromDatabase()
        output.getRandomImage()
    }

    @objc private func randomButtonTapped() {
        output.getRandomImage()
    }
    
    private func showAlertWith(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)
    }
    
    private func setPreviousValue(_ value: String, for field: UserField) {
        switch field {
        case .name:
            nameField.setText(text: value)
        case .surname:
            surnameField.setText(text: value)
        case .phoneNumber:
            phoneNumField.setText(text: value)
        }
    }

}

extension ProfileViewController {
    private func setupUI() {
        navigationItem.title = "DevHouse iOS"
        view.backgroundColor = .white
        
        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(surnameField)
        stackView.addArrangedSubview(phoneNumField)
    
        view.addSubview(avatarView)
        view.addSubview(stackView)
        view.addSubview(randomAvatarButton)

        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 37),
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 120),
            avatarView.widthAnchor.constraint(equalToConstant: 120),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 45),
            stackView.heightAnchor.constraint(equalToConstant: 132),
            
            randomAvatarButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 28),
            randomAvatarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            randomAvatarButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            randomAvatarButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
}

extension ProfileViewController: ProfileViewInput {
    func updateUIWithDataFromDB(name: String, surname: String, phone: String) {
        nameField.setText(text: name)
        surnameField.setText(text: surname)
        phoneNumField.setText(text: phone)
    }
    
    func updateImage(with image: UIImage) {
        avatarView.image = image
    }
    
    func showValidationError(for field: UserField, previousValue: String) {
        let title = "Wrong format, try again"
        var message = "\(field.rawValue) should contain only letters \nThe previous data is returned"
        if field == .phoneNumber { message = "\(field.rawValue) should contain only numbers \nThe previous data is returned" }
        setPreviousValue(previousValue, for: field)
        showAlertWith(title: title, message: message)
    }
    
}

extension ProfileViewController: CustomTextFieldProtocol {
    func checkAndSaveFor(field: UserField, data: String) {
        output.checkAndSaveNewTextFor(field, text: data)
    }
}


