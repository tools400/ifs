**FREE
/IF NOT DEFINED(PIFS)
/DEFINE PIFS

//  Constants
/IF NOT DEFINED(cTrue)
/DEFINE cTrue
DCL-C cTrue *ON;
/ENDIF

/IF NOT DEFINED(cFalse)
/DEFINE cFalse
DCL-C cFalse *OFF;
/ENDIF

DCL-C cIFS_ERROR -1;
DCL-C cIFS_EOF -2;

DCL-C cIFS_EOL_CRLF x'0D25';
DCL-C cIFS_EOL_LF x'25';
DCL-C cIFS_EOL_CR x'0D';
DCL-C cIFS_EOL_ANY x'00';

DCL-C cIFS_READDIR_DFT 7; // x'00000007'
DCL-C cIFS_READDIR_FILES 1; // x'00000001'
DCL-C cIFS_READDIR_DIR 2; // x'00000002'
DCL-C cIFS_READDIR_ALL 32; // x'00000020'
DCL-C cIFS_READDIR_CB_NAME 4; // x'00000004'
DCL-C cIFS_READDIR_CB_DIRENT 8; // x'00000008'
DCL-C cIFS_READDIR_SUBDIR 16; // x'00000010'
DCL-C cIFS_READDIR_PRE_ORDER 64; // x'00000040'
DCL-C cIFS_READDIR_POST_ORDER 128; // x'00000080'

DCL-C cIFS_DIRENT_TYPE_FILE '*STMF';
DCL-C cIFS_DIRENT_TYPE_DOCUMENT '*DOC';
DCL-C cIFS_DIRENT_TYPE_DIRECTORY '*DIR';
DCL-C cIFS_DIRENT_TYPE_FOLDER '*FLR';

DCL-C cIFS_MKDIR_DFT 0; // x'00000000'
DCL-C cIFS_MKDIR_RECURSION 1; // x'00000001'

DCL-C cIFS_RMDIR_DFT 0; // x'00000000'
DCL-C cIFS_RMDIR_DELETE_FILES 1; // x'00000001'
DCL-C cIFS_RMDIR_DELETE_SUB_DIRECTORIES 16; // x'00000010'

//  For testing purposes only!
DCL-C cIFS_RMDIR_TEST_MODE 1073741824; // x'40000000'

//  Callback Procedures

DCL-PR f_readDirIfs_path IND EXTPROC('f_readDirIfs_path');
  i_level     INT(10) VALUE;
  i_directory LIKE(ifs_path_t) VALUE;
  i_entry     LIKE(ifs_path_t) VALUE;
  i_type      LIKE(ifs_type_t) VALUE;
  i_pUserData POINTER VALUE;
  o_msg       LIKE(msg_t) VALUE;
END-PR;

DCL-PR f_readDirIfs_dirent IND EXTPROC('f_readDirIfs_dirent');
  i_level     INT(10) VALUE;
  i_directory LIKE(ifs_path_t) VALUE;
  i_dirent    LIKEDS(dirent_t) VALUE;
  i_type      LIKE(ifs_type_t) VALUE;
  i_pUserData POINTER VALUE;
  o_msg       LIKE(msg_t) VALUE;
END-PR;

//  Type definitions
DCL-S ifs_path_t CHAR(256) TEMPLATE;
DCL-S ifs_hFile_t INT(10) TEMPLATE;
DCL-S ifs_EOLChar_t VARCHAR(32) TEMPLATE;
DCL-S ifs_type_t CHAR(10) TEMPLATE;
DCL-DS ifs_fileID_t QUALIFIED TEMPLATE;
  ino UNS(10);
  dev UNS(20);
END-DS;

//  Imported prototypes
/COPY QIFS,CLIB
/COPY QIFS,CEELIB
/COPY QBASICS1,PBASICS1

//  Checks, whether an IFS directory exists.
DCL-PR f_isIfsDir IND EXTPROC('IFSR01_f_isIfsDir');
  i_path LIKE(ifs_path_t) CONST;
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Checks, whether an IFS file exists.
DCL-PR f_isIfsFile IND EXTPROC('IFSR01_f_isIfsFile');
  i_file LIKE(ifs_path_t) CONST;
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Fixes a given IFS path name.
DCL-PR f_fixIfsPath LIKE(ifs_path_t) EXTPROC('IFSR01_f_fixIfsPath');
  i_path LIKE(ifs_path_t) CONST;
