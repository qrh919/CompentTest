
#import "QWaterView.h"

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface QWaterView ()
{
    CGFloat _waveAmplitude;      //!< 振幅
    
    CGFloat _waveCycle;          //!< 周期
    
    CGFloat _waveSpeed1;          //!< 速度
    CGFloat _waveSpeed2;
    
    CGFloat _waterWaveHeight;   //视图的高
    CGFloat _waterWaveWidth;    //视图的宽
    
    CGFloat _wavePointY1;       //起点的Y值
    CGFloat _wavePointY2;
    
    CGFloat _waveOffsetX1; //!< 波浪x位移
    CGFloat _waveOffsetX2;
    
}
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic,strong) CAShapeLayer *firstWaveLayer;
@property (nonatomic,strong) CAShapeLayer *secondeWaveLayer;



@end

@implementation QWaterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self ConfigParams];
        
    }
    return self;
}

-(void)setAmplitude:(CGFloat)amplitude{
    _amplitude = amplitude;
    _waveAmplitude = amplitude;
}

-(void)setCycle:(CGFloat)cycle{
    _cycle = cycle;
    _waveCycle = cycle/_waterWaveWidth;
}

-(void)setType:(QWaterType)type{
    _type = type;
    if(type == QWaterTypeFromTop){
        _wavePointY1 = self.bounds.size.height;
        _wavePointY2 = self.bounds.size.height;
    }else{
        _wavePointY1 = 0;
        _wavePointY2 = 0;
    }
}

- (CAShapeLayer *)firstWaveLayer
{
    if (!_firstWaveLayer) {
        _firstWaveLayer = [CAShapeLayer layer];
        _firstWaveLayer.strokeColor = [UIColor clearColor].CGColor;
        _firstWaveLayer.fillColor = rgba(91, 142, 234,0.5).CGColor;
    }
    return _firstWaveLayer;
}
- (CAShapeLayer *)secondeWaveLayer
{
    if (!_secondeWaveLayer) {
        _secondeWaveLayer = [CAShapeLayer layer];
        _secondeWaveLayer.strokeColor = [UIColor clearColor].CGColor;
        _secondeWaveLayer.fillColor = rgba(91, 142, 234,0.5).CGColor;
    }
    return _secondeWaveLayer;
}

- (void)drawRect:(CGRect)rect
{
    self.layer.masksToBounds = NO;
    [self.layer addSublayer:self.firstWaveLayer];
    [self.layer addSublayer:self.secondeWaveLayer];
    [self draw:0 waveOffsetX2:0];
    
}
- (void)draw:(CGFloat)waveOffsetX waveOffsetX2:(CGFloat)waveOffsetX2
{
    if(_type == QWaterTypeFromBottom){
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(0, self.bounds.size.height)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
        CGFloat yP1 = 0;
        for (float x = self.bounds.size.width; x>= 0; x --) {
            yP1 = _waveAmplitude * sin(_waveCycle * x + waveOffsetX - 10) + _wavePointY1 + 10;
            [path addLineToPoint:CGPointMake(x, yP1)];
        }
        self.firstWaveLayer.path = path.CGPath;
        
        UIBezierPath *path2 = [UIBezierPath bezierPath];
        [path2 moveToPoint:CGPointMake(0, 0)];
        [path2 addLineToPoint:CGPointMake(0, self.bounds.size.height)];
        [path2 addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
        [path2 addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
        CGFloat yP2 = 0;
        for (float x = self.bounds.size.width; x>= 0; x --) {
            yP2 = _waveAmplitude * sin(_waveCycle * x + waveOffsetX2 - 20) + _wavePointY2 + 10;
            [path2 addLineToPoint:CGPointMake(x, yP2)];
        }
        self.secondeWaveLayer.path = path2.CGPath;
    }else{
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, self.bounds.size.height)];
        [path addLineToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
        CGFloat yP1 = self.bounds.size.height;
        for (float x = self.bounds.size.width; x>= 0; x --) {
            yP1 = _waveAmplitude * sin(_waveCycle * x + waveOffsetX - 10) + _wavePointY1 + 10;
            [path addLineToPoint:CGPointMake(x, yP1)];
        }
        self.firstWaveLayer.path = path.CGPath;
        
        UIBezierPath *path2 = [UIBezierPath bezierPath];
        [path2 moveToPoint:CGPointMake(0, self.bounds.size.height)];
        [path2 addLineToPoint:CGPointMake(0, 0)];
        [path2 addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
        [path2 addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
        CGFloat yP2 = self.bounds.size.height;
        for (float x = self.bounds.size.width; x>= 0; x --) {
            yP2 = _waveAmplitude * sin(_waveCycle * x + waveOffsetX2 - 20) + _wavePointY2 + 10;
            [path2 addLineToPoint:CGPointMake(x, yP2)];
        }
        self.secondeWaveLayer.path = path2.CGPath;
    }
}
#pragma mark 默认配置参数
- (void)ConfigParams
{
    _waterWaveWidth = self.frame.size.width;
    _waterWaveHeight = self.frame.size.height;
    
    _waveSpeed1 = 0.02/M_PI;
    _waveSpeed2 = 0.03/M_PI;
    
    _waveOffsetX1 = 0;
    _waveOffsetX2 = 0;
    
    _wavePointY1 = 0;
    _wavePointY2 = 0;
    
    _waveAmplitude = 30;
    
    _waveCycle =  1 * M_PI / _waterWaveWidth;
}

#pragma mark 加载layer ，绑定runloop 帧刷新
- (void)startWave
{
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark 帧刷新事件
- (void)getCurrentWave
{
    _waveOffsetX1 += _waveSpeed1;
    _waveOffsetX2 += _waveSpeed2;
    [self draw:_waveOffsetX1 waveOffsetX2:_waveOffsetX2];
    
}

- (CADisplayLink *)displayLink
{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave)];
    }
    return _displayLink;
}

@end
