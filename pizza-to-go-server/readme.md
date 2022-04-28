
## Installation 
 Wichtige Softwares was wir benutzen sollen: 
- Docker Desktop
- Maven 
- JAVA JDK Version 11

Überprufen Sie Ihre JDK und Maven Version mit
```bash
javac -version
mvn -version
```
Die beide Version von Java JDK sollen gelich sein. 

Zuerst sollten Sie Docker Desktop laufen lassen, damit wir diesen Webapp compilieren können. Nachdem Docker Desktop gestartet ist , sollten Sie eine Terminal in Haupt Ordner öffnen, wo Ihre Dockerfile & docker-compose steht. Geben Sie 
 ```bash
 mvn clean package
```
auf Ihre Terminal ein , damit wir alle benötigte Plugins und Dependensies auf unsere Lokale Rechner haben können um Program zu compilieren. 

Nach dieser Prozess fertig ist, sehen Sie Build Success auf Ihre Terminal. Wenn Build erfolgreich ist , dürfen Sie von Maven erzeugte war Datei in den Docker Container hochladen und laufen lassen. Dafür sollten Sie 
 ```bash
 docker-compose up --build
```
auf Ihre Terminal eingeben. Nachdem Build fetrig ist , sehen Sie "JDBC Connection Successfull".

## Test
Sie können diesen Webapp auf Ihre Browser unter http://localhost:9080/pizza-to-go-server/ zugreifen.

## SonderFall für Datenbank Tabelle
Falls Docker die Datenbanken Tabelle nicht ladet, soll man eigentlich die alle sql Datein von dem Ordner InitScripts durch Adminer hochladen. Adminer kann man unter http://localhost:8080 zugreifen
