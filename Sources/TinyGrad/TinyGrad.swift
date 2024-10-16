final public class Scalar {
    public var value: Float
    public var label: String?
    
    var gradient: Float = 0.0
    var children = Set<Scalar>()
    var `operator`: String?
    
    public init(_ value: Float, label: String? = nil) {
        self.value = value
        self.label = label
    }
    
    // Keep this initializer internal
    init(_ value: Float, children: (Scalar, Scalar), operator: String) {
        self.value = value
        self.children = [children.0, children.1]
        self.operator = `operator`
    }
}

extension Scalar {
    public static func +(_ lhs: Scalar, _ rhs: Scalar) -> Scalar {
        return Scalar(lhs.value + rhs.value, children: (lhs, rhs), operator: "+")
    }
    
    public static func *(_ lhs: Scalar, _ rhs: Scalar) -> Scalar {
        return Scalar(lhs.value * rhs.value, children: (lhs, rhs), operator: "*")
    }
}

extension Scalar: Equatable {
    public static func == (lhs: Scalar, rhs: Scalar) -> Bool {
        return lhs.value == rhs.value && lhs.children == rhs.children && lhs.label == rhs.label
    }
}

extension Scalar: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        for child in children {
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
    public func displayTree(level: Int = 0, isLast: Bool = true, prefix: String = "") -> String {
        let nodeLabel = label != nil ? "\(label!): " : ""
        var result = prefix + (level > 0 ? (isLast ? "`-- " : "|-- ") : "") + "\(nodeLabel)\(self.value)" + " [∇\(gradient)]"
        
        if let op = self.operator {
            result += "\n" + prefix + (level > 0 ? (isLast ? "    " : "|   ") : "") + "|- " + "(\(op))"
        }
        
        let newPrefix = prefix + (level > 0 ? (isLast ? "    " : "|   ") : "")
        
        let childrenArray = Array(children)
        for (index, child) in childrenArray.enumerated() {
            let isChildLast = index == childrenArray.count - 1
            result += "\n" + child.displayTree(level: level + 1, isLast: isChildLast, prefix: newPrefix)
        }
        
        return result
    }
}
