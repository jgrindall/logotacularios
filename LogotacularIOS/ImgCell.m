//
//  FileCell.m
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ImgCell.h"
#import "Appearance.h"
#import "ImageUtils.h"

@interface ImgCell()

@property UIImageView* imageView;
@property UILabel* textView;
@property UIView* coverView;
@property UIView* whiteView;
@property NSArray* coverConstraints;
@property NSArray* whiteConstraints;

@end

@implementation ImgCell

- (void)prepareForReuse{
	[super prepareForReuse];
	[self updateViews];
}

-  (void) setIsSelected:(BOOL)isSelected{
	_isSelected = isSelected;
	[self updateViews];
}

-  (void) setImage:(UIImage*)img{
	_image = img;
	[self updateViews];
}

-  (void) setFilename:(NSString *)filename{
	_filename = filename;
	[self updateViews];
}

- (void) removeImg{
	if(self.imageView){
		[self.imageView removeFromSuperview];
		self.imageView = nil;
	}
}

- (void) removeText{
	if(self.textView){
		[self.textView removeFromSuperview];
		self.textView = nil;
	}
}

- (void) layoutCover{
	int top = 35;
	float padding = 6;
	if(self.coverConstraints && [self.coverConstraints count]>=1){
		[self removeConstraints:self.coverConstraints];
		self.coverConstraints = @[];
	}
	float w = [_image size].width;
	float h = [_image size].height;
	CGSize imageSize = CGSizeMake(self.frame.size.width, self.frame.size.height - top);
	CGRect rect = [ImageUtils getRectForRatio:(w/h) inSize:imageSize];
	rect = CGRectInset(rect, -1, -1);
	NSLayoutConstraint* c0 = [NSLayoutConstraint constraintWithItem:self.coverView	attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView			attribute:NSLayoutAttributeTop multiplier:1.0 constant:rect.origin.y - padding];
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.coverView	attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imageView		attribute:NSLayoutAttributeLeading multiplier:1.0 constant:rect.origin.x - padding];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.coverView	attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:rect.size.width];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.coverView	attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:rect.size.height];
	self.coverConstraints = @[c0, c1, c2, c3];
	[self addConstraints:self.coverConstraints];
}

- (void) layoutWhite{
	if(self.whiteConstraints && [self.whiteConstraints count]>=1){
		[self removeConstraints:self.whiteConstraints];
		self.whiteConstraints = @[];
	}
	NSLayoutConstraint* c0 = [NSLayoutConstraint constraintWithItem:self.whiteView	attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.coverView			attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.whiteView	attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.coverView		attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.whiteView	attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.coverView		attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.whiteView	attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.coverView			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
	self.whiteConstraints = @[c0, c1, c2, c3];
	[self addConstraints:self.whiteConstraints];
}

-  (void) addCoverView{
	if(!self.coverView){
		self.coverView = [[UIView alloc] initWithFrame:CGRectZero];
		self.coverView.backgroundColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.0];
		[self addSubview:self.coverView];
		self.coverView.translatesAutoresizingMaskIntoConstraints = NO;
	}
}

-  (void) addImageView{
	int top = 35;
	float padding = 6;
	if(!self.imageView){
		self.imageView = [[UIImageView alloc] initWithFrame:self.frame];
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:self.imageView];
		self.imageView.backgroundColor = [UIColor clearColor];
		self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView	attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self				attribute:NSLayoutAttributeTop multiplier:1.0 constant:top + padding]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView	attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self			attribute:NSLayoutAttributeLeading multiplier:1.0 constant:padding]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView	attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self			attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-padding]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView	attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-padding]];
	}
}

-  (void) addWhiteView{
	if(!self.whiteView){
		self.whiteView = [[UIImageView alloc] initWithFrame:self.frame];
		self.whiteView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:self.whiteView];
		self.whiteView.backgroundColor = [UIColor grayColor];
		self.whiteView.translatesAutoresizingMaskIntoConstraints = NO;
	}
}

-  (void) addTextView{
	int top = 35;
	if(!self.textView){
		self.textView = [[UILabel alloc] initWithFrame:self.frame];
		[self.textView setTextAlignment:NSTextAlignmentCenter];
		[self.textView setFont:[Appearance fontOfSize:SYMM_FONT_SIZE_MED]];
		[self.textView setTextColor:[UIColor blackColor]];
		[self addSubview:self.textView];
		self.textView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView	attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self				attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView	attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self			attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView	attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self			attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView	attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil			attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:top]];
	}
}

- (void) updateViews{
	self.backgroundColor = [UIColor clearColor];
	[self addWhiteView];
	[self addImageView];
	[self addTextView];
	[self addCoverView];
	[self.imageView setImage:_image];
	[self.textView setText:_filename];
	self.alpha = (self.isSelected ? 1 : 0.4);
	self.textView.alpha = (self.isSelected ? 1 : 0.4);
	self.whiteView.alpha = (self.isSelected ? 1 : 0);
	self.coverView.alpha = (self.isSelected ? 0 : 0.55);
	[self layoutCover];
	[self layoutWhite];
}

- (void) dealloc{
	[self removeImg];
	[self removeText];
}

@end


