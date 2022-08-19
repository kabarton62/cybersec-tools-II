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

<sub>**Table 1, HTTP Response Codes**</sub>

In general, a 404 response code means a requrested resource does not exist. Any other response code can generally indicate that a requested resource does exist. This pattern of behavior can be used to identify resources through [forced browsing](https://owasp.org/www-community/attacks/Forced_browsing#:~:text=Forced%20browsing%20is%20an%20attack,application%2C%20but%20are%20still%20accessible.) Attackers or web application testers use forced browsing to enumerate and access resources that are not referenced by an application, or to identify applications that may not be intended for public access.

## Web application organization on a web server
Before we look at the tools used to enumerate web application resources, let's first discuss how web applications and their resources are separated and organized on a web server. A **web server** is the application used to serve resources to clients. You installed Apache2 in previous assignments. Apache2 is a very popular web service. Other web servers include Nginx, IIS, Lighttpd, and Apache Tomcat. Even Python can be used to create a simple HTTP server. 

An important detail to understand is that a single web server can simultaneously serve multiple web applications or websites. A web application or website is fundamentally a group of _resources_ that operate together to create a single application or site. A single application or site consists of application's/site's root directory, subdirectories, and files stored in those directories. Multiple applications or sites can be served on the same web server by storing the application/site root directories in the webroot or some subdirectory of the webroot. Table 2 illustrates how three web applications could be served on a single web server.

|Description|Application/Site <br />webroot = /var/www/html|Application Subdirectory|Resource|
|---|---|---|---|
|WordPress blog|webroot/|.|index.php|
|WordPress blog|webroot/wp-admin/|index.php|
|WordPress blog|webroot/wp-content/|index.php|
|WordPress blog|webroot/wp-includes/|admin-bar.php|
|phpMyAdmin application|webroot/phpmyadmin/|index.php|
|phpMyAdmin application|webroot/phpmyadmin/docs/|index.rst|
|phpMyAdmin application|webroot/phpmyadmin/js/|global.d.ts|
|phpMyAdmin application|webroot/phpmyadmin/sql/|create_tables.sql|
|October CMS|webroot/october/|index.php|
|October CMS|webroot/october/app/|Provider.php|
|October CMS|webroot/october/config/|backend.php|
|October CMS|webroot/october/tests/|bootstrap.php|

<sub>**Table 2, Web Application Segmentation**</sub>


