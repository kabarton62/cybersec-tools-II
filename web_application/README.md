# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Web Applications
## Download and extract Ticket-Booking 1.4
Download Ticket-Booking 1.4 from Exploit-DB directly to your server using wget and extract the files from the archive. The web application is archived in a .zip file, so unzip will be required to extract the archive. The following commands will install unzip and download the archive from Exploit-DB.
```
sudo apt update && sudo apt install unzip
wget https://www.exploit-db.com/apps/4a98716b169f2e384c3b7ca4f0432f4a-Ticket-Booking-master.zip
```
Note that 4a98716b169f2e384c3b7ca4f0432f4a-Ticket-Booking-master.zip was downloaded. 4a98716b169f2e384c3b7ca4f0432f4a in the filename is not random, it is the md5 hash value for the file. We can verify that our download was not corrupted by verifying file's hash against this value.
```
md5sum 4a98716b169f2e384c3b7ca4f0432f4a-Ticket-Booking-master.zip
```
A hash value of 4a98716b169f2e384c3b7ca4f0432f4a validates a good copy was downloaded. Any other result means the download is corrupt and the application should be downloaded again.
