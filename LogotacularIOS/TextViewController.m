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

@interface TextViewController ()

@property UITextView* logoText;
@property UIImageView* imgView;
@property UIGestureRecognizer* swipe;
@property NSString* cachedText;
@property UIView* errorView;
@property NSArray* errorConstraints;

@end

@implementation TextViewController

- (void) viewDidLoad{
	[self addImg];
	[self addError];
	[self addText];
	[self addListeners];
	[self layoutText];
	[self layoutImg];
	[self layoutError:CGRectZero];
}

- (void) addListeners{
	[[self getLogoModel] addGlobalListener:@selector(modelChanged) withTarget:self];
	[[self getErrorModel] addListener:@selector(errorChanged) forKey:LOGO_ERROR_ERROR withTarget:self];
	[[self getEventDispatcher] addListener:SYMM_NOTIF_DISMISS_KEY toFunction:@selector(dismissKeyboard) withContext:self];
	self.swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(textSwipe:)];
	self.swipe.delegate = self;
	[self.view addGestureRecognizer:self.swipe];
}

- (void) modelChanged{
	NSString* text = [[self getLogoModel] get];
	[self.logoText setText:text];
}

- (void) layoutText{
	self.logoText.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual		toItem:self.view			attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual	toItem:self.view			attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual		toItem:self.view			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual	toItem:self.view			attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

- (void) layoutImg{
	self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual			toItem:self.view			attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual		toItem:self.view			attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual		toItem:self.view			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual	toItem:self.view			attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

- (void) layoutError:(CGRect)rect{
	self.errorView.translatesAutoresizingMaskIntoConstraints = NO;
	if(self.errorConstraints && [self.errorConstraints count] >= 1){
		[self.view removeConstraints:self.errorConstraints];
		self.errorConstraints = nil;
	}
	NSLayoutConstraint* c0 = [NSLayoutConstraint constraintWithItem:self.errorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual			toItem:self.view			attribute:NSLayoutAttributeTop multiplier:1.0 constant:rect.origin.x];
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.errorView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual		toItem:self.view			attribute:NSLayoutAttributeLeading multiplier:1.0 constant:rect.origin.y];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.errorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual			toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:rect.size.width];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.errorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual		toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:rect.size.height];
	self.errorConstraints = [NSArray arrayWithObjects:c0, c1, c2, c3, nil];
	[self.view addConstraint:c0];
	[self.view addConstraint:c1];
	[self.view addConstraint:c2];
	[self.view addConstraint:c3];
}

- (void) textSwipe:(id) sender{
	[self hide];
}

-(void)addImg{
	self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"assets/paper.png"]];
	[self.view addSubview:self.imgView];
}

-(void)addError{
	self.errorView = [[UIView alloc] initWithFrame:self.view.frame];
	self.errorView.backgroundColor = [UIColor yellowColor];
	[self.view addSubview:self.errorView];
}

-(void)addText{
	self.logoText = [[UITextView alloc] initWithFrame:CGRectZero];
	self.logoText.editable = YES;
	self.logoText.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.logoText.autocorrectionType = UITextAutocorrectionTypeNo;
	self.logoText.delegate = self;
	self.logoText.allowsEditingTextAttributes = YES;
	self.logoText.backgroundColor = [UIColor clearColor];
	[self.logoText setFont:[Appearance monospaceFontOfSize:SYMM_FONT_SIZE_MED]];
	[self.view addSubview:self.logoText];
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
	if(logoError){
		NSNumber* line = [logoError valueForKey:@"line"];
		NSInteger intLine = [line integerValue];
		NSUInteger len = [self.logoText.text length];
		__block NSInteger i = 1;
		__block NSUInteger start = 0;
		__block NSUInteger end = 0;
		__block CGRect colourRect = CGRectZero;
		[self.logoText setText:text];
		[self.logoText.layoutManager enumerateLineFragmentsForGlyphRange:NSMakeRange(0, len) usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer *textContainer, NSRange glyphRange, BOOL *stop) {
			start = glyphRange.location;
			end = start + glyphRange.length;
			colourRect = rect;
			if(i == intLine){
				*stop = YES;
			}
			i++;
		}];
		[self showErrorText:text withStart:start andEnd:end andRect:colourRect];
	}
	else{
		[self.logoText text];
	}
}

-(void) showErrorText:(NSString*) text withStart:(NSUInteger)start andEnd:(NSUInteger)end andRect:(CGRect)rect{
	[self.logoText text];
	[self layoutError:rect];
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
}

- (void)textViewDidEndEditing:(UITextView*)textView{
	[self triggerEdit];
}

- (void) triggerEdit{
	NSString* text = self.logoText.text;
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_TEXT_EDITED withData:text];
}

- (void) checkChanged{
	NSString* text = self.logoText.text;
	if(![self.cachedText isEqualToString:text]){
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(triggerEdit) object:nil];
		[self performSelector:@selector(triggerEdit) withObject:nil afterDelay:0.5];
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
