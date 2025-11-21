//
//	UIFont+LoadFonts.m
//	Translate-UI
//
//	Created by Anna Radchenko on 03.05.2022.
//

//#import <UIKit/UIKit.h>
//#import <CoreText/CoreText.h>
//
//@implementation UIFont (LoadFonts)
//
//+ (void)load {
//	static dispatch_once_t onceToken;
//	dispatch_once(&onceToken, ^{
//		NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.translator.sz.tranlator-app-ios-UI"];
//		NSArray<NSURL *> *urls = [bundle URLsForResourcesWithExtension:@"ttf" subdirectory:nil];
//		
//		for (NSURL *url in urls) {
//			NSData *data = [NSData dataWithContentsOfURL:url];
//			
//			CFErrorRef error;
//			CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
//			CGFontRef font = CGFontCreateWithDataProvider(provider);
//			if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
//				CFStringRef errorDescription = CFErrorCopyDescription(error);
//				NSLog(@"Failed to load font: %@", errorDescription);
//				CFRelease(errorDescription);
//			}
//			
//			CFRelease(font);
//			CFRelease(provider);
//		}
//	});
//}
//
//@end
