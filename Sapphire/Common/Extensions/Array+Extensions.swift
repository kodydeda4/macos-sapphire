//
//  Array+Extensions.swift
//  Sapphire
//
//  Created by Kody Deda on 5/26/21.
//

import Overture

extension Array {
    
    /// Returns the result of setting `Element`.keypaths
    func reduce<Value> (
        set keyPath: WritableKeyPath<Self.Element, Value>,
        to value: Value,
        where predicate: (Self.Element) -> Bool = { _ in true }
    ) -> [Self.Element] {
        self.reduce(into: []) { array, element in
            array.append(
                predicate(element)
                    ? with(element, set(keyPath, value))
                    : element
            )
        }
    }
    
    /// Returns the result of setting `Element`.keypaths
    func reduce<Value> (
        set keyPath: WritableKeyPath<Self.Element, Value>,
        to value: (Self.Element) -> Value,
        where predicate: (Self.Element) -> Bool = { _ in true }
    ) -> [Self.Element] {
        self.reduce(into: []) { array, element in
            array.append(
                predicate(element)
                    ? with(element, set(keyPath, value(element)))
                    : element
            )
        }
    }

}


