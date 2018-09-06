<?xml version="1.0" encoding="utf-8"?>
<!-- 
     James Rapaport                                
     SeaZone Solutions Limited                                                  
     2010-11-30
     
     This stylesheet has been developed for the UK Location Programme
     (UKLP) by SeaZone Solutions Limited (SeaZone), with funding from Defra
     and CLG. It is designed to transform GEMINI 1.0 XML to GEMINI 2.1 XML.

     (C) Crown copyright

     You may re-use this publication (not including any departmental or agency logos) free of 
     charge in any format or medium. You must re-use it accurately and not in a misleading 
     context. You must acknowledge the material as Crown copyright and specify the title and 
     source of the publication.

     Document History:
     
     2010-11-30 - Version 0.1
     First draft.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gemini="http://www.gigateway.org.uk/gemini" 
                xmlns:egemini="http://www.gigateway.org.uk/egemini" 
                xmlns:gmd="http://www.isotc211.org/schemas/2005/gmd" 
                xmlns:gco="http://www.isotc211.org/schemas/2005/gco" 
                xmlns:gts="http://www.isotc211.org/schemas/2005/gts" 
                xmlns:gml="http://www.opengis.net/gml" 
                xmlns:xlink="http://www.w3.org/1999/xlink" 
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
                xmlns:java="http//xml.apache.org/xslt/java" 
                xmlns:sflatlongconvert="uk.co.snowflakesoft.metaeditor.transform.ConvertToLatLongValue"
                exclude-result-prefixes="gemini egemini xsi xsl java sflatlongconvert">
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes" />
  <!-- ========================================================================== -->
  <!-- Parameters                                                                 -->
  <!-- ========================================================================== -->
  <xsl:param name="CodeListUri">
    <xsl:text>http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/gmxCodelists.xml#</xsl:text>
  </xsl:param>
  <xsl:param name="LanguageCodeUri">
    <xsl:text>http://www.loc.gov/standards/iso639-2/php/code_list.php</xsl:text>
  </xsl:param>
  <!-- ========================================================================== -->
  <!-- Variables                                                                  -->
  <!-- ========================================================================== -->
  <xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <!-- ========================================================================== -->
  <!-- Core Template                                                              -->
  <!-- ========================================================================== -->
  <xsl:template match="/*">
    <gmd:MD_Metadata xmlns:gmd="http://www.isotc211.org/2005/gmd"
                    xmlns:gco="http://www.isotc211.org/2005/gco"
                    xmlns:gmx="http://www.isotc211.org/2005/gmx"
                    xmlns:gsr="http://www.isotc211.org/2005/gsr"
                    xmlns:gss="http://www.isotc211.org/2005/gss"
                    xmlns:gts="http://www.isotc211.org/2005/gts"
                    xmlns:gml="http://www.opengis.net/gml/3.2"
                    xmlns:xlink="http://www.w3.org/1999/xlink">
      <xsl:call-template name="MD_Metadata" />
    </gmd:MD_Metadata>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- MD_Metadata                                                                -->
  <!-- ========================================================================== -->
  <xsl:template name="MD_Metadata">
    <!-- Metadata file identifier -->
    <xsl:call-template name="fileIdentifier" />
    <!-- Metadata language -->
    <xsl:call-template name="language">
      <xsl:with-param name="GeminiItemName">
        <xsl:text>Metadata language</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
    <!-- Resource type -->
    <xsl:call-template name="hierarchyLevel" />
    <!-- Metadata point of contact -->
    <xsl:call-template name="metadataPointOfContact"/>
    <!-- Metadata date -->
    <xsl:call-template name="dateStamp"/>
    <!-- Reference system information -->
    <xsl:call-template name="referenceSystemInfo"/>
    <!-- Identification information -->
    <xsl:call-template name="identificationInfo"/>
    <!-- Distribution information -->
    <xsl:call-template name="distributionInfo"/>
    <!-- Data quality information -->
    <xsl:call-template name="dataQualityInfo"/>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Metadata file identifier                                                   -->
  <!-- ========================================================================== -->
  <xsl:template name="fileIdentifier">
    <xsl:comment>Metadata file identifier</xsl:comment>
    <xsl:element name="gmd:fileIdentifier" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:call-template name="CharacterString">
        <xsl:with-param name="value">
          <xsl:text/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Language                                                                   -->
  <!-- ========================================================================== -->
  <xsl:template name="language">
    <xsl:param name="LangCode">
      <xsl:text>eng</xsl:text>
    </xsl:param>
    <xsl:param name="GeminiItemName"/>
    <xsl:comment>
      <xsl:value-of select="$GeminiItemName"/>
    </xsl:comment>
    <xsl:element name="gmd:language" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:call-template name="LanguageCode">
        <xsl:with-param name="value" select="$LangCode"/>
      </xsl:call-template> 
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Resource type                                                              -->
  <!-- ========================================================================== -->
  <xsl:template name="hierarchyLevel">
    <xsl:comment>
      <xsl:text>Resource type</xsl:text>
    </xsl:comment>
    <xsl:element name="gmd:hierarchyLevel" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:element name="gmd:MD_ScopeCode" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:call-template name="CodeListAttributes">
          <xsl:with-param name="CodeList">
            <xsl:text>MD_ScopeCode</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="CodeListValue">
            <xsl:text>dataset</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Metadata point of contact                                                  -->
  <!-- ========================================================================== -->
  <xsl:template name="metadataPointOfContact">
    <xsl:comment>
      <xsl:text>Metadata point of contact</xsl:text>
    </xsl:comment>
    <xsl:for-each select="gmd:distributionInfo/*/gmd:distributor/*/gmd:distributorContact/gmd:DistributorResponsibleParty">
      <xsl:element name="gmd:contact" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:call-template name="CI_ResponsibleParty">
          <!-- Metadata point of contact is indicated by an xlink:href to the distributor point of contact -->
          <xsl:with-param name="value" select="."/>
        </xsl:call-template>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Metadata date                                                              -->
  <!-- ========================================================================== -->
  <xsl:template name="dateStamp">
    <xsl:comment>Metadata date</xsl:comment>
    <xsl:element name="gmd:dateStamp" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:call-template name="Date">
        <xsl:with-param name="value" select="gmd:dateStamp/*"/>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Reference System Information                                               -->
  <!-- ========================================================================== -->
  <xsl:template name="referenceSystemInfo">
    <xsl:comment>Spatial reference system</xsl:comment>
    <xsl:element name="gmd:referenceSystemInfo" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:element name="gmd:MD_ReferenceSystem" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:element name="gmd:referenceSystemIdentifier" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:element name="gmd:RS_Identifier" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:code" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:call-template name="CharacterString">
                <xsl:with-param name="value">
                  <xsl:call-template name="GetEpsgCode">
                    <xsl:with-param name="code">
                      <xsl:value-of select="gmd:referenceSystemInfo/*/gmd:referenceSystemIdentifier/*/gmd:code/*"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Identification Information                                                 -->
  <!-- ========================================================================== -->
  <xsl:template name="identificationInfo">
    <xsl:element name="gmd:identificationInfo" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:element name="gmd:MD_DataIdentification" namespace="http://www.isotc211.org/2005/gmd">
        <!-- Citation -->
        <xsl:call-template name="citation"/>
        <!-- Abstract -->
        <xsl:call-template name="abstract"/>
        <!-- Responsible organisation -->
        <xsl:call-template name="responsibleOrganisation"/>
        <!-- Maintenance and Update Frequency -->
        <xsl:call-template name="frequencyOfUpdate"/>        
        <!-- Browse graphic - not GEMINI 2.1 but may appear in GEMINI 1.0 metadata -->
        <xsl:call-template name="browseGraphic"/>
        <!-- Resource Format -->
        <xsl:call-template name="resourceFormat"/>
        <!-- Keyword -->
        <xsl:call-template name="keyword"/>
        <!-- Limitations on public access and Use constraints -->
        <xsl:call-template name="limitationsOnPublicAccess"/>
        <!-- Use constraints -->
        <xsl:call-template name="useConstraints"/>
        <!-- Spatial representation type - not GEMINI 2.1 but may appear in GEMINI 1.0 metadata -->
        <xsl:call-template name="spatialRepresentationType"/>        
        <!-- 	Spatial Resolution	-->
        <xsl:call-template name="spatialResolution" />
        <!-- Dataset language -->
        <xsl:call-template name="language">
          <xsl:with-param name="LangCode" select="translate(gmd:identificationInfo/*/gmd:language/*,$upper,$lower)"/>
          <xsl:with-param name="GeminiItemName">
            <xsl:text>Resource language</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
        <!-- Topic category -->
        <xsl:call-template name="topicCategory"/>
        <!-- Extent -->
        <xsl:call-template name="extent"/>
        <!-- Additional information source -->
        <xsl:call-template name="supplementalInformation" />
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Citation                                                                   -->
  <!-- ========================================================================== -->
  <xsl:template name="citation">
    <xsl:element name="gmd:citation" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:element name="gmd:CI_Citation" namespace="http://www.isotc211.org/2005/gmd">
        <!-- Title -->
        <xsl:comment>
          <xsl:text>Title</xsl:text>
        </xsl:comment>
        <xsl:element name="gmd:title" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:call-template name="CharacterString">
            <xsl:with-param name="value" select="gmd:identificationInfo/*/gmd:citation/*/gmd:title/*"/>
          </xsl:call-template>
        </xsl:element>
        <!-- Alternative title -->
        <xsl:for-each select="gmd:identificationInfo/*/gmd:citation/*/gmd:alternateTitle">
          <xsl:comment>
            <xsl:text>Alternative title</xsl:text>
          </xsl:comment>
          <xsl:element name="gmd:alternateTitle" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:call-template name="CharacterString">
              <xsl:with-param name="value" select="./*"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:for-each>
        <!-- Dataset reference date -->
        <xsl:for-each select="gmd:identificationInfo/*/gmd:citation/*/gmd:date">
          <xsl:element name="gmd:date" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:CI_Date" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:element name="gmd:date" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:call-template name="Date">
                  <xsl:with-param name="value" select="*/gmd:date/*"/>
                </xsl:call-template>
              </xsl:element>
              <xsl:element name="gmd:dateType" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:element name="gmd:CI_DateTypeCode" namespace="http://www.isotc211.org/2005/gmd">
                  <xsl:call-template name="CodeListAttributes">
                    <xsl:with-param name="CodeList">
                      <xsl:text>CI_DateTypeCode</xsl:text>
                    </xsl:with-param>
                    <xsl:with-param name="CodeListValue" select="*/gmd:dateType/*/@codeListValue"/>
                  </xsl:call-template>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
        <!-- Unique resource identifier -->
        <xsl:comment>Unique resource identifier</xsl:comment>
        <xsl:element name="gmd:identifier" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:element name="gmd:RS_Identifier" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:code" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:call-template name="CharacterString">
                <xsl:with-param name="value">
                  <xsl:text/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:element>
            <xsl:element name="gmd:codeSpace" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:call-template name="CharacterString">
                <xsl:with-param name="value">
                  <xsl:text/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:element>
          </xsl:element>
        </xsl:element>
        <xsl:for-each select="gmd:identificationInfo/*/gmd:citation/*/gmd:presentationForm">
          <xsl:element name="gmd:presentationForm" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:CI_PresentationFormCode" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:call-template name="CodeListAttributes">
                <xsl:with-param name="CodeList">
                  <xsl:text>CI_PresentationFormCode</xsl:text>
                </xsl:with-param>
                <xsl:with-param name="CodeListValue" select="*/@codeListValue"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Abstract                                                                   -->
  <!-- ========================================================================== -->
  <xsl:template name="abstract">
    <xsl:comment>
      <xsl:text>Abstract</xsl:text>
    </xsl:comment>
    <xsl:element name="gmd:abstract" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:call-template name="CharacterString">
        <xsl:with-param name="value" select="gmd:identificationInfo/*/gmd:abstract/*"/>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Responsible organisation                                                   -->
  <!-- ========================================================================== -->
  <xsl:template name="responsibleOrganisation">
    <xsl:comment>
      <xsl:text>Responsible organisation</xsl:text>
    </xsl:comment>
    <xsl:for-each select="gmd:identificationInfo/*/gmd:pointOfContact/*">
      <xsl:element name="gmd:pointOfContact" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:call-template name="CI_ResponsibleParty">
          <xsl:with-param name="value" select="."/>
          <xsl:with-param name="role" select="gmd:role/*/@codeListValue"/>
        </xsl:call-template>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Browse graphic                                                             -->
  <!-- ========================================================================== -->
  <xsl:template name="browseGraphic">
    <xsl:for-each select="gmd:identificationInfo/*/gmd:graphicOverview">
      <xsl:comment>
        <xsl:text>Browse graphic - not an element of GEMINI 2.1</xsl:text>
      </xsl:comment>
      <xsl:element name="gmd:graphicOverview" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:element name="gmd:MD_BrowseGraphic" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:element name="gmd:fileName" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:call-template name="CharacterString">
              <xsl:with-param name="value" select="./*/gmd:fileName/*"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Frequency of update                                                        -->
  <!-- ========================================================================== -->
  <xsl:template name="frequencyOfUpdate">
    <xsl:comment>
      <xsl:text>Frequency of update</xsl:text>
    </xsl:comment>
    <xsl:element name="gmd:resourceMaintenance" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:element name="gmd:MD_MaintenanceInformation" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:element name="gmd:maintenanceAndUpdateFrequency" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:element name="gmd:MD_MaintenanceFrequencyCode" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:call-template name="CodeListAttributes">
              <xsl:with-param name="CodeList">
                <xsl:text>MD_MaintenanceFrequencyCode</xsl:text>
              </xsl:with-param>
              <!-- GEMINI 1.0 schema uses gmd:metadataMaintenance for resource maintenance -->
              <xsl:with-param name="CodeListValue" select="gmd:metadataMaintenance/*/gmd:maintenanceAndUpdateFrequency/*/@codeListValue"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Resource format                                                            -->
  <!-- ========================================================================== -->
  <xsl:template name="resourceFormat">
    <xsl:for-each select="gmd:distributionInfo/*/gmd:distributionFormat/*">
      <xsl:comment>
        <xsl:text>Resource format</xsl:text>
      </xsl:comment>
      <xsl:element name="gmd:resourceFormat" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:call-template name="MD_Format">
          <xsl:with-param name="name" select="gmd:name/*"/>
          <xsl:with-param name="version" select="gmd:version/*"/>
        </xsl:call-template>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Keyword                                                                    -->
  <!-- ========================================================================== -->
  <xsl:template name="keyword">
    <xsl:comment>
      <xsl:text>Keyword</xsl:text>
    </xsl:comment>
    <xsl:choose>
      <xsl:when test="count(gmd:identificationInfo/*/gmd:descriptiveKeywords) > 0">
        <xsl:for-each select="gmd:identificationInfo/*/gmd:descriptiveKeywords">
          <xsl:element name="gmd:descriptiveKeywords" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:MD_Keywords" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:for-each select="*/gmd:keyword">
                <xsl:element name="gmd:keyword" namespace="http://www.isotc211.org/2005/gmd">
                  <xsl:call-template name="CharacterString">
                    <xsl:with-param name="value" select="./*"/>
                  </xsl:call-template>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="gmd:descriptiveKeywords" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:element name="gmd:MD_Keywords" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:keyword" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:call-template name="CharacterString">
                <xsl:with-param name="value">
                  <xsl:text/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Spatial representation type                                                -->
  <!-- ========================================================================== -->
  <xsl:template name="spatialRepresentationType">
    <xsl:for-each select="gmd:identificationInfo/*/gmd:spatialRepresentationType">
      <xsl:comment>
        <xsl:text>Spatial representation type - not an element of GEMINI 2.1</xsl:text>
      </xsl:comment>
      <xsl:element name="gmd:spatialRepresentationType" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:element name="gmd:MD_SpatialRepresentationTypeCode" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:call-template name="CodeListAttributes">
            <xsl:with-param name="CodeList">
              <xsl:text>MD_SpatialRepresentationTypeCode</xsl:text>
            </xsl:with-param>
            <xsl:with-param name="CodeListValue" select="*/@codeListValue"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Limitations on public access                                               -->
  <!-- ========================================================================== -->
  <xsl:template name="limitationsOnPublicAccess">
    <xsl:comment>
      <xsl:text>Limitations on public access</xsl:text>
    </xsl:comment>
    <xsl:element name="gmd:resourceConstraints" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:element name="gmd:MD_LegalConstraints" namespace="http://www.isotc211.org/2005/gmd">
        <!-- Resource constraints are in metadataConstraints in GEMINI 1.0 -->
        <xsl:for-each select="gmd:metadataConstraints/*/gmd:accessConstraints">
          <xsl:element name="gmd:accessConstraints" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:MD_RestrictionCode" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:call-template name="CodeListAttributes">
                <xsl:with-param name="CodeList">
                  <xsl:text>MD_RestrictionCode</xsl:text>
                </xsl:with-param>
                <xsl:with-param name="CodeListValue" select="*/@codeListValue"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
        <xsl:if test="count(gmd:metadataConstraints/*/gmd:accessConstraints[*/@codeListValue='otherRestrictions']) = 0">
          <xsl:element name="gmd:accessConstraints" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:MD_RestrictionCode" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:call-template name="CodeListAttributes">
                <xsl:with-param name="CodeList">
                  <xsl:text>MD_RestrictionCode</xsl:text>
                </xsl:with-param>
                <xsl:with-param name="CodeListValue">
                  <xsl:text>otherRestrictions</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:element>
          </xsl:element> 
        </xsl:if>
        <xsl:for-each select="gmd:metadataConstraints/*/gmd:useConstraints">
          <xsl:element name="gmd:useConstraints" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:MD_RestrictionCode" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:call-template name="CodeListAttributes">
                <xsl:with-param name="CodeList">
                  <xsl:text>MD_RestrictionCode</xsl:text>
                </xsl:with-param>
                <xsl:with-param name="CodeListValue" select="*/@codeListValue"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
        <xsl:element name="gmd:otherConstraints" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:call-template name="CharacterString">
            <xsl:with-param name="value">
              <xsl:text/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Use constraints                                                            -->
  <!-- ========================================================================== -->
  <xsl:template name="useConstraints">
    <xsl:comment>
      <xsl:text>Use constraints</xsl:text>
    </xsl:comment>
    <xsl:element name="gmd:resourceConstraints" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:element name="gmd:MD_Constraints" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:element name="gmd:useLimitation" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:call-template name="CharacterString">
            <xsl:with-param name="value">
              <xsl:text/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Topic category                                                             -->
  <!-- ========================================================================== -->
  <xsl:template name="topicCategory">
    <xsl:comment>
      <xsl:text>Topic category</xsl:text>
    </xsl:comment>
    <xsl:choose>
      <xsl:when test="count(gmd:identificationInfo/*/gmd:topicCategory) > 0">
        <xsl:for-each select="gmd:identificationInfo/*/gmd:topicCategory">
          <xsl:element name="gmd:topicCategory" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:MD_TopicCategoryCode" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:value-of select="./*"/>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="gmd:topicCategory" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:element name="gmd:MD_TopicCategoryCode" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:text/>
          </xsl:element>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Spatial resolution                                                         -->
  <!-- ========================================================================== -->
  <xsl:template name="spatialResolution">
    <xsl:for-each select="gmd:identificationInfo/*/gmd:spatialResolution">
      <xsl:comment>
        <xsl:text>Spatial resolution</xsl:text>
      </xsl:comment>
      <xsl:element name="gmd:spatialResolution" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:element name="gmd:MD_Resolution" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:element name="gmd:distance" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:call-template name="Distance">
              <xsl:with-param name="uom" select="*/gmd:distance/*/@uom"/>
              <xsl:with-param name="value" select="*/gmd:distance/*"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Extent                                                                     -->
  <!-- ========================================================================== -->
  <xsl:template name="extent">
    <xsl:for-each select="gmd:identificationInfo/*/gmd:extent">
      <xsl:element name="gmd:extent" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:element name="gmd:EX_Extent" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:for-each select="*/gmd:geographicElement/*/gmd:geographicIdentifier">
            <xsl:element name="gmd:geographicElement" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:element name="gmd:EX_GeographicDescription" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:comment>
                  <xsl:text>Extent</xsl:text>
                </xsl:comment>
                <xsl:element name="gmd:geographicIdentifier" namespace="http://www.isotc211.org/2005/gmd">
                  <xsl:element name="gmd:MD_Identifier" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:element name="gmd:code" namespace="http://www.isotc211.org/2005/gmd">
                      <xsl:call-template name="CharacterString">
                        <xsl:with-param name="value" select="*/gmd:code/*"/>
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
          <xsl:choose>
            <xsl:when test="count(*/gmd:geographicElement/gmd:GEMINI_GeographicBoundingBox) + count(*/gmd:geographicElement/gmd:GEMINI_GeographicBoundingBoxGrid) > 0">
              <xsl:for-each select="*/gmd:geographicElement/gmd:GEMINI_GeographicBoundingBox | */gmd:geographicElement/gmd:GEMINI_GeographicBoundingBoxGrid">
                <xsl:comment>
                  <xsl:text>Geographic bounding box</xsl:text>
                </xsl:comment>
                <xsl:element name="gmd:geographicElement" namespace="http://www.isotc211.org/2005/gmd">
                  <xsl:call-template name="EX_GeographicBoundingBox">
                    <xsl:with-param name="westBoundLongitude" select="gmd:westBoundLongitude/*"/>
                    <xsl:with-param name="eastBoundLongitude" select="gmd:eastBoundLongitude/*"/>
                    <xsl:with-param name="southBoundLatitude" select="gmd:southBoundLatitude/*"/>
                    <xsl:with-param name="northBoundLatitude" select="gmd:northBoundLatitude/*"/>
                  </xsl:call-template>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:comment>
                <xsl:text>Geographic bounding box</xsl:text>
              </xsl:comment>
              <xsl:element name="gmd:geographicElement" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:call-template name="EX_GeographicBoundingBox"/>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="count(*/gmd:temporalElement) > 0">
              <xsl:for-each select="*/gmd:temporalElement">
                <xsl:comment>
                  <xsl:text>Temporal extent</xsl:text>
                </xsl:comment>
                <xsl:element name="gmd:temporalElement" namespace="http://www.isotc211.org/2005/gmd">
                  <xsl:call-template name="EX_TemporalExtent">
                    <xsl:with-param name="id" select="*/gmd:extent/*/@gml:id"/>
                    <xsl:with-param name="beginPosition" select="*/gmd:extent/*/gml:begin/*/gml:timePosition"/>
                    <xsl:with-param name="endPosition" select="*/gmd:extent/*/gml:end/*/gml:timePosition"/>
                  </xsl:call-template>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:comment>
                <xsl:text>Temporal extent</xsl:text>
              </xsl:comment>
              <xsl:call-template name="EX_TemporalExtent"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Additional information source                                              -->
  <!-- ========================================================================== -->
  <xsl:template name="supplementalInformation">
    <xsl:choose>
      <xsl:when test="count(gmd:identificationInfo/*/gmd:supplementalInformation) = 1">
        <xsl:comment>
          <xsl:text>Additional information source</xsl:text>
        </xsl:comment>
        <xsl:element name="gmd:supplementalInformation" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:element name="gco:CharacterString" namespace="http://www.isotc211.org/2005/gco">
            <xsl:value-of select="./*"/>
            <xsl:call-template name="userDefined"/>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="count(//gmd:userDefined) > 0">
        <xsl:comment>
          <xsl:text>Additional information source - placeholder for NGDF User Defined metadata</xsl:text>
        </xsl:comment>
        <xsl:element name="gmd:supplementalInformation" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:element name="gco:CharacterString" namespace="http://www.isotc211.org/2005/gco">
            <xsl:call-template name="userDefined"/>
          </xsl:element>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Distribution info                                                          -->
  <!-- ========================================================================== -->
  <xsl:template name="distributionInfo">
    <xsl:for-each select="gmd:distributionInfo">
      <xsl:element name="gmd:distributionInfo" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:element name="gmd:MD_Distribution" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:choose>
            <xsl:when test="count(*/gmd:distributionFormat) > 0">
              <xsl:for-each select="*/gmd:distributionFormat">
                <xsl:element name="gmd:distributionFormat" namespace="http://www.isotc211.org/2005/gmd">
                  <xsl:call-template name="MD_Format">
                    <xsl:with-param name="name" select="*/gmd:name/*"/>
                    <xsl:with-param name="version" select="*/gmd:version/*"/>
                  </xsl:call-template>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="MD_Format"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="count(*/gmd:distributor) > 0">
            <xsl:element name="gmd:distributor" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:element name="gmd:MD_Distributor" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:element name="gmd:distributorContact" namespace="http://www.isotc211.org/2005/gmd">
                  <xsl:for-each select="*/gmd:distributor/*/gmd:distributorContact/gmd:DistributorResponsibleParty">
                    <xsl:call-template name="CI_ResponsibleParty">
                      <xsl:with-param name="value" select="."/>
                      <xsl:with-param name="role" select="gmd:role/*/@codeListValue"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:if>
          <xsl:if test="count(*/gmd:transferOptions) > 0">
            <xsl:for-each select="*/gmd:transferOptions">
              <xsl:element name="gmd:transferOptions" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:element name="gmd:MD_DigitalTransferOptions" namespace="http://www.isotc211.org/2005/gmd">
                  <xsl:for-each select="*/gmd:onLine">
                    <xsl:element name="gmd:onLine" namespace="http://www.isotc211.org/2005/gmd">
                      <xsl:call-template name="CI_OnlineResource">
                        <xsl:with-param name="url" select="*/gmd:linkage/*"/>
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:for-each select="*/gmd:offLine">
                    <xsl:element name="gmd:offLine" namespace="http://www.isotc211.org/2005/gmd">
                      <xsl:call-template name="MD_Medium">
                        <xsl:with-param name="name" select="*/gmd:mediumFormat/*/@codeListValue"/>
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:if>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Data quality info                                                          -->
  <!-- ========================================================================== -->
  <xsl:template name="dataQualityInfo">
    <xsl:element name="gmd:dataQualityInfo" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:element name="gmd:DQ_DataQuality" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:element name="gmd:scope" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:element name="gmd:DQ_Scope" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:level" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:element name="gmd:MD_ScopeCode" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:call-template name="CodeListAttributes">
                  <xsl:with-param name="CodeList">
                    <xsl:text>MD_ScopeCode</xsl:text>
                  </xsl:with-param>
                  <xsl:with-param name="CodeListValue">
                    <xsl:text>dataset</xsl:text>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
        <xsl:comment>
          <xsl:text>Lineage</xsl:text>
        </xsl:comment>
        <xsl:element name="gmd:lineage" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:element name="gmd:LI_Lineage" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:statement" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:call-template name="CharacterString">
                <xsl:with-param name="value" select="gmd:dataQualityInfo/*/gmd:lineage/*/gmd:statement/*"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- MD_Format                                                                  -->
  <!-- ========================================================================== -->
  <xsl:template name="MD_Format">
    <xsl:param name="name">
      <xsl:text>Unknown</xsl:text>
    </xsl:param>
    <xsl:param name="version">
      <xsl:text>Unknown</xsl:text>
    </xsl:param>
    <xsl:element name="gmd:MD_Format" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:element name="gmd:name" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:call-template name="CharacterString">
          <xsl:with-param name="value" select="$name"/>
        </xsl:call-template>
      </xsl:element>
      <xsl:element name="gmd:version" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:choose>
          <xsl:when test="gmd:version/* = 'unused'">
            <xsl:call-template name="CharacterString">
              <xsl:with-param name="value">
                <xsl:text>Unknown</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="CharacterString">
              <xsl:with-param name="value" select="$version"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- MD_Medium                                                                  -->
  <!-- ========================================================================== -->
  <xsl:template name="MD_Medium">
    <xsl:param name="name"/>
    <xsl:element name="gmd:MD_Medium" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:if test="string-length($name) > 0">
        <xsl:element name="gmd:name" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:element name="gmd:MD_MediumNameCode" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:call-template name="CodeListAttributes">
              <xsl:with-param name="CodeList">
                <xsl:text>MD_MediumNameCode</xsl:text>
              </xsl:with-param>
              <xsl:with-param name="CodeListValue" select="$name"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- EX_GeographicBoundingBox                                                   -->
  <!-- ========================================================================== -->
  <xsl:template name="EX_GeographicBoundingBox">
    <xsl:param name="westBoundLongitude"/>
    <xsl:param name="eastBoundLongitude"/>
    <xsl:param name="southBoundLatitude"/>
    <xsl:param name="northBoundLatitude"/>
    <xsl:element name="gmd:EX_GeographicBoundingBox" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:element name="gmd:westBoundLongitude" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:call-template name="Decimal">
          <xsl:with-param name="value" select="$westBoundLongitude"/>
        </xsl:call-template>
      </xsl:element>
      <xsl:element name="gmd:eastBoundLongitude" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:call-template name="Decimal">
          <xsl:with-param name="value" select="$eastBoundLongitude"/>
        </xsl:call-template>
      </xsl:element>
      <xsl:element name="gmd:southBoundLatitude" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:call-template name="Decimal">
          <xsl:with-param name="value" select="$southBoundLatitude"/>
        </xsl:call-template>
      </xsl:element>
      <xsl:element name="gmd:northBoundLatitude" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:call-template name="Decimal">
          <xsl:with-param name="value" select="$northBoundLatitude"/>
        </xsl:call-template>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- EX_TemporalExtent                                                          -->
  <!-- ========================================================================== -->
  <xsl:template name="EX_TemporalExtent">
    <xsl:param name="id">
      <xsl:text>t1</xsl:text>
    </xsl:param>
    <xsl:param name="beginPosition"/>
    <xsl:param name="endPosition"/>
    <xsl:element name="gmd:EX_TemporalExtent" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:element name="gmd:extent" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:element name="gml:TimePeriod" namespace="http://www.opengis.net/gml/3.2">
          <xsl:attribute name="gml:id" namespace="http://www.opengis.net/gml/3.2">
            <xsl:value-of select="$id"/>
          </xsl:attribute>
          <xsl:element name="gml:beginPosition" namespace="http://www.opengis.net/gml/3.2">
            <xsl:value-of select="$beginPosition"/>
          </xsl:element>
          <xsl:element name="gml:endPosition" namespace="http://www.opengis.net/gml/3.2">
            <xsl:value-of select="$endPosition"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- CI_ResponsibleParty                                                        -->
  <!-- ========================================================================== -->
  <xsl:template name="CI_ResponsibleParty">
    <xsl:param name="value" />
    <xsl:param name="role" />
    <xsl:choose>
      <xsl:when test="count($value) > 0">
        <xsl:element name="gmd:CI_ResponsibleParty" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:for-each select="$value/gmd:individualName">
            <xsl:element name="gmd:individualName" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:call-template name="CharacterString">
                <xsl:with-param name="value" select="gco:GEMINI_CharacterString"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:for-each>
          <xsl:for-each select="$value/gmd:organisationName">
            <xsl:element name="gmd:organisationName" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:call-template name="CharacterString">
                <xsl:with-param name="value" select="gco:GEMINI_CharacterString"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:for-each>
          <xsl:for-each select="$value/gmd:positionName">
            <xsl:element name="gmd:positionName" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:call-template name="CharacterString">
                <xsl:with-param name="value" select="gco:GEMINI_CharacterString"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:for-each>
          <!-- Contact information -->
          <xsl:element name="gmd:contactInfo" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:CI_Contact" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:for-each select="$value/gmd:contactInfo/*/gmd:phone">
                <xsl:element name="gmd:phone" namespace="http://www.isotc211.org/2005/gmd">
                  <xsl:element name="gmd:CI_Telephone" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:for-each select="*/gmd:voice">
                      <xsl:element name="gmd:voice" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:call-template name="CharacterString">
                          <xsl:with-param name="value" select="gco:GEMINI_CharacterString"/>
                        </xsl:call-template>
                      </xsl:element>
                    </xsl:for-each>
                    <xsl:for-each select="*/gmd:facsimile">
                      <xsl:element name="gmd:facsimile" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:call-template name="CharacterString">
                          <xsl:with-param name="value" select="gco:GEMINI_CharacterString"/>
                        </xsl:call-template>
                      </xsl:element>
                    </xsl:for-each>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
              <xsl:element name="gmd:address" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:call-template name="CI_Address">
                  <xsl:with-param name="value" select="$value/gmd:contactInfo/*/gmd:address/*"/>
                </xsl:call-template>
              </xsl:element>
              <xsl:for-each select="$value/gmd:contactInfo/*/gmd:onlineResource/*">
                <xsl:element name="gmd:onlineResource" namespace="http://www.isotc211.org/2005/gmd">
                  <xsl:call-template name="CI_OnlineResource">
                    <xsl:with-param name="url" select="gmd:linkage/*"/>
                  </xsl:call-template>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:element>
          <xsl:element name="gmd:role" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:choose>
              <xsl:when test="string-length($role) > 0">
                <xsl:call-template name="CI_RoleCode">
                  <xsl:with-param name="code" select="$role"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="CI_RoleCode"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="gmd:CI_ResponsibleParty" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:element name="gmd:organisationName" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:call-template name="CharacterString">
              <xsl:with-param name="value">
                <xsl:text/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:element>
          <xsl:element name="gmd:contactInfo" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:CI_Contact" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:element name="gmd:address" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:call-template name="CI_Address">
                  <xsl:with-param name="value" select="$value/gmd:contactInfo/*/gmd:address/*"/>
                </xsl:call-template>
              </xsl:element>
            </xsl:element>
          </xsl:element>
          <xsl:element name="gmd:role" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:choose>
              <xsl:when test="string-length($role) > 0">
                <xsl:call-template name="CI_RoleCode">
                  <xsl:with-param name="code" select="$role"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="CI_RoleCode"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- CI_Address                                                                 -->
  <!-- ========================================================================== -->
  <xsl:template name="CI_Address">
    <xsl:param name="value"/>
    <xsl:element name="gmd:CI_Address" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:for-each select="$value/gmd:deliveryPoint">
        <xsl:element name="gmd:deliveryPoint" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:call-template name="CharacterString">
            <xsl:with-param name="value" select="gco:GEMINI_CharacterString"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:for-each>
      <xsl:for-each select="$value/gmd:city">
        <xsl:element name="gmd:city" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:call-template name="CharacterString">
            <xsl:with-param name="value" select="gco:GEMINI_CharacterString"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:for-each>
      <xsl:for-each select="$value/gmd:administrativeArea">
        <xsl:element name="gmd:administrativeArea" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:call-template name="CharacterString">
            <xsl:with-param name="value" select="gco:GEMINI_CharacterString"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:for-each>
      <xsl:for-each select="$value/gmd:postalCode">
        <xsl:element name="gmd:postalCode" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:call-template name="CharacterString">
            <xsl:with-param name="value" select="gco:GEMINI_CharacterString"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:for-each>
      <xsl:for-each select="$value/gmd:country">
        <xsl:element name="gmd:country" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:call-template name="CharacterString">
            <xsl:with-param name="value" select="gco:GEMINI_CharacterString"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:for-each>
      <xsl:choose>
        <xsl:when test="count($value/gmd:electronicMailAddress) > 0">
          <xsl:for-each select="$value/gmd:electronicMailAddress">
            <xsl:element name="gmd:electronicMailAddress" namespace="http://www.isotc211.org/2005/gmd">
              <xsl:call-template name="CharacterString">
                <xsl:with-param name="value" select="gco:GEMINI_CharacterString"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="gmd:electronicMailAddress" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:call-template name="CharacterString">
              <xsl:with-param name="value">
                <xsl:text/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- CI_OnlineResource                                                          -->
  <!-- ========================================================================== -->
  <xsl:template name="CI_OnlineResource">
    <xsl:param name="url"/>
    <xsl:element name="gmd:CI_OnlineResource" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:element name="gmd:linkage" namespace="http://www.isotc211.org/2005/gmd">
        <xsl:element name="gmd:URL" namespace="http://www.isotc211.org/2005/gmd">
          <xsl:value-of select="$url"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- CI_RoleCode                                                                -->
  <!-- ========================================================================== -->
  <xsl:template name="CI_RoleCode">
    <xsl:param name="code">
      <xsl:text>pointOfContact</xsl:text>
    </xsl:param>
    <xsl:element name="gmd:CI_RoleCode" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:call-template name="CodeListAttributes">
        <xsl:with-param name="CodeList">
          <xsl:text>CI_RoleCode</xsl:text>
        </xsl:with-param>
        <xsl:with-param name="CodeListValue" select="$code"/>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Write gco:CharacterString elements                                         -->
  <!-- ========================================================================== -->
  <xsl:template name="CharacterString">
    <xsl:param name="value" />
    <xsl:element name="gco:CharacterString" namespace="http://www.isotc211.org/2005/gco">
      <xsl:value-of select="$value" />
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Write gco:Date or gco:DateTime elements                                    -->
  <!-- ========================================================================== -->
  <xsl:template name="Date">
    <xsl:param name="value"/>
    <xsl:choose>
      <xsl:when test="local-name($value) = 'Date'">
        <xsl:element name="gco:Date" namespace="http://www.isotc211.org/2005/gco">
          <xsl:value-of select="$value"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="local-name($value) = 'DateTime'">
        <xsl:element name="gco:DateTime" namespace="http://www.isotc211.org/2005/gco">
          <xsl:value-of select="$value"/>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Write gco:Decimal elements                                                 -->
  <!-- ========================================================================== -->
  <xsl:template name="Decimal">
    <xsl:param name="value" />
    <xsl:element name="gco:Decimal" namespace="http://www.isotc211.org/2005/gco">
      <xsl:value-of select="$value" />
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Write gco:Distance elements                                                -->
  <!-- ========================================================================== -->
  <xsl:template name="Distance">
    <xsl:param name="value"/>
    <xsl:param name="uom"/>
    <xsl:element name="gco:Distance" namespace="http://www.isotc211.org/2005/gco">
      <xsl:attribute name="uom">
        <xsl:choose>
          <xsl:when test="$uom='m'">
            <xsl:text>urn:ogc:def:uom:EPSG::9001</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$uom"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:value-of select="$value"/>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Write gco:Integer elements                                                 -->
  <!-- ========================================================================== -->
  <xsl:template name="Integer">
    <xsl:param name="value"/>
    <xsl:element name="gco:Integer" namespace="http://www.isotc211.org/2005/gco">
      <xsl:value-of select="$value"/>
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Write gmd:LanguageCode elements                                            -->
  <!-- ========================================================================== -->
  <xsl:template name="LanguageCode">
    <xsl:param name="value" />
    <xsl:element name="gmd:LanguageCode" namespace="http://www.isotc211.org/2005/gmd">
      <xsl:attribute name="codeList">
        <xsl:value-of select="$LanguageCodeUri"/>
      </xsl:attribute>
      <xsl:attribute name="codeListValue">
        <xsl:value-of select="$value"/>
      </xsl:attribute>
      <xsl:value-of select="$value" />
    </xsl:element>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Write code list attributes                                                 -->
  <!-- ========================================================================== -->
  <xsl:template name="CodeListAttributes">
    <xsl:param name="CodeList"/>
    <xsl:param name="CodeListValue"/>
    <xsl:attribute name="codeList">
      <xsl:value-of select="$CodeListUri"/>
      <xsl:value-of select="$CodeList"/>
    </xsl:attribute>
    <xsl:attribute name="codeListValue">
      <xsl:value-of select="$CodeListValue"/>
    </xsl:attribute>
    <xsl:value-of select="$CodeListValue"/>
  </xsl:template>
  <!-- ============================================================ -->
  <!-- Convert ESRI CRS Identifiers to EPSG URNs                    -->
  <!-- ============================================================ -->
  <xsl:template name="GetEpsgCode">
    <xsl:param name="code" />
    <xsl:choose>
      <xsl:when test="$code='nationalGridGB'">
        <xsl:text>urn:ogc:def:crs:EPSG::27700</xsl:text>
      </xsl:when>
      <xsl:when test="$code='irishGrid'">
        <xsl:text>urn:ogc:def:crs:EPSG::29902</xsl:text>
      </xsl:when>
      <xsl:when test="$code='irishTransverseMercator'">
        <xsl:text>urn:ogc:def:crs:EPSG::2157</xsl:text>
      </xsl:when>
      <xsl:when test="$code='wgs84'">
        <xsl:text>urn:ogc:def:crs:EPSG::4326</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$code"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- NGDF User Defined Elements                                                 -->
  <!-- ========================================================================== -->
  <xsl:template name="userDefined">
    <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
    <xsl:copy-of select="//gmd:userDefined"/>
    <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
