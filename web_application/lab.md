# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Web Applications

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
