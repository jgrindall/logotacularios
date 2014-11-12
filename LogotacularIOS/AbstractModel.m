//
//  AbstractModel.m
//  LogotacularIOS
//
//  Created by John on 28/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AbstractModel_protected.h"

@interface AbstractModel ()

@end

@implementation AbstractModel

- (instancetype) init{
	self = [super init];
	if(self){
		[self setup];
		[self setDefaults];
	}
	return self;
}

- (void) toggleBoolValForKey:(NSString*)key{
	BOOL currentVal = [[self getVal:key] boolValue];
	BOOL newVal = !currentVal;
	[self setVal:[NSNumber numberWithBool:newVal] forKey:key];
}

- (void) incrementValForKey:(NSString*)key{
	
}

- (void) setDefaults{
	
}

- (NSArray*) getKeys{
	return [NSArray array];
}

- (void) addGlobalListener:(SEL)action withTarget:(id)target{
	NSArray* keys = [self getKeys];
	for (NSString* k in keys){
		[self checkObserving:k];
	}
	[self.globalTargets addObject:target];
	[self.globalListeners addObject:[NSValue valueWithPointer:action]];
}

- (void) removeGlobalListener:(SEL)action withTarget:(id)target{
	NSUInteger i = 0;
	NSValue* v = [NSValue valueWithPointer:action];
	for (id t in self.globalTargets){
		if([t isEqual:target]){
			if([[self.globalListeners objectAtIndex:i] isEqualToValue:v]){
				[self removeGlobalAt:i];
				break;
			}
		}
		i++;
	}
}

- (void) checkObserving:(NSString*) key{
	if([self.globalListeners count] >= 1){
		return;
	}
	if(![self.keys containsObject:key]){
		[self.propHash addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
	}
}

- (void) cleanObserving{
	if([self.globalListeners count] >= 1){
		return;
	}
	NSArray* keys = [self getKeys];
	for (NSString* k in keys){
		if(![self.keys containsObject:k]){
			[self.propHash removeObserver:self forKeyPath:k context:nil];
		}
	}
}

- (void) addListener:(SEL)action forKey:(NSString*)key withTarget:(id)target{
	[self checkObserving:key];
	NSValue* v = [NSValue valueWithPointer:action];
	[self.keys addObject:key];
	[self.targets addObject:target];
	[self.listeners addObject:v];
}

- (void) removeListener:(SEL)action forKey:(NSString*)key withTarget:(id)target{
	NSUInteger i = 0;
	NSValue* v = [NSValue valueWithPointer:action];
	for (NSString* k in self.keys){
		if([k isEqualToString:key]){
			if([[self.listeners objectAtIndex:i] isEqualToValue:v]){
				id t = [self.targets objectAtIndex:i];
				if([t isEqual:target]){
					[self removeAt:i forKey:key];
					break;
				}
			}
		}
		i++;
	}
}

- (void) removeGlobalAt:(NSUInteger)i{
	[self.globalListeners removeObjectAtIndex:i];
	[self.globalTargets removeObjectAtIndex:i];
	[self cleanObserving];
}
			
- (void) removeAt:(NSUInteger)i forKey:(NSString*)key{
	[self.listeners removeObjectAtIndex:i];
	[self.targets removeObjectAtIndex:i];
	[self.keys removeObjectAtIndex:i];
	[self cleanObserving];
}

- (void) setup{
	self.propHash = [[NSMutableDictionary alloc] init];
	self.listeners = [NSMutableArray array];
	self.keys = [NSMutableArray array];
	self.targets = [NSMutableArray array];
	self.globalListeners = [NSMutableArray array];
	self.globalTargets = [NSMutableArray array];
}

- (id) getVal:(NSString*)key{
	return [self.propHash valueForKey:key];
}

- (void) setVal:(id)val forKey:(NSString*)key{
	[self.propHash setValue:val forKey:key];
}

- (void) call:(id)target withSelector:(SEL)sel withObject:(id)object{
	if([target respondsToSelector:sel]){
		IMP imp = [target methodForSelector:sel];
		void (*func)(id, SEL, id) = (void*)imp;
		func(target, sel, object);
	}
}

- (void) performForKey:(NSString*)keyPath withChange:(id)change{
	int i = 0;
	SEL sel;
	id target;
	for (NSString* key in self.keys){
		if([keyPath isEqualToString:key]){
			sel = (SEL)[[self.listeners objectAtIndex:i] pointerValue];
			target = [self.targets objectAtIndex:i];
			[self call:target withSelector:sel withObject:change];
		}
		i++;
	}
}

- (void) performGlobalWithChange:(id)change{
	int i = 0;
	SEL sel;
	for (id target in self.globalTargets){
		sel = (SEL)[[self.globalListeners objectAtIndex:i] pointerValue];
		[self call:target withSelector:sel withObject:change];
		i++;
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	[self performForKey:keyPath withChange:change];
	[self performGlobalWithChange:change];
}

- (void)dealloc{
	[self.listeners removeAllObjects];
	[self.targets removeAllObjects];
	[self.keys removeAllObjects];
	[self.globalListeners removeAllObjects];
	[self.globalTargets removeAllObjects];
	[self cleanObserving];
}

@end

