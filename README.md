## Prepare the development environment

CopApi is a Java Servlet and Jersey REST web service. A Swagger documentation has also been added.

### Requirements

You need:

* JDK
* Maven
* Apache Tomcat 9
* Git

CopApi currently uses **Jersey 2.23.2** and the `javax.servlet` API, so it should be run using **Tomcat 9**. Tomcat 10+ uses the newer `jakarta.servlet` API and is not compatible with the current application without additional changes.

### 1. Install the JDK

Verify that Java is already installed:

```bash
java -version
javac -version
```

If Java is not installed, install the appropriate JDK for the project.

### 2. Install Maven

Check whether Maven is installed:

```bash
mvn -version
```

On Ubuntu, Maven can be installed using:

```bash
sudo apt update
sudo apt install maven
```

### 3. Install Apache Tomcat 9

Tomcat 9 is required for the current version of CopApi.

#### Ubuntu

Tomcat 9 is not available in the standard repositories on newer Ubuntu versions. Download Tomcat 9 directly from the Apache archive instead:

https://archive.apache.org/dist/tomcat/tomcat-9/

To download and install, at the time of writing this:

```bash
cd /tmp

wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.112/bin/apache-tomcat-9.0.112.tar.gz

tar xzf apache-tomcat-9.0.112.tar.gz

sudo mv apache-tomcat-9.0.112 /opt/tomcat

sudo chown -R $USER:$USER /opt/tomcat
```

This installs Tomcat under:

```text
/opt/tomcat
```

### 4. Build the project

CopApi is a Maven project. Build it with:

```bash
mvn clean install
```

A successful build will produce the application WAR file in the `target` directory:

```text
target/data.war
```

### 5. Deploy CopApi to Tomcat

Tomcat looks for web applications in:

```text
/opt/tomcat/webapps/
```

Copy the generated WAR file there:

```bash
cp target/data.war /opt/tomcat/webapps/data.war
```

Because the WAR is named `data.war`, Tomcat will deploy the application using the `/data` context path.

The application will therefore be available at:

```text
http://localhost:8080/data/
```

Tomcat will normally unpack the WAR automatically into:

```text
/opt/tomcat/webapps/data/
```

Do not edit the unpacked `data/` directory directly. The WAR file is the deployable artifact and should be replaced when deploying a new version.

### 6. Start Tomcat

Start Tomcat with:

```bash
/opt/tomcat/bin/startup.sh
```

You should see:

```text
Tomcat started.
```

Verify that Tomcat is running by opening it in the browser:

```text
http://localhost:8080
```

Then access application at:

```text
http://localhost:8080/data/
```

### 7. Redeploying changes

After making changes to the application, rebuild the WAR:

```bash
mvn clean package
```

Then replace the deployed WAR:

```bash
cp target/data.war /opt/tomcat/webapps/data.war
```

Tomcat should automatically detect the changed WAR and redeploy the application.

The deployment can be monitored using:

```bash
tail -f /opt/tomcat/logs/catalina.out
```

If Tomcat does not automatically redeploy the application, restart it:

```bash
/opt/tomcat/bin/shutdown.sh
/opt/tomcat/bin/startup.sh
```

### 8. Troubleshooting Tomcat

If Tomcat reports that it has started but `localhost:8080` is unavailable, check the Tomcat log:

```bash
tail -50 /opt/tomcat/logs/catalina.out
```

You can also check whether something is listening on port 8080:

```bash
sudo lsof -i :8080
```

Tomcat also uses port **8005** as its shutdown port. If another Tomcat instance is already running, Tomcat may fail to start because port 8005 is already in use.

Check it with:

```bash
sudo lsof -i :8005
```

If an old Tomcat process is running, identify it:

```bash
ps -fp <PID>
```

and stop it before starting Tomcat again.

## Devel / Stage

### Testing

There is currently no develop/stage deployments of this, so any release of this goes to production after rigorous testing on local by preferably 2 different developers. Hopefully.

### Deployment

If the release is tested thoroughly, doing a 

```
mvn deploy
```

Should put a SNAPSHOT onto Nexus - and this should be put in a servicedesk task mail along with changes and where this should be deployed for the KB internal maintenance team.