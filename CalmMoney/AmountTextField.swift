import UIKit

class AmountTextField: UITextField, UITextFieldDelegate {

	private var characterLimit: Int?
	
	var correspondingCurrency: HandsOnCurrency?
	weak var converter: ConverterTableViewController?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		delegate = self
	}
	
	
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
		let width = rect.width
		let height = rect.height
		
		
		let context = UIGraphicsGetCurrentContext()
		let myColorspace = CGColorSpaceCreateDeviceRGB();
		
		let colors = [UIColor(rgba: "#34495E").cgColor, UIColor(rgba: "#34495E").cgColor]
		let myGradient = CGGradient(
			colorsSpace: myColorspace,
			colors: colors as CFArray,
			locations: [0.0, 1.0]
		)
		
		var centerPoint:CGPoint
		centerPoint = CGPoint(x:width, y:height)
			
		context?.saveGState()
		context?.addRect(CGRect(x: 0, y: height-1, width: width, height: height))
		context?.clip()
			
			context?.drawRadialGradient(myGradient!,
				startCenter: centerPoint,
				startRadius: 0,
				endCenter: centerPoint,
				endRadius: width,
				options: CGGradientDrawingOptions.drawsAfterEndLocation
			)
		context?.restoreGState()
	
    }
	
	
	@IBInspectable var maxLength: Int {
		get {
			guard let length = characterLimit else {
				return Int.max
			}
			return length
		}
		set {
			characterLimit = newValue
		}
	}
	
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
  
		let currentText = textField.text ?? ""
		let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
		if ( prospectiveText.characters.count <= maxLength ) {
			switch string {
			case "0","1","2","3","4","5","6","7","8","9":
				let currentNumber = NumberFormatter().formatterDollars().number(from: currentText)
				let newNumber = NSDecimalNumber(decimal: currentNumber!.decimalValue).multiplying(by: 10).adding(NSDecimalNumber(string: string))
				setAmount(value: newNumber)
				converter?.amountChanged(sender: self)
			default:
				if string.characters.count == 0 && currentText.characters.count != 0 {
					let currentNumber = NumberFormatter().formatterDollars().number(from: currentText)
					let newNumber = NSDecimalNumber(decimal: currentNumber!.decimalValue).dividing(by: 10).rounding(accordingToBehavior: NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.down, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
					setAmount(value: newNumber)
					converter?.amountChanged(sender: self)
				}
			}
		}
		return false
	}

	public func setAmount(value: NSDecimalNumber) {
		self.text = NumberFormatter().formatterDollars().string(from: value) ?? "0"
		self.correspondingCurrency?.amount.setAmount(value)
	}
}
