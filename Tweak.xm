#import "Tweak.h"

MusicAlertContainerView *musicAlertContainerView;

%group Music
%hook _TtC16MusicApplication31ContextActionsHUDViewController
- (void)viewDidLoad {
    %orig;

    for (UIView *hudView in self.view.subviews) {
        if ([hudView isKindOfClass:[UIView class]]) {
            [hudView setHidden:YES];
        }
    }

    UIImageView *imageView = MSHookIvar<UIImageView *>(self, "imageView");

    musicAlertContainerView = [[MusicAlertContainerView alloc] init];
    musicAlertContainerView.frame = CGRectMake(0,0,60,190);
    musicAlertContainerView.label.text = self.primaryLabel.text;
    [self.view addSubview:musicAlertContainerView];
    musicAlertContainerView.translatesAutoresizingMaskIntoConstraints = false;
    [musicAlertContainerView.heightAnchor constraintEqualToConstant:60].active = true;
    [musicAlertContainerView.widthAnchor constraintEqualToConstant:190].active = true;
    [musicAlertContainerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:0].active = true;
    
    if (isSmallDevice()) {
        [musicAlertContainerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-150].active = YES;
    } else {
        [musicAlertContainerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-168].active = YES;
    }
    
    if ([self.primaryLabel.text isEqualToString:@"Added to Library"]) {
        musicAlertContainerView.imageView.image = [UIImage systemImageNamed:@"checkmark.circle.fill"];
    } else {
        if (imageView.image != nil) {
            musicAlertContainerView.imageView.image = imageView.image;
        } else {
            musicAlertContainerView.imageView.image = [UIImage systemImageNamed:@"checkmark.circle.fill"];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    [self showMusicAlert];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideMusicAlert];
    });
}

%new
- (void)showMusicAlert {
    vibrate();
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:nil animations:^{
        musicAlertContainerView.alpha = 1.0;
        musicAlertContainerView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}

%new
- (void)hideMusicAlert {
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:nil animations:^{
        musicAlertContainerView.alpha = 0.0;
        musicAlertContainerView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished){
        if (finished) {
            musicAlertContainerView = nil;
        }
    }];
}
%end
%end

%group Podcasts
%hook _TtC15PodcastsStoreUI17HUDViewController
- (void)viewDidLoad {
    %orig;

    for (UIView *hudView in self.view.subviews) {
        if ([hudView isKindOfClass:[UIView class]]) {
            [hudView setHidden:YES];
        }
    }

    UIImageView *imageView = MSHookIvar<UIImageView *>(self, "imageView");

    musicAlertContainerView = [[MusicAlertContainerView alloc] init];
    musicAlertContainerView.frame = CGRectMake(0,0,60,190);
    musicAlertContainerView.label.text = self.primaryLabel.text;
    [self.view addSubview:musicAlertContainerView];
    musicAlertContainerView.translatesAutoresizingMaskIntoConstraints = false;
    [musicAlertContainerView.heightAnchor constraintEqualToConstant:60].active = true;
    [musicAlertContainerView.widthAnchor constraintEqualToConstant:190].active = true;
    [musicAlertContainerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:0].active = true;
    
    if (isSmallDevice()) {
        [musicAlertContainerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-150].active = YES;
    } else {
        [musicAlertContainerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-168].active = YES;
    }
    
    if ([self.primaryLabel.text isEqualToString:@"Added to Library"]) {
        musicAlertContainerView.imageView.image = [UIImage systemImageNamed:@"checkmark.circle.fill"];
    } else {
        if (imageView.image != nil) {
            musicAlertContainerView.imageView.image = imageView.image;
        } else {
            musicAlertContainerView.imageView.image = [UIImage systemImageNamed:@"checkmark.circle.fill"];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showMusicAlert];
    });
    [self showMusicAlert];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideMusicAlert];
    });
}

%new
- (void)showMusicAlert {
    vibrate();
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:nil animations:^{
        musicAlertContainerView.alpha = 1.0;
        musicAlertContainerView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}

%new
- (void)hideMusicAlert {
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:nil animations:^{
        musicAlertContainerView.alpha = 0.0;
        musicAlertContainerView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished){
        if (finished) {
            musicAlertContainerView = nil;
        }
    }];
}
%end
%end

%ctor {
    if (![NSProcessInfo processInfo]) return;
    NSString *processName = [NSProcessInfo processInfo].processName;
    if ([processName isEqualToString:@"Music"]) {
        %init(Music);
        return;
    }
    
    if ([processName isEqualToString:@"Podcasts"]) {
        %init(Podcasts);
        return;
    }
}
