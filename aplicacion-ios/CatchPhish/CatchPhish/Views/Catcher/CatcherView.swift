//
//  Catcher.swift
//  CatchPhish
//
//  Created by Claudio Gomez on 9/7/19.
//  Copyright © 2019 Claudio Gomez. All rights reserved.
//

import SwiftUI
import Combine

struct CatcherView: View {
    // MARK: Properties
    let minSpacerLength: CGFloat = 0
    
    @State var urlToAnalyze = ""
    @State var showLoading = false
    @State var showAnalyzeAlert = false
    @State var isPhishing = false
    
    var body: some View {
        LoadingView(isShowing: $showLoading) {
            ZStack() {
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Text("catcher.enterURL")
                        .foregroundColor(.white)
                    TextField("catcher.urlToAnalyze", text: self.$urlToAnalyze)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button(action: {
                        self.showLoading.toggle()
                        self.checkURL()
                    }) {
                        Text("catcher.catchIt")
                            .lineLimit(nil)
                            .foregroundColor(.white)
                            .padding()
                            .font(.headline)
                            .clipShape(Capsule().inset(by: 5))
                            .overlay(Capsule().inset(by: 5).stroke(Color.white, lineWidth: 3))
                    }
                    .alert(isPresented: self.$showAnalyzeAlert) { () -> Alert in
                        return self.alertForState(isPhishing: self.isPhishing)
                    }
                    Spacer()
                }
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color("BackgroundLightGray"), .blue]), startPoint: .bottom, endPoint: .top))
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    fileprivate func checkURL() {
        guard let request = NetworkHandler.createRequest(url: urlToAnalyze) else {
            self.showLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.showLoading = false
            if let error = error {
                NSLog("XXXXX> Error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    NSLog("XXXXX> Error")
                    return
            }
            if let data = data,
                let prediction = try? JSONDecoder().decode(Prediction.self, from: data) {
                self.isPhishing = prediction.isPhishing
                self.showAnalyzeAlert = true
            }
        }.resume()
    }
    
    func alertForState(isPhishing: Bool) -> Alert {
        var title = NSLocalizedString("alerts.phishing", comment: "")
        var message = NSLocalizedString("alerts.phishingMessage", comment: "")
        if isPhishing {
            message = String(format: message, arguments: [urlToAnalyze, "this"])
        } else {
            title = NSLocalizedString("alerts.legitimate", comment: "")
            message = NSLocalizedString("alerts.legitimateMessage", comment: "")
        }
        return Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("alerts.ok")))
    }
    
}

struct Catcher_Previews: PreviewProvider {
    static var previews: some View {
        CatcherView()
    }
}
