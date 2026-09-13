//
//  String+Localized.swift
//  Common
//
//  Created by Ridwan Febnur AR on 13/09/26.
//

import Foundation

public extension String {
    var localized: String {
        NSLocalizedString(self, bundle: .module, comment: "")
    }
}