END-PR;

//  Fixes a given IFS directory name.
DCL-PR f_fixIfsDir LIKE(ifs_path_t) EXTPROC('IFSR01_f_fixIfsDir');
  i_dir LIKE(ifs_path_t) CONST;
END-PR;

//  Retrieves the file name from a given path name.
DCL-PR f_rtvIfsFileFromPath LIKE(ifs_path_t) EXTPROC('IFSR01_f_rtvIfsFileFromPath');
  i_path LIKE(ifs_path_t) CONST;
END-PR;

//  Retrieves the directory name from a given path name.
DCL-PR f_rtvIfsDirFromPath LIKE(ifs_path_t) EXTPROC('IFSR01_f_rtvIfsDirFromPath');
  i_path LIKE(ifs_path_t) CONST;
END-PR;

//  Retrieves the file extension from a given path name.
DCL-PR f_rtvIfsFileExtFromPath LIKE(ifs_path_t) EXTPROC('IFSR01_f_rtvIfsFileExtFromPath');
  i_path LIKE(ifs_path_t) CONST;
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Removes the extension from an IFS file name.
DCL-PR f_rmvIfsFileExtFromPath LIKE(ifs_path_t) EXTPROC('IFSR01_f_rmvIfsFileExtFromPath');
  i_path LIKE(ifs_path_t) CONST;
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Open an IFS file for text mode.
DCL-PR f_openIfsFile LIKE(ifs_hFile_t) EXTPROC('IFSR01_f_openIfsFile');
  i_path     LIKE(ifs_path_t) CONST;
  i_opnFlags INT(10) CONST;
  i_codePage INT(10) OPTIONS(*NOPASS: *OMIT) CONST;
  i_pubAuth  INT(10) OPTIONS(*NOPASS: *OMIT) CONST;
  o_msg      LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Closes an IFS file that was opened with the f_opnIfsFile-function.
DCL-PR f_closeIfsFile INT(10) EXTPROC('IFSR01_f_closeIfsFile');
  i_hFile LIKE(ifs_hFile_t) CONST;
  o_msg   LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Writes to an IFS file.
DCL-PR f_writeIfsFile INT(10) EXTPROC('IFSR01_f_writeIfsFile');
  i_hFile   LIKE(ifs_hFile_t) CONST;
  i_pBuffer POINTER OPTIONS(*STRING) CONST;
  i_length  INT(10) CONST;
  o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Writes line to an IFS file.
DCL-PR f_writeLineIfsFile INT(10) EXTPROC('IFSR01_f_writeLineIfsFile');
  i_hFile   LIKE(ifs_hFile_t) CONST;
  i_pBuffer POINTER OPTIONS(*STRING) CONST;
  i_length  INT(10) CONST;
  i_EOLChar LIKE(ifs_EOLChar_t) OPTIONS(*NOPASS: *OMIT) CONST;
  o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Reads from an IFS file.
DCL-PR f_readIfsFile INT(10) EXTPROC('IFSR01_f_readIfsFile');
  i_hFile   LIKE(ifs_hFile_t) CONST;
  o_pBuffer POINTER CONST;
  i_length  INT(10) CONST;
  o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Reads a line from an IFS file.
DCL-PR f_readLineIfsFile INT(10) EXTPROC('IFSR01_f_readLineIfsFile');
  i_hFile   LIKE(ifs_hFile_t) CONST;
  o_pBuffer POINTER CONST;
  i_length  INT(10) CONST;
  i_EOLChar LIKE(ifs_EOLChar_t) OPTIONS(*NOPASS: *OMIT) CONST;
  o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Moves an IFS file to a new location.
DCL-PR f_moveIfsFile INT(10) EXTPROC('IFSR01_f_moveIfsFile');
  i_fromFile LIKE(ifs_path_t) CONST;
  i_toPath   LIKE(ifs_path_t) CONST;
  o_msg      LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Renames a given IFS file.
DCL-PR f_renameIfsFile INT(10) EXTPROC('IFSR01_f_renameIfsFile');
  i_fromFile LIKE(ifs_path_t) CONST;
  i_toFile   LIKE(ifs_path_t) CONST;
  o_msg      LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Deletes an IFS file.
