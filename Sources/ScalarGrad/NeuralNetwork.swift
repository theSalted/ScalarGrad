//
//  NeuralNetwork.swift
//  ScalarGrad
//
//  Created by Yuhao Chen on 10/17/24.
//

public struct Neuron {
    public var weight: [Scalar]
    public var bias: Scalar
    
    public var parameters: [Scalar] {
        return self.weight + [self.bias]
    }
    
    public init(inputSize: Int) {
        self.weight = (0..<inputSize).map { _ in Scalar(Float.random(in: -1.0...1.0)) }
        self.bias = Scalar(Float.random(in: -1.0...1.0))
    }
    
    public func callAsFunction(_ x: [Scalar]) -> Scalar {
        let activation = zip(weight, x).reduce(bias) { $0 + $1.0 * $1.1 }
        let out = tanh(activation)
        return out
    }
}


public struct Layer {
    public var neurons: [Neuron]
    
    public var parameters: [Scalar] {
        return neurons.flatMap { neuron in neuron.parameters }
    }
    
    public init(inputSize: Int, outputSize: Int) {
        self.neurons = (0..<outputSize).map { _ in Neuron(inputSize: inputSize)}
    }
    
    public func callAsFunction(_ x: [Scalar]) -> [Scalar] {
        let out = self.neurons.map { $0.callAsFunction(x) }
        return out
    }
}

public struct MLP {
    public var layers: [Layer]
    
    public var parameters: [Scalar] {
        return layers.flatMap { layer in layer.parameters }
    }
    
    public init(inputSize: Int, layerSizes: [Int]) {
        let sizes = [inputSize] + layerSizes
        self.layers = (0..<layerSizes.count).map { i in
            Layer(inputSize: sizes[i], outputSize: sizes[i + 1])
        }
    }
    
    public func callAsFunction(_ x: [Scalar]) -> [Scalar] {
        var x = x
        for layer in layers {
            x = layer.callAsFunction(x)
        }
        return x
    }
}
