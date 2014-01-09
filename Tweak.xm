#import <substrate.h>
#import <mach-o/dyld.h>

#define UIKIT_VERSION (NSVersionOfLinkTimeLibrary("UIKit") >> 16)

#define UIKIT_70 0xB57
#define UIKIT_71 0xB77

const char * sIsSystemApplicationSymbol(MSImageRef UIKitRef) {

    #ifdef __LP64__

        if (UIKIT_VERSION == UIKIT_70)
            return "__MergedGlobals3336";   //  7.0.4, armv8
        else if (UIKIT_VERSION == UIKIT_71) {

            if (MSFindSymbol(UIKitRef, "__MergedGlobals3384"))
                return "__MergedGlobals3384";   //  7.1b2, armv8
            else
                return "__MergedGlobals3393";   //  7.1b3, armv8

        }
        else
            return "__UIApplicationIsSystemApplication.sIsSystemApplication";

    #else

        return "__UIApplicationIsSystemApplication.sIsSystemApplication";   //  *, armv7(s)

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

    void * sIsSystemApplication = MSFindSymbol(UIKitRef, sIsSystemApplicationSymbol(UIKitRef));

    if (!sIsSystemApplication) {
        return;
    }

    BOOL s = UIApplicationIsSystemApplication_JB();

    #ifdef __LP64__

    if (UIKIT_VERSION == UIKIT_70)
    
    ((BOOL *)sIsSystemApplication)[15] = s;
    
    else if (UIKIT_VERSION == UIKIT_71)
    
    ((BOOL *)sIsSystemApplication)[17] = s;
    
    #else

    *((BOOL *)sIsSystemApplication) = s;

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

