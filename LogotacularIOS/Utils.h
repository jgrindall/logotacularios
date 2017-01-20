
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

+ (NSArray*) intersectionsWithRectForPoint0:(CGPoint) p andPoint1:(CGPoint)q andRect:(CGRect) r;

+ (BOOL) lineAndSegmentIntersectionPoint0:(CGPoint) p andPoint1:(CGPoint) q withSeg0:(CGPoint)a andSeg1:(CGPoint)b storeIn:(float*) x andIn: (float*)y;

@end
