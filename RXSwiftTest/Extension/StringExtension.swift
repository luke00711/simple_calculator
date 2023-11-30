//
//  StringExtension.swift
//  RXSwiftTest
//
//  Created by Lukman Lawi on 29/11/23.
//

import Foundation
extension Decimal {
    var significantFractionalDecimalDigits: Int {
        return max(-exponent, 0)
    }
}

extension String {
    func hasDecimalPoint() -> Bool {
        let regex = try! NSRegularExpression(pattern: "\\.")
        let matches = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
        return matches.count > 0
    }
    
    func doubleValue() -> CGFloat {
        return Double(self) ?? 0.0
    }
    
    func intValue() -> Int {
        return Int(self) ?? 0
    }
    
    func doubleToStringPrecision( ref : String?, secondRef: String?) -> String {
        let precision =  Decimal(string: ref ?? "0")?.significantFractionalDecimalDigits ?? 0
        let precision2 =  Decimal(string: secondRef ?? "0")?.significantFractionalDecimalDigits ?? 0

        let fin =  precision > precision2 ? precision : precision2
        return String(format: "%.\(fin)f",  NSDecimalNumber(string: self).doubleValue)
    }
}

extension NSNumber {
    class func addingValueFrom( totalValue : String? , nextValue: String?) -> String {
      let result = NSDecimalNumber(string: totalValue).adding(NSDecimalNumber(string: nextValue))
        
        let hasDecimal = totalValue?.hasDecimalPoint() == true || nextValue?.hasDecimalPoint() == true
        
        return hasDecimal ? "\(result.doubleValue)".doubleToStringPrecision(ref: totalValue, secondRef: nextValue) : "\(result.intValue)"
    }
    
    class func subtractValueFrom( totalValue : String? , nextValue: String?) -> String {
        let result = NSDecimalNumber(string: totalValue).subtracting(NSDecimalNumber(string: nextValue))
        
        let hasDecimal = totalValue?.hasDecimalPoint() == true || nextValue?.hasDecimalPoint() == true
        
        return hasDecimal ? "\(result.doubleValue)".doubleToStringPrecision(ref: totalValue, secondRef: nextValue) : "\(result.intValue)"
    }
    
    
    class func multiplyValueFrom( totalValue : String? , nextValue: String?) -> String {
        let result = NSDecimalNumber(string: totalValue).multiplying(by:(NSDecimalNumber(string: nextValue)))
        
        let hasDecimal = totalValue?.hasDecimalPoint() == true || nextValue?.hasDecimalPoint() == true
        
        return hasDecimal ? "\(result.doubleValue)".doubleToStringPrecision(ref: totalValue, secondRef: nextValue) : "\(result.intValue)"
    }
    
    
    class func divideValueFrom( totalValue : String? , nextValue: String?, isMod: Bool? = false) -> String {
        let result = NSDecimalNumber(string: totalValue).dividing(by:(NSDecimalNumber(string: nextValue)))
        
   
        let hasDecimal = totalValue?.hasDecimalPoint() == true || nextValue?.hasDecimalPoint() == true ||   result.stringValue.hasDecimalPoint()
        
        return hasDecimal ? "\(result.doubleValue)".doubleToStringPrecision(ref: totalValue, secondRef: isMod == true ? result.stringValue :  nextValue) : "\(result.intValue)"
    }
    
}
