//
//  InteractorsContainer.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

extension DIContainer {
    struct Interactors {
        let mainInteractor: MainInteractor
        let numberInteractor: NumberInteractor
        let listWordsInteractor: ListWordsInteractor
        let yesOrNoInteractor: YesOrNoInteractor
        let charactersInteractor: CharactersInteractor
        let coinInteractor: CoinInteractor
        let cubeInterator: CubeInterator
        let settingsInterator: SettingsInterator

        init(mainInteractor: MainInteractor,
             numberInteractor: NumberInteractor,
             listWordsInteractor: ListWordsInteractor,
             yesOrNoInteractor: YesOrNoInteractor,
             charactersInteractor: CharactersInteractor,
             coinInteractor: CoinInteractor,
             cubeInterator: CubeInterator,
             settingsInterator: SettingsInterator) {
            self.mainInteractor = mainInteractor
            self.numberInteractor = numberInteractor
            self.listWordsInteractor = listWordsInteractor
            self.yesOrNoInteractor = yesOrNoInteractor
            self.charactersInteractor = charactersInteractor
            self.coinInteractor = coinInteractor
            self.cubeInterator = cubeInterator
            self.settingsInterator = settingsInterator
        }

        static var stub: Self {
            .init(mainInteractor: MainInteractorImpl(),
                  numberInteractor: NumberInteractorImpl(),
                  listWordsInteractor: ListWordsInteractorImpl(),
                  yesOrNoInteractor: YesOrNoInteractorImpl(),
                  charactersInteractor: CharactersInteractorImpl(),
                  coinInteractor: CoinInteractorImpl(),
                  cubeInterator: CubeInteratorImpl(),
                  settingsInterator: SettingsInteratorImpl())
        }
    }
}