DCL-PR f_deleteIfsFile INT(10) EXTPROC('IFSR01_f_deleteIfsFile');
  i_path LIKE(ifs_path_t) CONST;
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Produces a unique temporary IFS file name.
DCL-PR f_getIfsTmpPath LIKE(ifs_path_t) EXTPROC('IFSR01_f_getIfsTmpPath');
  o_msg LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Gets the size on an IFS file.
DCL-PR f_getIfsFileSize INT(10) EXTPROC('IFSR01_f_getIfsFileSize');
  i_path LIKE(ifs_path_t) CONST;
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Gets the size on the IFS file specified by a given handle.
DCL-PR f_getIfsFileSizeH INT(10) EXTPROC('IFSR01_f_getIfsFileSizeH');
  i_hFile LIKE(ifs_hFile_t) CONST;
  o_msg   LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Returns the file ID that uniquely identifies a given file.
DCL-PR f_getIfsFileID LIKEDS(ifs_fileID_t) EXTPROC('IFSR01_f_getIfsFileID');
  i_path LIKE(ifs_path_t) CONST;
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Returns the file ID that uniquely identifies the file
//  specified by a given handle.
DCL-PR f_getIfsFileIDH LIKEDS(ifs_fileID_t) EXTPROC('IFSR01_f_getIfsFileIDH');
  i_hFile LIKE(ifs_hFile_t) CONST;
  o_msg   LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Gets the creation time of the IFS file.
DCL-PR f_getIfsFileCrtTime TIMESTAMP EXTPROC('IFSR01_f_getIfsFileCrtTime');
  i_path LIKE(ifs_path_t) CONST;
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Gets the time the IFS file data was last changed.
DCL-PR f_getIfsFileDataChgTime TIMESTAMP EXTPROC('IFSR01_f_getIfsFileDataChgTime');
  i_path LIKE(ifs_path_t) CONST;
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Changes the size on an IFS file.
DCL-PR f_chgIfsFileSize INT(10) EXTPROC('IFSR01_f_chgIfsFileSize');
  i_hFile   LIKE(ifs_hFile_t) CONST;
  i_newSize INT(10) CONST;
  o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Sets the read/write pointer to a new position.
DCL-PR f_seekIfsFile INT(10) EXTPROC('IFSR01_f_seekIfsFile');
  i_hFile  LIKE(ifs_hFile_t) CONST;
  i_offset INT(10) CONST;
  i_whence INT(10) CONST;
  o_msg    LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Reads entries of a given directory.
DCL-PR f_readIfsDir INT(10) EXTPROC('IFSR01_f_readIfsDir');
  i_path      LIKE(ifs_path_t) CONST;
  i_pCallback POINTER(*PROC) CONST;
  i_options   INT(10) OPTIONS(*NOPASS: *OMIT) CONST;
  i_pUserData POINTER OPTIONS(*NOPASS: *OMIT) CONST;
  o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Creates a new IFS directory. (deprecated)
DCL-PR f_crtIfsDir INT(10) EXTPROC('IFSR01_f_crtIfsDir');
  i_directory LIKE(ifs_path_t) CONST;
  i_options   INT(10) OPTIONS(*NOPASS: *OMIT) CONST;
  i_auth      INT(10) OPTIONS(*NOPASS: *OMIT) CONST;
  o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Deletes a given IFS directory.
DCL-PR f_dltIfsDir INT(10) EXTPROC('IFSR01_f_dltIfsDir');
  i_directory LIKE(ifs_path_t) CONST;
  i_options   INT(10) OPTIONS(*NOPASS: *OMIT) CONST;
  o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Returns cTrue if a given directory is empty, else cFalse.
DCL-PR f_isIfsDirEmpty IND EXTPROC('IFSR01_f_isIfsDirEmpty');
  i_dir LIKE(ifs_path_t) CONST;
  o_msg LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Returns the current working directory.
DCL-PR f_getIfsCurDir LIKE(ifs_path_t) EXTPROC('IFSR01_f_getIfsCurDir');
  o_msg LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

//  Changes the current working directory.
DCL-PR f_chgIfsCurDir INT(10) EXTPROC('IFSR01_f_chgIfsCurDir');
  i_dir LIKE(ifs_path_t) CONST;
  o_msg LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;

/ENDIF