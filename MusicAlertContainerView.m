#import "MusicAlertContainerView.h"

@implementation MusicAlertContainerView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.alpha = 0.0;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 8;
        self.layer.shadowOffset = CGSizeMake(0.0,3.0);
        
        self.effectView = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(0,0,60,190)];
        self.effectView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.effectView.layer.cornerCurve = kCACornerCurveContinuous;
        self.effectView.layer.cornerRadius = self.effectView.frame.size.height/12;
        self.effectView.layer.masksToBounds = YES;
        self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
        [self insertSubview:self.effectView atIndex:0];
        self.effectView.translatesAutoresizingMaskIntoConstraints = false;
        [self.effectView.heightAnchor constraintEqualToConstant:60].active = true;
        [self.effectView.widthAnchor constraintEqualToConstant:190].active = true;
        [self.effectView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = true;
        
        self.stackView = [UIStackView new];
        self.stackView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.stackView.axis = UILayoutConstraintAxisHorizontal;
        self.stackView.alignment = UIStackViewAlignmentFill;
        self.stackView.distribution = UIStackViewDistributionEqualSpacing;
        self.stackView.spacing = 5;
        self.stackView.layoutMarginsRelativeArrangement = YES;
        self.stackView.layoutMargins = UIEdgeInsetsMake(0,25,0,10);
        self.stackView.translatesAutoresizingMaskIntoConstraints = false;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25,0,30,30)];
        self.imageView.tintColor = [UIColor labelColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.stackView addArrangedSubview:self.imageView];
        [self.imageView.heightAnchor constraintEqualToConstant:30].active = true;
        [self.imageView.widthAnchor constraintEqualToConstant:30].active = true;
        
        self.label = [UILabel new];
        self.label.frame = CGRectMake(0,0,120,40);
        self.label.textColor = [UIColor labelColor];
        self.label.text = @"";
        self.label.font = [UIFont boldSystemFontOfSize:16];
        self.label.lineBreakMode = NSLineBreakByWordWrapping;
        self.label.numberOfLines = 0;
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.stackView addArrangedSubview:self.label];
        [self.label.heightAnchor constraintEqualToConstant:40].active = true;
        [self.label.widthAnchor constraintEqualToConstant:120].active = true;
        
        [self addSubview:self.stackView];
        self.stackView.translatesAutoresizingMaskIntoConstraints = false;
        [self.stackView.heightAnchor constraintEqualToConstant:60].active = true;
        [self.stackView.widthAnchor constraintEqualToConstant:190].active = true;
        [self.stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = true;
    }
    return self;
}
@end
