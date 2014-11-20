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

NSString* const STYLES = @"<style>h1, p, h2, h3, div, span{font-family: 'Lato-Regular';font-size: 24px;color:$color}p{font-size: 19px;}p.code, pre{font-family:'DroidSansMono', font-size: 48px !important;color:$color}p.quote{font-size: 14px;}</style>";

+ (NSString*) getHtml:(NSInteger)index withBri:(float)bri{
	NSString* textColor = ((bri < 0.6) ? @"#ffffff" : @"#222222");
	NSString* styles = [STYLES stringByReplacingOccurrencesOfString:@"$color" withString:textColor];
	NSDictionary* help = (NSDictionary*)[self getDictionary][@"help"][index];
	NSString* paras = [HelpData getParas:(NSArray*)help[@"contents"]];
	return [NSString stringWithFormat:@"%@<h3>%@</h3>%@", styles, help[@"header"], paras];
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

