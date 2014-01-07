#import <substrate.h>
#import <mach-o/dyld.h>

#define UIKIT_VERSION (NSVersionOfLinkTimeLibrary("UIKit") >> 16)

#define UIKIT_70 0xB57

const char * sIsSystemApplicationSymbol() {

    #ifdef __LP64__

        if (UIKIT_VERSION == UIKIT_70)
            return "__MergedGlobals3336";
        else
            return "__UIApplicationIsSystemApplication.sIsSystemApplication";

    #else

        return "__UIApplicationIsSystemApplication.sIsSystemApplication";

    #endif

}

BOOL UIApplicationIsSystemApplication_JB() {

    NSURL * bundleURL = [[NSBundle mainBundle] bundleURL];

    if (![bundleURL isFileURL])
        return NO;

    if (![[bundleURL path] isAbsolutePath])
		return NO;

    NSArray * components = [[[bundleURL path] stringByResolvingSymlinksInPath] pathComponents];

    if ([components count] == 2)
        return NO;

    if ([components count] >= 2) {

        if ([[components objectAtIndex:([components count] - 2)] hasPrefix:@"Applications"])
            return YES;
        else if (![[components objectAtIndex:([components count] - 3)] hasPrefix:@"AppleInternal"])
            return NO;

    }

    return NO;

}

void UIApplicationIsSystemApplication_JB_block(void) {

    MSImageRef UIKitRef = MSGetImageByName(UIKit_f);

    if (!UIKitRef)
        return;

    void * sIsSystemApplication = MSFindSymbol(UIKitRef, sIsSystemApplicationSymbol());

    if (!sIsSystemApplication) {
        return;
    }

    BOOL isSystemApplication = UIApplicationIsSystemApplication_JB();

    #ifdef __LP64__
    ((unsigned char *)sIsSystemApplication)[0] = isSystemApplication;
    ((unsigned char *)sIsSystemApplication)[15] = isSystemApplication;
    #else
    *((BOOL *)sIsSystemApplication) = isSystemApplication;
    #endif
}

%ctor {

    MSImageRef UIKitRef = MSGetImageByName(UIKit_f);

    if (!UIKitRef)
        return;

    void * ____UIApplicationIsSystemApplication_block_invoke = MSFindSymbol(UIKitRef, "____UIApplicationIsSystemApplication_block_invoke");

    if (!____UIApplicationIsSystemApplication_block_invoke)
        return;

    void * ____UIApplicationIsSystemApplication_block_invoke_old;

    MSHookFunction(____UIApplicationIsSystemApplication_block_invoke, (void *)UIApplicationIsSystemApplication_JB_block, &____UIApplicationIsSystemApplication_block_invoke_old);

}

