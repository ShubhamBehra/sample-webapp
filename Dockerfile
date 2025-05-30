# Use official Tomcat base image
FROM tomcat:11.0

# Remove default webapps to avoid conflicts
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file to Tomcat webapps directory
COPY target/sample.war /usr/local/tomcat/webapps/ROOT.war

# Expose default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
