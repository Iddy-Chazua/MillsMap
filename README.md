# Interactive Webmap

Originally authored by @ReettaValimaki with support from @Ivangayton for OpenMap development in Tanzania (OMDTZ) and maintained and updated by @Iddy-Chazua. 

# Preface:

This web map Porto, was primarily developed as a visualization and data management tool for nationwide data collection of mills and schools. It has successfully visualized data from over 55,000 mill machines and more than 17,000 primary schools across Tanzania. The web map uses an API to download data from the ODK central server.

## Infrastructure set-up
The map is composed of two main components, which are 
- Data collection server
- Web-map

### Requirements for deploying data collection server
For server deployment, you are needed to prepare the following 
- Domain name. In our case, we bought a domain from https://www.namecheap.com/
- Server for hosting, in our case we used https://cloud.digitalocean.com/ 
- During data Collection, specifications for the server used was
  - Ubuntu Docker 19.03.12 on Ubuntu 20.04 
    - Size 
      - 2 vCPUs 
      - RAM 4GB / 80GB Disk
      - Cost ($28/mo). Additional external 150GB SSD cost ($15/mo)
- After data collection, deploying the new server will not require the same server specifications because the traffic will be low and amount of data will not be as much as during actual data collection. For this reasons, the specifications will be;
   - Ubuntu Docker 19.03.12 on Ubuntu 20.04 (version of docker doesn't matter, you can opt for the available higher version)
     - Size 
       - 1 vCPU 
       - RAM 1GB / 25GB Disk
       - Cost ($6/mo)
-  We also added the external 150GB SSD to support pictures and data hosting but for now we can aim for minimal specifications because we are not expecting a large amount of data to be uploaded.

### Requirements for deploying web-map
For Web-map, you are needed to prepare the following 
- Domain name, because it uses "let’s encrypt" for the SSL, you should provide the domain in the very early stage. In our case, we bought a domain from https://www.namecheap.com/
- Server for hosting, in our case we used https://cloud.digitalocean.com/. 
  - Specifications for the 
    - Image Ubuntu 20.04 (LTS) x64 
    - Size 
      - 1 vCPU 
      - RAM 1GB / 25GB Disk
      - Cost ($6/mo)
  

### Deploying data collection server

Server will be deployed, and each participants will be given a url and the password to configure their webmap. 

#### For self deployment, you can find detailed documentation in the following links

- Set up Server; https://docs.getodk.org/central-install-digital-ocean/ 
- Creating ODK questionnaire; https://xlsform.org/en/


## Web map installation

### Cloud deployment
- Create a Digital Ocean droplet (or other server on whatever infrastructure you prefer), and associate a domain name with it. Either disable the UFW firewall or poke the appropriate holes in it for nginx and ssh.
 - Modify firewall system by running
```
ufw disable 
```
 - Create a user called ```millsmap``` with sudo privileges, 

```
  sudo adduser millsmap    # Enter password, name, etc
  sudo usermod -aG sudo millsmap
  sudo mkdir /home/millsmap/.ssh
  sudo cp .ssh/authorized_keys /home/millsmap/.ssh/
  sudo chown hot-admin /home/millsmap/.ssh/authorized_keys
```
- From the ```millsmap``` user account, clone this repo. Step into it with 
 ```
 git clone https://github.com/Iddy-Chazua/MillsMap
 ```
- ```cd MillsMap```.
- You'll need a file called ```secret_tokens.json``` that contains "username" and "password" for an ODK Central server containing your mill map data.
- Run the installation script with 
  ```
  script/setup.sh
  ```
  - Follow instructions. It needs the domain name, and your email so that "Let's Encrypt" can inform you when your certificate is expiring.

- Note: 
  - To change an odk central server: /app/config.py
  - To track submitted  files: /app/submission_files
  - Mills picture: /app/static/figures/
  - To add new form: /app/static/form_config.csv


## How to set up survey in data server and updating the map
### Surveying setting up in data server
  - Log in to the server
  - Create the project, by clicking add new button in ODK central.
![Alt text](/app/static/static_figures/add_project.png?raw=true "Title")

  - Then add survey forms; in our case, we have Zanzibar_Mills_Mapping_Census_Updating_V_0.11.xlsx for Zanzibar and Tanzania_Mainland_Mills_Mapping_Census_Updating_V_0.12.xlsx for Tanzania mainland which can be access here https://github.com/OMDTZ/MillsMap/tree/main/sample_forms
![Alt text](/app/static/static_figures/add_form.png?raw=true "Title")
  - After adding each form, deploy them and make sure all the permissions are activated 
  

### Updating the Map  - Using ODK
- Make sure you're using the server linked with webmap during the webmap installation stage
- In Mobile phone, install ODK from playstore then click configure with QR code then scan the provided QR Code from your server
- Set your identity; Open ODK >setting> user and device  identity>form metadata> type your user-name, phone number and email address 
- Open Your ODK application and you will find 5 options
  - Fill blank form 
  - Edit saved form 
  - Send finalized form 
  - View sent form 
  - Delete saved form
- In “Fill blank form”, you will find the deployed form, select and fill the information. 
- NB Please make sure you turn on location, to do so, go to setting on your android then turn on LOCATION.After that fill information. 
Then use the “Send finalized form” option, select all the forms and send them
#### For more detailed information, you can visit this site https://docs.getodk.org/getting-started/
