//
//  CustomError.swift
//  PitchPerfect
//
//  Created by Nestor Diazgranados on 5/30/20.
//  Copyright © 2020 NesDupier. All rights reserved.
//

import Foundation

struct CustomError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
