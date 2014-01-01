#include <substrate.h>

UIKIT_EXTERN BOOL _UIApplicationUsesLegacyUI();

typedef  struct { 
        unsigned int deactivatingReasonFlags : 8; 
        unsigned int isSuspended : 1; 
        unsigned int isSuspendedEventsOnly : 1; 
        unsigned int isLaunchedSuspended : 1; 
        unsigned int calledNonSuspendedLaunchDelegate : 1; 
        unsigned int isHandlingURL : 1; 
        unsigned int isHandlingRemoteNotification : 1; 
        unsigned int isHandlingLocalNotification : 1; 
        unsigned int isHandlingBackgroundContentFetch : 1; 
        unsigned int statusBarShowsProgress : 1; 
        unsigned int statusBarHidden : 1; 
        unsigned int blockInteractionEvents : 4; 
        unsigned int receivesMemoryWarnings : 1; 
        unsigned int showingProgress : 1; 
        unsigned int receivesPowerMessages : 1; 
        unsigned int launchEventReceived : 1; 
        unsigned int systemIsAnimatingApplicationLifecycleEvent : 1; 
        unsigned int isResuming : 1; 
        unsigned int isSuspendedUnderLock : 1; 
        unsigned int shouldExitAfterSendSuspend : 1; 
        unsigned int terminating : 1; 
        unsigned int isHandlingShortCutURL : 1; 
        unsigned int idleTimerDisabled : 1; 
        unsigned int deviceOrientation : 3; 
        unsigned int delegateShouldBeReleasedUponSet : 1; 
        unsigned int delegateHandleOpenURL : 1; 
        unsigned int delegateOpenURL : 1; 
        unsigned int delegateDidReceiveMemoryWarning : 1; 
        unsigned int delegateWillTerminate : 1; 
        unsigned int delegateSignificantTimeChange : 1; 
        unsigned int delegateWillChangeInterfaceOrientation : 1; 
        unsigned int delegateDidChangeInterfaceOrientation : 1; 
        unsigned int delegateWillChangeStatusBarFrame : 1; 
        unsigned int delegateDidChangeStatusBarFrame : 1; 
        unsigned int delegateDeviceAccelerated : 1; 
        unsigned int delegateDeviceChangedOrientation : 1; 
        unsigned int delegateDidBecomeActive : 1; 
        unsigned int delegateWillResignActive : 1; 
        unsigned int delegateDidEnterBackground : 1; 
        unsigned int delegateDidEnterBackgroundWasSent : 1; 
        unsigned int delegateWillEnterForeground : 1; 
        unsigned int delegateWillSuspend : 1; 
        unsigned int delegateDidResume : 1; 
        unsigned int delegateSupportsStateRestoration : 1; 
        unsigned int delegateSupportedInterfaceOrientations : 1; 
        unsigned int userDefaultsSyncDisabled : 1; 
        unsigned int headsetButtonClickCount : 4; 
        unsigned int isHeadsetButtonDown : 1; 
        unsigned int isFastForwardActive : 1; 
        unsigned int isRewindActive : 1; 
        unsigned int shakeToEdit : 1; 
        unsigned int isClassic : 1; 
        unsigned int zoomInClassicMode : 1; 
        unsigned int ignoreHeadsetClicks : 1; 
        unsigned int touchRotationDisabled : 1; 
        unsigned int taskSuspendingUnsupported : 1; 
        unsigned int taskSuspendingOnLockUnsupported : 1; 
        unsigned int isUnitTests : 1; 
        unsigned int requiresHighResolution : 1; 
        unsigned int disableViewContentScaling : 1; 
        unsigned int singleUseLaunchOrientation : 3; 
        unsigned int defaultInterfaceOrientation : 3; 
        unsigned int supportedInterfaceOrientationsMask : 5; 
        unsigned int delegateWantsNextResponder : 1; 
        unsigned int isRunningInApplicationSwitcher : 1; 
        unsigned int isSendingEventForProgrammaticTouchCancellation : 1; 
        unsigned int delegateWantsStatusBarTouchesEnded : 1; 
        unsigned int interfaceLayoutDirectionIsValid : 1; 
        unsigned int interfaceLayoutDirection : 3; 
        unsigned int restorationExtended : 1; 
        unsigned int normalRestorationInProgress : 1; 
        unsigned int normalRestorationCompleted : 1; 
        unsigned int isDelayingTintViewChange : 1; 
        unsigned int isUpdatingTintViewColor : 1; 
        unsigned int isHandlingMemoryWarning : 1; 
        unsigned int forceStatusBarTintColorChanges : 1; 
        unsigned int disableLegacyAutorotation : 1; 
        unsigned int isFakingForegroundTransitionForBackgroundFetch : 1; 
        unsigned int couldNotRestoreStateWhenLocked : 1; 
        unsigned int disableStyleOverrides : 1; 
        unsigned int legibilityAccessibilitySettingEnabled : 1; 
        unsigned int viewControllerBasedStatusBarAppearance : 1; 
        unsigned int fakingRequiresHighResolution : 1; 
        unsigned int isStatusBarFading : 1; 
} ApplicationFlags;

@interface UIApplication (Custom)

- (BOOL)UIApplicationIsSystemApplication;

@end

%hook UIApplication

%new
- (BOOL)UIApplicationIsSystemApplication {

	NSURL * bundleURL = [[NSBundle mainBundle] bundleURL];

	if (![bundleURL isFileURL])
		return NO;

	if (![[bundleURL path] isAbsolutePath])
		return NO;

	NSArray * components = [[bundleURL path] pathComponents];

	if ([components count] >= 2) {

		return [[components objectAtIndex:([components count] - 2)] isEqualToString:@"Applications"];

	}

	return NO;

}

- (void)_fetchInfoPlistFlags {

    %orig;

    if (_UIApplicationUsesLegacyUI())
        return;

    ApplicationFlags &_applicationFlags = MSHookIvar<ApplicationFlags>(self, "_applicationFlags");

    if (![[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIViewControllerBasedStatusBarAppearance"]) {
		_applicationFlags.viewControllerBasedStatusBarAppearance = ![self UIApplicationIsSystemApplication];
    }

}

%end
