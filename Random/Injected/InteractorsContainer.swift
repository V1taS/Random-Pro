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
        let textInteractor: ListWordsInteractor
        let yesOrNoInteractor: YesOrNoInteractor
        let charactersInteractor: CharactersInteractor
        let coinInteractor: CoinInteractor
        let cubeInterator: CubeInterator

        init(mainInteractor: MainInteractor,
             numberInteractor: NumberInteractor,
             textInteractor: ListWordsInteractor,
             yesOrNoInteractor: YesOrNoInteractor,
             charactersInteractor: CharactersInteractor,
             coinInteractor: CoinInteractor,
             cubeInterator: CubeInterator) {
            self.mainInteractor = mainInteractor
            self.numberInteractor = numberInteractor
            self.textInteractor = textInteractor
            self.yesOrNoInteractor = yesOrNoInteractor
            self.charactersInteractor = charactersInteractor
            self.coinInteractor = coinInteractor
            self.cubeInterator = cubeInterator
        }

        static var stub: Self {
            .init(mainInteractor: MainInteractorImpl(),
                  numberInteractor: NumberInteractorImpl(),
                  textInteractor: ListWordsInteractorImpl(),
                  yesOrNoInteractor: YesOrNoInteractorImpl(),
                  charactersInteractor: CharactersInteractorImpl(),
                  coinInteractor: CoinInteractorImpl(),
                  cubeInterator: CubeInteratorImpl())
        }
    }
}
