BEGIN;

CREATE TABLE cluster (
  cid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  created TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fullPath TEXT
);

CREATE TABLE file (
  fid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  cid INTEGER REFERENCES cluster ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
  
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  mode INTEGER NOT NULL,
  linkTo TEXT,
  gfi_attr TEXT,
  gfi_type TEXT,
  gfi_creator TEXT,
  UNIQUE (cid, name)
);

CREATE TABLE common (
  mcid INTEGER REFERENCES cluster ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
  vcid INTEGER REFERENCES cluster ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,

  mfid INTEGER REFERENCES file ON DELETE CASCADE ON UPDATE CASCADE,
  vfid INTEGER REFERENCES file ON DELETE CASCADE ON UPDATE CASCADE,
  
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  mode INTEGER NOT NULL,
  linkTo TEXT,
  gfi_attr TEXT,
  gfi_type TEXT,
  gfi_creator TEXT,
  UNIQUE (mcid, vcid, name, type, mode, linkTo) ON CONFLICT ROLLBACK
);

CREATE TRIGGER del_cid_file DELETE ON cluster BEGIN DELETE FROM file WHERE cid = OLD.cid; END;
CREATE TRIGGER del_cid_common DELETE ON cluster BEGIN DELETE FROM common WHERE mcid = OLD.cid OR vcid = OLD.cid; END;
CREATE TRIGGER del_fid_common DELETE ON file BEGIN DELETE FROM common WHERE mfid = OLD.fid OR vfid = OLD.fid; END;

CREATE TRIGGER upd_cid_file UPDATE OF cid ON cluster BEGIN UPDATE file SET cid = NEW.cid WHERE cid = OLD.cid; END;
CREATE TRIGGER upd_mcid_common UPDATE OF cid ON cluster BEGIN UPDATE common SET mcid = NEW.cid WHERE mcid = OLD.cid; END;
CREATE TRIGGER upd_vcid_common UPDATE OF cid ON cluster BEGIN UPDATE common SET vcid = NEW.cid WHERE vcid = OLD.cid; END;
CREATE TRIGGER upd_mfid_common UPDATE OF fid ON file BEGIN UPDATE common SET mfid = NEW.fid WHERE mfid = OLD.fid; END;
CREATE TRIGGER upd_vfid_common UPDATE OF fid ON file BEGIN UPDATE common SET vfid = NEW.fid WHERE vfid = OLD.fid; END;

INSERT INTO cluster (cid, name, type) VALUES (1, "Binary", "Master");
INSERT INTO cluster (cid, name, type) VALUES (2, "Source", "Master");

