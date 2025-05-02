//
//  UserDefaults+KeyValueStoring.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 01.05.25.
//

import Foundation
extension UserDefaults: KeyValueStoring {
    public func value<T>(for key: String) -> T? {
      object(forKey: key) as? T
    }

    public func setValue<T>(_ value: T, for key: String) {
      set(value, forKey: key)
    }

    public func removeValue(for key: String) {
      removeObject(forKey: key)
    }
  }
