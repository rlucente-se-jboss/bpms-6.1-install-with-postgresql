<!-- Change the datasource element for ExampleDS to use PostgreSQL instead -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:hib="http://java.sun.com/xml/ns/persistence"
    exclude-result-prefixes="hib">

  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="//hib:property[@name='hibernate.dialect']">
    <property xmlns="http://java.sun.com/xml/ns/persistence" name="hibernate.dialect" value="org.hibernate.dialect.PostgreSQLDialect"/>
  </xsl:template>
</xsl:stylesheet>
