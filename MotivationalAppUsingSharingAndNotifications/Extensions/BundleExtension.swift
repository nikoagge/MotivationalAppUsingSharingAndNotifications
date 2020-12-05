//
//  BundleExtension.swift
//  MotivationalAppUsingSharingAndNotifications
//
//  Created by Nikolas Aggelidis on 30/11/20.
//  Copyright © 2020 NAPPS. All rights reserved.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from fileName: String) -> T {
        guard let url = self.url(forResource: fileName, withExtension: nil) else { fatalError("Failed to locate \(fileName) in app bundle.") }
        guard let data = try? Data(contentsOf: url) else { fatalError("Failed to get data out of url \(url)") }
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else { fatalError("Failed to decode initial data \(data).") }
        
        return decodedData
    }
}
