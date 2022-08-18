# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Web Application Enumeration

## Web application resources
[Mozilla](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/Identifying_resources_on_the_Web) defines a _resource_ as a directory or file (document, photo or anything else) that is the target of an HTTP request. An HTTP request to a resource that does not exist will result in a HTTP 404 Not Found response code. A request to any resource that exists will result in some other HTTP response code. Examples of common response codes for resources that exist include:
|HTTP Response Code|Description|
|:-:|---|
|200|OK. The request succeeded.|
|301|Redirect. Resource permanently moved.|
|401|Unauthenticated. Client must authenticate to access resource|
|403|Forbidden. Client's identity is known but client not authorized to access the resource.|
|500|Internal server error. A general error that just means something didn't work or wasn't allowed.|

In general, a 404 response code means a requrested resource does not exist. Any other response code can generally indicate that a requested resource does exist. This pattern of behavior can be used to identify resources through [forced browsing](https://owasp.org/www-community/attacks/Forced_browsing#:~:text=Forced%20browsing%20is%20an%20attack,application%2C%20but%20are%20still%20accessible.) Attackers or web application testers use forced browsing to enumerate and access resources that are not referenced by an application, or to identify applications that may not be intended for public access.
