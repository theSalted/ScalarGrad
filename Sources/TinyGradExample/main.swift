//
//  main.swift
//  TinyGrad
//
//  Created by Yuhao Chen on 10/15/24.
//

import TinyGrad

let a = Scalar(2.0, label: "a")
let b = Scalar(-3.0, label: "b")
let c = Scalar(10.0, label: "c")
let d = a * b
d.label = "d"
let e = d + c
e.label = "e"
let f = Scalar(-2.0, label: "f")
let l = e * f
l.label = "l"

print("Value: ", l)
print("Tree:")
print(l.displayTree())


