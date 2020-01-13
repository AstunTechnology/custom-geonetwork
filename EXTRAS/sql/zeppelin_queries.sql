--- record hits by interval (zeppelin query)

select a.monthlyscore, g.name as owner, '%html '||'<a href="http://spatialdata.gov.scot/geonetwork/srv/eng/catalog.search#/metadata/'||a.uuid||'">'||a.uuid||'</a>' as url, (array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text)) AS title from (select metadata.uuid, 'https://spatialdata.gov.scot/geonetwork/srv/eng/catalog.search#/metadata/' || metadata.uuid as URL, foo.Id::integer, max(foo.overallscore::integer) - min(foo.overallscore::integer) as monthlyscore from (select action_tstamp_tx, cast(row_data -> 'id' as integer) as id, changed_fields -> 'popularity' as overallscore from audit.logged_actions where action_tstamp_tx >= 'now'::timestamp - '${interval=1 week,1 day|1 week|2 weeks|1 month|1 year}'::interval) as foo join custom.metadata_xml on foo.Id = metadata_xml.Id join metadata on metadata.Id= metadata_xml.Id where metadata.IsTemplate = 'n' group by foo.Id, metadata.uuid) a join custom.metadata_xml on a.uuid = metadata_xml.uuid join groups g on g.id = metadata_xml.groupowner where a.monthlyscore is not null  order by monthlyscore desc limit 100

--- get audit history (minus popularity and changedate changes) for a given uuid

select b.uuid, a.action_tstamp_tx, a.changed_fields from audit.logged_actions a join metadata b on cast(a.row_data -> 'id' as integer) = b.id where changed_fields ?| ARRAY['popularity','changedate'] = 'f' and b.uuid = '${uuid}' order by action_tstamp_tx desc

--- get list of tables in audit and public schemas

select * from custom.get_tables order by table_schema, table_name

--- get column headings and data types for specified table

select * from custom.getcolumns where table_name = '${table name without schema}'