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

NSString* const STYLES0 = @"h1, p, h2, h3, div, span, ul, li, td, td, th{font-family: 'Lato-Light';font-size: 16px;color:white;}";
NSString* const STYLES1 = @"table{border-collapse: collapse;font-size:18px;margin-left:43px;margin-top:10px;}table,tr{width:900px;}th{border:2px solid #666 !important;}td,th{padding:12px;border:2px solid #666;}td{font-size:19px;}table.commands td:nth-child(2n+1){text-align:center;}th{font-size:24px;text-align:center;}tr{width:100%;}table.commands td:nth-child(1){width:25%}table.commands td:nth-child(2){width:25%}table.commands td:nth-child(3){width:50%}table.commands.commands0 tr:nth-child(2n+1){background:#2dc86e;}table.commands.commands1 tr:nth-child(2n+1){background:#d55244;}table.commands.commands2 tr:nth-child(2n+1){background:#5aa1d8;}";
NSString* const STYLES2 = @"table.colors td{padding:15px;height:30px;text-align:center;width:25%}table.colors tr{height:30px;}table.colors td,th{border:2px solid transparent;}";
NSString* const STYLES3 = @"h1,h2,h3{font-size:23px;}";
NSString* const STYLES4 = @"li{padding:14px;}";
NSString* const STYLES5 = @"pre, span.mono{font-family:'DroidSansMono';color:white;font-size:19px;}p.quote{font-size: 16px;font-style:italic;}";

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

+ (NSString*) getHelpMedia:(NSInteger)index{
	return [HelpData getKey:@"media" inSection:@"help" withIndex:index withStyles:NO];
}

+ (NSString*) getHelpFile:(NSInteger)index{
	return [HelpData getKey:@"file" inSection:@"help" withIndex:index withStyles:NO];
}

+ (NSString*) getTutFile:(NSInteger)index{
	return [HelpData getKey:@"file" inSection:@"tut" withIndex:index withStyles:NO];
}

+ (NSString*) getTutData:(NSInteger)index{
	return [HelpData getKeys:@"contents" inSection:@"tut" withIndex:index withStyles:YES];
}

+ (NSString*) getHelpData:(NSInteger)index{
	return [HelpData getKeys:@"contents" inSection:@"help" withIndex:index withStyles:YES];
}

+ (NSString*) getTutBg:(NSInteger)index{
	return [HelpData getKey:@"bg" inSection:@"tut" withIndex:index withStyles:NO];
}

+ (NSString*) getRefBg:(NSInteger)index{
	return [HelpData getKey:@"bg" inSection:@"ref" withIndex:index withStyles:NO];
}

+ (NSString*) getHelpBg:(NSInteger)index{
	return [HelpData getKey:@"bg" inSection:@"help" withIndex:index withStyles:NO];
}

+ (NSString*) getTutMedia:(NSInteger)index{
	return [HelpData getKey:@"media" inSection:@"tut" withIndex:index withStyles:NO];
}

+ (NSString*) getHelpTop:(NSInteger)index{
	return [self getKeys:@"top" inSection:@"help" withIndex:index withStyles:YES];
}

+ (NSString*) getRefData:(NSInteger)index{
	return [self getKeys:@"contents" inSection:@"ref" withIndex:index withStyles:YES];
}

+ (NSString*) getHelpContents:(NSInteger)index{
	return [self getKeys:@"contents" inSection:@"help" withIndex:index withStyles:YES];
}

+ (NSString*) getStyles{
	return [NSString stringWithFormat:@"<style>%@%@%@%@%@%@</style>", STYLES0, STYLES1, STYLES2, STYLES3, STYLES4, STYLES5];
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

