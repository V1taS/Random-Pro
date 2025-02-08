//
//  SceneViewController.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 17.04.2024.
//

import SwiftUI
import SKStyle

// MARK: - SceneViewController

/// `SceneViewController` является контроллером, который управляет представлением,
/// адаптированным для использования с моделью представления `SceneViewModel`.
public final class SceneViewController<ViewModel: SceneViewModel, Content: View>: UIHostingController<Content> {
  
  // MARK: - Public properties
  
  /// Возвращает предпочитаемый стиль строки состояния на основе свойства модели представления.
  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return viewModel.preferredStatusBarStyle
  }
  
  // MARK: - Private properties
  
  /// Модель представления, связанная с этим контроллером.
  private let viewModel: ViewModel
  
  // MARK: - Init
  
  /// Инициализирует новый экземпляр `SceneViewController` с заданной моделью представления и содержимым.
  public init(viewModel: ViewModel, content: Content) {
    self.viewModel = viewModel
    super.init(rootView: content)
  }
  
  /// Инициализатор из кодера, выбрасывает исключение, так как его использование не поддерживается.
  @objc required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - The lifecycle of a UIViewController
  
  /// Вызывается после загрузки представления контроллера. Настраивает представление и навигацию.
  public override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.viewDidLoad?()
    setupView()
    setupNavigation()
    setupEndEditing()
  }
  
  /// Вызывается перед тем как представление станет видимым.
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.viewWillAppear?()
  }
  
  /// Вызывается когда представление начинает появляться на экране.
  public override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    viewModel.viewIsAppearing?()
  }
  
  /// Вызывается перед тем как система начнет расставлять подпредставления.
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    viewModel.viewWillLayoutSubviews?()
  }
  
  /// Вызывается после того как система расставила подпредставления.
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    viewModel.viewDidLayoutSubviews?()
  }
  
  /// Вызывается после того как представление полностью появилось на экране.
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.viewDidAppear?()
  }
  
  /// Вызывается перед началом процесса исчезновения представления с экрана.
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    viewModel.viewWillDisappear?()
  }
  
  /// Вызывается после того как представление полностью исчезло с экрана.
  public override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    viewModel.viewDidDisappear?()
  }
  
  /// Вызывается в момент освобождения объекта из памяти.
  deinit {
    viewModel.deinitAction?()
  }
  
  // MARK: - Private func @objc
  
  /// Скрыть клавиатуру
  @objc private func dismissKeyboard() {
    UIApplication.shared.sendAction(
      #selector(UIResponder.resignFirstResponder),
      to: nil,
      from: nil,
      for: nil
    )
  }
}

// MARK: - Private

private extension SceneViewController {
  /// Настраивает внешний вид основного представления контроллера.
  func setupView() {
    view.backgroundColor = viewModel.backgroundColor ?? SKStyleAsset.onyx.color
  }
  
  /// Настраивает элементы навигационной панели в соответствии с настройками модели представления.
  func setupNavigation() {
    navigationItem.title = viewModel.sceneTitle
    navigationItem.backButtonTitle = ""
    navigationItem.largeTitleDisplayMode = viewModel.largeTitleDisplayMode
    
    navigationItem.rightBarButtonItems = viewModel.rightBarButtonItems
    navigationItem.leftBarButtonItems = viewModel.leftBarButtonItems
    navigationController?.setNavigationBarHidden(viewModel.isNavigationBarHidden, animated: false)
    
    if let centerBarButtonItem = viewModel.centerBarButtonItem {
      switch centerBarButtonItem {
      case let .widgetCryptoView(barButtonView):
        navigationItem.titleView = barButtonView
      case let .customView(view):
        navigationItem.titleView = view
      }
    }
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  /// Настраивает поведение для завершения редактирования при касании экрана, если это разрешено.
  func setupEndEditing() {
    if viewModel.isEndEditing {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
      /// Позволяет другим элементам управления реагировать на касания.
      tapGesture.cancelsTouchesInView = false
      view.addGestureRecognizer(tapGesture)
    }
  }
}
