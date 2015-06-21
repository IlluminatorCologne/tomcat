# docker-tomcat
base docker container with buildin jdk sshd and apache tomcat


Usage
-----

To create the image, execute the following command on the tomcat folder:

        docker build -t illuminatorcologne/tomcat
To run the image and bind to port 8080:

        docker run -d -p 8080:8080 illuminatorcologne/tomcat
