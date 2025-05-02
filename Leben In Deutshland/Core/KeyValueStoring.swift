//
//  KeyValueStoring.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 01.05.25.
//

import Foundation
protocol KeyValueStoring {
    func value<T>(for key: String) -> T?
    func setValue<T>(_ value: T, for key: String)
    func removeValue(for key: String)
}
