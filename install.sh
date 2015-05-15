#!/bin/bash

. `dirname $0`/demo.conf

PUSHD ${WORK_DIR}
    # clean existing install
    ./clean.sh

    # install EAP first
    java -jar ${BIN_DIR}/jboss-eap-${VER_EAP_DIST}-installer.jar eap-auto.xml -variablefile eap-auto.xml.variables

    # then install BPMS on top of it
    java -jar ${BIN_DIR}/jboss-bpmsuite-${VER_BPMS_DIST}-installer.jar bpms-auto.xml -variablefile bpms-auto.xml.variables

    # extract the runtime for JBDS
    mkdir -p runtimes
    PUSHD runtimes
        # expand the runtimes for JBDS
        unzip -q ${BIN_DIR}/jboss-bpmsuite-${VER_BPMS_DIST}-engine.zip
    POPD

    # create users with other roles
    $JBOSS_HOME/bin/add-user.sh -a -p 'admin1jboss!' -u broker1 -s -ro user,broker
    $JBOSS_HOME/bin/add-user.sh -a -p 'admin1jboss!' -u broker2 -s -ro user,broker
    $JBOSS_HOME/bin/add-user.sh -a -p 'admin1jboss!' -u manager1 -s -ro user,manager
    $JBOSS_HOME/bin/add-user.sh -a -p 'admin1jboss!' -u manager2 -s -ro user,manager
    $JBOSS_HOME/bin/add-user.sh -a -p 'admin1jboss!' -u appraiser1 -s -ro user,appraiser
    $JBOSS_HOME/bin/add-user.sh -a -p 'admin1jboss!' -u appraiser2 -s -ro user,appraiser

    # add bpmdemo database to postgresql (assumes no password for postgres user)
    psql postgres <<EOF1
DROP DATABASE IF EXISTS bpmsdemo;
DROP USER IF EXISTS bpmsuser;
CREATE USER bpmsuser PASSWORD 'admin1jboss!';
CREATE DATABASE bpmsdemo OWNER bpmsuser;
EOF1

    # add the postgresql module
    PG_MODULE_MAIN=${JBOSS_HOME}/modules/org/postgresql/main
    mkdir -p ${PG_MODULE_MAIN}
    cp ${BIN_DIR}/postgresql-${VER_PG_DIST}.jar ${PG_MODULE_MAIN}
    cp ${WORK_DIR}/postgresql-module.xml ${PG_MODULE_MAIN}/module.xml

    # change ExampleDS to use PostgreSQL using xsltproc, a common
    # command line utility for xslt
    STANDALONE_XML=${JBOSS_HOME}/standalone/configuration/standalone.xml
    xsltproc replace-exampleds-datasource.xsl ${STANDALONE_XML} > standalone.xml
    mv standalone.xml ${STANDALONE_XML}

    # change hibernate.dialect in business-central
    PERSISTENCE_XML=${JBOSS_HOME}/standalone/deployments/business-central.war/WEB-INF/classes/META-INF/persistence.xml
    xsltproc replace-hibernate-dialect.xsl ${PERSISTENCE_XML} > persistence.xml
    mv persistence.xml ${PERSISTENCE_XML}

    # change jdbc module in jboss-deployment-structure
    DEPLOYMENT_XML=${JBOSS_HOME}/standalone/deployments/business-central.war/WEB-INF/jboss-deployment-structure.xml
    xsltproc replace-h2database-module.xsl ${DEPLOYMENT_XML} > jboss-deployment-structure.xml
    mv jboss-deployment-structure.xml ${DEPLOYMENT_XML}
POPD
