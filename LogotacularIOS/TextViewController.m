//
//  TextViewController.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TextViewController.h"
#import "ImageUtils.h"
#import "Appearance.h"
#import "PLogoModel.h"
#import "PLogoErrorModel.h"
#import "SymmNotifications.h"
#import <CoreText/CoreText.h>
#import "Appearance.h"
#import <QuartzCore/QuartzCore.h>

@interface TextViewController ()

@property UITextView* logoText;
@property UIGestureRecognizer* swipe;
@property NSString* cachedText;
@property UIView* errorView;
@property NSArray* errorConstraints;

@end

@implementation TextViewController

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self addText];
	[self addErrorView];
	[self addListeners];
	self.view.layer.cornerRadius = 10;
	self.view.layer.masksToBounds = YES;
	self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.4];
	self.view.alpha = 0.35;
	[self layoutText];
	[self layoutError:CGRectZero];
}

- (void) clearError{
	
}

- (void) layoutError:(CGRect)rect{
	rect = CGRectOffset(rect, 10, 10);
	NSLog(@"error %@", NSStringFromCGRect(rect));
	self.errorView.frame = rect;
	return;
	/**
	float x = rect.origin.x;
	float y = rect.origin.y;
	float w = rect.size.width;
	float h = rect.size.height;
	w = fmaxf(1, w);
	h = fmaxf(1, h);
	NSLog(@"layoutError %@   %f %f %f %f", NSStringFromCGRect(rect), x, y, w, h);
	self.errorView.translatesAutoresizingMaskIntoConstraints = NO;
	if(self.errorConstraints && [self.errorConstraints count]>=1){
		[self.view removeConstraints:self.errorConstraints];
	}
	NSLayoutConstraint* c0 = [NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual		toItem:self.view			attribute:NSLayoutAttributeTop					multiplier:1.0 constant:x];
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual		toItem:self.view			attribute:NSLayoutAttributeLeft					multiplier:1.0 constant:y];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual		toItem:nil					attribute:NSLayoutAttributeNotAnAttribute		multiplier:1.0 constant:w];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual		toItem:nil					attribute:NSLayoutAttributeNotAnAttribute		multiplier:1.0 constant:h];
	self.errorConstraints = @[c0, c1, c2, c3];
	[self.view addConstraints:self.errorConstraints];
	 **/
}

- (void) addErrorView{
	self.errorView = [[UIView alloc] initWithFrame:CGRectZero];
	[self.view addSubview:self.errorView];
	self.errorView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
}

- (void) addListeners{
	[[self getLogoModel] addGlobalListener:@selector(modelChanged) withTarget:self];
	[[self getErrorModel] addListener:@selector(errorChanged) forKey:LOGO_ERROR_ERROR withTarget:self];
	[[self getEventDispatcher] addListener:SYMM_NOTIF_DISMISS_KEY toFunction:@selector(dismissKeyboard) withContext:self];
	self.swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(textSwipe:)];
	self.swipe.delegate = self;
	[self.view addGestureRecognizer:self.swipe];
}

- (void) drawErrorForStart:(NSInteger)start andEnd:(NSInteger)end{
	NSLayoutManager *layoutManager = [self.logoText layoutManager];
	NSTextContainer *textContainer = [self.logoText textContainer];
	NSRange range = NSMakeRange(start, end - start);
	CGRect r = [layoutManager boundingRectForGlyphRange:range inTextContainer:textContainer];
	[self layoutError:r];
}

- (void) modelChanged{
	NSString* text = [[self getLogoModel] get];
	[self.logoText setText:text];
}

- (void) layoutText{
	float p = 10;
	self.logoText.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual		toItem:self.view			attribute:NSLayoutAttributeTop			multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual		toItem:self.view			attribute:NSLayoutAttributeLeft			multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual		toItem:self.view			attribute:NSLayoutAttributeBottom		multiplier:1.0 constant:-p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual		toItem:self.view			attribute:NSLayoutAttributeRight		multiplier:1.0 constant:-p - 10]];
}

- (void) textSwipe:(id) sender{
	[self hide];
}

