# This image is used to build the containerized version of mule runtime 3.9. 
# Based on:  java:8u111-jre and Java 8 is the basic requirement to run mule 3.9 version (https://docs.mulesoft.com/mule-runtime/3.9/hardware-and-software-requirements)

FROM                    java:8u111-jre
MAINTAINER              Anup Salokhe (salokheanup@gmail.com)

# Mule installation:

# Download the distribution and store it into the folder
RUN wget -P /opt/ https://repository-master.mulesoft.org/nexus/service/local/repositories/releases/content/org/mule/distributions/mule-standalone/4.2.1/mule-standalone-4.2.1.tar.gz
				  
WORKDIR                 /opt
RUN                     tar -xzvf /opt/mule-standalone-4.2.1.tar.gz
RUN                     ln -s /opt/mule-standalone-4.2.1 mule
RUN                     rm -f mule-standalone-4.2.1.tar.gz

# In Case you want to use the Enterprise mule runtime distribution you must comply with license agreement, and provide the necessary license key while building the image.
#WORKDIR                 /opt/mule-standalone-4.2.1
#RUN                     rm -Rf .mule
#ADD                     ./mule-ee-license.lic /opt/mule-standalone-4.2.1/conf/
#RUN                     bin/mule -installLicense conf/mule-ee-license.lic
#RUN                     rm -f conf/mule-ee-license.lic
#RUN                     rm -Rf apps/default*
#RUN                     rm -Rf examples

# Remove the unwanted files. (In order to maintain the image size as small as possible)
RUN                     rm -f  mule-standalone-4.2.1.tar.gz
RUN                     rm -Rf mule-standalone-4.2.1.tar/mmc-3.5.1
RUN                     rm -f mule-standalone-4.2.1.tar/startup*
RUN                     rm -f mule-standalone-4.2.1.tar/shutdown*
RUN                     rm -f mule-standalone-4.2.1.tar/status*


# Mule remote debugger
EXPOSE  5000

# Mule JMX port (Should match Mule config file)
EXPOSE  1098

# Mule MMC agent port
EXPOSE  7777

# Environment and execution:
ENV             MULE_BASE /opt/mule
WORKDIR         /opt/mule-standalone-4.2.1

CMD             /opt/mule/bin/mule

# Deploy your application
# Copy the Mule Archive(.zip) in the "/opt/mule/apps/" of container . Comment if you want to mount and use the code base at runtime. 
# ADD  			./apps/ticketbookingservice.zip   /opt/mule/apps/ticketbookingservice.zip
