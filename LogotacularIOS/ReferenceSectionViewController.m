//
//  ExamplesSectionViewController.m
//  LogotacularIOS
//
//  Created by John on 26/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ReferenceSectionViewController.h"
#import "SymmNotifications.h"
#import "HelpData.h"
#import "Appearance.h"

@interface ReferenceSectionViewController ()

@property UITextView* textView;

@end

@implementation ReferenceSectionViewController

- (void) addChildren{
	[super addChildren];
	[self addText];
}

- (void) layoutAll{
	[super layoutAll];
	[self layoutText];
}

- (void) layoutText{
	float p = 10;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view						attribute:NSLayoutAttributeTop multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeLeading multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view						attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-2*p]];
}

- (void) addText{
	self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
	self.textView.scrollEnabled = NO;
	self.textView.translatesAutoresizingMaskIntoConstraints = NO;
	self.textView.font = [Appearance fontOfSize:SYMM_FONT_SIZE_MED];
	self.textView.backgroundColor = [Appearance grayColor];
	[self.view addSubview:self.textView];
	self.textView.textContainerInset = UIEdgeInsetsMake(6, 5, 5, 5);
	NSString* htmlString = [HelpData getRefData:self.index];
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
	self.textView.layer.cornerRadius = 10;
	self.textView.layer.masksToBounds = YES;
	self.textView.attributedText = attributedString;
}

@end
