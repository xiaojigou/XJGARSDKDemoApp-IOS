
#import <UIKit/UIKit.h>
#import "XJGARSDKResSelViewController.h"

//The UIViewController class provides the infrastructure for managing the views of your iOS apps. A view controller manages a set of views that make up a portion of your app’s user interface. It is responsible for loading and disposing of those views, for managing interactions with those views, and for coordinating responses with any appropriate data objects. View controllers also coordinate their efforts with other controller objects—including other view controllers—and help manage your app’s overall interface.
//
//Use a navigation controller delegate (a custom object that implements this protocol) to modify behavior when a view controller is pushed or popped from the navigation stack of a UINavigationController object.
//
//The UIImagePickerControllerDelegate protocol defines methods that your delegate object must implement to interact with the image picker interface. The methods of this protocol notify your delegate when the user either picks an image or movie, or cancels the picker operation.
@interface ImageSampleViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, XJGARSDKChangeResDelegate>

@end
