# aws-metadata-json

## How to install
- Create an EC2 Linux instance on AWS using Terraform
  - Run terraform files,
  - `cd Challenge-2/terraform`
  -  terraform init
  -  terraform apply --auto-approve=true
- It will create a key file named dev-key.pem, If you are using windows for permission of key use below commands,
  - `$path=".\dev-key.pem"`
  - `icacls.exe $path /reset`
  - `icacls.exe $path /inheritance:r`
  - `icacls.exe $path /GRANT:R "$($env:USERNAME):(R)"`

- SSH into the instance
  - `ssh -i dev-key.pem ec2-user@{IP}`
- Clone this repository
  - `git clone https://github.com/sagary2j/DevOps-tasks.git
- Install modules
  - `sudo pip3 install -r requirments.txt
- Open the repository on your instance
  - `cd Challenge-2`
- Install project dependancies
  - `pipenv install`


## How to run
- Open the `src` folder
  - `cd Challenge-2/src`
- Run whichever script you need:
  - `python3 get_metadata.py`
  - `python3 get_key.py`

## How it works
- It makes use of the http://169.254.169.254/latest/meta-data link-local address. Instance metatada is provided at this link, but only when you visit it from a running instance.
