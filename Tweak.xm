#import <UIKit/UIKit.h>

// Statically define our views so we can access them in another method.
UIVisualEffectView *effectView;
UIStackView *stackView;
UILabel *newLabel;
UIImageView *newImageView;

// Add a slight vibration
static void vibrate() {
    UIImpactFeedbackGenerator * feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [feedback prepare];
    [feedback impactOccurred];
}

@interface _TtC16MusicApplication31ContextActionsHUDViewController : UIViewController
// Existing methods
@property (nonatomic, strong) UILabel *primaryLabel;
@property (nonatomic, strong) UILabel *secondaryLabel;
// New Methods
- (void)showMusicAlert;
- (void)hideMusicAlert;
@end

// Determine if screen is size of iPhone 7
BOOL isSmallDevice() {
    if ([UIScreen mainScreen].nativeBounds.size.width <= 750) return YES;
    return NO;
}

// The swift class is MusicApplication.ContextActionsHUDViewController
// The swizzled class is _TtC16MusicApplication31ContextActionsHUDViewController
// You could use objcgetclass but I find this method better so we can access the properties and call self
%hook _TtC16MusicApplication31ContextActionsHUDViewController
- (void)viewDidLoad {
    %orig;
    
    // Hide the original HUDView
    UIView *HUDView = MSHookIvar<UIView *>(self, "HUDView");
    HUDView.hidden = YES;
    
    // Get the original imageView containing the icons
    UIImageView *imageView = MSHookIvar<UIImageView *>(self, "imageView");
    
    // Create the blurView that goes behind the stackView
    effectView = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(0,0,50,170)];
    effectView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    effectView.alpha = 0.0;
    effectView.layer.cornerCurve = kCACornerCurveContinuous;
    effectView.layer.cornerRadius = effectView.frame.size.height/12;
    effectView.layer.masksToBounds = YES;
    effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
    [self.view insertSubview:effectView atIndex:0];
    effectView.translatesAutoresizingMaskIntoConstraints = false;
    [effectView.heightAnchor constraintEqualToConstant:50].active = true;
    [effectView.widthAnchor constraintEqualToConstant:170].active = true;
    [effectView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:0].active = true;
    
    // Push it higher if device is bigger
    if (isSmallDevice()) {
        [effectView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-130].active = YES;
    } else {
        [effectView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-158].active = YES;
    }
    
    // create the stackView with horizontal layout
    stackView = [UIStackView new];
    stackView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    stackView.alpha = 0.0;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.spacing = 0;
    stackView.layoutMarginsRelativeArrangement = YES;
    stackView.layoutMargins = UIEdgeInsetsMake(0,25,0,10);
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    
    // Create the newImageView
    newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25,0,25,25)];
    // For some reason the Add to Library icon wouldn't work but all others did
    if ([self.primaryLabel.text isEqualToString:@"Added to Library"]) {
        // Set it to a custom SFSymbol
        newImageView.image = [UIImage systemImageNamed:@"checkmark.circle.fill"];
    } else {
        if (imageView.image != nil) {
            // if the original imageView has an image, set it
            newImageView.image = imageView.image;
        } else {
            // If it doesn't have an image, set it to a random SFSymbol (Hopefully we will never see this symbol)
            newImageView.image = [UIImage systemImageNamed:@"checkmark.circle.fill"];
        }
    }
    newImageView.tintColor = [UIColor labelColor];
    newImageView.contentMode = UIViewContentModeScaleAspectFit;
    [stackView addArrangedSubview:newImageView];
    [newImageView.heightAnchor constraintEqualToConstant:25].active = true;
    [newImageView.widthAnchor constraintEqualToConstant:25].active = true;
    
    // Create our label
    newLabel = [UILabel new];
    newLabel.frame = CGRectMake(0,0,120,40);
    newLabel.textColor = [UIColor labelColor];
    newLabel.text = self.primaryLabel.text;
    newLabel.font = [UIFont boldSystemFontOfSize:14];
    newLabel.lineBreakMode = NSLineBreakByWordWrapping;
    newLabel.numberOfLines = 0;
    newLabel.textAlignment = NSTextAlignmentCenter;
    [stackView addArrangedSubview:newLabel];
    [newLabel.heightAnchor constraintEqualToConstant:40].active = true;
    [newLabel.widthAnchor constraintEqualToConstant:120].active = true;
    
    [self.view addSubview:stackView];
    [stackView.widthAnchor constraintEqualToAnchor:effectView.widthAnchor].active = true;
    [stackView.heightAnchor constraintEqualToAnchor:effectView.heightAnchor].active = true;
    [stackView.centerXAnchor constraintEqualToAnchor:effectView.centerXAnchor].active = true;
    [stackView.centerYAnchor constraintEqualToAnchor:effectView.centerYAnchor].active = true;
}

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    // Show the alert then force it hidden after 1.9 seconds (right before the original hud is dismissed, to avoid the animations is uses)
    [self showMusicAlert];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideMusicAlert];
    });
}

%new
- (void)showMusicAlert {
    // using SpringAnimation to scale up slightly while showing our alert
    vibrate();
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:nil animations:^{
        stackView.transform = CGAffineTransformMakeScale(1, 1);
        effectView.transform = CGAffineTransformMakeScale(1, 1);
        stackView.alpha = 1.0;
        effectView.alpha = 1.0;
    } completion:nil];
}

%new
- (void)hideMusicAlert {
    // using SpringAnimation to scale down slightly before hiding our alert
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:nil animations:^{
        stackView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        effectView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        stackView.alpha = 0.0;
        effectView.alpha = 0.0;
    } completion:^(BOOL finished){
        // remove our views completely
        if (finished) {
            stackView = nil;
            effectView = nil;
            newLabel = nil;
            newImageView = nil;
        }
    }];
}
%end
