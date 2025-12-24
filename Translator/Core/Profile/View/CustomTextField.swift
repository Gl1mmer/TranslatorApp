//
//  CustomTextField.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 19.12.2025.
//

import UIKit

protocol CustomTextFieldProtocol: AnyObject {
    func checkAndSaveFor(field: UserField, data: String)
}

class CustomTextField: UIView {
    
    weak var delegate: CustomTextFieldProtocol?
    private var fieldType: UserField
    
    private let titleLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    private let textField: UITextField = {
        $0.placeholder = "Enter your data"
        $0.borderStyle = .none
        $0.returnKeyType = .done
        $0.textAlignment = .right
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.clearButtonMode = .whileEditing
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITextField())

    init(field: UserField, delegate: CustomTextFieldProtocol) {
        self.fieldType = field
        self.delegate = delegate
        
        super.init(frame: .zero)
        setupLayout()
        
        titleLabel.text = field.rawValue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(textField)

        textField.delegate = self

        titleLabel.setContentHuggingPriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            textField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    func setText(text: String) {
        textField.text = text
    }
}

extension CustomTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.checkAndSaveFor(
            field: fieldType,
            data: textField.text ?? ""
        )
    }
}
