//
//  AbstractAlertController_protected.h
//  
//
//  Created by John on 07/11/2014.
//
//

#import "AbstractAlertController.h"

@interface AbstractAlertController ()

@property UIView* bg;
@property UILabel* titleLabel;
@property UIView* panel;
@property NSArray* panelConstraints;
@property NSArray* buttonLabels;
@property NSString* titleText;

- (UIButton*) getButton:(NSString*) imageUrl withAction:(SEL)action withLabel:(NSString*)label;
- (void)layoutPanel:(float)dy;

@end
