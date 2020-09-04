# iOS Native Sample Application Series


The iOS  Native Sample Application Series consists of complete applications (hereinafter referred to as "solutions") and incomplete applications (hereinafter referred to as "exercises") built using the SMP OData SDK for iOS platform. Each set (exercise and solution) demonstrates a distinct functionality offered by the SDK to build native iOS applications utilizing the SAP Mobile Platform.  These exercises are identical to the solutions, except certain key code snippets are marked with TODO comments. The objective is for the end user to fill in the TODO sections with the appropriate code snippets to get each functionality working, based on the information provided in the How-to guides. The solution project has all the TODO sections already filled and can be a quick reference for the user.

## SAP Mobile Platform

SAP Mobile Platform (SMP) from SAP is the industry-leading mobile application development platform that solves mobility challenges, supports mobile apps that fit your business-to-enterprise (B2E) or business-to-consumer (B2C) use case, and helps balance device user requirements with enterprise requirements. SMP provides you with an open development environment, which enables you to develop mobile applications using familiar environments and languages, open-source tools, and third-party toolkits, libraries, and frameworks. You can leverage SAP Mobile Platform services for authentication, secure data access and integration to SAP and non-SAP back-end software, application versioning and lifecycle management, usage analytics, and end-to-end traceability.

SAP Mobile Platform SDK development tools and SDKs leverage common open source technologies and standards to increase your productivity and reduce development time.The SAP Mobile Platform SDK - available as a separate download from Service Market Place - provides you with tools that streamline the development, delivery, security and management of mobile applications.

The SCN enablement page for native application projects built using SMP SDK can be found at: http://scn.sap.com/docs/DOC-58677. The page also has links to all of the How-to guides (mentioned below )for the projects contained in this repository.
 

## Project Information

The "master" branch contains exercises. The "solution" branch contains the solutions. 
http://scn.sap.com/docs/DOC-60128 contains the details of configuring the projects to include the SMP SDK libraries.


Here is list of projects (exercise- solution pair) and the link to the corresponding How-to guides based on the topic covered.

1. 04_UserOnboarding_Exercise_Xcode and 04_UserOnboarding_Solution_Xcode

  Demonstrates how to onboard a native  application using SMP SDK.

  How-to Guide: http://scn.sap.com/docs/DOC-60196
 

2. 05_UserOnboarding_MAF_Exercise_Xcode and 05_UserOnboarding_MAF_Solution_Xcode

  Demonstrates how to onboard a native  application using SMP SDK MAF based APIs.

  How-to Guide: http://scn.sap.com/docs/DOC-60195

3. 06_ODataService_GetData_Exercise_Xcode and 06_ODataService_GetData_Solution_Xcode

  Demonstrates how to do a GET request using SMP SDK.

  How-to Guide:  http://scn.sap.com/docs/DOC-60194

4. 07_External_JSON_Exercise_Xcode and 07_External_JSON_Solution_Xcode

    Demonstrates how to connect to an external JSON service using SMP SDK.

  How-to Guide: http://scn.sap.com/docs/DOC-60193

5. 08_ODataService_PostData_Exercise_Xcode and 08_ODataService_PostData_Solution_Xcode

   Demonstrates how to do POST  and PUT requests using SMP SDK.

  How-to Guide:  http://scn.sap.com/docs/DOC-60192

6. 09_BatchRequest_Exercise_Xcode and 09_BatchRequest_Solution_Xcode

   Demonstrates how to do batch requests using SMP SDK.

  How-to Guide:  http://scn.sap.com/docs/DOC-60127

7. 10_Log_And_Trace_Exercise_Xcode and 10_Log_And_Trace_Solution_Xcode

   Demonstrates how to enable logging and tracing using SMP SDK.

  How-to Guide: http://scn.sap.com/docs/DOC-60129

8. 11_PushNotifications_Exercise_Xcode and 11_PushNotifications_Solution_Xcode

   Demonstrates how to recieve PUSH notifications using SMP SDK.

  How-to Guide: http://scn.sap.com/docs/DOC-60191

9. 13_Offline_Exercise_Xcode and 13_Offline_Solution_Xcode

   Demonstrates how to work in offline mode using SMP SDK.

   How-to Guide: http://scn.sap.com/docs/DOC-60130

10. 14_TechnicalCache_Exercise_Xcode and 14_TechnicalCache_Solution_Xcode 

   Demonstrates how to use technical cache using SMP SDK.

  How-to Guide: http://scn.sap.com/docs/DOC-65730

The projects use the ubiquitous Flight database that is shipped with SAP systems to register a device with the SMP Server and retrieve flight information and also book flights.  The OData Service exposed by NetWeaver Gateway is consumed by the solutions by utilizing the methods provided in the SDK. In addition, some projects include a call to the Federal Aviation Administration (FAA) Airport Status web service (see http://services.faa.gov/docs/services/airport/#airportStatus for more information). To demonstrate display of data using an externally available JSON Service (weather conditions and destination airport). Use of this web service may be subject to additional terms and conditions as specified by the FAA from time to time. SAP makes no representations or warranties and accepts no liability in respect of the web service or your use thereof. You are solely responsible for any use of the web service that you make.


## Licenses

This project is licensed under the Apache Software License, v. 2 except as noted otherwise in the [License file](https://github.com/SAP/sap_mobile_native_ios/blob/master/LICENSE.txt)


