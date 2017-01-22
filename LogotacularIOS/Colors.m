

#import "Colors.h"

@interface Colors ()

@property NSDictionary* dic;

@end

@implementation Colors

static NSMutableDictionary* _dic = nil;

+ (NSString*) getColorNameForNumber:(NSNumber*)num{
	NSArray* clrs = [NSArray arrayWithObjects:@"dkred", @"red", @"fuchsia", @"pink", @"wisteria", @"purple", @"indigo", @"midnight", @"blue", @"ltblue", @"cyan", @"sage", @"emerald", @"turquoise", @"dkgreen", @"green",@"applegreen", @"yellow",@"ltorg", @"orange",@"dkorg", @"brown",@"chocolate", @"black",@"dkgrey", @"grey", @"ltgrey", @"white", nil];
	int intVal = (int)num.floatValue;
	if(intVal < 0){
		intVal *= -1;
	}
	intVal = intVal % [clrs count];
	return (NSString*)[clrs objectAtIndex:intVal];
}

+ (UIColor*) getColorForNumber:(NSNumber*)num{
	NSString* name = [self getColorNameForNumber:num];
	return [self getColorForString:name];
}

+ (UIColor*) getColorForString:(NSString*)name{
	if(![Colors dictionary]){
		[Colors loadDic];
	}
	UIColor* clr = [Colors dictionary][name];
	return clr;
}

+ (NSString*) getDark:(NSString*)s{
	if(![Colors dictionary]){
		[Colors loadDic];
	}
	return [NSString stringWithFormat:@"bg_%@", s];
}

+ (NSDictionary*) dictionary{
	return _dic;
}

+ (void) loadDic{
	_dic = [[NSMutableDictionary alloc] initWithDictionary:@{}];
	_dic[@"turquoise"] =		[Colors colorWithHexString:0x1abc9c];
	_dic[@"emerald"] =			[Colors colorWithHexString:0x1abc9c];
	_dic[@"turq"] =				[Colors colorWithHexString:0x1abc9c];
	_dic[@"green"] =			[Colors colorWithHexString:0x2ecc71];
	_dic[@"blue"] =				[Colors colorWithHexString:0x2f88ca];
	_dic[@"ltblue"] =			[Colors colorWithHexString:0x82CAFF];
	_dic[@"lightblue"] =		[Colors colorWithHexString:0x82CAFF];
	_dic[@"purple"] =			[Colors colorWithHexString:0x9b59b6];
	_dic[@"darkpurple"] =		[Colors colorWithHexString:0x653aa5];
	_dic[@"dkpurple"] =			[Colors colorWithHexString:0x653aa5];
	_dic[@"indigo"] =			[Colors colorWithHexString:0x653aa5];
	_dic[@"pink"] =				[Colors colorWithHexString:0xDC67CF];
	_dic[@"dkorange"] =			[Colors colorWithHexString:0xd35400];
	_dic[@"darkorg"] =			[Colors colorWithHexString:0xd35400];
	_dic[@"dkorg"] =			[Colors colorWithHexString:0xd35400];
	_dic[@"darkorange"] =		[Colors colorWithHexString:0xd35400];
	_dic[@"dkturq"] =			[Colors colorWithHexString:0x1abc9c];
	_dic[@"dkturquoise"] =		[Colors colorWithHexString:0x1abc9c];
	_dic[@"darkturquoise"] =	[Colors colorWithHexString:0x1abc9c];
	_dic[@"darkgreen"] =		[Colors colorWithHexString:0x27ae60];
	_dic[@"dkgreen"] =			[Colors colorWithHexString:0x27ae60];
	_dic[@"yellow"] =			[Colors colorWithHexString:0xf2DC0A];
	_dic[@"carrot"] =			[Colors colorWithHexString:0xe67e22];
	_dic[@"orange"] =			[Colors colorWithHexString:0xe67e22];
	_dic[@"org"] =				[Colors colorWithHexString:0xe67e22];
	_dic[@"red"] =				[Colors colorWithHexString:0xe74c3c];
	_dic[@"terracotta"] =		[Colors colorWithHexString:0xc0392b];
	_dic[@"darkkred"] =			[Colors colorWithHexString:0xc0392b];
	_dic[@"dkred"] =			[Colors colorWithHexString:0xc0392b];
	_dic[@"ltorange"] =			[Colors colorWithHexString:0xf39c12];
	_dic[@"lightorg"] =			[Colors colorWithHexString:0xf39c12];
	_dic[@"ltorg"] =			[Colors colorWithHexString:0xf39c12];
	_dic[@"lightorange"] =		[Colors colorWithHexString:0xf39c12];
	_dic[@"white"] =			[Colors colorWithHexString:0xdddddd];
	_dic[@"gray"] =				[Colors colorWithHexString:0x95a5a6];
	_dic[@"grey"] =				[Colors colorWithHexString:0x95a5a6];
	_dic[@"lightgrey"] =		[Colors colorWithHexString:0xbdc3c7];
	_dic[@"ltgrey"] =			[Colors colorWithHexString:0xbdc3c7];
	_dic[@"lightgray"] =		[Colors colorWithHexString:0xbdc3c7];
	_dic[@"ltgray"] =			[Colors colorWithHexString:0xbdc3c7];
	_dic[@"darkgray"] =			[Colors colorWithHexString:0x6f7c7d];
	_dic[@"dkgray"] =			[Colors colorWithHexString:0x6f7c7d];
	_dic[@"darkgrey"] =			[Colors colorWithHexString:0x6f7c7d];
	_dic[@"dkgrey"] =			[Colors colorWithHexString:0x6f7c7d];
	_dic[@"midnight"] =			[Colors colorWithHexString:0x34495e];
	_dic[@"dkblue"] =			[Colors colorWithHexString:0x34495e];
	_dic[@"darkblue"] =			[Colors colorWithHexString:0x34495e];
	_dic[@"black"] =			[Colors colorWithHexString:0x000000];
	_dic[@"gray2"] =			[Colors colorWithHexString:0xD1C1A1];
	
	_dic[@"fuchsia"] =			[Colors colorWithHexString:0xDE16AA];
	_dic[@"wisteria"] =			[Colors colorWithHexString:0xDBA4EB];
	_dic[@"cyan"] =				[Colors colorWithHexString:0x15EBE0];
	_dic[@"sage"] =				[Colors colorWithHexString:0xA1C4A4];
	_dic[@"brown"] =			[Colors colorWithHexString:0xA35218];
	_dic[@"chocolate"] =		[Colors colorWithHexString:0x612B04];
	_dic[@"applegreen"] =			[Colors colorWithHexString:0x57F25A];
	
	_dic[@"bg_main"] =				[Colors colorWithHexString:0xffffff];
	_dic[@"bg_files"] =				[Colors colorWithHexString:0xffffff];
	_dic[@"bg_help"] =				[Colors colorWithHexString:0xffffff];
	_dic[@"bg_ref"] =				[Colors colorWithHexString:0xffffff];
	_dic[@"bg_examples"] =			[Colors colorWithHexString:0xffffff];
	
}

