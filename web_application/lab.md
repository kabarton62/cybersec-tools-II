# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Web Applications - osTicket

## Get osTicket v1.15.8
1. Download the osTicket v1.15.8 from [here](https://osticket.com/download/). Click the red icon. You will be directed to osTicket's GitHub repository. From the GitHub repository, copy the link to the .zip file under Assets.
2. Download the .zip archive directly to your GCP instance.
3. Extract all file in the .zip archive. Two directories will be extracted scripts/ and upload/.

## Move osTicket to the webroot
1. Move upload/ to /var/www/html/ticket.
2. Change ownership of /var/www/html/ticket and all subdirectories and files to www-data.
3. Browse to osTicket.
4. **Capture a screenshot of the initial osTicket Installer page.**

## Install dependencies/prerequisites
1. The installer will determine if required and recommended prerequisites are installed.
2. Confirm the required prerequisites are installed. Resolve any errors.
3. You can expect to be missing serveral recommended prerequisites. Some of the recommended prerequisites are obviously PHP extensions (i.e., PHP IMAP Extension). Although others recommended prerequisites are also PHP extensions, some are not so obvious (i.e., Gdlib Extension). 
4. Complete Internet searches to determine to install the recommended prerequisites and install all of those packages/extensions.
5. **Capture a screenshot of the osTicket Installer page after installing the _required and recommended prerequisites_.**

## Install osTicket
1. Follow the prompts from the osTicket Installer to complete osTicket installation.
2. A couple of tips worth noting:
- Part of the instructions reference files in the **include/** directory. Technically, that directory will be **/var/www/html/ticket/include/** in our configuration. Either change directory to /var/www/html/ticket or use the correct file path to include/.
- The osTicket Installer will ask for System Settings (Helpdesk Name & Default Email). Make up whatever details you want.
- The osTicket Installer will ask for Admin User details. Make up whatever details you want for the admin user, but **note the username and password**.
- The osTicket Installer will ask for Database Settings. Prepare MySQL as necessary and complete the database settings. **Do not reuse existing database(s) or MySQL users**. 
- The [exercise](./exercise.md) can provide necessary guidance to complete osTicket installation.
3. **Capture a screenshot of the osTicket Installer page that shows reports installation is complete.**

## Demonstrate osTicket works
1. Follow links to Agent sign-in.
2. Login using the username and password for your admin user.
3. **Capture a screenshot of the _osTicket::Staff Control Panel_.**

## Extra-mile: Discover admin username and password in the osTicket database (5 pts)
1. Examine the osTicket database tables and columns. Find the table and columns that store the admin user's credentials.
2. **Capture a screenshot of the admin user's credentials shown from a database query.**
