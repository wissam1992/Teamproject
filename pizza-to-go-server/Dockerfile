
FROM open-liberty:javaee8-java11

COPY --chown=1001:0 src/main/liberty/config/server.xml /config/

COPY --chown=1001:0 target/pizza-to-go-server.war /config/dropins/

COPY --chown=1001:0 bootstrap.properties /config/

VOLUME ["/app"]

# RUN su

# RUN chmod -R 755 /app

ADD --chown=1001:0 https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.20/mysql-connector-java-8.0.20.jar /config/lib/mysql-connector-java-8.0.20.jar