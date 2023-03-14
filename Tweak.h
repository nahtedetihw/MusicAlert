#import <UIKit/UIKit.h>
#import "MusicAlertContainerView.h"

static void vibrate() {
    UIImpactFeedbackGenerator * feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [feedback prepare];
    [feedback impactOccurred];
}

BOOL isSmallDevice() {
    if ([UIScreen mainScreen].nativeBounds.size.width <= 750) return YES;
    return NO;
}

@interface _TtC16MusicApplication31ContextActionsHUDViewController : UIViewController
@property (nonatomic, strong) UILabel *primaryLabel;
@property (nonatomic, strong) UILabel *secondaryLabel;
@property (nonatomic) MusicAlertContainerView *musicAlertContainerView;
- (void)showMusicAlert;
- (void)hideMusicAlert;
@end

@interface _TtC15PodcastsStoreUI17HUDViewController : UIViewController
@property (nonatomic, strong) UILabel *primaryLabel;
@property (nonatomic, strong) UILabel *secondaryLabel;
@property (nonatomic) MusicAlertContainerView *musicAlertContainerView;
- (void)showMusicAlert;
- (void)hideMusicAlert;
@end
