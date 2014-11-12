//
//  LogoModel.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "LogoModel.h"

@implementation LogoModel

NSString* const LOGO_POINTER = @"logo_pointer";
NSString* const LOGO_HISTORY = @"logo_history";

- (void) setDefaults{
	[self reset:@""];
}

- (void) changePointerBy:(NSInteger) i{
	NSInteger pointer = [[self getVal:LOGO_POINTER] integerValue];
	NSInteger newPointer = pointer + i;
	[self setVal:[NSNumber numberWithInteger:newPointer] forKey:LOGO_POINTER];
}

- (void) undo{
	if([self undoEnabled]){
		[self changePointerBy:-1];
	}
}

- (void) redo{
	if([self redoEnabled]){
		[self changePointerBy:1];
	}
}

- (void) pruneTop:(NSInteger)top{
	NSMutableArray* history = (NSMutableArray*)[self getVal:LOGO_HISTORY];
	for(int i = 1; i<= top; i++){
		[history removeLastObject];
	}
}

- (NSString*) get{
	NSMutableArray* history = (NSMutableArray*)[self getVal:LOGO_HISTORY];
	NSInteger pointer = [[self getVal:LOGO_POINTER] integerValue];
	return [history objectAtIndex:pointer];
}

- (void) reset:(NSString*)val{
	NSMutableArray* history = [NSMutableArray arrayWithObjects:val, nil];
	[self setVal:@0 forKey:LOGO_POINTER];
	[self setVal:history forKey:LOGO_HISTORY];
}

- (void) add:(NSString*) val{
	NSString* oldVal = [self get];
	NSMutableArray* history = (NSMutableArray*)[self getVal:LOGO_HISTORY];
	if([val isEqualToString:oldVal]){
		return;
	}
	NSInteger top = [self getTop];
	if(top >= 1){
		[self pruneTop:top];
	}
	[history addObject:val];
	[self setVal:[NSNumber numberWithInt:([history count] - 1)] forKey:LOGO_POINTER];
}

- (void) output:(NSString*)label{
	//NSString* msg = [NSString stringWithFormat:@"%@  logomodel\npointer %@\nhistory %@ (%i)\n", label, [self getVal:LOGO_POINTER], [self getVal:LOGO_HISTORY], [(NSMutableArray*)[self getVal:LOGO_HISTORY] count] ];
}

- (NSArray*) getKeys{
	return [NSArray arrayWithObjects:LOGO_POINTER, LOGO_HISTORY, nil];
}

- (BOOL) undoEnabled{
	NSInteger pointer = [[self getVal:LOGO_POINTER] integerValue];
	return (pointer >= 1);
}

- (NSInteger) getTop{
	NSInteger pointer = [[self getVal:LOGO_POINTER] integerValue];
	NSMutableArray* history = (NSMutableArray*)[self getVal:LOGO_HISTORY];
	NSInteger size = [history count];
	if(size >= 1){
		return size - pointer - 1;
	}
	return 0;
}

- (BOOL) redoEnabled{
	NSMutableArray* history = (NSMutableArray*)[self getVal:LOGO_HISTORY];
	NSInteger size = [history count];
	NSInteger top = [self getTop];
	return (size >= 1 && top >= 1);
}

@end
