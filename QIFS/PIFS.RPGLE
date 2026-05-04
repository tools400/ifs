 DEF  /IF NOT DEFINED(PIFS)
 DEF  /DEFINE PIFS
      *
      *  Constants
      /IF NOT DEFINED(cTrue)
      /DEFINE cTrue
     D cTrue           C                   const(*on )
      /ENDIF
      *
      /IF NOT DEFINED(cFalse)
      /DEFINE cFalse
     D cFalse          C                   const(*off)
      /ENDIF
      *
     D cIFS_ERROR...
     D                 C                   const(-1)
     D cIFS_EOF...
     D                 C                   const(-2)
      *
     D cIFS_EOL_CRLF...
     D                 C                   const(x'0D25')
     D cIFS_EOL_LF...
     D                 C                   const(x'25')
     D cIFS_EOL_CR...
     D                 C                   const(x'0D')
     D cIFS_EOL_ANY...
     D                 C                   const(x'00')
      *
     D cIFS_READDIR_DFT...
     D                 C                   const(7)                             x'00000007'
     D cIFS_READDIR_FILES...
     D                 C                   const(1)                             x'00000001'
     D cIFS_READDIR_DIR...
     D                 C                   const(2)                             x'00000002'
     D cIFS_READDIR_ALL...
     D                 C                   const(32)                            x'00000020'
     D cIFS_READDIR_CB_NAME...
     D                 C                   const(4)                             x'00000004'
     D cIFS_READDIR_CB_DIRENT...
     D                 C                   const(8)                             x'00000008'
     D cIFS_READDIR_SUBDIR...
     D                 C                   const(16)                            x'00000010'
     D cIFS_READDIR_PRE_ORDER...
     D                 C                   const(64)                            x'00000040'
     D cIFS_READDIR_POST_ORDER...
     D                 C                   const(128)                           x'00000080'
      *
     D cIFS_DIRENT_TYPE_FILE...
     D                 C                   const('*STMF')
     D cIFS_DIRENT_TYPE_DOCUMENT...
     D                 C                   const('*DOC')
     D cIFS_DIRENT_TYPE_DIRECTORY...
     D                 C                   const('*DIR')
     D cIFS_DIRENT_TYPE_FOLDER...
     D                 C                   const('*FLR')
      *
     D cIFS_MKDIR_DFT...
     D                 C                   const(0)                             x'00000000'
     D cIFS_MKDIR_RECURSION...
     D                 C                   const(1)                             x'00000001'
      *
     D cIFS_RMDIR_DFT...
     D                 C                   const(0)                             x'00000000'
     D cIFS_RMDIR_DELETE_FILES...
     D                 C                   const(1)                             x'00000001'
     D cIFS_RMDIR_DELETE_SUB_DIRECTORIES...
     D                 C                   const(16)                            x'00000010'
      *
      *  For testing purposes only!
     D cIFS_RMDIR_TEST_MODE...
     D                 C                   const(1073741824)                    x'40000000'
      *
      *  Callback Procedures
      *
     D f_readDirIfs_path...
     D                 PR              N   extproc('f_readDirIfs_path')
     D  i_level                      10I 0 value
     D  i_directory                        value  like(ifs_path_t    )
     D  i_entry                            value  like(ifs_path_t    )
     D  i_type                             value  like(ifs_type_t    )
     D  i_pUserData                    *   value
     D  o_msg                              value  like(msg_t         )
      *
     D f_readDirIfs_dirent...
     D                 PR              N   extproc('f_readDirIfs_dirent')
     D  i_level                      10I 0 value
     D  i_directory                        value  like(ifs_path_t    )
     D  i_dirent                           value  likeds(dirent_t    )
     D  i_type                             value  like(ifs_type_t    )
     D  i_pUserData                    *   value
     D  o_msg                              value  like(msg_t         )
      *
      *  Type definitions
     D ifs_path_t      S            256A   template
     D ifs_hFile_t     S             10I 0 template
     D ifs_EOLChar_t   S             32A   template  varying
     D ifs_type_t      S             10A   template
     D ifs_fileID_t    DS                  qualified               template
     D  ino                          10U 0
     D  dev                          20U 0
      *
      *  Imported prototypes
      /COPY QIFS,CLIB
      /COPY QIFS,CEELIB
      /COPY QBASICS1,PBASICS1
      *
      *  Checks, whether an IFS directory exists.
     D f_isIfsDir...
     D                 PR              N
     D                                     extproc('IFSR01+
     D                                     _f_isIfsDir+
     D                                     ')
     D i_path                              const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Checks, whether an IFS file exists.
     D f_isIfsFile...
     D                 PR              N
     D                                     extproc('IFSR01+
     D                                     _f_isIfsFile+
     D                                     ')
     D i_file                              const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Fixes a given IFS path name.
     D f_fixIfsPath...
     D                 PR                  like(ifs_path_t    )
     D                                     extproc('IFSR01+
     D                                     _f_fixIfsPath+
     D                                     ')
     D i_path                              const  like(ifs_path_t    )
      *
      *  Fixes a given IFS directory name.
     D f_fixIfsDir...
     D                 PR                  like(ifs_path_t    )
     D                                     extproc('IFSR01+
     D                                     _f_fixIfsDir+
     D                                     ')
     D i_dir                               const  like(ifs_path_t    )
      *
      *  Retrieves the file name from a given path name.
     D f_rtvIfsFileFromPath...
     D                 PR                  like(ifs_path_t    )
     D                                     extproc('IFSR01+
     D                                     _f_rtvIfsFileFromPath+
     D                                     ')
     D i_path                              const  like(ifs_path_t    )
      *
      *  Retrieves the directory name from a given path name.
     D f_rtvIfsDirFromPath...
     D                 PR                  like(ifs_path_t    )
     D                                     extproc('IFSR01+
     D                                     _f_rtvIfsDirFromPath+
     D                                     ')
     D i_path                              const  like(ifs_path_t    )
      *
      *  Retrieves the file extension from a given path name.
     D f_rtvIfsFileExtFromPath...
     D                 PR                         like(ifs_path_t    )
     D                                     extproc('IFSR01+
     D                                     _f_rtvIfsFileExtFromPath+
     D                                     ')
     D i_path                              const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Removes the extension from an IFS file name.
     D f_rmvIfsFileExtFromPath...
     D                 PR                         like(ifs_path_t    )
     D                                     extproc('IFSR01+
     D                                     _f_rmvIfsFileExtFromPath+
     D                                     ')
     D i_path                              const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Open an IFS file for text mode.
     D f_openIfsFile...
     D                 PR                  like(ifs_hFile_t   )
     D                                     extproc('IFSR01+
     D                                     _f_openIfsFile+
     D                                     ')
     D i_path                              const  like(ifs_path_t    )
     D i_opnFlags                    10I 0 const
     D i_codePage                    10I 0 const  options(*nopass: *omit)
     D i_pubAuth                     10I 0 const  options(*nopass: *omit)
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Closes an IFS file that was opened with the f_opnIfsFile-function.
     D f_closeIfsFile...
     D                 PR            10I 0
     D                                     extproc('IFSR01+
     D                                     _f_closeIfsFile+
     D                                     ')
     D i_hFile                             const  like(ifs_hFile_t   )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Writes to an IFS file.
     D f_writeIfsFile...
     D                 PR            10I 0
     D                                     extproc('IFSR01+
     D                                     _f_writeIfsFile+
     D                                     ')
     D i_hFile                             const  like(ifs_hFile_t   )
     D i_pBuffer                       *   const  options(*string)
     D i_length                      10I 0 const
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Writes line to an IFS file.
     D f_writeLineIfsFile...
     D                 PR            10I 0
     D                                     extproc('IFSR01+
     D                                     _f_writeLineIfsFile+
     D                                     ')
     D i_hFile                             const  like(ifs_hFile_t   )
     D i_pBuffer                       *   const  options(*string)
     D i_length                      10I 0 const
     D i_EOLChar                           const  like(ifs_EOLChar_t )
     D                                            options(*nopass: *omit)
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Reads from an IFS file.
     D f_readIfsFile...
     D                 PR            10I 0
     D                                     extproc('IFSR01+
     D                                     _f_readIfsFile+
     D                                     ')
     D i_hFile                             const  like(ifs_hFile_t   )
     D o_pBuffer                       *   const
     D i_length                      10I 0 const
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Reads a line from an IFS file.
     D f_readLineIfsFile...
     D                 PR            10I 0
     D                                     extproc('IFSR01+
     D                                     _f_readLineIfsFile+
     D                                     ')
     D i_hFile                             const  like(ifs_hFile_t   )
     D o_pBuffer                       *   const
     D i_length                      10I 0 const
     D i_EOLChar                           const  like(ifs_EOLChar_t )
     D                                            options(*nopass: *omit)
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Moves an IFS file to a new location.
     D f_moveIfsFile...
     D                 PR            10I 0
     D                                     extproc('IFSR01+
     D                                     _f_moveIfsFile+
     D                                     ')
     D i_fromFile                          const  like(ifs_path_t    )
     D i_toPath                            const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Renames a given IFS file.
     D f_renameIfsFile...
     D                 PR            10I 0
     D                                     extproc('IFSR01+
     D                                     _f_renameIfsFile+
     D                                     ')
     D i_fromFile                          const  like(ifs_path_t    )
     D i_toFile                            const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Deletes an IFS file.
     D f_deleteIfsFile...
     D                 PR            10I 0
     D                                     extproc('IFSR01+
     D                                     _f_deleteIfsFile+
     D                                     ')
     D i_path                              const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Produces a unique temporary IFS file name.
     D f_getIfsTmpPath...
     D                 PR                         like(ifs_path_t )
     D                                     extproc('IFSR01+
     D                                     _f_getIfsTmpPath+
     D                                     ')
     D o_msg                                      like(msg_t      )
     D                                            options(*nopass: *omit)
      *
      *  Gets the size on an IFS file.
     D f_getIfsFileSize...
     D                 PR            10I 0
     D                                     extproc('IFSR01+
     D                                     _f_getIfsFileSize+
     D                                     ')
     D i_path                              const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Gets the size on the IFS file specified by a given handle.
     D f_getIfsFileSizeH...
     D                 PR            10I 0
     D                                     extproc('IFSR01+
     D                                     _f_getIfsFileSizeH+
     D                                     ')
     D i_hFile                             const  like(ifs_hFile_t   )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Returns the file ID that uniquely identifies a given file.
     D f_getIfsFileID...
     D                 PR                         likeds(ifs_fileID_t)
     D                                     extproc('IFSR01+
     D                                     _f_getIfsFileID+
     D                                     ')
     D i_path                              const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Returns the file ID that uniquely identifies the file
      *  specified by a given handle.
     D f_getIfsFileIDH...
     D                 PR                         likeds(ifs_fileID_t)
     D                                     extproc('IFSR01+
     D                                     _f_getIfsFileIDH+
     D                                     ')
     D i_hFile                             const  like(ifs_hFile_t   )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Gets the creation time of the IFS file.
     D f_getIfsFileCrtTime...
     D                 PR              Z
     D                                     extproc('IFSR01+
     D                                     _f_getIfsFileCrtTime+
     D                                     ')
     D i_path                              const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Gets the time the IFS file data was last changed.
     D f_getIfsFileDataChgTime...
     D                 PR              Z
     D                                     extproc('IFSR01+
     D                                     _f_getIfsFileDataChgTime+
     D                                     ')
     D i_path                              const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Changes the size on an IFS file.
     D f_chgIfsFileSize...
     D                 PR            10I 0
     D                                     extproc('IFSR01+
     D                                     _f_chgIfsFileSize+
     D                                     ')
     D i_hFile                             const  like(ifs_hFile_t   )
     D i_newSize                     10I 0 const
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Sets the read/write pointer to a new position.
     D f_seekIfsFile...
     D                 PR            10I 0
     D                                     extproc('IFSR01+
     D                                     _f_seekIfsFile+
     D                                     ')
     D i_hFile                             const  like(ifs_hFile_t   )
     D i_offset                      10I 0 const
     D i_whence                      10I 0 const
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Reads entries of a given directory.
     D f_readIfsDir...
     D                 PR            10I 0
     D                                     extproc('IFSR01+
     D                                     _f_readIfsDir+
     D                                     ')
     D i_path                              const  like(ifs_path_t    )
     D i_pCallback                     *   const  procptr
     D i_options                     10I 0 const  options(*nopass: *omit)
     D i_pUserData                     *   const  options(*nopass: *omit)
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Creates a new IFS directory. (deprecated)
     D f_crtIfsDir...
     D                 PR            10I 0
     D                                     extproc('IFSR01+
     D                                     _f_crtIfsDir+
     D                                     ')
     D  i_directory                        const  like(ifs_path_t    )
     D  i_options                    10I 0 const  options(*nopass: *omit)
     D  i_auth                       10I 0 const  options(*nopass: *omit)
     D  o_msg                                     like(msg_t      )
     D                                            options(*nopass: *omit)
      *
      *  Deletes a given IFS directory.
     D f_dltIfsDir...
     D                 PR            10I 0
     D                                     extproc('IFSR01+
     D                                     _f_dltIfsDir+
     D                                     ')
     D  i_directory                        const  like(ifs_path_t    )
     D  i_options                    10I 0 const  options(*nopass: *omit)
     D  o_msg                                     like(msg_t      )
     D                                            options(*nopass: *omit)
      *
      *  Returns cTrue if a given directory is empty, else cFalse.
     D f_isIfsDirEmpty...
     D                 PR              N
     D                                     extproc('IFSR01+
     D                                     _f_isIfsDirEmpty+
     D                                     ')
     D i_dir                               const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Returns the current working directory.
     D f_getIfsCurDir...
     D                 PR                         like(ifs_path_t    )
     D                                     extproc('IFSR01+
     D                                     _f_getIfsCurDir+
     D                                     ')
     D  o_msg                                     like(msg_t      )
     D                                            options(*nopass: *omit)
      *
      *  Changes the current working directory.
     D f_chgIfsCurDir...
     D                 PR            10I 0
     D                                     extproc('IFSR01+
     D                                     _f_chgIfsCurDir+
     D                                     ')
     D  i_dir                              const  like(ifs_path_t    )
     D  o_msg                                     like(msg_t      )
     D                                            options(*nopass: *omit)
      *
 DEF  /ENDIF
