//
//  StartFirewallView.swift
//  CatchPhish
//
//  Created by Claudio Gomez on 9/16/19.
//  Copyright © 2019 Claudio Gomez. All rights reserved.
//

import SwiftUI
import NetworkExtension

struct StartFirewallView: View {
    
    @EnvironmentObject var settings: SettingsConfiguration
    
    var buttonText: LocalizedStringKey {
        return settings.isFirewallStarted ? "settings.stopFirewall" : "settings.startFirewall"
    }
    
    var imageName: String {
        return settings.isFirewallStarted ? "xmark.shield" : "checkmark.shield"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HStack() {
                Button(action: {
                    self.settings.isFirewallStarted.toggle()
                    self.toogleFirewall()
                }) {
                    HStack() {
                        Text(buttonText)
                            .foregroundColor(.white)
                        Image(systemName: imageName)
                            .foregroundColor(.white)
                            .font(.title)
                        Spacer()
                        Toggle("", isOn: $settings.isFirewallStarted)
                    }
                }
            }
        })
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white, lineWidth: 1.5))
        .padding()
            .padding(.top, 40)
    }
    
    private func toogleFirewall() {
        if self.settings.isFirewallStarted {
            FirewallManager.shared.enableFirewall()
        } else {
            FirewallManager.shared.disableFirewall()
        }
    }
}

struct StartFirewallView_Previews: PreviewProvider {
    static var previews: some View {
        StartFirewallView().environmentObject(SettingsConfiguration())
    }
}
