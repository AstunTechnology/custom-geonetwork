
CREATE SCHEMA custom;


ALTER SCHEMA custom OWNER TO geonetwork;


CREATE VIEW custom.metadata_xml AS
 SELECT metadata.id,
    metadata.uuid,
    metadata.schemaid,
    metadata.istemplate,
    metadata.isharvested,
    metadata.createdate,
    metadata.changedate,
    XMLPARSE(DOCUMENT metadata.data STRIP WHITESPACE) AS data_xml,
    metadata.data,
    metadata.source,
    metadata.title,
    metadata.root,
    metadata.harvestuuid,
    metadata.owner,
    metadata.doctype,
    metadata.groupowner,
    metadata.harvesturi,
    metadata.rating,
    metadata.popularity,
    metadata.displayorder
   FROM public.metadata;


ALTER TABLE custom.metadata_xml OWNER TO geonetwork;


CREATE VIEW custom.all_records AS
 SELECT groups.name AS organisation,
    (bah.id)::text AS id,
    (bah.owner)::text AS owner,
    users.username,
    email.email,
    (bah.uuid)::text AS uuid,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS title,
    (statusvalues.name)::text AS status,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date[gmd:dateType/gmd:CI_DateTypeCode[@codeListValue="creation"]]/gmd:date/gco:Date/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), ''::text) AS creationdate,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date[gmd:dateType/gmd:CI_DateTypeCode[@codeListValue="revision"]]/gmd:date/gco:Date/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), ''::text) AS revisiondate,
    regexp_replace(array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text), '[\n\r\u2028]+'::text, ' '::text, 'g'::text) AS abstract,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '|'::text) AS keywords,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/eamp:EA_Constraints/eamp:afa/eamp:EA_Afa/eamp:afaNumber/gco:Decimal/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd},{eamp,http://environment.data.gov.uk/eamp}}'::text[]), '|'::text) AS afanumber,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/eamp:EA_Constraints/eamp:afa/eamp:EA_Afa/eamp:afaStatus/eamp:EA_AfaStatus/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd},{eamp,http://environment.data.gov.uk/eamp}}'::text[]), '|'::text) AS afastatus,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '|'::text) AS orl,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS lineage,
    regexp_replace(array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '|'::text), '[\n\r\u2028]+'::text, ' '::text, 'g'::text) AS otherconstraints,
    ((((((((COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[1])::text, ''::text) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[1])::text, ''::text)) || ' '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:positionName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[1])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[1])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[1])::text, ''::text)) AS contact1,
    ((((((((COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[2])::text, ''::text) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[2])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:positionName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[2])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[2])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[2])::text, ''::text)) AS contact2,
    ((((((((COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[3])::text, ''::text) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[3])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:positionName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[3])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[3])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[1])::text, ''::text)) AS contact3,
    ((((((((COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[4])::text, ''::text) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[4])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:positionName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[4])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[4])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[1])::text, ''::text)) AS contact4
   FROM (((((( SELECT DISTINCT ON (metadatastatus.metadataid) metadatastatus.metadataid,
            metadatastatus.statusid,
            metadatastatus.userid,
            metadatastatus.changedate,
            metadatastatus.changemessage
           FROM public.metadatastatus
          ORDER BY metadatastatus.metadataid, metadatastatus.changedate DESC) foo
     LEFT JOIN public.statusvalues ON ((foo.statusid = statusvalues.id)))
     RIGHT JOIN ( SELECT metadata_xml.id,
            metadata_xml.uuid,
            metadata_xml.schemaid,
            metadata_xml.istemplate,
            metadata_xml.isharvested,
            metadata_xml.createdate,
            metadata_xml.changedate,
            metadata_xml.data_xml,
            metadata_xml.data,
            metadata_xml.source,
            metadata_xml.title,
            metadata_xml.root,
            metadata_xml.harvestuuid,
            metadata_xml.owner,
            metadata_xml.doctype,
            metadata_xml.groupowner,
            metadata_xml.harvesturi,
            metadata_xml.rating,
            metadata_xml.popularity,
            metadata_xml.displayorder
           FROM custom.metadata_xml
          WHERE (metadata_xml.istemplate <> 'y'::bpchar)
          ORDER BY metadata_xml.id) bah ON ((foo.metadataid = bah.id)))
     LEFT JOIN public.groups ON ((bah.groupowner = groups.id)))
     LEFT JOIN public.email ON ((bah.owner = email.user_id)))
     LEFT JOIN public.users ON ((bah.owner = users.id)))
  ORDER BY groups.name, bah.id;


