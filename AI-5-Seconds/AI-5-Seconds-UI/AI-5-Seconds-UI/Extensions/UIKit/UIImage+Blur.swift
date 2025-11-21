//
//	UIImage+Blur.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 13.09.2022.
//

import UIKit
import Accelerate

public extension UIImage {
	func blur(radius: Float) -> UIImage {
		let size = self.size
		guard radius > 0, let sourceCGImage: CGImage = self.cgImage else {
			return self
		}

		let imageBuffer = getVImageBuffer(source: sourceCGImage, scaledToSize: size)

		guard var srcBuffer = imageBuffer else {
			return self
		}
		
		let pixelBuffer = malloc(srcBuffer.rowBytes * Int(srcBuffer.height))
		defer {
			free(pixelBuffer)
		}

		var outBuffer = vImage_Buffer(data: pixelBuffer, height: srcBuffer.height, width: srcBuffer.width, rowBytes: srcBuffer.rowBytes)

		var boxSize = UInt32(floor(radius * 5))
		boxSize |= 1;

		let error = vImageTentConvolve_ARGB8888(&srcBuffer, &outBuffer, nil, 0, 0, boxSize, boxSize, nil, UInt32(kvImageEdgeExtend))

		guard error == vImage_Error(kvImageNoError) else {
			return self
		}

		var format = arg888format()
		guard let cgResult = vImageCreateCGImageFromBuffer(&outBuffer, &format, nil, nil, vImage_Flags(kvImageNoFlags), nil) else {
			return self
		}

		let result = UIImage(cgImage: cgResult.takeRetainedValue(), scale: self.scale, orientation: self.imageOrientation)

		return result
	}

	internal func getVImageBuffer(source: CGImage, scaledToSize: CGSize) -> vImage_Buffer? {
		
		var srcBuffer = vImage_Buffer()

		var format = arg888format()
		var error = vImageBuffer_InitWithCGImage(&srcBuffer, &format, nil, source, vImage_Flags(kvImageNoFlags))

		guard error == vImage_Error(kvImageNoError) else {
			free(srcBuffer.data)
			return nil
		}

		var ratio: CGFloat = 1
		let sourceWidth = CGFloat(source.width)
		let sourceHeight = CGFloat(source.height)

		if sourceWidth > scaledToSize.width && sourceHeight > scaledToSize.height {
			ratio = max(scaledToSize.width / sourceWidth, scaledToSize.height / sourceHeight)
		}

		if ratio == 1 {
			return srcBuffer
		} else {
			let dstWidth = vImagePixelCount(sourceWidth * ratio)
			let dstHeight = vImagePixelCount(sourceHeight * ratio)
			let dstBytesPerPixel = source.bytesPerRow / source.width
			let dstBytesPerRow = dstBytesPerPixel * Int(dstWidth)
			let dstData = malloc( dstBytesPerRow * Int(dstHeight) )

			var dstBuffer = vImage_Buffer(data: dstData, height: dstHeight, width: dstWidth, rowBytes: dstBytesPerRow)

			error = vImageScale_ARGB8888(&srcBuffer, &dstBuffer, nil, UInt32(kvImageHighQualityResampling))
			free(srcBuffer.data)

			guard error == vImage_Error(kvImageNoError) else {
				free(dstData)
				return nil
			}
			return dstBuffer
		}
	}
	
	internal func arg888format() -> vImage_CGImageFormat {
		return vImage_CGImageFormat(
					bitsPerComponent: 8,
					bitsPerPixel: 32,
					colorSpace: nil,
					bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue),
					version: 0,
					decode: nil,
					renderingIntent: .defaultIntent)
	}
}
