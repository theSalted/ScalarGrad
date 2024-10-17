//
//  Arithmetic.swift
//  TinyGrad
//
//  Created by Yuhao Chen on 10/16/24.
//

import Foundation

// MARK: Operators
extension Scalar {
    public static func +(_ lhs: Scalar, _ rhs: Scalar) -> Scalar {
        let out = Scalar(lhs.value + rhs.value, children: (lhs, rhs), operator: "+")
        out._backward = {
            lhs.gradient = 1.0 * (out.gradient ?? 0.0) + (lhs.gradient ?? 0.0)
            rhs.gradient = 1.0 * (out.gradient ?? 0.0) + (rhs.gradient ?? 0.0)
        }
        return out
    }
    
    public static func *(_ lhs: Scalar, _ rhs: Scalar) -> Scalar {
        let out = Scalar(lhs.value * rhs.value, children: (lhs, rhs), operator: "*")
        out._backward = {
            lhs.gradient = rhs.value * (out.gradient ?? 0.0) + (lhs.gradient ?? 0.0)
            rhs.gradient = lhs.value * (out.gradient ?? 0.0) + (rhs.gradient ?? 0.0)
        }
        return out
    }
}

// MARK: Free Functions


public func tanh(_ x: Scalar) -> Scalar {
    let t = (exp(2 * x.value) - 1) / (exp(2 * x.value) + 1)
    let out = Scalar(t, children: (x, nil), operator: "tanh")
    out._backward = {
        x.gradient = (1 - pow(t, 2)) * (out.gradient ?? 0.0) + (x.gradient ?? 0.0)
    }
    return out
}