+ (UIColor *)colorWithHexString:(int)rgbValue {
	float r = ((rgbValue & 0xFF0000) >> 16)/255.0;
	float g = ((rgbValue & 0xFF00) >> 8)/255.0;
	float b = (rgbValue & 0xFF)/255.0;
	return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

+ (UIColor*) darken:(UIColor*)c withAmount:(float) less{
	CGFloat r, g, b, a;
	if ([c getRed:&r green:&g blue:&b alpha:&a]){
		return [UIColor colorWithRed:MAX(r * less, 0.0) green:MAX(g * less, 0.0) blue:MAX(b * less, 0.0) alpha:a];
	}
	return nil;
}

+ (UIColor*) makeTransparent:(UIColor*)c multiplyAlphaFactor:(float) mult{
	CGFloat r, g, b, a;
	if ([c getRed:&r green:&g blue:&b alpha:&a]){
		return [UIColor colorWithRed:r green:g blue:b alpha:a*mult];
	}
	return nil;
}

+ (UIColor*) darken:(UIColor*)c{
	return [Colors darken:c withAmount:0.65];
}

+ (UIColor*)stringToClr:(NSString*) value{
	CGFloat r = 0.0, g = 0.0, b = 0.0, a = 1.0;
	NSString *stringValue = (NSString *)value;
	sscanf([stringValue UTF8String],
#ifdef __x86_64
		   "%lf %lf %lf %lf",
#else
		   "%f %f %f %f",
#endif
		   &r, &g, &b, &a);
	return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (NSString*)clrToString:(UIColor*)value{
	CGFloat r = 0.0, g = 0.0, b = 0.0, a = 1.0;
	[value getRed: &r
			   green: &g
				blue: &b
			   alpha: &a];
	return [NSString stringWithFormat:@"%.3f %.3f %.3f %.3f", r, g, b, a];
}

+ (float) distBetweenClr:(UIColor*) c0 andClr:(UIColor*) c1{
	CGFloat r = 0.0, g = 0.0, b = 0.0, a = 1.0;
	CGFloat r1 = 0.0, g1 = 0.0, b1 = 0.0, a1 = 1.0;
	BOOL conv0 = [c0 getRed: &r green: &g blue: &b alpha: &a];
	BOOL conv1 = [c1 getRed: &r1 green: &g1 blue: &b1 alpha: &a1];
	if(conv0 && conv1){
		return fabs(r - r1) + fabs(g - g1) + fabs(b - b1) + fabs(a - a1);
	}
	return -1;
}

@end

