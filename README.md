iOS Native Sample Application Series

The iOS  Native Sample Application Series consists of complete applications (hereinafter referred to as "solutions") and incomplete applications (hereinafter referred to as "exercises") built using the SMP OData SDK for iOS platform. Each set ( exercise and solution) demonstrates a distinct functionality offered by the SDK to build native iOS applications utilizing the SAP Mobile Platform.  These exercises are identical to the solutions, except certain key code snippets are marked with TODO comments.  The objective is for the end user to fill in the TODO sections with the appropriate code snippets to get each functionality working, based on the information provided in the How To… guides. The solution project has all the TODO sections already filled and can be a quick reference for the user.

The "master" branch contains the exercises.
The "solution" branch contains the solutions. 

All the How To... guides associated with each project can be found at :
http://scn.sap.com/docs/DOC-58677#iOS 

 
SAP Mobile Platform  SDK hides all the complexities involved in consuming an OData Service.  The SDK leverages the power and simplicity of Microsoft’s asynchronous programming, dependency properties and other key concepts.  

The projects use the ubiquitous Flight database that is shipped with SAP systems to register a device with the SMP Server and retrieve flight information and also book flights.  The OData Service exposed by NetWeaver Gateway is consumed by the solutions by utilizing the methods provided in the SDK.  In addition, some projects include a call to the Federal Aviation Administration (FAA) Airport Status web service (see http://services.faa.gov/docs/services/airport/#airportStatus for more information). to demonstrate display of data using an externally available JSON Service.( weather conditions a destination airport).Use of this web service may be subject to additional terms and conditions as specified by the FAA from time to time. SAP makes no representations or warranties and accepts no liability in respect of the web service or your use thereof. You are solely responsible for any use of the web service that you make.
