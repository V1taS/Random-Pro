//
//  TextFieldUIKit.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI
import Combine

struct TextFieldUIKit: UIViewRepresentable {
    
    private var textField = UITextField()
    let placeholder: String
    @Binding var text: String
    var font: UIFont
    var foregroundColor: UIColor
    var keyType: UIKeyboardType
    var isSecureText: Bool
    
    init(placeholder: String,
         text: Binding<String>,
         font: UIFont,
         foregroundColor: UIColor,
         keyType: UIKeyboardType,
         isSecureText: Bool) {
        self.placeholder = placeholder
        self._text = text
        self.font = font
        self.foregroundColor = foregroundColor
        self.keyType = keyType
        self.isSecureText = isSecureText
    }
    
    func makeUIView(context: Context) -> UITextField {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let color = Color.primaryInactive()
        
        textField.delegate = context.coordinator
        textField.keyboardType = keyType
        textField.textColor = foregroundColor
        textField.font = font
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor : color]
        )
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = isSecureText
        
        doneButton.tintColor = .primaryGray()
        toolBar.items = [flexButton, doneButton]
        toolBar.setItems([flexButton, doneButton], animated: true)
        textField.inputAccessoryView = toolBar
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(textField: self.textField, text: self._text)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        private var dispose = Set<AnyCancellable>()
        @Binding var text: String
        
        init(textField: UITextField, text: Binding<String>) {
            self._text = text
            super.init()
            
            NotificationCenter.default
                .publisher(for: UITextField.textDidChangeNotification, object: textField)
                .compactMap { $0.object as? UITextField }
                .compactMap { $0.text }
                .receive(on: RunLoop.main)
                .assign(to: \.text, on: self)
                .store(in: &dispose)
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
}

extension  UITextField{
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
        self.endEditing(true)
    }
    
}

