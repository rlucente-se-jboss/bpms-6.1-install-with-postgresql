<!-- Change the datasource element for ExampleDS to use PostgreSQL instead -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ds="urn:jboss:domain:datasources:1.2"
    exclude-result-prefixes="ds">

  <!-- copy everything else -->
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" />
    </xsl:copy>
  </xsl:template>

  <!-- change the ExampleDS datasource -->
  <xsl:template match="ds:datasources">
  <datasources xmlns="urn:jboss:domain:datasources:1.2">
    <datasource jndi-name="java:jboss/datasources/ExampleDS" pool-name="ExampleDS">
      <connection-url>jdbc:postgresql://localhost:5432/bpmsdemo</connection-url>
      <driver>postgresql</driver>
      <security>
        <user-name>bpmsuser</user-name>
        <password>admin1jboss!</password>
      </security>
      <validation>
        <background-validation>true</background-validation>
        <background-validation-millis>60000</background-validation-millis>
        <valid-connection-checker class-name="org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLValidConnectionChecker"></valid-connection-checker>
        <exception-sorter class-name="org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLExceptionSorter"></exception-sorter>
      </validation>
    </datasource>
    <drivers>
      <driver name="postgresql" module="org.postgresql">
        <xa-datasource-class>org.postgresql.xa.PGXADataSource</xa-datasource-class>
      </driver>
    </drivers>
  </datasources>
  </xsl:template>
</xsl:stylesheet>
