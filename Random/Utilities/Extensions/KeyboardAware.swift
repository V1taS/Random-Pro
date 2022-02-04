//
//  KeyboardAware.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

public class KeyboardInfo: ObservableObject {

    public static var shared = KeyboardInfo()

    @Published public var height: CGFloat = .zero

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func keyboardChanged(notification: Notification) {
        if notification.name == UIApplication.keyboardWillHideNotification {
            self.height = .zero
        } else {
            self.height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? .zero
        }
    }

}

struct KeyboardAware: ViewModifier {
    @ObservedObject private var keyboard = KeyboardInfo.shared
    var keyboardWillShow: ((CGFloat) -> Void)?

    func body(content: Content) -> some View {
        keyboardWillShow?(self.keyboard.height)
        
        return content
            .background(Color.white.opacity(0.000000000001))
            .padding(.bottom, self.keyboard.height)
            .edgesIgnoringSafeArea(self.keyboard.height > .zero ? .bottom : [])
            .animation(.easeOut)
    }
}

extension View {
    public func keyboardAware(_ customeHeight: CGFloat = .zero, keyboardWillShow: ((CGFloat) -> Void)? = nil) -> some View {
        ModifiedContent(content: self, modifier: KeyboardAware(keyboardWillShow: keyboardWillShow))
    }
}

