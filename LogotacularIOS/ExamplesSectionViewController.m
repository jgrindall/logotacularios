//
//  ExamplesSectionViewController.m
//  LogotacularIOS
//
//  Created by John on 26/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ExamplesSectionViewController.h"
#import "SymmNotifications.h"
#import "HelpData.h"
#import "Appearance.h"
#import "Assets.h"

@interface ExamplesSectionViewController ()

@property UIButton* progCopyButton;
@property UITextView* textView;
@property UIImageView* imgView;

@end

@implementation ExamplesSectionViewController

- (void) addChildren{
	[super addChildren];
	[self addText];
	[self addImage];
	[self addButton];
}

- (void) layoutAll{
	[super layoutAll];
	[self layoutButton];
	[self layoutText];
	[self layoutImage];
}

- (void) layoutButton{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progCopyButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:185.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progCopyButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:40.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progCopyButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.textView			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progCopyButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.textView		attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

- (void) layoutText{
	float p = 10;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view						attribute:NSLayoutAttributeTop multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeLeading multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view						attribute:NSLayoutAttributeWidth multiplier:0.5 constant:-p]];
}

- (void) layoutImage{
	float p = 10;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view						attribute:NSLayoutAttributeTop multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.textView				attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view						attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-p]];
}

- (void) addText{
	self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
	self.textView.translatesAutoresizingMaskIntoConstraints = NO;
	self.textView.font = [Appearance fontOfSize:SYMM_FONT_SIZE_MED];
	self.textView.backgroundColor = [Appearance grayColor];
	[self.view addSubview:self.textView];
	self.textView.textContainerInset = UIEdgeInsetsMake(6, 5, 5, 5);
	self.textView.scrollEnabled = NO;
	self.textView.editable = NO;
	NSString* htmlString = [HelpData getExampleData:self.index];
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
	self.textView.layer.cornerRadius = 10;
	self.textView.layer.masksToBounds = YES;
	self.textView.attributedText = attributedString;
}

- (void) addImage{
	self.imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
	NSString* media = [HelpData getExampleMedia:self.index];
	self.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"assets/%@", media]];
	[self.view addSubview:self.imgView];
	self.imgView.layer.cornerRadius = 10;
	self.imgView.layer.masksToBounds = YES;
	self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void) addButton{
	self.progCopyButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.progCopyButton setTitle:@"Load this file!" forState:UIControlStateNormal];
	[self.progCopyButton setImage:[UIImage imageNamed:RIGHT_ICON] forState:UIControlStateNormal];
	self.progCopyButton.imageEdgeInsets = UIEdgeInsetsMake(0, 136, 0, 0);
	self.progCopyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 60);
	[self.progCopyButton addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.progCopyButton];
	self.progCopyButton.frame = CGRectZero;
	self.progCopyButton.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void) onClick{
	NSString* file = [HelpData getExampleFile:self.index];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_LOAD_FROM_HELP withData:file];
	[self exit];
}

- (void) dealloc{
	[self.progCopyButton removeTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
	[self.progCopyButton removeFromSuperview];
	self.progCopyButton = nil;
	[self.textView removeFromSuperview];
	self.textView = nil;
	[self.imgView removeFromSuperview];
	self.imgView = nil;
}

@end
