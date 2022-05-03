//
//  MainScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol MainScreenFactoryOutput: AnyObject {
    
    /// Были получены модельки
    ///  - Parameter models: Модельки для главного экрана
    func didRecive(models: [MainScreenCellModel])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol MainScreenFactoryInput {
    
    /// Создать массив моделек из количества ячеек
    /// - Parameter cells: Массив ячеек
    func createModelsFrom(cells: [MainScreenCellModel.MainScreenCell])
}

/// Фабрика
final class MainScreenFactory: MainScreenFactoryInput {
    
    // MARK: - Internal properties
    
    weak var output: MainScreenFactoryOutput?
    
    // MARK: - Internal func
    
    func createModelsFrom(cells: [MainScreenCellModel.MainScreenCell]) {
        let appearance = Appearance()
        var models: [MainScreenCellModel] = []
        
        cells.forEach { cell in
            switch cell {
            case .films(let advLabel):
                let model = configureModelFrom(cell: cell,
                                               imageCard: appearance.imageCardFilms,
                                               titleCard: appearance.titleCardFilms,
                                               isShowADVLabel: isShow(advLabel),
                                               titleADVText: configure(advLabel))
                models.append(model)
            case .teams(let advLabel):
                let model = configureModelFrom(cell: cell,
                                               imageCard: appearance.imageCardTeam,
                                               titleCard: appearance.titleCardTeam,
                                               isShowADVLabel: isShow(advLabel),
                                               titleADVText: configure(advLabel))
                models.append(model)
            case .number(let advLabel):
                let model = configureModelFrom(cell: cell,
                                               imageCard: appearance.imageCardNumber,
                                               titleCard: appearance.titleCardNumber,
                                               isShowADVLabel: isShow(advLabel),
                                               titleADVText: configure(advLabel))
                models.append(model)
            case .yesOrNo(let advLabel):
                let model = configureModelFrom(cell: cell,
                                               imageCard: appearance.imageCardYesOrNot,
                                               titleCard: appearance.titleCardYesOrNot,
                                               isShowADVLabel: isShow(advLabel),
                                               titleADVText: configure(advLabel))
                models.append(model)
            case .character(let advLabel):
                let model = configureModelFrom(cell: cell,
                                               imageCard: appearance.imageCardCharacters,
                                               titleCard: appearance.titleCardCharacters,
                                               isShowADVLabel: isShow(advLabel),
                                               titleADVText: configure(advLabel))
                models.append(model)
            case .list(let advLabel):
                let model = configureModelFrom(cell: cell,
                                               imageCard: appearance.imageCardList,
                                               titleCard: appearance.titleCardList,
                                               isShowADVLabel: isShow(advLabel),
                                               titleADVText: configure(advLabel))
                models.append(model)
            case .coin(let advLabel):
                let model = configureModelFrom(cell: cell,
                                               imageCard: appearance.imageCardCoin,
                                               titleCard: appearance.titleCardCoin,
                                               isShowADVLabel: isShow(advLabel),
                                               titleADVText: configure(advLabel))
                models.append(model)
            case .cube(let advLabel):
                let model = configureModelFrom(cell: cell,
                                               imageCard: appearance.imageCardCube,
                                               titleCard: appearance.titleCardCube,
                                               isShowADVLabel: isShow(advLabel),
                                               titleADVText: configure(advLabel))
                models.append(model)
            case .dateAndTime(let advLabel):
                let model = configureModelFrom(cell: cell,
                                               imageCard: appearance.imageCardDateAndTime,
                                               titleCard: appearance.titleCardDateAndTime,
                                               isShowADVLabel: isShow(advLabel),
                                               titleADVText: configure(advLabel))
                models.append(model)
            case .lottery(let advLabel):
                let model = configureModelFrom(cell: cell,
                                               imageCard: appearance.imageCardLottery,
                                               titleCard: appearance.titleCardLottery,
                                               isShowADVLabel: isShow(advLabel),
                                               titleADVText: configure(advLabel))
                models.append(model)
            case .contact(let advLabel):
                let model = configureModelFrom(cell: cell,
                                               imageCard: appearance.imageCardContact,
                                               titleCard: appearance.titleCardContact,
                                               isShowADVLabel: isShow(advLabel),
                                               titleADVText: configure(advLabel))
                models.append(model)
            case .music(let advLabel):
                let model = configureModelFrom(cell: cell,
                                               imageCard: appearance.imageCardMusic,
                                               titleCard: appearance.titleCardMusic,
                                               isShowADVLabel: isShow(advLabel),
                                               titleADVText: configure(advLabel))
                models.append(model)
            case .travel(let advLabel):
                let model = configureModelFrom(cell: cell,
                                               imageCard: appearance.imageCardTravel,
                                               titleCard: appearance.titleCardTravel,
                                               isShowADVLabel: isShow(advLabel),
                                               titleADVText: configure(advLabel))
                models.append(model)
            case .password(let advLabel):
                let model = configureModelFrom(cell: cell,
                                               imageCard: appearance.imageCardPassword,
                                               titleCard: appearance.titleCardPassword,
                                               isShowADVLabel: isShow(advLabel),
                                               titleADVText: configure(advLabel))
                models.append(model)
            case .russianLotto(let advLabel):
                let model = configureModelFrom(cell: cell,
                                               imageCard: appearance.imageCardRussianLotto,
                                               titleCard: appearance.titleCardRussianLotto,
                                               isShowADVLabel: isShow(advLabel),
                                               titleADVText: configure(advLabel))
                models.append(model)
            }
        }
        output?.didRecive(models: models)
    }
    
