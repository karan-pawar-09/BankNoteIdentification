# Banknoteid

Indian Banknote Identification using Deep Learnin

## Note
We have not yet added sufficient new notes of 20, 100, 500 and others, so it may not give correct prediction for those notes

## Work Done

Deep Learning Models for the classification of Indian currency notes using transfer learning were explored. The importance of transfer learning in feature extraction was emphasized, as it played a crucial role in achieving high accuracy in the model. Experiments were conducted using three pre-trained models - VGG19, ResNet50, and Inception V3, and they were tested with different hyperparameters such as epoch, batch size, and learning rate. Among these models, the ResNet50 model achieved the highest accuracy for the dataset. It was then deployed using Flask on ec2 linux server and used in an Android app using the Flutter framework.

## Screenshot
<img width="250" alt="app_screenshot" src="https://github.com/karan-pawar-09/BankNoteIdentification/assets/70064211/5af0dce5-cd2d-4fcf-8a39-18042ec202d2">

## Android App Download Link
https://github.com/karan-pawar-09/BankNoteIdentification/releases/download/v1.1.0/banknoteid.apk

## Flask backend github repo link
https://github.com/karan-pawar-09/Flask-Backend-For-BankNote-Identification

## BackEnd deployment 
Deployment Steps:

Install Gunicorn: Gunicorn needs to be installed on the EC2 server. This can be done using pip, the Python package manager.

Configure Gunicorn: Set up a Gunicorn configuration file that specifies the Flask app's entry point, the number of worker processes, and other relevant settings.

Install Nginx: Install Nginx on the EC2 server using the package manager available for the Linux distribution.

Configure Nginx: Set up an Nginx configuration file that defines the server blocks, routes, and proxy pass configurations. This ensures that Nginx forwards requests to the Gunicorn server.

Start Gunicorn and Nginx: Start Gunicorn to run the Flask app using the configured Gunicorn settings. Also, start Nginx to handle incoming requests and proxy them to Gunicorn.

Configure Security Groups and Firewall: Configure the security groups and firewall settings of the EC2 instance to allow incoming HTTP/HTTPS traffic on the specified ports.

Domain and DNS Configuration: If you have a custom domain, configure the DNS settings to point to the public IP address of your EC2 instance.

With these steps, the Flask app is deployed on the AWS EC2 Linux server, and Gunicorn and Nginx are used to ensure proper functioning and performance of the app. Nginx acts as a reverse proxy and handles the incoming requests, while Gunicorn runs the Flask app and manages the worker processes
