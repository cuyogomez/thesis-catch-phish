//
//  SettingsView.swift
//  CatchPhish
//
//  Created by Claudio Gomez on 9/7/19.
//  Copyright © 2019 Claudio Gomez. All rights reserved.
//

import SwiftUI
import Intents

struct SettingsView: View {

    @EnvironmentObject var settings: SettingsConfiguration
    
    var body: some View {
        ZStack {
            VStack() {
                StartFirewallView()
                Spacer()
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [ Color("BackgroundLightGray"), .blue]), startPoint: .bottom, endPoint: .top))
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            self.firstLoadCofigureView()
        }
    }
    
    fileprivate func firstLoadCofigureView() {
        FirewallManager.shared.loadPreferences()
        donateIntent()
    }
    
    fileprivate func donateIntent() {
        INPreferences.requestSiriAuthorization { authorization in
            guard authorization == INSiriAuthorizationStatus.authorized else {
                 return
            }
         
            let intent = ConfigureFirewallIntent()
            let action = self.settings.isFirewallStarted ? FirewallOptions.stop.rawValue : FirewallOptions.start.rawValue
            intent.action = action
            intent.suggestedInvocationPhrase = "\(action.capitalized)s the firewall"
            let interaction = INInteraction(intent: intent, response: nil)
            interaction.donate(completion: { (error) in
                if let error = error {
                     print(error.localizedDescription)
                }
            })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(SettingsConfiguration())
    }
}
