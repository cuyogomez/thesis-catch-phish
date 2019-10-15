//
//  MasterView.swift
//  CatchPhish
//
//  Created by Claudio Gomez on 9/7/19.
//  Copyright © 2019 Claudio Gomez. All rights reserved.
//

import SwiftUI

struct MasterView: View {
    var body: some View {
        TabView {
            CatcherView().tabItem {
                Image(systemName: "checkmark.shield")
                Text("master.option.catcher")
            }
            SettingsView().tabItem {
                Image(systemName: "gear")
                Text("master.option.settings")
                .font(.headline)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            FirewallManager.shared.loadPreferences()
        }
        
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
    }
}
