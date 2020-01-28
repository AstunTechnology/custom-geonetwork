<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                  xmlns:gco="http://www.isotc211.org/2005/gco"
                  xmlns:gmd="http://www.isotc211.org/2005/gmd"
                  exclude-result-prefixes="#all">

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/root">
    <xsl:apply-templates select="gmd:*"/>
  </xsl:template>

  <!-- Add gco:Boolean to gmd:pass with nilReason to work nicely in the editor,
      update-fixed-info.xsl should removed if empty to avoid xsd errors  -->
  <xsl:template match="gmd:pass[@gco:nilReason and not(gco:Boolean)]">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <gco:Boolean></gco:Boolean>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gmd:MD_Distribution">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <xsl:copy-of select="gmd:distributionFormat" />
      <xsl:if test="not(gmd:distributionFormat)" >
        <xsl:message>=== adding a distribution format element===</xsl:message>
        <gmd:distributionFormat>
            <gmd:MD_Format>
               <gmd:name>
                  <gco:CharacterString xmlns:gco="http://www.isotc211.org/2005/gco"></gco:CharacterString>
               </gmd:name>
               <gmd:version>
                  <gco:CharacterString xmlns:gco="http://www.isotc211.org/2005/gco">unknown</gco:CharacterString>
               </gmd:version>
            </gmd:MD_Format>
         </gmd:distributionFormat>
      </xsl:if>

      <xsl:copy-of select="gmd:transferOptions" />

    </xsl:copy>

  </xsl:template>

  <xsl:template match="gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:copy-of select="gmd:name" />
      <xsl:copy-of select="gmd:version" />
    <xsl:if test="not(gmd:version/gco:CharacterString/text())" >
        <gmd:version>
            <gco:CharacterString xmlns:gco="http://www.isotc211.org/2005/gco">unknown</gco:CharacterString>
        </gmd:version>
      </xsl:if>
    </xsl:copy>
  </xsl:template>


  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
