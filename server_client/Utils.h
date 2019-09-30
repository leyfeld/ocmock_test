#import <Foundation/Foundation.h>

@class Data;
@interface Utils : NSObject
+(NSArray*)convertStringJsonToData:(NSString*)jsonString;
+(NSString*)convertDataToStringJson:(Data*)data;
@end
