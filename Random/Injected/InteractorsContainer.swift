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
        let textInteractor: TextInteractor

        init(mainInteractor: MainInteractor,
             numberInteractor: NumberInteractor,
             textInteractor: TextInteractor) {
            self.mainInteractor = mainInteractor
            self.numberInteractor = numberInteractor
            self.textInteractor = textInteractor
        }

        static var stub: Self {
            .init(mainInteractor: MainInteractorImpl(),
                  numberInteractor: NumberInteractorImpl(),
                  textInteractor: TextInteractorImpl())
        }
    }
}
