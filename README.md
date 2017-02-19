# docker-alfresco-dev-env

## Description
The aim of this project is to quickly be able to set up an ***Alfresco*** development environment. The environment is composed of minimum 2 containers called here ***backend*** and  ***frontend***. This environment can be improved, tailored to your needs, copied, shared without worrying of breaking anything on your host.
The backend development environment has ***java 8***,***eclipse mars***, ***maven*** and a version of ***Alfresco 5.2.d*** amongst other tools installed in the image after build. For information, the ***backend*** image is based on https://github.com/pdubois/docker-alfresco/tree/v5.2.a that is already build here: https://hub.docker.com/r/pdubois/docker-alfresco/tags/

The frontend will install in the image ***nodejs***, ***nvm*** (node version manager, see:  https://github.com/creationix/nvm), ***npm***, ***Angular 2***, ***Alfresco ng 2 component*** (see: https://github.com/Alfresco/alfresco-ng2-components), ***yo*** ( see: https://github.com/yeoman/yo). 
***nvm*** facilitates ***nodejs*** versions switching management. Firefox and GoogleChrome. 

## How to build and run your environment?

**Prerequisite:** you need to install ***docker*** on your platform, see: https://www.docker.com/ and git client 

The steps are: 

- Clone the project
- Build the backend image
- Build the frontend image
- Start the backend
- Start frontend
- Test that ***AngularJS 2*** runs fine on frontend.
- Test that you can build an ***AngularJS 2*** Alfresco application

#### Cloning the project

```
git clone https://github.com/pdubois/docker-alfresco-dev-env.git 
```

#### Build the backend image

Note: In this guide, the ***backend*** image will be named ***backend2***. Name is provided after the -t parameter in the command under.


```
cd backend
sudo docker build -t backend2 .
```

#### Build the frontend image

Note: In this guide, the ***frontend*** imagefrontend will be named ***frontend2***. Name is provided after the -t parameter in the command under.

```
cd ..
cd frontend
sudo docker build -t frontend2 .
```

#### Start the backend

Notes: 

The ***backend*** and the ***frontend*** containers will run attached to a dedicated network. In this guide the network will be created and called ***my-net-2***
For more information about docker networking, you can refer to: https://docs.docker.com/engine/userguide/networking/

Creating the network:

```
cd ..
cd backend
sudo docker network create --driver bridge my-net-2
```

Inspecting the network example:

```
sudo docker network inspect my-net-2
[
    {
        "Name": "my-net-2",
        "Id": "07aa897fc050512684a3b5ba486dc8a0302c38b9a8eb8e84c2efac61686bd343",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.27.0.0/16",
                    "Gateway": "172.27.0.1/16"
                }
            ]
        },
        "Internal": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]
```
Starting the ***backend***, running containeri will be called ***backend3***:

```
sudo docker run -P --network=my-net-2 -e INITIAL_PASS=admin -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro -d -i -t --name backend3 backend2
```

Alternatively, you can use the ***start.sh*** command in the backend folder of this project to start the backend:

```
sudo ./start.sh my-net-2 backend3 backend2
```


Inspect network again to be sure newly started container runs on it:

```
sudo docker network inspect my-net-2
[
    {
        "Name": "my-net-2",
        "Id": "07aa897fc050512684a3b5ba486dc8a0302c38b9a8eb8e84c2efac61686bd343",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.27.0.0/16",
                    "Gateway": "172.27.0.1/16"
                }
            ]
        },
        "Internal": false,
        "Containers": {
            "004f930af69ce31213f25ede3232cc1925f974ee52096202e72960ca0d1f996a": {
                "Name": "backend3",
                "EndpointID": "4f120e088ff07185014c2513e53e89b35a82cb90a59147615fe02fdbf247f7ba",
                "MacAddress": "02:42:ac:1b:00:02",
                "IPv4Address": "172.27.0.2/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```
You can observe that "backend3" is running attached to "my-net-2" network.

Notes:
The ***backend*** is started having ***CORS*** (see: https://en.wikipedia.org/wiki/Cross-origin_resource_sharing ) enabled. For the setup of ***CORS*** in alfresco, you can have a look at http://fcorti.com/2016/09/05/alfresco-development-framework-in-action/#alfresco_setup
The backend ***EXPOSE*** port ***4443*** and port ***8080*** to ephemeral ports on the host in the range 32768 to 61000. Please check https://docs.docker.com/engine/userguide/networking/default_network/binding/ for more information. To get the acual mapping of ports between container and host do ***"sudo docker ps"***

You may want to generate a project on the backend using new SDK 3.0. in place of using the installed default alfresco version. This is in case if you need to customize backend as well. To do so you should use the following command:

```
mvn org.apache.maven.plugins:maven-archetype-plugin:2.4:generate -DarchetypeCatalog=https://artifacts.alfresco.com/nexus/content/groups/public/archetype-catalog.xml -Dfilter=org.alfresco.maven.archetype:
```

Backend has maven 3.3.9 installed and it seems to come by default with maven-archetype-plugin version 3.0 that was breaking the functionality. Forcing version 2.4. to made it work.


You may need as well enabling ***CORS*** in your maven project, in that case you need to bring in the following module dependency in your project and edit your pom.xml as such:

```
                    <!--
                        JARs and AMPs that should be overlayed/applied to the Platform/Repository WAR
                        (i.e. alfresco.war)
                    -->
			
			...
			
                        <!-- Bring in custom Modules -->
                        <moduleDependency>
                           <groupId>org.alfresco</groupId>
                           <artifactId>enablecors</artifactId>
                           <version>1.0</version>
                           <type>jar</type>
                        </moduleDependency>

                       ...
  
                    </platformModules>
```

It was tested with ***SDK 3.0 beta-5*** using platform ***5.2.d*** 


#### Start the frontend


To start the frontend, do:

```
cd ..
cd frontend
sudo ./start.sh my-net-2 frontend3 frontend
2828fb943b05aa37cbfd0bb65709775fb0b562f2e3ecd72ac6c41688e5276974
```

Caveat:  sometimes for some reason using network name does not work when starting the container and the container immediatly stops. Should it happen to you, then better use the NETWORK ID in place of the network name. To get the NETWORK ID, sudo docker network ls.

Attach to the container in command line and check that backend can be reached:

```
sudo docker attach 2828fb943b05aa37cbfd0bb65709775fb0b562f2e3ecd72ac6c41688e5276974
npm@2828fb943b05:/$ 
npm@2828fb943b05:/$ 
npm@2828fb943b05:/$ping backend3
PING backend3 (172.27.0.2) 56(84) bytes of data.
64 bytes from backend3.my-net-2 (172.27.0.2): icmp_seq=1 ttl=64 time=0.148 ms
64 bytes from backend3.my-net-2 (172.27.0.2): icmp_seq=2 ttl=64 time=0.094 ms
64 bytes from backend3.my-net-2 (172.27.0.2): icmp_seq=3 ttl=64 time=0.092 ms
^C
--- backend3 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 1998ms
rtt min/avg/max/mdev = 0.092/0.111/0.148/0.027 ms
```

Checking that alfresco is up and running on the backend by getting a ticket:

```
npm@2828fb943b05:/$ curl -v "http://backend3:8080/alfresco/service/api/login?u=admin&pw=admin"
* Hostname was NOT found in DNS cache
*   Trying 172.27.0.2...
* Connected to backend3 (172.27.0.2) port 8080 (#0)
> GET /alfresco/service/api/login?u=admin&pw=admin HTTP/1.1
> User-Agent: curl/7.35.0
> Host: backend3:8080
> Accept: */*
> 
< HTTP/1.1 200 OK
* Server Apache-Coyote/1.1 is not blacklisted
< Server: Apache-Coyote/1.1
< Cache-Control: no-cache
< Expires: Thu, 01 Jan 1970 00:00:00 GMT
< Pragma: no-cache
< Content-Type: text/xml;charset=UTF-8
< Content-Length: 104
< Date: Wed, 23 Nov 2016 14:54:15 GMT
< 
<?xml version="1.0" encoding="UTF-8"?>
<ticket>TICKET_53a83ea57ce5a0d88d0f7968aefd4b04296000b1</ticket>
* Connection #0 to host backend3 left intact
```

Checking your node version and creating a hello world ***"AngularJS 2"******* application using Angular CLI:

```
node -v
v7.1.0
ng new  hello-world
installing ng2
  create .editorconfig
  create README.md
  create src/app/app.component.css
  create src/app/app.component.html
  create src/app/app.component.spec.ts
  create src/app/app.component.ts
  create src/app/app.module.ts
  create src/app/index.ts
  create src/assets/.gitkeep
  create src/environments/environment.prod.ts
  create src/environments/environment.ts
  create src/favicon.ico
  create src/index.html
  create src/main.ts
  create src/polyfills.ts
  create src/styles.css
  create src/test.ts
  create src/tsconfig.json
  create src/typings.d.ts
  create angular-cli.json
  create e2e/app.e2e-spec.ts
  create e2e/app.po.ts
  create e2e/tsconfig.json
  create .gitignore
  create karma.conf.js
  create package.json
  create protractor.conf.js
  create tslint.json
Installing packages for tooling via npm.
Installed packages for tooling via npm.
npm@2828fb943b05:~$ ls
WebStorm-162.1628.41  WebStorm-2016.2.2.tar.gz  hello-world
npm@2828fb943b05:~$ # In order to see what is generated
npm@2828fb943b05:~$ cd hello-world; tree . 
```
Lets test and start the *** "hello-world"*** application from webstorm IDE, please have a look at following video: https://youtu.be/r9d_wjBOZpM

An alias ***"webstorm"*** allows you start the IDE directly.

If you want to start the application outside of the IDE, stop ***npm***, quit the IDE and firefox. Change directory to "hello-world". Then do:

```
npm start&
firefox&
```
In firefox address bar type http://localhost:4200/

Note: If you wandt to use google-chrome, then start it using ***google-chrome --no-sandbox***

Lets start a new frontend container now:

```
sudo ./start.sh my-net-2 frontend4 frontend
919be94e2708ec4ad42bf6b46b5d861147bb6170f305b47c24c68b42801fce5c
sudo docker attach 919be94e2708ec4ad42bf6b46b5d861147bb6170f305b47c24c68b42801fce5c
```
After that please follow this video to generate your first ***AngularJS 2*** application in docker container: https://youtu.be/NvSxcLNxRKk



Commands used in the video are:

```
yo ng2-alfresco-app
cd my-alfresco-app
npm install
npm start
```
Firefox should display http://localhost:3000 Log in using "admin","admin"
