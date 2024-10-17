final public class Scalar: ExpressibleByFloatLiteral {
    public var value: Float
    public var label: String?
    public var gradient: Float? = nil
    var neighbors = Set<Scalar>()
    var `operator`: String?
    var _backward: (() -> Void) = {}
    
    public init(_ value: Float, label: String? = nil) {
        self.value = value
        self.label = label
    }
    
    // Implement ExpressibleByFloatLiteral
    public required init(floatLiteral value: Float) {
        self.value = value
    }
    
    // Keep this initializer internal
    init(_ value: Float, elements: (Scalar?, Scalar?), operator: String) {
        self.value = value
        
        if let leftChild = elements.0 {
            self.neighbors.insert(leftChild)
        }
        if let rightChild = elements.1 {
            self.neighbors.insert(rightChild)
        }
        self.operator = `operator`
    }
    
    public func backward() {
        self.gradient = 1.0
        
        let topo = self.makeTopologicalOrdered()
        for node in topo.reversed() {
            node._backward()
        }
    }
}

extension Scalar {
    func makeTopologicalOrdered() -> [Scalar] {
        var visited = Set<Scalar>()
        var topo = [Scalar]()
        
        Scalar.buildTopologicalOrder(from: self, visited: &visited, to: &topo)
        
        return topo
    }
    
    fileprivate static func buildTopologicalOrder(from s: Scalar, visited: inout Set<Scalar>, to topo: inout [Scalar]) {
        if !visited.contains(s) {
            visited.insert(s)
            for child in s.neighbors {
                buildTopologicalOrder(from: child, visited: &visited, to: &topo)
            }
            topo.append(s)
        }
    }

}


extension Scalar: Equatable {
    public static func ==(lhs: Scalar, rhs: Scalar) -> Bool {
        return lhs.value == rhs.value && lhs.neighbors == rhs.neighbors && lhs.label == rhs.label
    }
}

extension Scalar: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        for child in neighbors {
            hasher.combine(child)
        }
        hasher.combine(label)
    }
}

extension Scalar: CustomStringConvertible {
    public var description: String {
        return String(self.value)
    }
}

extension Scalar {
    public func makeAsciiTree(level: Int = 0, isLast: Bool = true, prefix: String = "") -> String {
        let nodeLabel = label != nil ? "\(label!): " : ""
        let gradientLabel = gradient != nil ? " [∇\(gradient!)]" : ""
        var result = prefix + (level > 0 ? (isLast ? "`-- " : "|-- ") : "") + "\(nodeLabel)\(self.value)" + gradientLabel
        
        if let op = self.operator {
            result += "\n" + prefix + (level > 0 ? (isLast ? "    " : "|   ") : "") + "|- " + "(\(op))"
        }
        
        let newPrefix = prefix + (level > 0 ? (isLast ? "    " : "|   ") : "")
        
        let childrenArray = Array(neighbors)
        for (index, child) in childrenArray.enumerated() {
            let isChildLast = index == childrenArray.count - 1
            result += "\n" + child.makeAsciiTree(level: level + 1, isLast: isChildLast, prefix: newPrefix)
        }
        
        return result
    }
}
