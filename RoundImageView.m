#import "RoundImageView.h"
#import "SDWebImageManager.h"

#define   pi 3.14159265359
#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)

@interface RoundImageView ()

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, assign) CGFloat radius;

@end

@implementation RoundImageView

@dynamic image;
@synthesize radius = _radius;
@synthesize lineWidth = _lineWidth;
@synthesize bgColor = _bgColor;

- (id)initWithFrame:(CGRect)frame
   withCornerRadius:(CGFloat)radius
 withRoundLineWidth:(CGFloat)lineWidth;
{
    self = [self initWithFrame:frame
              withCornerRadius:radius
            withRoundLineWidth:lineWidth
                   withBGColor:nil
                   isUIEnabled:YES];

    return self;
}

- (id)initWithFrame:(CGRect)frame
   withCornerRadius:(CGFloat)radius
 withRoundLineWidth:(CGFloat)lineWidth
        withBGColor:(UIColor *)bgColor
{
    self = [self initWithFrame:frame
              withCornerRadius:radius
            withRoundLineWidth:lineWidth
                   withBGColor:bgColor
                   isUIEnabled:YES];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
   withCornerRadius:(CGFloat)radius
 withRoundLineWidth:(CGFloat)lineWidth
        withBGColor:(UIColor *)bgColor
        isUIEnabled:(BOOL)isUIEnabled
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _radius = radius;
        
        self.alpha = 0.0f;
        
        _lineWidth = lineWidth;
        
        _bgColor = bgColor;
        
        self.userInteractionEnabled = isUIEnabled;
    }
    return self;
}

- (void)dealloc {
    
    image_ = nil;
    _bgColor = nil;
}

- (void)drawRect:(CGRect)rect {
    
    //1.圆形
    CGRect bounds = self.bounds;
    
    if(!_bgColor)
    {
        [[UIColor clearColor] set];
    }
    else{
    
        [_bgColor set];
    }
    
    UIRectFill(bounds);
    [[UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:_radius] addClip];
    
    //2.背景透明
    
    if (!_bgColor) {
        self.backgroundColor = [UIColor clearColor];
    }
    else{
        self.backgroundColor = _bgColor;
    }
    
    if (image_) {
        [image_ drawInRect:bounds];
        self.alpha = 1.0f;
        
        //3.画环
        UIColor *color = [UIColor whiteColor];
        [color set]; //设置线条颜色
        
        UIBezierPath* aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
                                                             radius:_radius
                                                         startAngle:0
                                                           endAngle:DEGREES_TO_RADIANS(360)
                                                          clockwise:YES];
        
        aPath.lineWidth = _lineWidth;
        aPath.lineCapStyle = kCGLineCapRound; //线条拐角
        aPath.lineJoinStyle = kCGLineCapRound; //终点处理
        
        [aPath stroke];
    }
}

- (void) downLoadImageLink:(NSString *)imageLink
{
    [self downLoadImageLink:imageLink withDefaultImagePrefix:nil andSuffix:nil];
}

- (void) downLoadImageLink:(NSString *)imageLink
    withDefaultImagePrefix:(NSString *)prefix
                 andSuffix:(NSString *)suffix
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    if (imageLink) {
        
        [manager downloadWithURL:[NSURL URLWithString:imageLink]
                         options:0
                        progress:^(NSUInteger receivedSize, long long expectedSize)
         {
             // progression tracking code
         }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
         {
             if (image)
             {
                 // do something with image
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     self.image = image;
                 });
                 
             }
             else{
                 
                 if (prefix) {
                     
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         self.image = LoadImage(prefix, suffix);
                     });
                     
                 }
             }
         }];
    }
    else{
        
        if (prefix) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.image = LoadImage(prefix, suffix);
            });
            
        }
    }
}

#pragma mark - Accessor

- (void)setImage:(UIImage *)image {
    
    image_ = image;
    
    [self setNeedsDisplayInRect:self.bounds];
}

- (UIImage *)image {
    
    return image_;
}

@end
