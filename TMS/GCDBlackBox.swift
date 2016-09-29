//
//  GCDBlackBox.swift
//  TMS
//
//  Created by Y50 on 26/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

func performDatabaseOperations(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
