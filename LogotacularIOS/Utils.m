

#import "Utils.h"

@interface Utils ()

@end

@implementation Utils

+ (NSArray*) intersectionsWithRectForPoint0:(CGPoint) p andPoint1:(CGPoint)q andRect:(CGRect) r{
	NSMutableArray* inter = [[NSMutableArray alloc] init];
	float p0x, p0y, p1x, p1y, p2x, p2y, p3x, p3y;
	CGPoint topLeft = CGPointMake(r.origin.x, r.origin.y);
	CGPoint topRight = CGPointMake(r.origin.x + r.size.width, r.origin.y);
	CGPoint bottomRight = CGPointMake(r.origin.x + r.size.width, r.origin.y + r.size.height);
	CGPoint bottomLeft = CGPointMake(r.origin.x, r.origin.y + r.size.height);
	if([Utils lineAndSegmentIntersectionPoint0:p andPoint1:q withSeg0:topLeft andSeg1:topRight storeIn:&p0x andIn:&p0y]){
		[inter addObject:[NSValue valueWithCGPoint:CGPointMake(p0x, p0y)]];
	}
	if([Utils lineAndSegmentIntersectionPoint0:p andPoint1:q withSeg0:topRight andSeg1:bottomRight storeIn:&p1x andIn:&p1y]){
		[inter addObject:[NSValue valueWithCGPoint:CGPointMake(p1x, p1y)]];
	}
	if([Utils lineAndSegmentIntersectionPoint0:p andPoint1:q withSeg0:bottomRight andSeg1:bottomLeft storeIn:&p2x andIn:&p2y]){
		[inter addObject:[NSValue valueWithCGPoint:CGPointMake(p2x, p2y)]];
	}
	if([Utils lineAndSegmentIntersectionPoint0:p andPoint1:q withSeg0:bottomLeft andSeg1:topLeft storeIn:&p3x andIn:&p3y]){
		[inter addObject:[NSValue valueWithCGPoint:CGPointMake(p3x, p3y)]];
	}
	return inter;
};

+ (BOOL) lineAndSegmentIntersectionPoint0:(CGPoint) p andPoint1:(CGPoint) q withSeg0:(CGPoint)a andSeg1:(CGPoint)b storeIn: (float*) x andIn: (float*)y{
	float const TOL = 0.001;
	CGPoint d = CGPointMake(b.x - a.x, b.y - a.y);
	CGPoint e = CGPointMake(q.x - p.x, q.y - p.y);
	float lhs = p.x*e.y - p.y*e.x - a.x*e.y + a.y*e.x;
	float m = d.x*e.y - d.y*e.x;
	if(fabsf(m) > TOL){
		float mu = lhs/m;
		if (mu >= 0 && mu <=1){
			*x = a.x + mu*d.x;
			*y = a.y + mu*d.y;
			return YES;
		}
	}
	return NO;
}

@end
