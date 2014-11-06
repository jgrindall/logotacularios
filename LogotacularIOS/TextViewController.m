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

@end

@implementation TextViewController

- (void) viewDidLoad{
	[self addImg];
	[self addText];
	[self addListeners];
	[self layoutText];
	[self layoutImg];
}

- (void) addListeners{
	[[self getEventDispatcher] addListener:SYMM_NOTIF_STORE_TEXT toFunction:@selector(storeText) withContext:self];
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

- (void) textSwipe:(id) sender{
	[self hide];
}

-(void)addImg{
	self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"assets/paper.png"]];
	[self.view addSubview:self.imgView];
}

-(void)addText{
	self.logoText = [[UITextView alloc] initWithFrame:CGRectZero];
	self.logoText.editable = YES;
	self.logoText.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.logoText.autocorrectionType = UITextAutocorrectionTypeNo;
	self.logoText.delegate = self;
	self.logoText.backgroundColor = [UIColor clearColor];
	[self.logoText setFont:[Appearance monospaceFontOfSize:SYMM_FONT_SIZE_MED]];
	[self.view addSubview:self.logoText];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	self.view.alpha = 1.0;
}

- (NSString*) getText{
	return [self.logoText text];
}

- (void) errorChanged{
	NSString* text = [[self getLogoModel] get];
	[self.logoText setText:text];
}

- (void) setText:(NSString*) text{
	id logoError = [[self getErrorModel] getVal:LOGO_ERROR_ERROR];
	/*
	 NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:@"firstsecondthird"];
	 [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,5)];
	 [string addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(5,6)];
	 [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(11,5)];
	 [string addAttribute:NSFontAttributeName value:[Appearance monospaceFontOfSize:SYMM_FONT_SIZE_MED] range:NSMakeRange(0, 10)];
	 [self.logoText setAttributedText:string];

	 */
	[self.logoText setText:text];
}

- (void) show{
	[self move:YES];
}

- (void) hide{
	[self move:NO];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
	self.cachedText = [self.logoText text];
	[[self getErrorModel] setVal:nil forKey:LOGO_ERROR_ERROR];
}

- (void)textViewDidEndEditing:(UITextView*)textView{
	NSString* text = self.logoText.text;
	if(![self.cachedText isEqualToString:text]){
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_TEXT_EDITED withData:text];
	}
}

- (id<PLogoModel>) getLogoModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoModel)];
}

- (id<PLogoModel>) getErrorModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoErrorModel)];
}

- (void) storeText{
	//NSString* text = [self getText];
	//[[self getLogoModel] add:text];
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
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_STORE_TEXT toFunction:@selector(storeText) withContext:self];
	[[self getLogoModel] removeGlobalListener:@selector(modelChanged) withTarget:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_DISMISS_KEY toFunction:@selector(dismissKeyboard) withContext:self];
	[[self getErrorModel] removeListener:@selector(errorChanged) forKey:LOGO_ERROR_ERROR withTarget:self];
}

-(void) dealloc{
	[self removeListeners];
}

@end