ALTER TABLE custom.all_records OWNER TO geonetwork;


CREATE VIEW custom.all_records_for_harvesting AS
 SELECT a.metadataid,
    b.uuid,
    c.name,
    foo.statusid
   FROM (((public.operationallowed a
     JOIN public.metadata b ON ((a.metadataid = b.id)))
     JOIN public.groups c ON ((b.groupowner = c.id)))
     JOIN ( SELECT DISTINCT ON (a_1.metadataid) a_1.metadataid,
            a_1.statusid,
            a_1.changedate,
            b_1.groupowner,
            c_1.name
           FROM ((public.metadatastatus a_1
             JOIN public.metadata b_1 ON ((a_1.metadataid = b_1.id)))
             JOIN public.groups c_1 ON ((b_1.groupowner = c_1.id)))
          WHERE (a_1.statusid = 2)
          ORDER BY a_1.metadataid, a_1.changedate DESC) foo ON ((b.id = foo.metadataid)))
  WHERE ((a.operationid = 0) AND (a.groupid = 1) AND ((c.name)::text <> 'Environment Agency'::text))
UNION ALL
 SELECT a.metadataid,
    b.uuid,
    c.name,
    foo.statusid
   FROM (((public.operationallowed a
     JOIN ( SELECT metadata_xml.id,
            metadata_xml.uuid,
            metadata_xml.schemaid,
            metadata_xml.istemplate,
            metadata_xml.isharvested,
            metadata_xml.createdate,
            metadata_xml.changedate,
            metadata_xml.data_xml,
            metadata_xml.data,
            metadata_xml.source,
            metadata_xml.title,
            metadata_xml.root,
            metadata_xml.harvestuuid,
            metadata_xml.owner,
            metadata_xml.doctype,
            metadata_xml.groupowner,
            metadata_xml.harvesturi,
            metadata_xml.rating,
            metadata_xml.popularity,
            metadata_xml.displayorder
           FROM custom.metadata_xml
          WHERE (('OpenData'::text = ANY ((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))::text[])) OR ('NotOpen'::text = ANY ((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))::text[])))) b ON ((a.metadataid = b.id)))
     JOIN public.groups c ON ((b.groupowner = c.id)))
     JOIN ( SELECT DISTINCT ON (a_1.metadataid) a_1.metadataid,
            a_1.statusid,
            a_1.changedate,
            b_1.groupowner,
            c_1.name
           FROM ((public.metadatastatus a_1
             JOIN public.metadata b_1 ON ((a_1.metadataid = b_1.id)))
             JOIN public.groups c_1 ON ((b_1.groupowner = c_1.id)))
          WHERE (a_1.statusid = 2)
          ORDER BY a_1.metadataid, a_1.changedate DESC) foo ON ((b.id = foo.metadataid)))
  WHERE ((a.operationid = 0) AND (a.groupid = 1) AND ((c.name)::text = 'Environment Agency'::text));


ALTER TABLE custom.all_records_for_harvesting OWNER TO geonetwork;


COMMENT ON VIEW custom.all_records_for_harvesting IS 'Records with status "approved" and "all" privileges for "all" group';


CREATE VIEW custom.citationidentifier AS
 SELECT m.uuid,
    foo.citationidentifier
   FROM (public.metadata m
     LEFT JOIN ( SELECT metadata_xml.uuid,
            array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS citationidentifier
           FROM custom.metadata_xml) foo ON (((m.uuid)::text = (foo.uuid)::text)));


ALTER TABLE custom.citationidentifier OWNER TO geonetwork;


CREATE VIEW custom.contactemails AS
 SELECT metadata_xml.id,
    metadata_xml.uuid,
    (unnest(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[])))::text AS contactemail
   FROM custom.metadata_xml
  ORDER BY metadata_xml.id;


ALTER TABLE custom.contactemails OWNER TO geonetwork;


COMMENT ON VIEW custom.contactemails IS 'All contact emails extracted from within metadata';


CREATE VIEW custom.get_tables AS
 SELECT tables.table_schema,
    tables.table_name
   FROM information_schema.tables
  WHERE ((tables.table_schema)::text <> ALL (ARRAY[('information_schema'::character varying)::text, ('pg_catalog'::character varying)::text, ('custom'::character varying)::text]))
  ORDER BY tables.table_schema, tables.table_name;


ALTER TABLE custom.get_tables OWNER TO geonetwork;


