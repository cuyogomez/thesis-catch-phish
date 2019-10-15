//
//  LightHostingViewController.swift
//  CatchPhish
//
//  Created by Claudio Gomez on 9/17/19.
//  Copyright © 2019 Claudio Gomez. All rights reserved.
//

import UIKit
import SwiftUI

class LightHostingViewController<Content>: UIHostingController<Content> where Content: View {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
