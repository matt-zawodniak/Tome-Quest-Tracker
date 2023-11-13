//
//  QuestTrackerModel.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/18/23.
//

import SwiftUI

struct QuestTrackerModel {
	
	func setDate(quest: Quest, value: Bool) {
		if value == true {
			quest.dueDate = Date()
		}
		else {
			quest.dueDate = nil
		}
	}
}

enum QuestDifficulty: CaseIterable, CustomStringConvertible {
	case easy
	case average
	case hard
	
	var description: String {
		switch self {
		case .easy: return "Easy"
		case .average: return "Average"
		case .hard: return "Hard"
		}
	}
}

enum QuestLength: CaseIterable, CustomStringConvertible {
	case short
	case average
	case long
	
	var description: String {
		switch self {
		case .short: return "Short"
		case .average: return "Average"
		case .long: return "Long"
		}
	}
}

extension Optional where Wrapped == String {
	var _bound: String? {
		get {
			return self
		}
		set {
			self = newValue
		}
	}

	public var bound: String {
		get {
			return _bound ?? ""
		}
		set {
			_bound = newValue.isEmpty ? nil : newValue
		}
	}
}

extension Optional where Wrapped == Date {
	var exists: Bool {
		if self == nil {
			return false
		} else {
			return true
		}
	}
}