    // MARK: - Private func
    
    /// Создаем модельку
    private func configureModelFrom(cell: MainScreenCellModel.MainScreenCell,
                                    imageCard: UIImage,
                                    titleCard: String,
                                    isShowADVLabel: Bool,
                                    titleADVText: String?) -> MainScreenCellModel {
        MainScreenCellModel(cell: cell,
                            imageCard: imageCard,
                            titleCard: titleCard,
                            isShowADVLabel: isShowADVLabel,
                            titleADVText: titleADVText)
    }
    
    /// Проверяем можно ли показать рекламный лайбл
    private func isShow(_ advLabel: MainScreenCellModel.MainScreenCell.ADVLabel) -> Bool {
        switch advLabel {
        case .hit, .new, .premium, .close:
            return true
        case .none:
            return false
        }
    }
    
    /// Конфигурируем названием рекламного лайбла
    private func configure(_ advLabel: MainScreenCellModel.MainScreenCell.ADVLabel) -> String? {
        let appearance = Appearance()
        switch advLabel {
        case .hit:
            return appearance.advLabelHit.uppercased()
        case .new:
            return appearance.advLabelNew.uppercased()
        case .premium:
            return appearance.advLabelPremium.uppercased()
        case .close:
            return appearance.advLabelClosed.uppercased()
        case .none:
            return nil
        }
    }
}

// MARK: - Appearance

private extension MainScreenFactory {
    struct Appearance {
        let imageCardFilms = UIImage(systemName: "film") ?? UIImage()
        let titleCardFilms = NSLocalizedString("Фильмы", comment: "")
        
        let imageCardTeam = UIImage(systemName: "person.circle") ?? UIImage()
        let titleCardTeam = NSLocalizedString("Команды", comment: "")
        
        let imageCardNumber = UIImage(systemName: "number") ?? UIImage()
        let titleCardNumber = NSLocalizedString("Число", comment: "")
        
        let imageCardYesOrNot = UIImage(systemName: "questionmark.square") ?? UIImage()
        let titleCardYesOrNot = NSLocalizedString("Да или Нет", comment: "")
        
        let imageCardCharacters = UIImage(systemName: "textbox") ?? UIImage()
        let titleCardCharacters = NSLocalizedString("Буква", comment: "")
        
        let imageCardList = UIImage(systemName: "list.bullet.below.rectangle") ?? UIImage()
        let titleCardList = NSLocalizedString("Список", comment: "")
        
        let imageCardCoin = UIImage(systemName: "bitcoinsign.circle") ?? UIImage()
        let titleCardCoin = NSLocalizedString("Монета", comment: "")
        
        let imageCardCube = UIImage(systemName: "cube") ?? UIImage()
        let titleCardCube = NSLocalizedString("Кубики", comment: "")
        
        let imageCardDateAndTime = UIImage(systemName: "calendar") ?? UIImage()
        let titleCardDateAndTime = NSLocalizedString("Дата и время", comment: "")
        
        let imageCardLottery = UIImage(systemName: "tag") ?? UIImage()
        let titleCardLottery = NSLocalizedString("Лотерея", comment: "")
        
        let imageCardContact = UIImage(systemName: "phone.circle") ?? UIImage()
        let titleCardContact = NSLocalizedString("Контакт", comment: "")
        
        let imageCardMusic = UIImage(systemName: "tv.music.note") ?? UIImage()
        let titleCardMusic = NSLocalizedString("Музыка", comment: "")
        
        let imageCardTravel = UIImage(systemName: "airplane") ?? UIImage()
        let titleCardTravel = NSLocalizedString("Путешествие", comment: "")
        
        let imageCardPassword = UIImage(systemName: "wand.and.stars") ?? UIImage()
        let titleCardPassword = NSLocalizedString("Пароли", comment: "")
        
        let imageCardRussianLotto = UIImage(systemName: "square.grid.4x3.fill") ?? UIImage()
        let titleCardRussianLotto = NSLocalizedString("Русское Лото", comment: "")
        
        let advLabelHit = NSLocalizedString("ХИТ", comment: "")
        let advLabelNew = NSLocalizedString("НОВОЕ", comment: "")
        let advLabelPremium = NSLocalizedString("Премиум", comment: "")
        let advLabelClosed = NSLocalizedString("Закрыто", comment: "")
    }
}
