import Cocoa
import XCPlayground

let allFonts = NSFontDescriptor.init(fontAttributes: nil).matchingFontDescriptors(withMandatoryKeys: nil)
allFonts.count

class FontSampleView : NSView {
	var label: NSTextField!

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	init(frame frameRect: NSRect, font: NSFont, text: String = "000/666") {
		super.init(frame: frameRect)

		label = NSTextField(frame: NSRect.zero)
		label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		label.backgroundColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)
		label.font = font
		label.stringValue = text
		label.prepareContent(in: self.bounds)

		let fitframe: NSRect
		do {
			let fitsize = label.sizeThatFits(self.bounds.size)
			let fitorigin = NSPoint(x: -0.5 * fitsize.width, y: -0.5 * fitsize.height)
			let fitrect = NSRect.init(origin: fitorigin, size: fitsize)
			let moveToCenter = CGAffineTransform(translationX: 0.5 * self.bounds.width, y: 0.5 * self.bounds.height)

			fitframe = fitrect.applying(moveToCenter)
		}

		label.frame = fitframe
		self.addSubview(label)
	}


	override func draw(_ dirtyRect: NSRect) {
		let bg = NSBezierPath.init(rect: dirtyRect)

		#colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1).setFill()
		bg.fill()


	}
}

for (i, fontDescriptor) in allFonts.enumerated() {
	if let font = NSFont(descriptor: fontDescriptor, size: 120.0) {
		let newView = FontSampleView(frame: NSRect(x: 0, y: 0, width: 1280, height: 720), font: font, text: "\(i)/\(allFonts.count)")

		XCPlayground.XCPlaygroundLiveViewRepresentation.View(newView)
	}
	else {
		print("failed to make text with \(fontDescriptor)")
	}

}


