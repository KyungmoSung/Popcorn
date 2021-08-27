//
//  AnyValue.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/12/15.
//

import Foundation

enum AnyValue: Codable {
    case int(Int)
    case double(Double)
    case string(String)
    case bool(Bool)
    case array([AnyValue])
    case dict([String: AnyValue])
    case empty

    init(_ value: Int?) {
        if let value = value {
            self = .int(value)
        } else {
            self = .empty
        }
    }
    
    init(_ value: Double?) {
        if let value = value {
            self = .double(value)
        } else {
            self = .empty
        }
    }
    
    init(_ value: String?) {
        if let value = value {
            self = .string(value)
        } else {
            self = .empty
        }
    }
    
    init(_ value: Bool?) {
        if let value = value {
            self = .bool(value)
        } else {
            self = .empty
        }
    }
    
    init(_ value: [AnyValue]?) {
        if let value = value {
            self = .array(value)
        } else {
            self = .empty
        
        }
    }
    init(_ value: [String: AnyValue]?) {
        if let value = value {
            self = .dict(value)
        } else {
            self = .empty
        }
    }
    
    init(from decoder: Decoder) throws {
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }
        
        if let double = try? decoder.singleValueContainer().decode(Double.self) {
            self = .double(double)
            return
        }

        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        
        if let bool = try? decoder.singleValueContainer().decode(Bool.self) {
            self = .bool(bool)
            return
        }
        
        if let array = try? decoder.singleValueContainer().decode([AnyValue].self) {
            self = .array(array)
            return
        }
        
        if let dict = try? decoder.singleValueContainer().decode([String: AnyValue].self) {
            self = .dict(dict)
            return
        }
        
        self = .empty
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .int(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .bool(let value):
            try container.encode(value)
        case .array(let value):
            try container.encode(value)
        case .dict(let value):
            try container.encode(value)
        case .empty:
            break
        }
    }
}

extension AnyValue {
    var intValue: Int? {
        switch self {
        case .int(let value):
            return value
        case .double(let value):
            return Int(value)
        case .string(let value):
            return Int(value)
        case .bool(let value):
            return value ? 1 : 0
        default:
            return nil
        }
    }
    
    var doubleValue: Double? {
        switch self {
        case .int(let value):
            return Double(value)
        case .double(let value):
            return value
        case .string(let value):
            return Double(value)
        default:
            return nil
        }
    }
    
    var stringValue: String? {
        switch self {
        case .int(let value):
            return String(value)
        case .double(let value):
            return String(value)
        case .string(let value):
            return value
        case .bool(let value):
            return value ? "Y" : "N"
        default:
            return nil
        }
    }
    
    var boolValue: Bool? {
        switch self {
        case .int(let value):
            return value != 0
        case .double(let value):
            return value != 0
        case .string(let value):
            switch value.lowercased() {
            case "y", "true", "success", "1":
                return true
            default:
                return false
            }
        case .bool(let value):
            return value
        default:
            return nil
        }
    }
    
    var arrayValue: [AnyValue]? {
        switch self {
        case .array(let value):
            return value
        default:
            return nil
        }
    }
    
    var dictValue: [String: AnyValue]? {
        switch self {
        case .dict(let value):
            return value
        default:
            return nil
        }
    }
    
    func dateValue(format: String = "yyyy-MM-dd") -> Date? {
        switch self {
        case .string(let value):
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter.date(from: value)
        default:
            return nil
        }
    }
}
