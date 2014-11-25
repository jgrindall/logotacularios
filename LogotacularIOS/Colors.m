

#import "Colors.h"

@interface Colors ()

@property NSDictionary* dic;

@end

@implementation Colors

static NSMutableDictionary* _dic = nil;

+ (UIColor*) getColorForString:(NSString*)name{
	if(![Colors dictionary]){
		[Colors loadDic];
	}
	UIColor* clr = [Colors dictionary][name];
	return clr;
}

+ (NSString*) getDark:(NSInteger)i{
	if(![Colors dictionary]){
		[Colors loadDic];
	}
	return [NSString stringWithFormat:@"bg%li", (long)i];
}

+ (NSDictionary*) dictionary{
	return _dic;
}

+ (void) loadDic{
	_dic = [[NSMutableDictionary alloc] initWithDictionary:@{}];
	_dic[@"turquoise"] =		[Colors colorWithHexString:0x1abc9c];
	_dic[@"turq"] =				[Colors colorWithHexString:0x1abc9c];
	_dic[@"green"] =			[Colors colorWithHexString:0x2ecc71];
	_dic[@"blue"] =				[Colors colorWithHexString:0x2f88ca];
	_dic[@"purple"] =			[Colors colorWithHexString:0x9b59b6];
	_dic[@"dkorange"] =			[Colors colorWithHexString:0xd35400];
	_dic[@"darkorg"] =			[Colors colorWithHexString:0xd35400];
	_dic[@"dkorg"] =			[Colors colorWithHexString:0xd35400];
	_dic[@"darkorange"] =		[Colors colorWithHexString:0xd35400];
	_dic[@"dkturq"] =			[Colors colorWithHexString:0x16a085];
	_dic[@"dkturquoise"] =		[Colors colorWithHexString:0x16a085];
	_dic[@"darkturquoise"] =	[Colors colorWithHexString:0x16a085];
	_dic[@"darkgreen"] =		[Colors colorWithHexString:0x27ae60];
	_dic[@"dkgreen"] =			[Colors colorWithHexString:0x27ae60];
	_dic[@"yellow"] =			[Colors colorWithHexString:0xf1c40f];
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
	_dic[@"white"] =			[Colors colorWithHexString:0xecf0f1];
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
	_dic[@"black"] =			[Colors colorWithHexString:0x000000];
	
	_dic[@"bg0"] =				[Colors colorWithHexString:0x75347a];
	_dic[@"bg1"] =				[Colors colorWithHexString:0xbd4b00];
	_dic[@"bg2"] =				[Colors colorWithHexString:0x27ae60];
	_dic[@"bg3"] =				[Colors colorWithHexString:0x75347a];
}

+ (UIColor *)colorWithHexString:(int)rgbValue {
	float r = ((rgbValue & 0xFF0000) >> 16)/255.0;
	float g = ((rgbValue & 0xFF00) >> 8)/255.0;
	float b = (rgbValue & 0xFF)/255.0;
	return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

@end

