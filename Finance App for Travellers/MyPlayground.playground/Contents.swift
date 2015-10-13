//: Playground - noun: a place where people can play

import UIKit


extension NSDecimalNumber {
	func abs() -> NSDecimalNumber {
		if self.compare(NSDecimalNumber.zero()) == NSComparisonResult.OrderedAscending {
			return NSDecimalNumber.zero().decimalNumberBySubtracting(self)
		} else {
			return self
		}
	}
}



let formatter = NSNumberFormatter()
formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
let locale = NSLocale(
	localeIdentifier: NSLocale.localeIdentifierFromComponents(
		[
			NSLocaleCurrencyCode: "AUD",
			NSLocaleLanguageCode: NSBundle.mainBundle().preferredLocalizations.first!
		]
	)
)
formatter.locale = locale
print(locale.localeIdentifier)
let number:NSDecimalNumber = NSDecimalNumber(string: "-150,40")
if let string = formatter.stringFromNumber(number) {
	
	let amountString = NSString(string: string)
	let firstAttributes = [NSFontAttributeName:UIFont.systemFontOfSize(20)]
	let secondAttributes = [NSFontAttributeName:UIFont.familyNames() systemFontOfSize(32)]
	
	
	var attributedString = NSMutableAttributedString(string: amountString as String, attributes: firstAttributes)
	
	//let range = string.rangeOfCharacterFromSet(NSCharacterSet(charactersInString: "0123456789.,"))
	//let range = amountString.rangeOfCharacterFromSet(NSCharacterSet(charactersInString: "0123456789.,"))
	let str1 = String(number.abs())
	let range = amountString.rangeOfString(str1)

	attributedString.addAttributes(secondAttributes, range: range)
	attributedString.addAttributes(secondAttributes, range: amountString.rangeOfCharacterFromSet(NSCharacterSet(charactersInString: "-")))
	
} else {
	var attributedString = NSMutableAttributedString(string: "")
}
