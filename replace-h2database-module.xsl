<!-- Change the datasource element for ExampleDS to use PostgreSQL instead -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:deploy="urn:jboss:deployment-structure:1.0"
    exclude-result-prefixes="deploy">

  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="//deploy:module[@name='com.h2database.h2']">
    <module xmlns="urn:jboss:deployment-structure:1.0" name="org.postgresql"/>
  </xsl:template>
</xsl:stylesheet>
