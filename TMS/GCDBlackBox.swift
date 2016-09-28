//
//  GCDBlackBox.swift
//  TMS
//
//  Created by Y50 on 26/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}

func performDatabaseOperations(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}