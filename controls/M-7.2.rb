# frozen_string_literal: true

control 'M-7.2' do
  title '7.2 Specify file handler in logging.properties files (Scored)'
  desc  "Handlers specify where log messages are sent. Console handlers send
log messages to the Java console and File handlers specify logging to a file.
Utilizing file handlers will ensure that security event information is
persisted to disk. "
  impact 0.5
  tag "ref": '1. https://tomcat.apache.org/tomcat-8.0-doc/logging.html'
  tag "severity": 'medium'
  tag "cis_id": '7.2'
  tag "cis_control": ['No CIS Control', '6.1']
  tag "cis_level": 1
  desc 'check', "Review each application’s logging.properties file located
in the applications
$CATALINA_BASE\\webapps\\<app name>\\WEB-INF\\classes directory and determine
if the
file handler properties are set.
$ grep handlers \\
$CATALINA_BASE\\webapps\\<app name>\\WEB-INF\\classes\\logging.properties
In the instance where an application specific logging has not been created, the

logging.properties file will be located in $CATALINA_BASE\\conf
$ grep handlers $CATALINA_BASE\\conf\\logging.properties
"
  desc 'fix', "Add the following entries to your logging.properties file if they
do not exist.
handlers=org.apache.juli.FileHandler, java.util.logging.ConsoleHandler
Ensure logging is not off and set the logging level to the desired level such
as:
org.apache.juli.FileHandler.level=FINEST
"
  desc 'default value', "No value for new applications by default.\n"

  log_prop = tomcat_properties_file.read_content("#{input('tomcat_home')}/conf/logging.properties")

  describe log_prop do
    its(['handlers']) { should include 'org.apache.juli.FileHandler' }
    its(['handlers']) { should include 'java.util.logging.ConsoleHandler' }
    its(['org.apache.juli.FileHandler.level']) { should cmp 'FINEST' }
  end
end
