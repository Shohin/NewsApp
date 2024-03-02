//
//  LoginVC.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 01/03/24.
//

import Foundation
import UIKit

final class LoginVC: UIViewController {
    private lazy var logoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "news-logo")
        imgView.contentMode = .scaleAspectFit
        imgView.backgroundColor = .red
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private lazy var fieldsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.returnKeyType = .next
        setup(field: field)
        return field
    }()
    
    private lazy var passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.returnKeyType = .done
        field.isSecureTextEntry = true
        setup(field: field)
        return field
    }()
    
    private lazy var loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 22
        btn.clipsToBounds = true
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var activeField: UITextField? = nil
    
    private let vm: LoginVM
    init(vm: LoginVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardObserver()
    }
    
    private func setup() {
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureAction)))
        
        view.addSubview(logoImageView)
        view.addSubview(fieldsStackView)
        fieldsStackView.addArrangedSubview(usernameField)
        fieldsStackView.addArrangedSubview(passwordField)
        view.addSubview(loginButton)
        
        validateFieldsForUpdatingButtons()
        
        setupLayout()
    }
    
    private func setupLayout() {
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 1).isActive = true
        
        fieldsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48).isActive = true
        fieldsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fieldsStackView.heightAnchor.constraint(equalToConstant: 104).isActive = true
        fieldsStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32).isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: fieldsStackView.bottomAnchor, constant: 30).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    private func setup(field: UITextField) {
        field.delegate = self
        field.addTarget(self, action: #selector(fieldChangeAction(textField:)), for: .editingChanged)
        field.layer.borderColor = UIColor.systemBlue.cgColor
        field.layer.borderWidth = 1
        field.clipsToBounds = true
        field.layer.cornerRadius = 8
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 8, height: 0)))
        field.rightViewMode = .always
        field.rightView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 8, height: 0)))
    }
    
    private func updateLoginButton(isEnabled: Bool) {
        loginButton.isEnabled = isEnabled
        loginButton.alpha = isEnabled ? 1 : 0.6
    }
    
    private func validateFieldsForUpdatingButtons() {
        let isEnabled: Bool
        do {
            try vm.model.validate()
            isEnabled = true
        } catch {
            isEnabled = false
        }
        updateLoginButton(isEnabled: isEnabled)
    }
    
    private func login() {
        vm.login {[weak self] message in
            self?.showQuickAlert(message: message)
        }
    }
    
    //MARK: Keyboard
    private func registerKeyboardObserver() {
        NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(self.keyboardWillShow),
                    name: UIResponder.keyboardWillShowNotification,
                    object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func unregisterKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        guard let activeField else { return }
        
        let bottomOfTextField = activeField.convert(activeField.bounds, to: view).maxY
        let topOfKeyboard = view.frame.height - keyboardSize.height

        // if the bottom of Textfield is below the top of keyboard, move up
        if bottomOfTextField > topOfKeyboard {
            view.bounds.origin.y = bottomOfTextField - topOfKeyboard + 32
        }
    }
        
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        view.bounds.origin.y = 0
    }
    
    //MARK: actions
    @objc
    private func tapGestureAction() {
        hideKeyboard()
    }
    
    @objc
    private func fieldChangeAction(textField: UITextField) {
        if textField == usernameField {
            vm.model.username = textField.text
        } else if textField == passwordField {
            vm.model.password = textField.text
        }
        
        validateFieldsForUpdatingButtons()
    }
    
    @objc
    private func loginAction() {
        hideKeyboard()
        login()
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            textField.resignFirstResponder()
            login()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
        do {
            if textField == usernameField {
                do {
                    try vm.model.validateUsername()
                }
            } else if textField == passwordField {
                try vm.model.validatePassword()
            }
        } catch(let error) {
            showQuickAlert(message: (error as? LoginValidationError)?.message ?? error.localizedDescription)
        }
    }
}