-(void)addText{
	self.logoText = [[UITextView alloc] initWithFrame:self.view.frame];
	self.logoText.editable = YES;
	self.logoText.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.logoText.autocorrectionType = UITextAutocorrectionTypeNo;
	self.logoText.delegate = self;
	self.logoText.allowsEditingTextAttributes = YES;
	self.logoText.backgroundColor = [UIColor clearColor];
	[self.logoText setFont:[Appearance monospaceFontOfSize:SYMM_FONT_SIZE_MED]];
	self.logoText.textColor = [UIColor whiteColor];
	[self.view addSubview:self.logoText];
	self.logoText.layer.borderColor = [UIColor blackColor].CGColor;
	self.logoText.layer.borderWidth = 1.0f;
	self.logoText.textContainer.lineFragmentPadding = 0;
	self.logoText.textContainerInset = UIEdgeInsetsZero;
}

- (void) textViewDidChange:(UITextView *)textView{
	[self checkChanged];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	self.view.alpha = 1.0;
}

- (NSString*) getText{
	return [self.logoText text];
}

- (void) errorChanged{
	[self setText];
}

- (void) setText{
	NSString* text = [[self getLogoModel] get];
	NSDictionary* logoError = (NSDictionary*)[[self getErrorModel] getVal:LOGO_ERROR_ERROR];
	NSLog(@"setText %@", logoError);
	int k = 0;
	int start = 0;
	int end = 0;
	if(logoError && logoError[@"line"]){
		NSInteger intLine = [logoError[@"line"] integerValue];
		NSArray* comps = [text componentsSeparatedByString:@"\\n"];
		while(k <= intLine - 2){
			start += [(NSString*)comps[k] length];
			k++;
		}
		end = start + [(NSString*)comps[k] length];
		[self drawErrorForStart:start andEnd:end];
	}
	else{
		[self clearError];
	}
}

- (void) show{
	[self move:YES];
}

- (void) hide{
	[self move:NO];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
	[[self getErrorModel] setVal:nil forKey:LOGO_ERROR_ERROR];
	self.cachedText = [self.logoText text];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(editEnded) object:nil];
	self.view.alpha = 0.85;
}

- (void)textViewDidEndEditing:(UITextView*)textView{
	[self triggerEdit];
	[self triggerCheck];
	[self performSelector:@selector(editEnded) withObject:nil afterDelay:2.5];
}


- (void) editEnded{
	[UIView animateWithDuration:0.5 animations:^{
		self.view.alpha = 0.35;
	}];
}

- (void) triggerCheck{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_SYNTAX_CHECK withData:nil];
}

- (void) triggerEdit{
	NSString* text = self.logoText.text;
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_TEXT_EDITED withData:text];
}

- (void) checkChanged{
	NSString* text = self.logoText.text;
	if(![self.cachedText isEqualToString:text]){
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(triggerEdit) object:nil];
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(triggerCheck) object:nil];
		[self performSelector:@selector(triggerEdit) withObject:nil afterDelay:0.5];
		[self performSelector:@selector(triggerCheck) withObject:nil afterDelay:2.5];
	}
}

- (id<PLogoModel>) getLogoModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoModel)];
}

- (id<PLogoModel>) getErrorModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoErrorModel)];
}

- (void) dismissKeyboard{
	[self.logoText resignFirstResponder];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGesture{
	return NO;
}

- (void) move:(BOOL)show{
	float x1t;
	float time = 0.5;
	float x0 = self.view.frame.size.width - self.logoText.frame.size.width/2;
	float x1 = x0 + self.logoText.frame.size.width;
	if(show){
		x1t = x1;
		x1 = x0;
		x0 = x1t;
		time = 0.2;
	}
	[ImageUtils bounceAnimateView:self.view from:x0 to:x1 withKeyPath:@"position.x" withKey:@"textBounce" withDelegate:nil withDuration:time withImmediate:NO];
}

- (void) removeListeners{
	[self.view removeGestureRecognizer:self.swipe];
	[[self getLogoModel] removeGlobalListener:@selector(modelChanged) withTarget:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_DISMISS_KEY toFunction:@selector(dismissKeyboard) withContext:self];
	[[self getErrorModel] removeListener:@selector(errorChanged) forKey:LOGO_ERROR_ERROR withTarget:self];
}

-(void) dealloc{
	[self removeListeners];
}

@end
