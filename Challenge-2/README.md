# aws-metadata-json

## How to install
- [Create an EC2 Linux instance on AWS using Terraform]
- [SSH into the instance]
-  Install the pre-requisite using
    - `sudo yum install python3 git`
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
