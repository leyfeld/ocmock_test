#import "Utils.h"
#import "Data.h"

@implementation Utils

+(NSArray*)convertStringJsonToData:(NSString*)jsonString
{
    if(jsonString == nil)
    {
        return nil;
    }
    NSError* error = [[NSError alloc] init];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if(error.code != 0)
    {
        return nil;
    }
    NSArray* arrayFromJson = [json valueForKey:@"array"];
    NSMutableArray* arrayData = [[NSMutableArray alloc] init];
    for(int i = 0; i < [arrayFromJson count]; i++)
    {
        Data* data = [[Data alloc]init];
        data.name = [arrayFromJson[i] valueForKey:@"name"];
        data.pets = [arrayFromJson[i] valueForKey:@"pets"];
        NSNumber* type = [arrayFromJson[i] valueForKey:@"type"];
        NSInteger value = [type integerValue];
        data.type = (enum Sex)value;
        [arrayData addObject:data];
    }
    return arrayData;
}

+(NSString*)convertDataToStringJson:(Data*)data
{
    NSDictionary* dataToJson = [Utils createDictionaryWithData:data];
    if(!dataToJson)
    {
        return nil;
    }
    NSMutableArray* arrayWithJson = [[NSMutableArray alloc] init];
    [arrayWithJson addObject:dataToJson];
    NSDictionary* rootDictinary = [[NSDictionary alloc] initWithObjectsAndKeys:arrayWithJson,@"array", nil];
    NSData* nsdata = [NSJSONSerialization  dataWithJSONObject:rootDictinary options:0 error:nil];
    NSString* stringWithJson = [[NSString alloc] initWithData:nsdata   encoding:NSUTF8StringEncoding];
    NSLog(@"%@",stringWithJson);
    return stringWithJson;
}

+(NSDictionary*)createDictionaryWithData:(Data*)data
{
    if(!data)
    {
        return nil;
    }
    NSMutableDictionary* dictData = [[NSMutableDictionary alloc] init];
    if(data.name)
    {
        [dictData setObject:data.name forKey:@"name"];
    }
    if(data.pets)
    {
        [dictData setObject:data.pets forKey:@"pets"];
    }
    if(data.type)
    {
        NSInteger myValue = data.type;
        NSNumber* number = [NSNumber numberWithInteger: myValue];
        [dictData setObject:number forKey:@"type"];
    }
    return dictData;
}
@end
