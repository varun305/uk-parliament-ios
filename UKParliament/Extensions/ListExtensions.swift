import Foundation

extension Array where Element: Any {
    public func toMap<M: Hashable, N>(mappingKey: (Element) -> M, mappingValue: (Element) -> N) -> [M: N] {
        var map = [M: N]()
        self.forEach { element in
            map[mappingKey(element)] = mappingValue(element)
        }
        return map
    }

    public func reversedIf(_ condition: Bool) -> [Element] {
        if condition {
            return self.reversed()
        } else {
            return self
        }
    }
}
