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

NSString* const STYLES0 = @"h1, p, h2, h3, div, span, ul, li, td, td, th{font-family: 'Lato-Regular';font-size: 18px;color:white;}";
NSString* const STYLES1 = @"table{border-collapse: collapse;font-size:19px;margin-left:43px;margin-top:10px;}td{font-size:19px;}tr,td{width:100px;}table,tr{width:900px;}td, th{padding:12px;border:2px solid #1e8549;}td:nth-child(2n+1){text-align:center;}th{font-size:24px;padding:6px;text-align:center;}tr{width:100%;padding:5px;}td:nth-child(1){width:25%}td:nth-child(2){width:25%}td:nth-child(3){width:50%}tr:nth-child(2n+1){background:#1e8549;}";
NSString* const STYLES2 = @"h1,h2,h3{font-size:24px;}";
NSString* const STYLES3 = @"li{padding:10px;}";
NSString* const STYLES4 = @"pre, span.mono{font-family:'DroidSansMono';color:white;font-size:20px;}p.quote{font-size: 14.5px;font-style:italic;}";

+ (NSString*) getKey:(NSString*)key inSection:(NSString*)section withIndex:(NSInteger)index withStyles:(BOOL)styles{
	NSDictionary* sectionDic = (NSDictionary*)[self getDictionary][section][index];
	if(sectionDic){
		if(styles){
			return [NSString stringWithFormat:@"%@%@", [self getStyles], sectionDic[key]];
		}
		else{
			return [NSString stringWithFormat:@"%@", sectionDic[key]];
		}
	}
	return @"";
}

+ (NSString*) getKeys:(NSString*)key inSection:(NSString*)section withIndex:(NSInteger)index withStyles:(BOOL)styles{
	NSDictionary* sectionDic = (NSDictionary*)[self getDictionary][section][index];
	if(sectionDic){
		NSString* paras = [HelpData getParas:(NSArray*)sectionDic[key]];
		if(styles){
			return [NSString stringWithFormat:@"%@%@", [HelpData getStyles], paras];
		}
		else{
			return [NSString stringWithFormat:@"%@", paras];
		}
	}
	return @"";
}

+ (NSString*) getHelpMovie:(NSInteger)index{
	return [HelpData getKey:@"popup" inSection:@"help" withIndex:index withStyles:NO];
}

+ (NSString*) getHelpMedia:(NSInteger)index{
	return [HelpData getKey:@"media" inSection:@"help" withIndex:index withStyles:NO];
}

+ (NSString*) getHelpFile:(NSInteger)index{
	return [HelpData getKey:@"file" inSection:@"help" withIndex:index withStyles:NO];
}

+ (NSString*) getExampleMedia:(NSInteger)index{
	return [HelpData getKey:@"media" inSection:@"examples" withIndex:index withStyles:NO];
}

+ (NSString*) getExampleFile:(NSInteger)index{
	return [HelpData getKey:@"file" inSection:@"examples" withIndex:index withStyles:NO];
}

+ (NSString*) getHelpTop:(NSInteger)index{
	return [self getKeys:@"top" inSection:@"help" withIndex:index withStyles:YES];
}

+ (NSString*) getExampleData:(NSInteger)index{
	return [self getKeys:@"contents" inSection:@"examples" withIndex:index withStyles:YES];
}

+ (NSString*) getRefData:(NSInteger)index{
	return [self getKeys:@"contents" inSection:@"ref" withIndex:index withStyles:YES];
}

+ (NSString*) getHelpContents:(NSInteger)index{
	return [self getKeys:@"contents" inSection:@"help" withIndex:index withStyles:YES];
}

+ (NSString*) getStyles{
	return [NSString stringWithFormat:@"<style>%@%@%@%@%@</style>", STYLES0, STYLES1, STYLES2, STYLES3, STYLES4];
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

