These scripts simplify creating a clean, never-been-run installation
of BPMS 6.1.  The scripts also set up a directory of runtimes for
JBDS to use for Drools.

To use this, edit the demo.conf file and set the BIN_DIR directory
correctly for where the following binaries are located:

    jboss-bpmsuite-6.1.0.GA-engine.zip
    jboss-bpmsuite-6.1.0.GA-installer.jar
    jboss-eap-6.4.0-installer.jar
    postgresql-9.4-1201.jdbc41.jar

The eap-auto.xml and bpms-auto.xml scripts should also be edited
so that the <installpath/> element matches the intended installation
location.  This script will install BPMS 6.1 in the same directory
as these scripts.  I currently target
$HOME/demo/bpms-6.1/bpms/jboss-eap-6.4.

After that, to remove an installation, simply type:

    ./clean.sh

And to install the software, simply type:

    ./install.sh

The runtimes for JBDS are located at:

    $HOME/runtimes/jboss-bpmsuite-6.1.0.GA-redhat-2-engine

The install.sh script adds additional users for BPMS.  You can modify
these as needed.  The auto.xml.variable file contains the password for
the bpmsAdmin user.

Make sure to start the server using the script:

    ./start.sh

The reason for this is that BPMS creates its own git and maven
repositories based on the current directory where the server was
launched.  To make sure that repositories aren't created in multiple
locations, the server should be started from a consistent location.