CREATE VIEW custom.getcolumns AS
 SELECT columns.table_schema,
    columns.table_name,
    columns.column_name,
    columns.ordinal_position,
    columns.is_nullable,
    columns.data_type
   FROM information_schema.columns
  WHERE ((columns.table_schema)::text <> ALL (ARRAY[('information_schema'::character varying)::text, ('pg_catalog'::character varying)::text]));


ALTER TABLE custom.getcolumns OWNER TO geonetwork;


CREATE VIEW custom.intgsiemails AS
 SELECT DISTINCT contactemails.contactemail,
    'metadata'::text AS context,
    'internal'::text AS server
   FROM custom.contactemails
  WHERE ((contactemails.contactemail ~~* '%gsi.gov.uk'::text) AND (contactemails.contactemail !~~* '%forestry.gsi.gov.uk'::text))
  GROUP BY contactemails.contactemail
UNION
 SELECT email.email AS contactemail,
    'userlogin'::text AS context,
    'internal'::text AS server
   FROM public.email
  WHERE (((email.email)::text ~~* '%gsi.gov.uk'::text) AND ((email.email)::text !~~* '%forestry.gsi.gov.uk'::text))
  ORDER BY 1;


ALTER TABLE custom.intgsiemails OWNER TO geonetwork;


CREATE VIEW custom.opendata_validation AS
 SELECT DISTINCT foo.uuid,
    foo.title,
    foo.beenthroughvalidation,
    foo.organisation
   FROM ( SELECT metadata_xml.uuid,
            array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS title,
            validation.valdate,
            categories.name AS organisation,
                CASE
                    WHEN ((validation.valdate)::text <> ''::text) THEN 'y'::text
                    ELSE 'n'::text
                END AS beenthroughvalidation
           FROM public.metadatastatus,
            (((custom.metadata_xml
             LEFT JOIN public.metadatacateg ON ((metadata_xml.id = metadatacateg.metadataid)))
             LEFT JOIN public.categories ON ((metadatacateg.categoryid = categories.id)))
             LEFT JOIN public.validation ON ((validation.metadataid = metadata_xml.id)))
          WHERE ((metadatastatus.metadataid = metadata_xml.id) AND (('OpenData'::text = ANY ((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))::text[])) OR ('NotOpen'::text = ANY ((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))::text[]))))) foo
  GROUP BY foo.organisation, foo.uuid, foo.title, foo.beenthroughvalidation
  ORDER BY foo.organisation, foo.beenthroughvalidation, foo.title;


ALTER TABLE custom.opendata_validation OWNER TO geonetwork;


