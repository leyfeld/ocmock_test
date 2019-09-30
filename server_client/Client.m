
#import "Client.h"
#import "Data.h"
#import "Server.h"
#import "Utils.h"


@implementation Client
{
    Server* m_server;
}

-(instancetype)initWithServer:(Server*)server
{
    if (self = [super init])
    {
        m_server = server;
    }
    return self;
}

-(NSArray*)receiveData:(NSError**)error
{
    NSString* string = [m_server getData:error];
    NSError* errorPtr = *error;
    if(errorPtr.code != 0)
    {
        return nil;
    }
    return [Utils convertStringJsonToData:string];
}

-(NSError*)sendData:(Data*)data
{
    NSError* error = [m_server postData:[Utils convertDataToStringJson:data]];
    return error;
}



@end
