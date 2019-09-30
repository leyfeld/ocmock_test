#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Data.h"
#import "Utils.h"
#import "Server.h"
#import "Client.h"

@interface test : XCTestCase

@end

@implementation test


- (Client*)newClientWithString:(NSString*)string
{
    id mockServer = OCMClassMock([Server class]);
    OCMStub([mockServer getData:(NSError* __autoreleasing*)[OCMArg anyPointer]]).andReturn(string);
    Client* client = [[[Client alloc]init] initWithServer:mockServer];
    return client;
}

- (void)testReceiveData
{
    NSString *expectedString = @"{\"array\":[{\"name\":\"Vasya\",\"pets\":[\"sharik\",\"tuzik\"],\"type\":1}]}";
    Client* client = [self newClientWithString:expectedString];
    NSError* error = [[NSError alloc] init];
    NSArray* array = [client receiveData:&error];
    XCTAssertTrue([array count] == 1, @"Invalid array returned");
}

- (void)testReceiveEmptyData
{
    NSError* error = [[NSError alloc] init];
    NSString* jsonString = @"";
    Client* client = [self newClientWithString:jsonString];
    NSArray* array = [client receiveData:&error];
    XCTAssertNil(array, @"Array should be nil");
}

- (void)testReceiveInvalidData
{
    NSError* error = [[NSError alloc] init];
    NSString* jsonString = @"{\"array\":[{\"name\":\"Vasya\",\"pets\":[\"sharik\",\"tuzik\"],\"type]}";
    Client* client = [self newClientWithString:jsonString];
    NSArray* array = [client receiveData:&error];
    XCTAssertNil(array, @"Array should be nil");
}

- (void)testReceiveNilData
{
    NSError* error = [[NSError alloc] init];
    NSString* jsonString = nil;
    Client* client = [self newClientWithString:jsonString];
    NSArray* array = [client receiveData:&error];
    XCTAssertNil(array, @"Array should be nil");
}

- (void)testReceiveDataReturnError
{
    NSError* error = [[NSError alloc] init];
    NSString* jsonString = @"";
    id mockServer = OCMClassMock([Server class]);
    NSError* new_error = [[NSError alloc] initWithDomain:@"" code:200 userInfo:nil];
    OCMStub([mockServer getData:[OCMArg setTo:new_error]]).andReturn(jsonString);
    Client* client = [[[Client alloc]init] initWithServer:mockServer];
    [client receiveData:&error];
    XCTAssertTrue(error.code == new_error.code, @"Invalid array returned");
}

- (void)testSendData
{
    NSError* error = [[NSError alloc] initWithDomain:@"" code:200 userInfo:nil];
    id mockServer = OCMClassMock([Server class]);
    OCMStub([mockServer postData:nil]).andReturn(error);
    Client* client = [[[Client alloc]init] initWithServer:mockServer];
    NSError* errorFromServer = [client sendData:nil];
    XCTAssertTrue(errorFromServer.code == error.code, @"");
}

- (void)testConvertNotFormatedStringJsonToData
{
    NSString *jsonString = @"{\"array\":[{\"name\":\"Vasya\",\"pets\":[\"sharik\",\"tuzik\"],\"type\":1}]}";
    NSArray* array = [Utils convertStringJsonToData:jsonString];
    XCTAssertTrue([array count] == 1, @"Incorrectly convert JSON string to data's array");
    
}

- (void)testConvertFormatedJsonToData
{
    NSString *jsonString = @"{\n"
    "    \"array\": [\n"
    "        {\n"
    "            \"name\": \"Vasya\",\n"
    "            \"type\": 1,\n"
    "            \"pets\": [\n"
    "                \"sharik\",\n"
    "                \"tuzik\"\n"
    "            ]\n"
    "        }\n"
    "    ]\n"
    "}";
    NSArray* array = [Utils convertStringJsonToData:jsonString];
    XCTAssertTrue([array count] == 1, @"Incorrectly convert JSON string to data's array");
}

- (void)testConvertEmptyStringJsonToData
{
    NSString* jsonString = @"";
    NSArray* array = [Utils convertStringJsonToData:jsonString];
    XCTAssertNil(array, @"Array should be nil");
}

