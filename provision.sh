#!/bin/bash

echo " ----> Installing some stuff";
/usr/bin/yum install -y -q git wget mc

echo " ----> Installing Java8 JDK";
## small hack to get JDK without need to accept certificate on Oracle Website
/usr/bin/wget -q --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-linux-x64.rpm
/bin/rpm -i --quiet jdk*.rpm && rm -f jdk*.rpm

echo " ----> Installing Ansible";
/bin/rpm -iUh --quiet http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
####For 7.5: http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
/usr/bin/yum install -y -q ansible

if [ ! -f /etc/init.d/jenkins ]; 
then
    echo " ----> Installing Jenkins";
    ## Install Jenkins
    #
    # URL: http://10.0.0.5:8080
    # Home: /var/lib/jenkins
    # Start/Stop: /etc/init.d/jenkins
    # Config: /etc/default/jenkins
    # Jenkins log: /var/log/jenkins/jenkins.log
    /usr/bin/wget -q http://pkg.jenkins-ci.org/redhat-rc/jenkins-2.0-1.1.noarch.rpm
    /bin/rpm -i --quiet jenkins*.rpm && rm -f jenkins*.rpm

    ### Move Jenkins to port 6060
    #sed -i 's/8080/6060/g' /etc/default/jenkins

    ### disable ajp13
    sed -i 's/"8009"/"-1"/g' /etc/sysconfig/jenkins
    /etc/init.d/jenkins restart
fi

echo " ----> Installing maven 3.0.5";
/usr/bin/wget -q http://mirror.cc.columbia.edu/pub/software/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
/bin/tar xzf apache-maven-3.0.5-bin.tar.gz -C /opt/
/bin/rm -f apache-maven*.tar.gz

## setup maven path system-wide
export M2_HOME=/opt/apache-maven-3.0.5
echo "export M2_HOME=${M2_HOME}" > /etc/profile.d/maven.sh
echo "export PATH=${M2_HOME}/bin:${PATH}" >> /etc/profile.d/maven.sh
. /etc/profile.d/maven.sh

############

echo " --------------------------------------- ";
echo "Jenkins is available here: http://10.0.0.5:8080/";
echo "Java JDK version:"
java -version
echo "Maven version:"
mvn -version
echo "Login info: vagrant/vagrant"