//
//  EntryContext.swift
//  HydrationSleep
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

enum EntryContext<Value> {
    case new
    case edit(Value)
}
