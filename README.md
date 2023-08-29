

# Devops Final Capston Project

### Project Slides

https://github.com/Veronaz/DevopsFinalCapstonProject/blob/main/DevOps%20Final%20Capstone%20Project%20Presentation.pdf

Toronto Institute of Data Science &amp; Technology Applied DevOps Engineering Diploma Program(Bootcamp) Final Capstone Project

`git clone git@github.com:Veronaz/FinalCapstonProjectVerona.git`

## Terraform

### install terraform cli 'tfswitch'

`brew install warrensbox/tap/tfswitch`

`vim ~/.zshrc`

paste `export PATH=$PATH:/Users/verona/bin` and save

`source ~/.zshrc`

### login aws (aws configure)
Make sure the iam role has admin and eks access

### Iac terraform

`cd Iac`

`terraform init`

`terraform apply`



## Jenkins

### Install session manager

`curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac_arm64/session-manager-plugin.pkg" -o "session-manager-plugin.pkg"`

`sudo installer -pkg session-manager-plugin.pkg -target /`

`sudo ln -s /usr/local/sessionmanagerplugin/bin/session-manager-plugin /usr/local/bin/session-manager-plugin

### login Jenkins

1. open a browser and go to http://<jenkins EC2 public iPv4>:<port>
2. follow the instruction and log into jenkins (change the localhost:<port> to the above public ip address)
3. install 'kubernetes CLI' plugin
4. add 'http://<jenkins EC2 public iPv4>:<port>/github-webhook/' to github repository > setting > webhook and change type to 'application json' to trigger jenkins update automatically when github receives a push

5. connect into Jenkins EC2 console and install kubectl cli; refer to 'https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html'; allow jenkins user `sudo cp kubectl /usr/sbin`



* if no connection: paste in jenkins aws EC2 console`sudo service jenkins start`..

## Architecture Diagram


![Devops_final_diagram drawio](https://github.com/Veronaz/DevopsFinalCapstonProject/assets/115947471/a5810b69-e706-4338-ab4d-bad5ac100298)

