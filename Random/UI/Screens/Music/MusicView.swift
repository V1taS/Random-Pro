//
//  MusicView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct MusicView: View {
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                Networking.share.getNusic() { music in
                    print("\(music)")
                }
            }
    }
}

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView()
    }
}