INSERT INTO file (cid, name, type, mode) VALUES (1, '/ChangeLog', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/LICENSE', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/README', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/ReleaseNotes', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/Constants.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/content.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/content_frame.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/DataTypes.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/Functions.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/index.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/NSArray.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/NSDictionary.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/NSMutableArray.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/NSMutableDictionary.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/NSMutableSet.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/NSMutableString.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/NSObject.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/NSSet.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/NSString.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/RegexKitImplementationTopics.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/RegexKitProgrammingGuide.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/RKCache.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/RKEnumerator.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/RKRegex.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/toc.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/toc_opened.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/CSS', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/CSS/common.css', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/CSS/content.css', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/CSS/doc.css', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/CSS/guide.css', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/CSS/print.css', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/CSS/toc.css', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/Images', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/Images/1_new_app.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/Images/2_add_framework.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/Images/3_added_framework.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/Images/4_copy_files.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/Images/5_copy_dest.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/Images/6_added_to_copy.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/Images/grad_18_1.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/Images/triangle_closed.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/Images/triangle_closed_sm.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/Images/triangle_open.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/Images/triangle_open_sm.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/JavaScript', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/JavaScript/common.js', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/JavaScript/toc.js', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/index.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre-config.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_compile.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_compile2.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_config.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_copy_named_substring.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_copy_substring.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_dfa_exec.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_exec.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_free_substring.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_free_substring_list.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_fullinfo.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_get_named_substring.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_get_stringnumber.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_get_stringtable_entries.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_get_substring.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_get_substring_list.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_info.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_maketables.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_refcount.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_study.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcre_version.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcreapi.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcrebuild.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcrecallout.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcrecompat.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcrecpp.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcregrep.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcrematching.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcrepartial.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcrepattern.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcreperform.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcreposix.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcreprecompile.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcresample.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcrestack.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcresyntax.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/Documentation/pcre/pcretest.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework', 'd', 16877);
INSERT INTO file (cid, name, type, mode, linkTo) VALUES (1, '/RegexKit.framework/Headers', 'l', 16877, 'Versions/Current/Headers');
INSERT INTO file (cid, name, type, mode, linkTo) VALUES (1, '/RegexKit.framework/RegexKit', 'l', 33261, 'Versions/Current/RegexKit');
INSERT INTO file (cid, name, type, mode, linkTo) VALUES (1, '/RegexKit.framework/Resources', 'l', 16877, 'Versions/Current/Resources');
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions', 'd', 16877);
INSERT INTO file (cid, name, type, mode, linkTo) VALUES (1, '/RegexKit.framework/Versions/Current', 'l', 16877, 'A');
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/RegexKit', 'f', 33261);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/Headers', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/Headers/NSArray.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/Headers/NSDictionary.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/Headers/NSObject.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/Headers/NSSet.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/Headers/NSString.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/Headers/pcre.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/Headers/RegexKit.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/Headers/RegexKitDefines.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/Headers/RegexKitTypes.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/Headers/RKCache.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/Headers/RKEnumerator.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/Headers/RKRegex.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/Headers/RKUtility.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/Resources', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/Resources/Info.plist', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/Resources/English.lproj', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (1, '/RegexKit.framework/Versions/A/Resources/English.lproj/InfoPlist.strings', 'f', 33188);

INSERT INTO file (cid, name, type, mode) VALUES (2, '/ChangeLog', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/LICENSE', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/README', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/README.MacOSX', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/ReleaseNotes', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/Constants.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/content.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/content_frame.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/DataTypes.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/Functions.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/index.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/NSArray.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/NSDictionary.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/NSMutableArray.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/NSMutableDictionary.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/NSMutableSet.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/NSMutableString.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/NSObject.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/NSSet.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/NSString.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/RegexKitImplementationTopics.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/RegexKitProgrammingGuide.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/RKCache.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/RKEnumerator.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/RKRegex.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/toc.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/toc_opened.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/CSS', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/CSS/common.css', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/CSS/content.css', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/CSS/doc.css', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/CSS/guide.css', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/CSS/print.css', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/CSS/toc.css', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/Images', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/Images/1_new_app.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/Images/2_add_framework.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/Images/3_added_framework.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/Images/4_copy_files.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/Images/5_copy_dest.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/Images/6_added_to_copy.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/Images/grad_18_1.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/Images/triangle_closed.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/Images/triangle_closed_sm.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/Images/triangle_open.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/Images/triangle_open_sm.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/JavaScript', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/JavaScript/common.js', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/JavaScript/toc.js', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/index.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre-config.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_compile.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_compile2.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_config.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_copy_named_substring.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_copy_substring.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_dfa_exec.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_exec.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_free_substring.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_free_substring_list.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_fullinfo.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_get_named_substring.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_get_stringnumber.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_get_stringtable_entries.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_get_substring.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_get_substring_list.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_info.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_maketables.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_refcount.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_study.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcre_version.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcreapi.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcrebuild.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcrecallout.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcrecompat.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcrecpp.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcregrep.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcrematching.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcrepartial.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcrepattern.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcreperform.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcreposix.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcreprecompile.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcresample.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcrestack.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcresyntax.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Documentation/pcre/pcretest.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/GNUstep', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/GNUstep/GNUmakefile', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/GNUstep/GNUmakefile.postamble', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/GNUstep/README.GNUstep', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/RegexKit.xcodeproj', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/RegexKit.xcodeproj/project.pbxproj', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Info.plist', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/NSArray.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/NSDictionary.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/NSObject.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/NSSet.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/NSString.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/RegexKit_Prefix.pch', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/RKAutoreleasedMemory.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/RKCache.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/RKCoder.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/RKEnumerator.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/RKLock.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/RKPlaceholder.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/RKPrivate.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/RKRegex.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/RKUtility.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Build', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Build/Distribution', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Build/Distribution/distribution_pcre.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Build/Distribution/Documentation.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Build/Makefiles', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Build/Makefiles/Makefile.pcre', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Build/Scripts', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Build/Scripts/buildDistribution.sh', 'f', 33261);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Build/Scripts/buildPCRE.sh', 'f', 33261);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Build/Scripts/fileCheck.pl', 'f', 33261);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Build/Scripts/stripHeaderdoc.sh', 'f', 33261);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Build/SQL', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Build/SQL/files.sql', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Build/Xcode', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Build/Xcode/projectExportedSymbols', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Build/Xcode/RegexKit Build Settings.xcconfig', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Misc', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Misc/spelling_words', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/CSS', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/CSS/common.css', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/CSS/content.css', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/CSS/doc.css', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/CSS/guide.css', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/CSS/print.css', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/CSS/toc.css', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/Images', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/Images/1_new_app.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/Images/2_add_framework.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/Images/3_added_framework.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/Images/4_copy_files.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/Images/5_copy_dest.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/Images/6_added_to_copy.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/Images/grad_18_1.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/Images/triangle_closed.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/Images/triangle_closed_sm.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/Images/triangle_open.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/Images/triangle_open_sm.png', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/JavaScript', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/JavaScript/common.js', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Resources/JavaScript/toc.js', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Scripts', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Scripts/buildDocumentation.sh', 'f', 33261);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Scripts/checkHTML.sh', 'f', 33261);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Scripts/checkSpelling.sh', 'f', 33261);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Scripts/generateHTML.pl', 'f', 33261);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Scripts/generatePCREToC.pl', 'f', 33261);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Scripts/parseHeaders.pl', 'f', 33261);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Scripts/resolveLinks.pl', 'f', 33261);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/SQL', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/SQL/config.sql', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/SQL/init.sql', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Static', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Static/index.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Static/RegexKitImplementationTopics.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Static/RegexKitProgrammingGuide.html', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Templates', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Templates/Constants.tmpl', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Templates/content.tmpl', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Templates/DataTypes.tmpl', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Templates/Functions.tmpl', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Templates/NSArray.tmpl', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Templates/NSDictionary.tmpl', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Templates/NSMutableArray.tmpl', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Templates/NSMutableDictionary.tmpl', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Templates/NSMutableSet.tmpl', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Templates/NSMutableString.tmpl', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Templates/NSObject.tmpl', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Templates/NSSet.tmpl', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Templates/NSString.tmpl', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Templates/RKCache.tmpl', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Templates/RKEnumerator.tmpl', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Templates/RKRegex.tmpl', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Documentation/Templates/toc.tmpl', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit/NSArray.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit/NSDictionary.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit/NSObject.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit/NSSet.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit/NSString.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit/pcre.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit/RegexKit.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit/RegexKitDefines.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit/RegexKitPrivate.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit/RegexKitTypes.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit/RKAutoreleasedMemory.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit/RKCache.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit/RKCoder.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit/RKEnumerator.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit/RKLock.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit/RKPlaceholder.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit/RKRegex.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Headers/RegexKit/RKUtility.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Resources', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Resources/English.lproj', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/Resources/English.lproj/InfoPlist.strings', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests', 'd', 16877);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests/collectionAdditions.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests/collectionAdditions.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests/core.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests/core.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests/debug.sh', 'f', 33261);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests/enumeration.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests/enumeration.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests/functionality.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests/functionality.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests/multithreading.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests/multithreading.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests/NSDate.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests/NSDate.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests/stringConversion.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests/stringConversion.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests/timing.h', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests/timing.m', 'f', 33188);
INSERT INTO file (cid, name, type, mode) VALUES (2, '/Source/unitTests/Unit Tests-Info.plist', 'f', 33188);

CREATE INDEX file_cid_idx ON file (cid);
CREATE INDEX common_mcid_vcid_name_idx ON common (mcid, vcid, name);

COMMIT;
