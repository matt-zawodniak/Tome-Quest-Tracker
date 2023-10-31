//
//  QuestTrackerViewModel.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/20/23.
//

import SwiftUI

class QuestTrackerViewModel: ObservableObject {

	@Published var trackerModel = QuestTrackerModel()
	
}

extension Date {
	var string: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
		dateFormatter.timeStyle = .short
		return dateFormatter.string(from: self)
	}
	var dayOnly: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEEE"
		
		return dateFormatter.string(from: self)
	}
	var timeOnly: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .none
		dateFormatter.timeStyle = .short
		return dateFormatter.string(from: self)
	}
}

extension Optional where Wrapped == Date {
	var _bound: Date? {
		get {
			return self
		}
		set {
			self = newValue
		}
	}
	public var bound: Date {
		get {
			return _bound ?? Date()
		}
		set {
			_bound = newValue
		}
	}
	var exists: Bool {
		if self == nil {
			return false
		} else {
			return true
		}
	}
	var string: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
		dateFormatter.timeStyle = .short
		if self == nil {
			return ""
		} else {
			return dateFormatter.string(from: self!)
		}
	}
	var dateOnly: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
		if self == nil {
			return ""
		} else {
			return dateFormatter.string(from: self!)
		}
	}
	var dayOnly: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEEE"
		if self == nil {
			return ""
		} else {
			return dateFormatter.string(from: self!)
		}
	}
	var timeOnly: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .none
		dateFormatter.timeStyle = .short
		if self == nil {
			return ""
		} else {
			return dateFormatter.string(from: self!)
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
