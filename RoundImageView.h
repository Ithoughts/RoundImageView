#import <UIKit/UIKit.h>

@interface RoundImageView : UIView{

    UIImage *image_;
}

@property (readwrite, retain) UIImage *image;

- (id)initWithFrame:(CGRect)frame
   withCornerRadius:(CGFloat)radius
 withRoundLineWidth:(CGFloat)lineWidth;

- (id)initWithFrame:(CGRect)frame
   withCornerRadius:(CGFloat)radius
 withRoundLineWidth:(CGFloat)lineWidth
        withBGColor:(UIColor *)bgColor;

- (id)initWithFrame:(CGRect)frame
   withCornerRadius:(CGFloat)radius
 withRoundLineWidth:(CGFloat)lineWidth
        withBGColor:(UIColor *)bgColor
        isUIEnabled:(BOOL)isUIEnabled;

- (void) downLoadImageLink:(NSString *)imageLink;

- (void) downLoadImageLink:(NSString *)imageLink
    withDefaultImagePrefix:(NSString *)prefix
                 andSuffix:(NSString *)suffix;

@end
