import Cocoa
import XCPlayground

let allFonts = NSFontDescriptor.init(fontAttributes: nil).matchingFontDescriptors(withMandatoryKeys: nil).prefix(120)
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
		label.font = font
		label.stringValue = text

		let fitframe: NSRect
		do {
			let fitsize = label.sizeThatFits(self.bounds.size)
			let fitorigin = NSPoint(x: -0.5 * fitsize.width, y: -0.5 * fitsize.height)
			let fitrect = NSRect(origin: fitorigin, size: fitsize).offsetBy(dx: 2.0, dy: 2.0)
			let moveToCenter = CGAffineTransform(translationX: 0.5 * self.bounds.width, y: 0.5 * self.bounds.height)

			fitframe = fitrect.applying(moveToCenter)
		}

		label.frame = fitframe
		self.addSubview(label)
		label.needsLayout = true
	}


	override func draw(_ dirtyRect: NSRect) {
		let bg = NSBezierPath.init(rect: dirtyRect)

		#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill()
		bg.fill()
	}
}

extension NSImage {
	@discardableResult
	func saveAsPNG(url: URL) -> Bool {
		guard let tiffData = self.tiffRepresentation else {
			print("failed to get tiffRepresentation. url: \(url)")
			return false
		}
		let imageRep = NSBitmapImageRep(data: tiffData)
		guard let imageData = imageRep?.representation(using: .PNG, properties: [:]) else {
			print("failed to get PNG representation. url: \(url)")
			return false
		}
		do {
			try imageData.write(to: url)
			return true
		} catch {
			print("failed to write to disk. url: \(url)")
			return false
		}
	}
}

for (i, fontDescriptor) in allFonts.enumerated() {
	if let font = NSFont(descriptor: fontDescriptor, size: 120.0) {
		let rect720 = NSRect(origin: .zero, size: NSSize(width: 1280, height: 720))
		let newView = FontSampleView(frame: rect720, font: font, text: "\(i+1)/\(allFonts.count)")

		let eps = newView.dataWithEPS(inside: rect720)
		if let image = NSImage(data: eps) {

			let fm = FileManager.default

			let saveDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("SampleImages", isDirectory: true)

			do {
				try fm.createDirectory(at: saveDir, withIntermediateDirectories: true, attributes: nil)

				let saveURL = URL.init(fileURLWithPath: "fontimage\(1+i).png", relativeTo: saveDir)
				image.saveAsPNG(url: saveURL)
			}
			catch {
				print(error.localizedDescription)
			}

		}
	}
	else {
		print("failed to make text with \(fontDescriptor)")
	}

}


