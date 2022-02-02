//
//  SettingHostingController.swift
//  Together
//
//  Created by lcx on 2021/11/28.
//

import SwiftUI

class SettingHostingController: UIHostingController<SettingView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: SettingView());
    }
}
