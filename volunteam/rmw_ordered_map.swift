//rmw_ordered_map.swift

struct rmw_ordered_map<type_key: Hashable, type_value>
{
        var keys: Array<type_key> = []
        var values: Dictionary<type_key, type_value> = [:]
        
        init()
        {
        }
        
        subscript(key: type_key) -> type_value?
                {
                get
                {
                        return self.values[key]
                }
                set(new_value)
                {
                        if new_value == nil
                        {
                                self.values.removeValueForKey(key)
                                do
                                {
                                        self.keys = self.keys.filter{$0 != key}
                                }
                                return
                        }
                        
                        let old_value = self.values.updateValue(new_value!, forKey: key)
                        if old_value == nil
                        {
                                self.keys.append(key)
                        }
                }
        }
        
        func key_at_index(index: Int) -> type_key?
        {
                if index >= self.count
                {
                        return nil
                }
                else
                {
                        return keys[index]
                }
        }
        
        func value_at_index(index: Int) -> type_value?
        {
                if index >= self.count
                {
                        return nil
                }
                else
                {
                        return values[keys[index]]
                }
        }
        
        var first: type_value?
                {
                        if let first = keys.first
                        {
                                return values[first]
                        }
                        return nil
        }
        
        var last: type_value?
                {
                        if let last = keys.last
                        {
                                return values[last]
                        }
                        return nil
        }
        
        mutating func reverse()
        {
                self.keys = Array(self.keys.reverse())
        }
        
        mutating func insert(key: type_key, value: type_value, at_index: Int)
        {
                self.keys.insert(key, atIndex: at_index)
                self.values[key] = value
        }
        
        mutating func append(key: type_key, value: type_value)
        {
                self.keys.append(key)
                self.values[key] = value
        }
        
        mutating func prepend(key: type_key, value: type_value)
        {
                self.keys.insert(key, atIndex: 0)
                self.values[key] = value
        }
        
        mutating func removeAll(keepCapacity: Bool)
        {
                values.removeAll(keepCapacity: keepCapacity)
                keys.removeAll(keepCapacity: keepCapacity)
        }
        
        var description: String
                {
                        var result = "{\n"
                        for i in 0..<self.keys.count
                        {
                                let key = self.keys[i]
                                result += "[\(i)]: \(key) => \(self[key])\n"
                                
                        }
                        result += "}"
                        return result
        }
        
        var count: Int
                {
                        return keys.count
        }
}