- (void)testConvertNullStringJsonToData
{
    NSString* jsonString  = nil;
    NSArray* array = [Utils convertStringJsonToData:jsonString];
    XCTAssertNil(array, @"Array should be nil");
}

- (void)testConvertStringJsonWithTwoDatas
{
    NSString *jsonString = @"{\n"
    "    \"array\": [\n"
    "        {\n"
    "            \"name\": \"Vasya\",\n"
    "            \"type\": 1,\n"
    "            \"pets\": [\n"
    "                \"sharik\",\n"
    "                \"tuzik\"\n"
    "            ]\n"
    "        },\n"
    "        {\n"
    "            \"name\": \"Anna\",\n"
    "            \"type\": 2\n"
    "        }\n"
    "    ]\n"
    "}";
    NSArray* array = [Utils convertStringJsonToData:jsonString];
    XCTAssertTrue([array count] == 2, @"Incorrectly convert JSON string to data's array");
}

- (void)testConvertDataToShortStringJson
{
    NSString* expectedString = @"{\"array\":[{\"name\":\"Anna\",\"type\":2}]}";
    id array = [Utils convertStringJsonToData:expectedString];
    NSString* actualString = [Utils convertDataToStringJson:array[0]];
    XCTAssertTrue([actualString isEqualToString:expectedString], @"Incorrectly convert Data to json string");

}

- (void)testConvertDataToLongStringJson
{
    NSString* expectedString = @"{\"array\":[{\"name\":\"Vasya\",\"pets\":[\"sharik\",\"tuzik\"],\"type\":1}]}";
    id array = [Utils convertStringJsonToData:expectedString ];
    NSString* actualString = [Utils convertDataToStringJson:array[0]];
    XCTAssertTrue([actualString isEqualToString:expectedString], @"Incorrectly convert Data to json string");
}


- (void)testConvertDataWithTypeAndNameToStringJson
{
    Data* data = [[Data alloc] init];
    data.name = @"Anna";
    data.type = 2;
    NSString* expectedString = @"{\"array\":[{\"name\":\"Anna\",\"type\":2}]}";
    NSString* actualString = [Utils convertDataToStringJson:data];
    XCTAssertTrue([actualString isEqualToString:expectedString], @"Incorrectly convert Data to json string");
}

- (void)testConvertDataWithTypeToStringJson
{
    Data* data = [[Data alloc] init];
    data.type = 3;
    NSString* expectedString = @"{\"array\":[{\"type\":3}]}";
    NSString* actualString = [Utils convertDataToStringJson:data];
    XCTAssertTrue([actualString isEqualToString:expectedString], @"Incorrectly convert Data to json string");
}

- (void)testConvertDataWithEmptyNameToStringJson
{
    Data* data = [[Data alloc] init];
    data.name = @"";
    NSString* expectedString = @"{\"array\":[{\"name\":\"\"}]}";
    NSString* actualString = [Utils convertDataToStringJson:data];
    XCTAssertTrue([actualString isEqualToString:expectedString], @"Incorrectly convert Data to json string");
}

- (void)testConvertDataWithNullPetsToStringJson
{
    Data* data = [[Data alloc] init];
    data.pets = nil;
    NSString* expectedString = @"{\"array\":[{}]}";
    NSString* actualString = [Utils convertDataToStringJson:data];
    XCTAssertTrue([actualString isEqualToString:expectedString], @"Incorrectly convert Data to json string");
}

- (void)testConvertDataWithNullNameToStringJson
{
    Data* data = [[Data alloc] init];
    data.name = nil;
    NSString* expectedString = @"{\"array\":[{}]}";
    NSString* actualString = [Utils convertDataToStringJson:data];
    XCTAssertTrue([actualString isEqualToString:expectedString], @"Incorrectly convert Data to json string");
}

- (void)testConvertNullDataToStringJson
{
    Data* data = nil;
    NSString* actualString = [Utils convertDataToStringJson:data];
    XCTAssertNil(actualString, @"String should be nil");
}

@end