CREATE VIEW custom.records_custodian AS
 SELECT metadata_xml.id,
    array_to_string(xpath('(/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact[gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode="custodian"]/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString/text())[1]'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS custodian1,
    array_to_string(xpath('(/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact[gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode="custodian"]/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString/text())[2]'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS custodian2,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS title,
    categories.name AS organisation
   FROM ((custom.metadata_xml
     LEFT JOIN public.metadatacateg ON ((metadata_xml.id = metadatacateg.metadataid)))
     LEFT JOIN public.categories ON ((metadatacateg.categoryid = categories.id)))
  ORDER BY categories.name, metadata_xml.id;


ALTER TABLE custom.records_custodian OWNER TO geonetwork;


CREATE VIEW custom.records_date_updated AS
 SELECT metadata_xml.id,
    metadata_xml.changedate,
    array_to_string(xpath('(/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact[gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode="custodian"]/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString/text())[1]'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS custodian,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS title,
    groups.name AS organisation
   FROM (custom.metadata_xml
     LEFT JOIN public.groups ON ((metadata_xml.groupowner = groups.id)))
  WHERE (to_date((metadata_xml.changedate)::text, 'YYYY-MM-DD'::text) < (('now'::text)::date - '3 mons'::interval));


ALTER TABLE custom.records_date_updated OWNER TO geonetwork;


CREATE VIEW custom.records_on_ext_not_forharvesting AS
 SELECT a.uuid,
    a.id,
    a.istemplate,
    b.name
   FROM (public.pub_metadata a
     JOIN public.pub_groups b ON ((a.groupowner = b.id)))
  WHERE (NOT ((a.uuid)::text IN ( SELECT all_records_for_harvesting.uuid
           FROM custom.all_records_for_harvesting)));


ALTER TABLE custom.records_on_ext_not_forharvesting OWNER TO geonetwork;


COMMENT ON VIEW custom.records_on_ext_not_forharvesting IS 'records on external server not in custom.all_records_for_harvesting';


CREATE VIEW custom.records_orl AS
 SELECT foo.uuid,
    array_to_string(xpath('//gmd:CI_OnlineResource/gmd:linkage/gmd:URL/text()'::text, foo.node, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), ''::text) AS url,
    array_to_string(xpath('//gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString/text()'::text, foo.node, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), ''::text) AS url_protocol,
    array_to_string(xpath('//gmd:CI_OnlineResource/gmd:name/gco:CharacterString/text()'::text, foo.node, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), ''::text) AS url_name,
    array_to_string(xpath('//gmd:CI_OnlineResource/gmd:description/gco:CharacterString/text()'::text, foo.node, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), ''::text) AS url_description,
    categories.name AS organisation
   FROM ((( SELECT unnest(xpath('/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[])) AS node,
            metadata_xml.uuid,
            metadata_xml.id
           FROM custom.metadata_xml) foo
     LEFT JOIN public.metadatacateg ON ((foo.id = metadatacateg.metadataid)))
     LEFT JOIN public.categories ON ((metadatacateg.categoryid = categories.id)))
  ORDER BY categories.name, foo.uuid;


ALTER TABLE custom.records_orl OWNER TO geonetwork;


CREATE VIEW custom.records_status AS
 SELECT metadata_xml.id,
    metadata_xml.uuid,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS title,
    statusvalues.name AS status,
    foo.userid,
    foo.changedate,
    foo.changemessage,
    categories.name AS organisation
   FROM ((((( SELECT DISTINCT ON (metadatastatus.metadataid) metadatastatus.metadataid,
            metadatastatus.statusid,
            metadatastatus.userid,
            metadatastatus.changedate,
            metadatastatus.changemessage
           FROM public.metadatastatus
          ORDER BY metadatastatus.metadataid, metadatastatus.changedate DESC) foo
     LEFT JOIN public.statusvalues ON ((foo.statusid = statusvalues.id)))
     RIGHT JOIN custom.metadata_xml ON ((foo.metadataid = metadata_xml.id)))
     LEFT JOIN public.metadatacateg ON ((metadata_xml.id = metadatacateg.metadataid)))
     LEFT JOIN public.categories ON ((metadatacateg.categoryid = categories.id)))
  ORDER BY categories.name, (array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text));


ALTER TABLE custom.records_status OWNER TO geonetwork;

CREATE VIEW custom.records_validation AS
 SELECT metadata_xml.id,
    statusvalues.name,
    metadatastatus.changedate,
    metadatastatus.changemessage,
    validation.valtype,
    validation.status,
    validation.failed,
    validation.valdate,
    categories.name AS organisation,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS orl,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS title
   FROM public.metadatastatus,
    public.statusvalues,
    (((custom.metadata_xml
     LEFT JOIN public.validation ON ((validation.metadataid = metadata_xml.id)))
     LEFT JOIN public.metadatacateg ON ((metadata_xml.id = metadatacateg.metadataid)))
     LEFT JOIN public.categories ON ((metadatacateg.categoryid = categories.id)))
  WHERE ((metadatastatus.metadataid = metadata_xml.id) AND (metadatastatus.statusid = statusvalues.id) AND ((statusvalues.name)::text = 'approved'::text) AND ((validation.failed IS NULL) OR (validation.failed > 0)))
  ORDER BY categories.name, metadata_xml.id;


ALTER TABLE custom.records_validation OWNER TO geonetwork;


CREATE VIEW custom.uniquegsiemails AS
 SELECT DISTINCT lower(foo.contactemail) AS email
   FROM ( SELECT intgsiemails.contactemail,
            intgsiemails.context,
            intgsiemails.server
           FROM custom.intgsiemails
        UNION
         SELECT pub_extgsiemails.contactemail,
            pub_extgsiemails.context,
            pub_extgsiemails.server
           FROM public.pub_extgsiemails) foo
  GROUP BY (lower(foo.contactemail))
  ORDER BY (lower(foo.contactemail));


ALTER TABLE custom.uniquegsiemails OWNER TO geonetwork;


REVOKE ALL ON SCHEMA custom FROM PUBLIC;
REVOKE ALL ON SCHEMA custom FROM geonetwork;
GRANT ALL ON SCHEMA custom TO geonetwork;
GRANT USAGE ON SCHEMA custom TO geonetwork_ro;


REVOKE ALL ON TABLE custom.metadata_xml FROM PUBLIC;
REVOKE ALL ON TABLE custom.metadata_xml FROM geonetwork;
GRANT ALL ON TABLE custom.metadata_xml TO geonetwork;
GRANT SELECT ON TABLE custom.metadata_xml TO geonetwork_ro;


REVOKE ALL ON TABLE custom.all_records FROM PUBLIC;
REVOKE ALL ON TABLE custom.all_records FROM geonetwork;
GRANT ALL ON TABLE custom.all_records TO geonetwork;
GRANT SELECT ON TABLE custom.all_records TO geonetwork_ro;


REVOKE ALL ON TABLE custom.all_records_for_harvesting FROM PUBLIC;
REVOKE ALL ON TABLE custom.all_records_for_harvesting FROM geonetwork;
GRANT ALL ON TABLE custom.all_records_for_harvesting TO geonetwork;
GRANT SELECT ON TABLE custom.all_records_for_harvesting TO geonetwork_ro;


REVOKE ALL ON TABLE custom.citationidentifier FROM PUBLIC;
REVOKE ALL ON TABLE custom.citationidentifier FROM geonetwork;
GRANT ALL ON TABLE custom.citationidentifier TO geonetwork;
GRANT SELECT ON TABLE custom.citationidentifier TO geonetwork_ro;


REVOKE ALL ON TABLE custom.contactemails FROM PUBLIC;
REVOKE ALL ON TABLE custom.contactemails FROM geonetwork;
GRANT ALL ON TABLE custom.contactemails TO geonetwork;
GRANT SELECT ON TABLE custom.contactemails TO geonetwork_ro;



REVOKE ALL ON TABLE custom.get_tables FROM PUBLIC;
REVOKE ALL ON TABLE custom.get_tables FROM geonetwork;
GRANT ALL ON TABLE custom.get_tables TO geonetwork;
GRANT SELECT ON TABLE custom.get_tables TO geonetwork_ro;



REVOKE ALL ON TABLE custom.getcolumns FROM PUBLIC;
REVOKE ALL ON TABLE custom.getcolumns FROM geonetwork;
GRANT ALL ON TABLE custom.getcolumns TO geonetwork;
GRANT SELECT ON TABLE custom.getcolumns TO geonetwork_ro;



REVOKE ALL ON TABLE custom.intgsiemails FROM PUBLIC;
REVOKE ALL ON TABLE custom.intgsiemails FROM geonetwork;
GRANT ALL ON TABLE custom.intgsiemails TO geonetwork;
GRANT SELECT ON TABLE custom.intgsiemails TO geonetwork_ro;



REVOKE ALL ON TABLE custom.opendata_validation FROM PUBLIC;
REVOKE ALL ON TABLE custom.opendata_validation FROM geonetwork;
GRANT ALL ON TABLE custom.opendata_validation TO geonetwork;
GRANT SELECT ON TABLE custom.opendata_validation TO geonetwork_ro;



REVOKE ALL ON TABLE custom.records_custodian FROM PUBLIC;
REVOKE ALL ON TABLE custom.records_custodian FROM geonetwork;
GRANT ALL ON TABLE custom.records_custodian TO geonetwork;
GRANT SELECT ON TABLE custom.records_custodian TO geonetwork_ro;



REVOKE ALL ON TABLE custom.records_date_updated FROM PUBLIC;
REVOKE ALL ON TABLE custom.records_date_updated FROM geonetwork;
GRANT ALL ON TABLE custom.records_date_updated TO geonetwork;
GRANT SELECT ON TABLE custom.records_date_updated TO geonetwork_ro;



REVOKE ALL ON TABLE custom.records_on_ext_not_forharvesting FROM PUBLIC;
REVOKE ALL ON TABLE custom.records_on_ext_not_forharvesting FROM geonetwork;
GRANT ALL ON TABLE custom.records_on_ext_not_forharvesting TO geonetwork;
GRANT SELECT ON TABLE custom.records_on_ext_not_forharvesting TO geonetwork_ro;


REVOKE ALL ON TABLE custom.records_orl FROM PUBLIC;
REVOKE ALL ON TABLE custom.records_orl FROM geonetwork;
GRANT ALL ON TABLE custom.records_orl TO geonetwork;
GRANT SELECT ON TABLE custom.records_orl TO geonetwork_ro;



REVOKE ALL ON TABLE custom.records_status FROM PUBLIC;
REVOKE ALL ON TABLE custom.records_status FROM geonetwork;
GRANT ALL ON TABLE custom.records_status TO geonetwork;
GRANT SELECT ON TABLE custom.records_status TO geonetwork_ro;



REVOKE ALL ON TABLE custom.records_validation FROM PUBLIC;
REVOKE ALL ON TABLE custom.records_validation FROM geonetwork;
GRANT ALL ON TABLE custom.records_validation TO geonetwork;
GRANT SELECT ON TABLE custom.records_validation TO geonetwork_ro;

