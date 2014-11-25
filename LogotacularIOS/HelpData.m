//
//  HelpData.m
//  LogotacularIOS
//
//  Created by John on 20/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "HelpData.h"
#import <UIKit/UIKit.h>

@interface HelpData ()

@property NSDictionary* _dic;

@end

@implementation HelpData

static NSMutableDictionary* _dic = nil;

NSString* const STYLES = @"<style>h1, p, h2, h3, div, span, ul, li{font-family: 'Lato-Regular';font-size: 18px;color:$color}h1,h2,h3{font-size:24px;}pre, span.mono{font-family:'DroidSansMono';color:$color;}p.quote{font-size: 14px;}</style>";

+ (NSString*) getMedia:(NSInteger)index{
	return @"";
}

+ (NSString*) getButtonPos:(NSInteger)index{
	return @"";
}

+ (NSString*) getExampleData:(NSInteger)index{
	return @"";
}

+ (NSString*) getTop:(NSInteger)index{
	NSString* textColor = @"#ffffff";
	NSString* styles = [STYLES stringByReplacingOccurrencesOfString:@"$color" withString:textColor];
	NSDictionary* help = (NSDictionary*)[self getDictionary][@"help"][index];
	if(help){
		NSString* paras = [HelpData getParas:(NSArray*)help[@"title"]];
		return [NSString stringWithFormat:@"%@<h3>%@</h3>%@", styles, help[@"header"], paras];
	}
	else{
		return @"";
	}
}

+ (NSString*) getContents:(NSInteger)index{
	NSString* textColor = @"#ffffff";
	NSString* styles = [STYLES stringByReplacingOccurrencesOfString:@"$color" withString:textColor];
	NSDictionary* help = (NSDictionary*)[self getDictionary][@"help"][index];
	if(help){
		NSString* paras = [HelpData getParas:(NSArray*)help[@"contents"]];
		return [NSString stringWithFormat:@"%@%@", styles, paras];
	}
	else{
		return @"";
	}
}

+ (NSString*) getParas:(NSArray*)paras{
	NSString* s = @"";
	for (NSString* p in paras) {
		s = [s stringByAppendingString:p];
	}
	return s;
}

+ (NSDictionary*)getDictionary{
	if(!_dic){
		NSError * error;
		NSString* path = [[NSBundle mainBundle] pathForResource:@"assets/help/help" ofType:@"json"];
		NSString* fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
		if(error){
			NSLog(@"Error reading file: %@", error.localizedDescription);
		}
		_dic = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)[NSJSONSerialization JSONObjectWithData:[fileContents dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL]];
	}
	return _dic;
}

@end

