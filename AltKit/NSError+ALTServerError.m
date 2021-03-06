//
//  NSError+ALTServerError.m
//  AltStore
//
//  Created by Riley Testut on 5/30/19.
//  Copyright © 2019 Riley Testut. All rights reserved.
//

#import "NSError+ALTServerError.h"

NSErrorDomain const AltServerErrorDomain = @"com.rileytestut.AltServer";
NSErrorDomain const AltServerInstallationErrorDomain = @"com.rileytestut.AltServer.Installation";

NSErrorUserInfoKey const ALTUnderlyingErrorCodeErrorKey = @"underlyingErrorCode";
NSErrorUserInfoKey const ALTProvisioningProfileBundleIDErrorKey = @"bundleIdentifier";

@implementation NSError (ALTServerError)

+ (void)load
{
    [NSError setUserInfoValueProviderForDomain:AltServerErrorDomain provider:^id _Nullable(NSError * _Nonnull error, NSErrorUserInfoKey  _Nonnull userInfoKey) {
        if ([userInfoKey isEqualToString:NSLocalizedFailureReasonErrorKey])
        {
            return [error alt_localizedFailureReason];
        }
        
        if ([userInfoKey isEqualToString:NSLocalizedRecoverySuggestionErrorKey])
        {
            return [error alt_localizedRecoverySuggestion];
        }
        
        return nil;
    }];
}

- (nullable NSString *)alt_localizedFailureReason
{
    switch ((ALTServerError)self.code)
    {
        case ALTServerErrorUnderlyingError:
        {
            NSString *underlyingErrorCode = self.userInfo[ALTUnderlyingErrorCodeErrorKey];
            if (underlyingErrorCode == nil)
            {
                return NSLocalizedString(@"An unknown error occured.", @"");
            }
            
            return [NSString stringWithFormat:NSLocalizedString(@"Error code: %@", @""), underlyingErrorCode];
        }
        
        case ALTServerErrorUnknown:
            return NSLocalizedString(@"An unknown error occured.", @"");
            
        case ALTServerErrorConnectionFailed:
            return NSLocalizedString(@"Could not connect to AltServer.", @"");
            
        case ALTServerErrorLostConnection:
            return NSLocalizedString(@"Lost connection to AltServer.", @"");
            
        case ALTServerErrorDeviceNotFound:
            return NSLocalizedString(@"AltServer could not find this device.", @"");
            
        case ALTServerErrorDeviceWriteFailed:
            return NSLocalizedString(@"Failed to write app data to device.", @"");
            
        case ALTServerErrorInvalidRequest:
            return NSLocalizedString(@"AltServer received an invalid request.", @"");
            
        case ALTServerErrorInvalidResponse:
            return NSLocalizedString(@"AltServer sent an invalid response.", @"");
            
        case ALTServerErrorInvalidApp:
            return NSLocalizedString(@"The app is invalid.", @"");
            
        case ALTServerErrorInstallationFailed:
            return NSLocalizedString(@"An error occured while installing the app.", @"");
            
        case ALTServerErrorMaximumFreeAppLimitReached:
            return NSLocalizedString(@"Cannot activate more than 3 apps and app extensions.", @"");
            
        case ALTServerErrorUnsupportediOSVersion:
            return NSLocalizedString(@"Your device must be running iOS 12.2 or later to install AltStore.", @"");
            
        case ALTServerErrorUnknownRequest:
            return NSLocalizedString(@"AltServer does not support this request.", @"");
            
        case ALTServerErrorUnknownResponse:
            return NSLocalizedString(@"Received an unknown response from AltServer.", @"");
            
        case ALTServerErrorInvalidAnisetteData:
            return NSLocalizedString(@"Invalid anisette data.", @"");
            
        case ALTServerErrorPluginNotFound:
            return NSLocalizedString(@"Could not connect to Mail plug-in.", @"");
            
        case ALTServerErrorProfileNotFound:
            return [self profileErrorLocalizedDescriptionWithBaseDescription:NSLocalizedString(@"Could not find profile", "")];
    }
}

- (nullable NSString *)alt_localizedRecoverySuggestion
{
    switch ((ALTServerError)self.code)
    {
        case ALTServerErrorConnectionFailed:
        case ALTServerErrorDeviceNotFound:
            return NSLocalizedString(@"Make sure you have trusted this phone with your computer and WiFi sync is enabled.", @"");
            
        case ALTServerErrorPluginNotFound:
            return NSLocalizedString(@"Make sure Mail is running and the plug-in is enabled in Mail's preferences.", @"");
            
        default:
            return nil;
    }
}

- (NSString *)profileErrorLocalizedDescriptionWithBaseDescription:(NSString *)baseDescription
{
    NSString *localizedDescription = nil;
    
    NSString *bundleID = self.userInfo[ALTProvisioningProfileBundleIDErrorKey];
    if (bundleID)
    {
        localizedDescription = [NSString stringWithFormat:@"%@ “%@”", baseDescription, bundleID];
    }
    else
    {
        localizedDescription = [NSString stringWithFormat:@"%@.", baseDescription];
    }
    
    return localizedDescription;
}
    
@end
