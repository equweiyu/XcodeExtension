//
//  TypeModel.swift
//  XcodeExtension
//
//  Created by 白天伟 on 2019/1/24.
//  Copyright © 2019 baitianwei. All rights reserved.
//

import Foundation
protocol TypeModel {
    var key: String { get set }
    var valueTypeName: String { get }
}

private func covertToTypeModel(key: String, json: Any) -> TypeModel {
    if let map = json as? [String: Any] {
        return ObjectModel(key: key, items: Array(map).map({covertToTypeModel(key: $0.key, json: $0.value)}))
    } else if let list = json as? [Any] {
        return ArrayModel(key: key, item: covertToTypeModel(key: key, json: list.first ?? "Null"))
    } else {
        return PaitModel(key: key, value: json)
    }
}

func covertToObjectModel(key: String, json: Any) -> ObjectModel? {
    return covertToTypeModel(key: key, json: json) as? ObjectModel
}

struct ObjectModel: TypeModel {
    var key: String

    var valueTypeName: String {
        return convertFromSnakeCase(key)[0..<1].uppercased() + convertFromSnakeCase(key)[1...]
    }

    let items: [TypeModel]

    func show() -> String {
        let listShow: (String) -> String = {(f) in "[\(f)]"}
        let parameterShow: (String, String) -> String = {(key, typeName) in "    let \(key): \(typeName)"}
        let classShow: (String, String) -> String = {(name, body) in "class \(name) {\n\(body)\n}"}
        let valueTypeNameShow: (TypeModel) -> String = {(f) in
            if f is ObjectModel {
                return f.valueTypeName
            } else if f is ArrayModel {
                return listShow(f.valueTypeName)
            } else {
                return f.valueTypeName
            }
        }
        let keyShow: (String) -> String = {(f) in convertFromSnakeCase(f)}
        var result: String = classShow(valueTypeName, items.map({parameterShow(keyShow($0.key), valueTypeNameShow($0))}).joined(separator: "\n"))
        for item in items {
            if let objectItem = item as? ObjectModel {
                result += "\n" + objectItem.show()
            } else if let arrayItem = item as? ArrayModel {
                if let objectItem = arrayItem.item as? ObjectModel {
                    result += "\n" + objectItem.show()
                }
            }
        }
        return result
    }
}
struct ArrayModel: TypeModel {
    var key: String

    var valueTypeName: String {
        return item.valueTypeName
    }

    let item: TypeModel

}
struct PaitModel: TypeModel {
    var key: String

    var valueTypeName: String {
        if let _ = value as? String {
            return "String"
        } else if let _ = value as? Int {
            return "Int"
        } else if let _ = value as? Double {
            return "Double"
        } else if let _ = value as? Bool {
            return "Bool"
        } else {
            return "\(Mirror(reflecting: value).subjectType)"
        }
    }

    let value: Any
}

extension Data {
    func JSONObject() throws  -> Any? {
        return try JSONSerialization.jsonObject(with: self, options: [.allowFragments])
    }
}
