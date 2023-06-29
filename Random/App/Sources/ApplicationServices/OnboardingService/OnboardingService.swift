//
//  OnboardingService.swift
//  Random
//
//  Created by Artem Pavlov on 28.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import WelcomeSheet

protocol OnboardingService {

  var onboardingPages: [WelcomeSheetPage]? { get }

}

final class OnboardingServiceImpl: OnboardingService {

  var onboardingPages: [WelcomeSheet.WelcomeSheetPage]? {
    return getPagesTest()
  }

  private func getPagesTest() -> [WelcomeSheetPage] {
    let pages: [WelcomeSheetPage] = [
      WelcomeSheetPage(title: "Welcome to Welcome Sheet", rows: [
          WelcomeSheetPageRow(imageSystemName: "rectangle.stack.fill.badge.plus",
                              title: "Quick Creation",
                              content: "It's incredibly intuitive. Simply declare an array of pages filled with content."),

          WelcomeSheetPageRow(imageSystemName: "slider.horizontal.3",
                           //   accentColor: Color.indigo,
                              title: "Highly Customisable", content: "Match sheet's appearance to your app, link buttons, perform actions after dismissal."),

          WelcomeSheetPageRow(imageSystemName: "ipad.and.iphone",
                              title: "Works out of the box",
                              content: "Don't worry about various screen sizes. It will look gorgeous on every iOS device.")
      ], optionalButtonTitle: "About Welcome Sheet...", optionalButtonURL: URL(string: "https://github.com/MAJKFL/Welcome-Sheet")),

      WelcomeSheetPage(title: "What's New in Translate", rows: [
          WelcomeSheetPageRow(imageSystemName: "platter.2.filled.iphone",
                              title: "Conversation Views",
                              content: "Choose a side-by-side or face-to-face conversation view."),

          WelcomeSheetPageRow(imageSystemName: "mic.badge.plus",
                              title: "Auto Translate",
                              content: "Respond in conversations without tapping the microphone button."),

          WelcomeSheetPageRow(imageSystemName: "iphone",
                              title: "System-Wide Translation",
                              content: "Translate selected text anywhere on your iPhone.")
      ], mainButtonTitle: "Wassup?")
  ]

    return pages
  }

  // MARK: - Private properties
}

private extension OnboardingServiceImpl {
  struct Appearance {}
}
