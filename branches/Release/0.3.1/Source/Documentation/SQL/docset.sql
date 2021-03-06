drop table docset;
drop table files;
drop table nodeNames;
--drop view v_tst;

BEGIN;

CREATE TABLE IF NOT EXISTS docset (
dsid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
docset TEXT NOT NULL,
UNIQUE (docset) ON CONFLICT REPLACE
);

CREATE TABLE IF NOT EXISTS files (
fid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
dsid INTEGER,
path TEXT NOT NULL,
file TEXT NOT NULL,
filePath TEXT NOT NULL,
UNIQUE (path, file) ON CONFLICT IGNORE
);

CREATE INDEX IF NOT EXISTS files_dsid_path_file_idx ON files (dsid, path, file);
CREATE INDEX IF NOT EXISTS files_filePath_idx ON files (filePath);

CREATE TABLE IF NOT EXISTS nodeNames (
refid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
fid INTEGER NOT NULL,
anchor TEXT,
href TEXT NOT NULL,
name TEXT NOT NULL,
UNIQUE (refid, anchor) ON CONFLICT REPLACE
);

CREATE INDEX IF NOT EXISTS nodeNames_fid ON nodeNames (fid);

CREATE TRIGGER IF NOT EXISTS nodeNames_null_anchor_trig
AFTER INSERT ON nodeNames
FOR EACH ROW WHEN NEW.anchor IS NULL
BEGIN DELETE FROM nodeNames WHERE nodeNames.anchor IS NULL AND nodeNames.fid = NEW.fid AND refid != NEW.refid; END;
/*
CREATE VIEW IF NOT EXISTS v_tst AS
SELECT
ds.dsid AS dsid,
f.fid AS fid,
nn.refid AS refid,
ds.docset AS docset,
f.path AS path,
f.file AS file,
nn.anchor AS anchor,
nn.name AS name
FROM docset AS ds
JOIN files AS f ON f.dsid = ds.dsid
JOIN nodeNames AS nn ON nn.fid = f.fid
--ORDER BY ds.dsid, f.fid, nn.refid
;
*/
COMMIT;
