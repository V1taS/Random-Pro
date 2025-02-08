//
//  ReferralProgramTableViewCell.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 25.07.2023.
//

import UIKit
import FancyStyle

// MARK: - ReferralProgramTableViewCell

public final class ReferralProgramTableViewCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = ReferralProgramTableViewCell.description()
  
  // MARK: - Private properties
  
  private let referralProgramView = ReferralProgramView()
  
  // MARK: - Initilisation
  
  public override init(style: CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Public func
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - lottieAnimationJSONName: Анимация лотти
  ///  - title: Заголовок
  ///  - firstStepTitle: Описание первого шага
  ///  - link: Ссылка
  ///  - secondStepTitle: Описание второго шага
  ///  - circleStepsTitle: Описание в кружках
  ///  - currentStep: Текущее количество регистраций
  ///  - maxSteps: Максимальное количество регистраций
  ///  - linkAction: Действие по нажатию на кнопку
  public func configureCellWith(
    lottieAnimationJSONName: String,
    title: String?,
    firstStepTitle: String?,
    link: String?,
    secondStepTitle: String?,
    circleStepsTitle: String,
    currentStep: Int,
    maxSteps: Int = 5,
    linkAction: ((_ link: String?) -> Void)?
  ) {
    referralProgramView.configureWith(
      lottieAnimationJSONName: lottieAnimationJSONName,
      title: title,
      firstStepTitle: firstStepTitle,
      link: link,
      secondStepTitle: secondStepTitle,
      circleStepsTitle: circleStepsTitle,
      currentStep: currentStep,
      maxSteps: maxSteps,
      linkAction: linkAction
    )
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [referralProgramView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      referralProgramView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: appearance.minInset),
      referralProgramView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      referralProgramView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      referralProgramView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                  constant: -appearance.minInset)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    selectionStyle = .none
  }
}

// MARK: - Appearance

private extension ReferralProgramTableViewCell {
  struct Appearance {
    let minInset: CGFloat = 4
    let defaultInset: CGFloat = 16
  }
}
