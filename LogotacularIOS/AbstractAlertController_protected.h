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
@property UIView* panel;
@property NSArray* panelConstraints;

- (UIButton*) getButton:(NSString*) imageUrl withAction:(SEL)action withLabel:(NSString*)label atNum:(int)num;
- (void)layoutPanel:(float)dy;

@end
