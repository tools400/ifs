**FREE
//=====================================================================*
//  IFSR01     - SrvPgm: IFS-Funktionen                                *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  15.03.2004                                              *
//  E-mail  :  thomas.raddatz@Tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//  01.02.2005  Th.Raddatz    Added procedure f_readLineIfsFile() to   *
//                            read a line from a streamfile.           *
//                                                                     *
//  01.02.2005  Th.Raddatz    Added procedure f_writeLineIfsFile() to  *
//                            write a line to a streamfile.            *
//                                                                     *
//  15.02.2005  Th.Raddatz    Added procedure f_readIfsDir() to        *
//                            read a directory.                        *
//                                                                     *
//  03.02.2005  Th.Raddatz    Added support for new open() flag        *
//                            O_CCSID.                                 *
//                                                                     *
//  08.02.2006  Th.Raddatz    Changed IFS to be compatible to V5R1.    *
//                                                                     *
//  24.02.2006  Th.Raddatz    Fixed problem that f_readLineIfsFile()   *
//                            did not return -1 in case of an error.   *
//                            Fixed problem that caller to             *
//                            f_readLineIfsFile() could not distinguish*
//                            betwenn EOF and an empty line returned.  *
//                            f_readLineIfsFile() now returns -2 in    *
//                            case of EOF.                             *
//                                                                     *
//  18.06.2006  Th.Raddatz    Fixed problem that caused an endless     *
//                            loop in f_renameIfsFile().               *
//                                                                     *
//  18.11.2006  Th.Raddatz    Added procedure f_getIfsFileCrtTime().   *
//                                                                     *
//  17.04.2008  Th.Raddatz    Added procedure                          *
//                            f_getIfsFileDataChgTime().               *
//                                                                     *
//  31.08.2008  Th.Raddatz    Now correctly producing the target       *
//                            file path from the source path           *
//                            and the target file name.                *
//                                                                     *
//  09.09.2008  Th.Raddatz    Moved g_hFile and g_path into data       *
//                            structure g_handleList.                  *
//                            Changed f_writeLineIfsFile() to append   *
//                            buffer data and end-of-line characters   *
//                            to the IFS file at once. (atomic write   *
//                            of data and EOL character.)              *
//                                                                     *
//  18.09.2008  Th.Raddatz    Added procedures: f_getIfsTmpPath()      *
//                                              f_crtIfsDir()          *
//                                                                     *
//  07.11.2008  Th.Raddatz    Added procedures: f_getIfsFileSizeH()    *
//                                              f_getIfsFileID()       *
//                                              f_getIfsFileIDH()      *
//                                                                     *
//  21.01.2009  Th.Raddatz    Added procedures: f_getIfsCurDir()       *
//                                              f_chgIfsCurDir()       *
//                                                                     *
//  28.01.2009  Th.Raddatz    Added procedures: f_dltIfsDir()          *
//                                                                     *
//  30.01.2009  Th.Raddatz    Added procedures: f_isIfsDirEmpty()      *
//                                                                     *
//  03.02.2009  Th.Raddatz    Fixed problem that f_readIfsDir() did    *
//                            not properly retrieve the file status    *
//                            information (stat()) if a file name      *
//                            had trailing blanks.                     *
//                                                                     *
//  18.09.2009  Th.Raddatz    Fixed compile problem in IFSTEST_09      *
//                            and added cIFS_RMDIR_DELETE_FILES to     *
//                            f_dltIfsDir().                           *
//                                                                     *
//  20.11.2010  Th.Raddatz    Fixed problem that O_CCSID flag was      *
//                            not removed from the open flags when     *
//                            re-opening a newly created file.         *
//                                                                     *
//  30.03.2012  Th.Raddatz    Added compiler directives to get a clean *
//                            compile on V5R1 systems.                 *
//                                                                     *
//  03.03.2017  Th.Raddatz    Added member COPYRIGHT.                  *
//                            Fixed compile error message RNF7597.     *
//                            Updated CEELIB and CLIB.                 *
//                                                                     *
//  08.12.2025  Th.Raddatz    Fix writing utf-8 files.                 *
//                                                                     *
// =================================================================== *
// >>PRE-COMPILER<<                                                    *
//   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                         *
//                           SRCFILE(&SL/&SF) SRCMBR(&SM);             *
//   >>COMPILE<<                                                       *
//     >>PARM<< DBGVIEW(*LIST);                                        *
//     >>PARM<< TRUNCNBR(*NO );                                        *
//     >>PARM<< TGTRLS(V7R3M0);                                        *
//     >>PARM<< OPTION(*EVENTF);                                       *
//   >>END-COMPILE<<                                                   *
//   >>EXECUTE<<                                                       *
// >>END-PRE-COMPILER<<                                                *
// =================================================================== *
CTL-OPT NOMAIN;
CTL-OPT DEBUG OPTION(*SRCSTMT: *NODEBUGIO);
CTL-OPT DECEDIT('0,') DATEDIT(*DMY.);
CTL-OPT DATFMT(*ISO) TIMFMT(*ISO);
CTL-OPT EXPROPTS(*RESDECPOS);
/COPY QIFS,COPYRIGHT
// =================================================================== *
//
//-------------------------------------------------------------------------
//  Exported functions and type definitions
//-------------------------------------------------------------------------
/COPY QIFS,PIFS

DCL-S ifs_pathV_t VARCHAR(256) TEMPLATE;

//-------------------------------------------------------------------------
//  Private prototypes
//-------------------------------------------------------------------------

//  Removes a given directory entry from the directory.
DCL-PR lf_removeDirectoryEntry IND EXTPROC('lf_removeDirectoryEntry');
  i_level     INT(10) VALUE;
  i_directory LIKE(ifs_path_t) VALUE;
  i_entry     LIKE(ifs_path_t) VALUE;
  i_type      LIKE(ifs_type_t) VALUE;
  i_pUserData POINTER VALUE;
  o_msg       LIKE(msg_t) VALUE;
END-PR;

//  Removes a given directory entry from the directory (test mode).
DCL-PR lf_removeDirectoryEntryTestMode IND EXTPROC('lf_removeDirectoryEntryTestMode');
  i_level     INT(10) VALUE;
  i_directory LIKE(ifs_path_t) VALUE;
  i_entry     LIKE(ifs_path_t) VALUE;
  i_type      LIKE(ifs_type_t) VALUE;
  i_pUserData POINTER VALUE;
  o_msg       LIKE(msg_t) VALUE;
END-PR;

//  Add entry to file handle table
DCL-PR lp_addEntryToFileHandleTable;
  i_hFile        LIKE(ifs_hFile_t) CONST;
  i_path         LIKE(ifs_path_t) CONST;
  i_useTmpBuffer IND CONST;
END-PR;

//  Get path from file handle
DCL-PR lf_getPathFromFileHandleTable LIKE(ifs_path_t);
  i_hFile LIKE(ifs_hFile_t) CONST;
END-PR;

//  Returns TRUE if f_writeLineIfsFile() must use a temporary
//  buffer, else FALSE
DCL-PR lf_useTmpBuffer IND;
  i_hFile LIKE(ifs_hFile_t) CONST;
END-PR;

//  Checks and reallocates size of temporary write buffer. Returns
//  buffer pointer.
DCL-PR lf_checkAndReallocateTmpBuffer POINTER;
  i_hFile   LIKE(ifs_hFile_t) CONST;
  i_newSize INT(10) CONST;
END-PR;

//  Returns the file handle table index for a given file handle.
DCL-PR lf_getFileHandleTableIndex INT(10);
  i_hFile LIKE(ifs_hFile_t) CONST;
END-PR;

//  Remove entry from file handle
DCL-PR lp_removeEntryFromFileHandleTable;
  i_hFile LIKE(ifs_hFile_t) CONST;
END-PR;

//  Convert Epoch timestamp to RPG timestamp
DCL-PR lf_cvtEpochTmStmpToRpgTmStmp TIMESTAMP;
  i_epochTmStmp INT(10) VALUE;
END-PR;

//  Creates a IFS message.
DCL-PR lf_newIfsMsg LIKEDS(msg_t);
  i_ID   LIKE(msg_t.id) OPTIONS(*OMIT: *NOPASS) CONST;
  i_data VARCHAR(512) OPTIONS(*OMIT: *NOPASS) CONST;
  i_type LIKE(msg_t.type) OPTIONS(*OMIT: *NOPASS) CONST;
END-PR;

//  Checks whether an IFS object is a file;
DCL-PR lf_isFile IND;
  i_st_stat LIKEDS(st_stat_t) CONST;
END-PR;

//  Checks whether an IFS object is a directory.
DCL-PR lf_isDir IND;
  i_st_stat LIKEDS(st_stat_t) CONST;
END-PR;

//  Checks whether an IFS object matches a given string pattern.
DCL-PR lf_isEntryEqual IND;
  i_entry   LIKE(ifs_path_t) VALUE;
  i_pattern LIKE(ifs_path_t) VALUE;
END-PR;

//  Initializes the path structure for the Qp0lGetAttr API.
DCL-PR lf_initializePath LIKE(ifs_path_t);
  i_path LIKEDS(Qlg_Path_Name_t) CONST;
END-PR;

//  Retrieves a file 'time' attribute.
DCL-PR lf_getIfsFileTimeAttr INT(10);
  i_path LIKE(ifs_path_t) CONST;
  i_attr INT(10) CONST;
  o_time TIMESTAMP;
END-PR;

/IF not defined(*V5R2M0)
DCL-PR lf_bitand UNS(10);
  i_arg1 UNS(10) VALUE;
  i_arg2 UNS(10) VALUE;
END-PR;

/ENDIF
//-------------------------------------------------------------------------
//  Global constants
//-------------------------------------------------------------------------
DCL-C cDELIMITER ':/\';
DCL-C cDFT_ASC_CODEPAGE 850;

DCL-C cSLASH '/';
DCL-C cBACKSLASH '\';
DCL-C cCOLON ':';

//-------------------------------------------------------------------------
//  Global fields
//-------------------------------------------------------------------------
DCL-S g_numHandles INT(10) INZ;
DCL-DS g_handleList QUALIFIED;
  hFile        LIKE(ifs_hFile_t) INZ DIM(100);
  useTmpBuffer IND INZ(cFalse) DIM(%elem(g_handleList.hFile));
  path         LIKE(ifs_path_t) INZ DIM(%elem(g_handleList.hFile));
END-DS;

DCL-DS g_tempBuffer QUALIFIED;
  pData POINTER INZ;
  size  INT(10) INZ;
END-DS;

DCL-C cBUFFER_SIZE 8196;

//=========================================================================
//  Checks, whether an IFS directory exists.
//=========================================================================
//  Parameters:
//   i_path        - The name of an IFS directory.
//
//  Returns:
//   doesExist     - Returns TRUE if the directory exists, else FALSE.
//=========================================================================
DCL-PROC f_isIfsDir EXPORT;
  DCL-PI *N IND;
    i_path LIKE(ifs_path_t) CONST;
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S doesExist IND INZ(cFalse);

  //  Parameter positions
  DCL-C p_isMsg 2;

  //  Local fields
  DCL-S isPresent INT(10) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  stat() result data structure
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;

/COPY QIFS,IFS1011
/COPY QIFS,IFS1015
  // ---------------------------------------------------------

  // If the input path could not be found, ...
if   stat(%trim(i_path): %addr(st_stat)) = RC_ERROR;
  // ... then set the error flag
   doesExist = cFalse;
else;
  // ... else check whether it is a directory or not.
   if   lf_isDir(st_stat);
      doesExist = cTrue;
   else;
      doesExist = cFalse;
   endif;
endif;

  // If the directory does not exist, ...
if not doesExist;
  // ... then create message 'directory not found'
   clear      IFS1011;
   IFS10111 = '';
   IFS10112 = %trim(i_path);
   msg      = lf_newIfsMsg('IFS1011': IFS1011);
else;
  // ... then create message 'directory exists'
   clear      IFS1015;
   IFS10151 = '';
   IFS10152 = %trim(i_path);
   msg      = lf_newIfsMsg('IFS1015': IFS1015);
endif;

  // Set message type to *INFO
msg.type = cMsg_Info;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
endif;

return    doesExist;


END-PROC;

//=========================================================================
//  Checks, whether an IFS file exists.
//=========================================================================
//  Parameters:
//   i_file        - The name of an IFS file.
//
//  Returns:
//   doesExist     - Returns TRUE if the file exists, else FALSE.
//=========================================================================
DCL-PROC f_isIfsFile EXPORT;
  DCL-PI *N IND;
    i_file LIKE(ifs_path_t) CONST;
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S doesExist IND INZ(cFalse);

  //  Parameter positions
  DCL-C p_isMsg 2;

  //  Local fields
  DCL-S isPresent INT(10) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  stat() result data structure
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;

/COPY QIFS,IFS1012
/COPY QIFS,IFS1013
  // ---------------------------------------------------------

  // If the input file does not exist, ...
if   stat(%trim(i_file): %addr(st_stat)) = RC_ERROR;
  // ... then create error message
   doesExist = cFalse;
else;
  // ... else check whether it is a file or not.
   if   lf_isFile(st_stat);
      doesExist = cTrue;
   else;
      doesExist = cFalse;
   endif;
endif;

  // If the file does not exist, ...
if not doesExist;
  // ... then create message 'file not found'
   clear      IFS1012;
   IFS10121 = '';
   IFS10122 = %trim(i_file);
   msg      = lf_newIfsMsg('IFS1012': IFS1012);
else;
  // ... then create message 'file exists'
   clear      IFS1013;
   IFS10131 = '';
   IFS10132 = %trim(i_file);
   msg      = lf_newIfsMsg('IFS1013': IFS1013);
endif;

  // Set message type to *INFO
msg.type = cMsg_Info;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
endif;

return    doesExist;


END-PROC;

//=========================================================================
//  Fixes a given IFS path name.
//  (Hint:   path = directory + file)
//=========================================================================
//  Parameters:
//   i_path        - A given IFS path name.
//
//  Returns:
//   path          - The fixed IFS path name.
//=========================================================================
DCL-PROC f_fixIfsPath EXPORT;
  DCL-PI *N LIKE(ifs_path_t);
    i_path LIKE(ifs_path_t) CONST;
  END-PI;

  //  Return value
  DCL-S path LIKE(ifs_path_t) INZ;
  // ---------------------------------------------------------

  // Trim input path
path = %trim(i_path);

  // If no path was specified, ...
if   path = '';
  // ... then return to caller
   return   path;
endif;

  // Translate backslashes ('\') to slashes ('/')
path = %xlate(cBACKSLASH: cSLASH: path);

return    path;


END-PROC;

//=========================================================================
//  Fixes a given IFS directory name.
//  (Hint:   path = directory + file)
//=========================================================================
//  Parameters:
//   i_dir         - A given IFS directory name.
//
//  Returns:
//   dir           - The fixed IFS directory name.
//=========================================================================
DCL-PROC f_fixIfsDir EXPORT;
  DCL-PI *N LIKE(ifs_path_t);
    i_dir LIKE(ifs_path_t) CONST;
  END-PI;

  //  Return value
  DCL-S dir LIKE(ifs_path_t) INZ;
  // ---------------------------------------------------------

  // Trim input directory name
dir = %trim(i_dir);

  // If no directory was specified, ...
if   dir = '';
  // ... then return to caller
   return   dir;
endif;

  // Translate backslashes ('\') to slashes ('/')
dir = %xlate(cBACKSLASH: cSLASH: dir);

  // Append missing slash
if   %subst(dir: %len(%trimr(dir)): 1) <> cSLASH;
   dir = %trimr(dir) + cSLASH;
endif;

return    dir;


END-PROC;

//=========================================================================
//  Retrieves the file name from a given path name.
//=========================================================================
//  Attention: The f_rtvIfsFileFromPath-function must also be able to
//             retrieve the file name from pathes starting with 'http://'
//             or 'ftp://'. Please consider that, when changing the
//             f_rtvIfsFileFromPath-function.
//=========================================================================
//  Parameters:
//   i_path        - A given IFS path name.
//
//  Returns:
//   file          - The file name portion of the path.
//=========================================================================
DCL-PROC f_rtvIfsFileFromPath EXPORT;
  DCL-PI *N LIKE(ifs_path_t);
    i_path LIKE(ifs_path_t) CONST;
  END-PI;

  //  Return value
  DCL-S file LIKE(ifs_path_t) INZ;

  //  Local fields
  DCL-S pToken POINTER INZ;
  DCL-S token LIKE(file) INZ;
  // ---------------------------------------------------------

  // If the path ends with / or \, ...
if   (f_right(%trimr(i_path): 1) = cSLASH) or
     (f_right(%trimr(i_path): 1) = cBACKSLASH);
  // ... then it does not contain a file name
   file = '';
else;
  // ... else search for the last token of the path
   pToken = strtok(i_path: cDELIMITER);
   dow   pToken <> *NULL;
      token  = %str(pToken);
      pToken = strtok(*NULL: cDELIMITER);
   enddo;

   file = token;
endif;

return    file;


END-PROC;

//=========================================================================
//  Retrieves the directory name from a given path name.
//=========================================================================
//  Attention: The f_rtvIfsDirFromPath-function must also be able to
//             retrieve the directory name from pathes starting with 'http://'
//             or 'ftp://'. Please consider that, when changing the
//             f_rtvIfsDirFromPath-function.
//=========================================================================
//  Parameters:
//   i_path        - A given IFS path name.
//
//  Returns:
//   directory     - The directory name portion of the path.
//=========================================================================
DCL-PROC f_rtvIfsDirFromPath EXPORT;
  DCL-PI *N LIKE(ifs_path_t);
    i_path LIKE(ifs_path_t) CONST;
  END-PI;

  //  Return value
  DCL-S directory LIKE(ifs_path_t) INZ;

  //  Local fields
  DCL-S pathLength INT(10) INZ;
  DCL-S dirLength INT(10) INZ;
  DCL-S x INT(10) INZ;
  DCL-S y INT(10) INZ;
  // ---------------------------------------------------------

  // If the path ends with / or \, ...
if   (f_right(%trimr(i_path): 1) = cSLASH) or
     (f_right(%trimr(i_path): 1) = cBACKSLASH);
  // ... then it does not contain an file name
  //     and therefore the directory name is equal
  //     to the path  name.
   directory = i_path;
else;
  // ... else search for the last token of the path
   pathLength = %len(%trimR(i_path));
   dirLength  = 0;
   for   x = 1 to pathLength;
      y = %scan(%subst(i_path: x: 1): cDELIMITER);
      if   y > 0;
         dirLength = x;
      endif;
   endfor;

  // retrieve the directory protion of the path
   if   dirLength > 0;
      directory = %subst(i_path: 1: dirLength);
   endif;
endif;

return    directory;


END-PROC;

//=========================================================================
//  Retrieves the extension of an IFS file name.
//=========================================================================
//  Parameters:
//   i_path        - The path name of a given IFS file.
//   o_msg         - Error message.
//
//  Returns:
//   extension     - Returns the extension of the file name.
//=========================================================================
DCL-PROC f_rtvIfsFileExtFromPath EXPORT;
  DCL-PI *N LIKE(ifs_path_t);
    i_path LIKE(ifs_path_t) CONST;
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S extension LIKE(ifs_path_t) INZ;

  //  Parameter positions
  DCL-C p_isMsg 2;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;
  DCL-S file LIKE(ifs_path_t) INZ;
  DCL-S length INT(10) INZ;
  // ---------------------------------------------------------

file   = f_rtvIfsFileFromPath(i_path);
length = %len(%trimR(file)) - 1;   // There must be at least one character
  // beyond the dot "."

dow length >= 1;

   if (%subst(file: length: 1) = '.');
      extension = %subst(file: length + 1);
      leave;
   endif;

   length = length - 1;
enddo;

msg = lf_newIfsMsg(cMsg_ID_OK);

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return    extension;


END-PROC;

//=========================================================================
//  Removes the extension from an IFS file name.
//=========================================================================
//  Parameters:
//   i_path        - The path name of a given IFS file.
//   o_msg         - Error message.
//
//  Returns:
//   path          - The file name without the extension.
//=========================================================================
DCL-PROC f_rmvIfsFileExtFromPath EXPORT;
  DCL-PI *N LIKE(ifs_path_t);
    i_path LIKE(ifs_path_t) CONST;
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S path_wo_ext LIKE(ifs_path_t) INZ;

  //  Parameter positions
  DCL-C p_isMsg 2;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;
  DCL-S isFound IND INZ(cFalse);
  DCL-S length INT(10) INZ;
  // ---------------------------------------------------------

length = %len(%trimR(i_path));

dow length >= 2;   // There must be at least one character left
  // before the dot "."

   if (%subst(i_path: length: 1) = cSLASH) or
      (%subst(i_path: length: 1) = cBACKSLASH);
      leave;
   endif;

   if (%subst(i_path: length: 1) = '.');
      path_wo_ext = %subst(i_path: 1: length - 1);
      isFound = cTrue;
      leave;
   endif;

   length = length - 1;
enddo;

if not isFound;
   path_wo_ext = i_path;
endif;

msg = lf_newIfsMsg(cMsg_ID_OK);

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return    path_wo_ext;


END-PROC;

//=========================================================================
//  Open an IFS file for text mode.
//=========================================================================
//  Parameters:
//   i_path        - A given IFS path name.
//   i_opnFlags    - O_CREAT        If the file being opened does not exist,
//                                  create it.
//                   O_EXCL         Send error message if file exists and
//                                  O_CREAT was specified.
//                   O_TRUNC        Truncate the file to zero length.
//                   O_APPEND       Position the file offset at the end of
//                                  the file before each write operation.
//                   O_CODEPAGE     The call to open has a codepage argument.
//                                  This flag cannot be specified with the
//                                  O_CCSID flag.
//                   O_TEXTDATA     The data is processed as text.
//                   O_INHERITMODE  Create the file with the same data
//                                  authorities as the parent file.
//                   O_CCSID        Text conversions between any two CCSIDs
//                                  supported by the iconv() API can be performed.
//                                  This flag cannot be specified with the
//                                  O_CODEPAGE flag.
//
//                   O_SHARE_RDONLY Share with readers only.
//                   O_SHARE_WRONLY Share with writers only.
//                   O_SHARE_RDWR   Share with readers and writers.
//                   O_SHARE_NONE   Share with neither readers nor writers.
//
//                   O_RDONLY       Open for reading only.
//                   O_WRONLY       Open for writing only.
//                   O_RDWR         Open for both reading and writing.
//
//   i_codePage    - When the O_CODEPAGE flag is specified, i_codepage
//                   must contain the codepage of the new file.
//                   When the O_CCSID flag is specified, i_codepage
//                   must contain the CCSID of the new file.
//   i_auth        - S_IRUSR        Owner has read authority.
//                   S_IWUSR        Owner has write authority.
//                   S_IXUSR        Owner has execute/search authority.
//                   S_IRWXU        Owner has all authorities.
//
//                   S_IRGRP        Group has read authority.
//                   S_IWGRP        Group has write authority.
//                   S_IXGRP        Group has execute/search authority.
//                   S_IRWXG        Group has all authorities.
//
//                   S_IROTH        Public has read authority.
//                   S_IWOTH        Public has write authority.
//                   S_IXOTH        Public has execute/search authority.
//                   S_IRWXO        Public has all authorities.
//   o_msg         - Error message.
//
//  Returns:
//   hFile         - The handle of the open file.
//=========================================================================
DCL-PROC f_openIfsFile EXPORT;
  DCL-PI *N LIKE(ifs_hFile_t);
    i_path     LIKE(ifs_path_t) CONST;
    i_opnFlags INT(10) CONST;
    i_codePage INT(10) OPTIONS(*NOPASS: *OMIT) CONST;
    i_auth     INT(10) OPTIONS(*NOPASS: *OMIT) CONST;
    o_msg      LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S hFile LIKE(ifs_hFile_t) INZ;

  //  Parameter positions
  DCL-C p_isCodePage 3;
  DCL-C p_isAuth 4;
  DCL-C p_isMsg 5;

  //  Fields for optional parameters
  DCL-S codePage LIKE(i_codePage) INZ;
  DCL-S auth LIKE(i_auth) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;
  DCL-S opnFlags LIKE(i_opnFlags) INZ;
  DCL-S doesExist IND INZ(cFalse);
  DCL-S useTmpBuffer IND INZ(cFalse);

/COPY QIFS,IFS1000
  // ---------------------------------------------------------

  // Process optional parameters ...
  // ... i_codePage
if (%parms() >= p_isCodePage);
   CEETSTA(isPresent: p_isCodePage: *omit);
else;
   isPresent = 0;
endif;

if (isPresent = 1);
   codePage = i_codePage;
else;
   codePage = cDFT_ASC_CODEPAGE;
endif;

  // ... i_auth
if (%parms() >= p_isAuth);
   CEETSTA(isPresent: p_isAuth: *omit);
else;
   isPresent = 0;
endif;

if (isPresent = 1);
   auth = i_auth;
else;
   auth = S_IRWXU + S_IRWXG + S_IRWXO;  // *PUBLIC = *ALL
endif;

  // Check file existance
doesExist = f_isIfsFile(%trimr(i_path): *omit);

  // Set open flags
opnFlags = i_opnFlags;

  // If O_CODEPAGE and O_CCSID are not specified ...
if (not f_isBitOn(O_CODEPAGE: opnFlags) and
    not f_isBitOn(O_CCSID: opnFlags));
  // ... and the file does not exists
   if (not doesExist);
  // ... then set O_CODEPAGE
      opnFlags = opnFlags + O_CODEPAGE;
   endif;
else;
  // ... else if the file already exists
   if (doesExist);
  // ... then remove O_CODEPAGE or O_CCSID
      select;
      when (f_isBitOn(O_CODEPAGE: opnFlags));
         opnFlags = opnFlags - O_CODEPAGE;
      when (f_isBitOn(O_CCSID: opnFlags));
         opnFlags = opnFlags - O_CCSID;
      endsl;
   endif;
endif;

  // Open the file
if (f_isBitOn(O_TEXT_CREAT: opnFlags));
   if (not f_isBitOn(O_CCSID: opnFlags));
      opnFlags = opnFlags + O_CCSID;
   endif;
   hFile = open(%trimr(i_path): opnFlags: auth: codePage: 0);
else;
   hFile = open(%trimr(i_path): opnFlags: auth: codePage);

  // If the file was just created ...
   if (hFile <> RC_ERROR) and (not doesExist);
  // ... then re-open the file to let the operating system
  //     do the codepage conversion.
      if (close(hFile) = RC_ERROR);
         hFile = RC_ERROR;
      else;
  // Remove O_CODEPAGE or O_CCSID flag
         select;
         when (f_isBitOn(O_CODEPAGE: opnFlags));
            opnFlags = opnFlags - O_CODEPAGE;
         when (f_isBitOn(O_CCSID   : opnFlags));
            opnFlags = opnFlags - O_CCSID;
         endsl;
  // Remove the O_CREAT flag
         if   f_isBitOn(O_CREAT: opnFlags);
            opnFlags = opnFlags - O_CREAT;
         endif;
  // Re-open the file
         hFile = open(%trimr(i_path): opnFlags);
      endif;
   endif;
endif;

  // In case on an open error ...
if (hFile = RC_ERROR);
  // ... create error message
   clear   IFS1000;
   IFS10001 = '';
   IFS10002 = i_path;
   IFS10003 = f_errno;
   IFS10004 = f_strerror(f_errno);
   msg = lf_newIfsMsg('IFS1000': IFS1000);
else;
  // ... else store the path in the file handle table
   useTmpBuffer = (f_isBitOn(O_SHARE_WRONLY: opnFlags) or
                   f_isBitOn(O_SHARE_RDWR  : opnFlags)) and
                  (f_isBitOn(O_WRONLY: opnFlags) or
                   f_isBitOn(O_RDWR  : opnFlags));
   lp_addEntryToFileHandleTable(hFile: %trim(i_path): useTmpBuffer);
  // clear error message
   msg = lf_newIfsMsg(cMsg_ID_OK);
endif;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return    hFile;


END-PROC;

//=========================================================================
//  Closes an IFS file that was opened with the f_openIfsFile-function.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file opened by f_openIfsFile().
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
DCL-PROC f_closeIfsFile EXPORT;
  DCL-PI *N INT(10);
    i_hFile LIKE(ifs_hFile_t) CONST;
    o_msg   LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S rc INT(10) INZ;

  //  Parameter positions
  DCL-C p_isMsg 2;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;

/COPY QIFS,IFS1001
  // ---------------------------------------------------------

  // Close file
rc = close(i_hFile);

  // If we got an error
if   rc = RC_ERROR;
  // ... then create error message
   clear   IFS1001;
   IFS10011 = '';
   IFS10012 = lf_getPathFromFileHandleTable(i_hFile);
   IFS10013 = f_errno;
   IFS10014 = f_strerror(f_errno);
   msg = lf_newIfsMsg('IFS1001': IFS1001);
else;
  // ... else remove entry from handle
   lp_removeEntryFromFileHandleTable(i_hFile);
  // clear message
   msg = lf_newIfsMsg(cMsg_ID_OK);
endif;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return    rc;


END-PROC;

//=========================================================================
//  Writes to an IFS file.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file opened by f_openIfsFile().
//   i_pBuffer     - A pointer to the data to write to the IFS file.
//   i_length      - The length of the data or 0 is the data is a
//                   null-terminated string.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns the number of bytes that were written to
//                   the IFS file or -1.
//=========================================================================
DCL-PROC f_writeIfsFile EXPORT;
  DCL-PI *N INT(10);
    i_hFile   LIKE(ifs_hFile_t) CONST;
    i_pBuffer POINTER OPTIONS(*STRING) CONST;
    i_length  INT(10) CONST;
    o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S bytesWritten INT(10) INZ;

  //  Parameter positions
  DCL-C p_isMsg 4;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;
  DCL-S length INT(10) INZ;

/COPY QIFS,IFS1002
  // ---------------------------------------------------------

  // Get the buffer length if the length is specified as -1
if   i_length = 0;
   length = strlen(i_pBuffer);
else;
   length = i_length;
endif;

  // Write data to IFS file
bytesWritten = write(i_hFile: i_pBuffer: length);

  // If we got an error
if   bytesWritten = RC_ERROR;
  // ... then create error message
   clear   IFS1002;
   IFS10021 = '';
   IFS10022 = lf_getPathFromFileHandleTable(i_hFile);
   IFS10023 = f_errno;
   IFS10024 = f_strerror(f_errno);
   msg = lf_newIfsMsg('IFS1002': IFS1002);
else;
  // clear message
   msg = lf_newIfsMsg(cMsg_ID_OK);
endif;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return    bytesWritten;


END-PROC;

//=========================================================================
//  Writes a line to an IFS file.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file opened by f_openIfsFile().
//   i_pBuffer     - A pointer to the data to write to the IFS file.
//   i_length      - The length of the data or 0 is the data is a
//                   null-terminated string.
//   i_EOLChar     - End-Of-Line character string.
//                   Default:        cIFS_EOL_CRLF
//                   cIFS_EOL_CRLF - Ascii 0D+0A, typically used
//                                   by DOS and Windows systems.
//                   cIFS_EOL_LF   - Ascii 0A, typically used
//                                   by Unix systems.
//                   cIFS_EOL_CR   - Ascii 0D, typically used
//                                   by Mac systems.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns the number of bytes that were written to
//                   the IFS file or -1.
//
//  Comments:
//   A line is considered as a series of bytes terminated by an
//   End-Of-Line character. The EOL-character must not be included in
//   the buffer addressed by i_pBuffer. It is automatically added.
//   By default the f_writeLineIfsFile() procedure uses CR+LF as
//   the EOL-characters. Since DOS/Windows, Unix and Mac uses different
//   EOL-characters, the EOL-character to be use can be specified at
//   i_EOLChar.
//   Notice that beside the predefined constants you can use any other
//   character or character string up to 32 byte as the EOL-character.
//
//  Hint:
//   Usually f_writeLineIfsFile() uses separate write operation to
//   write the data and the end-of-line characters to the file. If
//   a file is shared with other writers, data and EOL characters
//   have to be written in a single, atomic operation. Otherwise
//   the output data can get mixed up with the data of other writers.
//   In those cases f_writeLineIfsFile() uses a temporary buffer to
//   ensure that the data and the EOL characters are written at once.
//   Of course that reduces performance.
//   In order to gain better performance you may add the EOL characters
//   manually before calling f_writeLineIfsFile(). In that case specify
//   and empty string for the EOL characters at f_writeLineIfsFile().
//
//   Sample:
//
//     data = 'Hello World' + cIFS_EOL_CRLF;
//     f_writeLineIfsFile(hFile
//                        : %addr(data)
//                        : %len(data)
//                        : ''
//                        : msg);
//
//=========================================================================
DCL-PROC f_writeLineIfsFile EXPORT;
  DCL-PI *N INT(10);
    i_hFile   LIKE(ifs_hFile_t) CONST;
    i_pBuffer POINTER OPTIONS(*STRING) CONST;
    i_length  INT(10) CONST;
    i_EOLChar LIKE(ifs_EOLChar_t) OPTIONS(*NOPASS: *OMIT) CONST;
    o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S bytesWritten INT(10) INZ;

  //  Parameter positions
  DCL-C p_isEOLChar 4;
  DCL-C p_isMsg 5;

  //  Fields for optional parameters
  DCL-S eolChar LIKE(i_EOLChar) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;
  DCL-S length INT(10) INZ;
  DCL-S startPos INT(10) INZ;
  DCL-S numBytes INT(10) INZ;
  DCL-S newSize INT(10) INZ;
  DCL-S byteBuffer CHAR(32) BASED(pByteBuffer);
  DCL-S pBuffer POINTER INZ;
  DCL-S x INT(10) INZ;
  // ---------------------------------------------------------

  // Get optional parameters ...
  // ... EOL-character (string)
if   %parms() >= p_isEOLChar;
   CEETSTA(isPresent: p_isEOLChar: *omit);
else;
   isPresent = 0;
endif;

if   isPresent = 1;
   EOLChar = i_EOLChar;
else;
   EOLChar = cIFS_EOL_CRLF;
endif;

  // Get the buffer length if the length is specified as 0
if   i_length = 0;
   length = strlen(i_pBuffer);
else;
   length = i_length;
endif;

  // Use temporary buffer when file is shared with other writers
if (%len(EOLChar) > 0 and lf_useTmpBuffer(i_hFile));

  // Check buffer size, reallocate buffer if necessary
   newSize = length + %len(EOLChar);
   pBuffer = lf_checkAndReallocateTmpBuffer(i_hFile: newSize);

  // Copy input buffer to temporary write buffer
   memcpy(pBuffer: i_pBuffer: length);

  // Add EOL-character (string)
   pByteBuffer = pBuffer + length;
   %subst(byteBuffer: 1: %len(EOLChar)) = EOLChar;

  // Adjust length of buffer
   length = newSize;

  // Clear EOL characters to avoid that they are appended twice
   EOLChar = '';

endif;

  // Write data to IFS file
if (pBuffer <> *NULL);
   bytesWritten = f_writeIfsFile(i_hFile: pBuffer: length: msg);
else;
   bytesWritten = f_writeIfsFile(i_hFile: i_pBuffer: length: msg);
endif;

  // Add EOL-character (string)
if (EOLChar <> '' and msg.ID = cMSG_ID_OK);
   numBytes = f_writeIfsFile(i_hFile: EOLChar: %len(EOLChar): msg);
endif;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return    bytesWritten;


END-PROC;

//=========================================================================
//  Reads from an IFS file.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file opened by f_openIfsFile().
//   i_pBuffer     - A pointer to the input data.
//   i_length      - The length of the buffer.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns the number of bytes that were red from
//                   the IFS file or -1.
//=========================================================================
DCL-PROC f_readIfsFile EXPORT;
  DCL-PI *N INT(10);
    i_hFile   LIKE(ifs_hFile_t) CONST;
    i_pBuffer POINTER CONST;
    i_length  INT(10) CONST;
    o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S bytesRed INT(10) INZ;

  //  Parameter positions
  DCL-C p_isMsg 4;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;

/COPY QIFS,IFS1004
  // ---------------------------------------------------------

  // Read data from the IFS file
bytesRed = read(i_hFile: i_pBuffer: i_length);

  // If we got an error ...
if   bytesRed = RC_ERROR;
  // ... then create error message
   clear   IFS1004;
   IFS10041 = '';
   IFS10042 = lf_getPathFromFileHandleTable(i_hFile);
   IFS10043 = f_errno;
   IFS10044 = f_strerror(f_errno);
   msg = lf_newIfsMsg('IFS1004': IFS1004);
else;
  // clear message
   msg = lf_newIfsMsg(cMsg_ID_OK);
endif;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return    bytesRed;


END-PROC;

//=========================================================================
//  Reads a line from an IFS file.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file opened by f_openIfsFile().
//   i_pBuffer     - A pointer to the input data.
//   i_length      - The length of the buffer.
//   i_EOLChar     - End-Of-Line character string.
//                   Default:        cIFS_EOL_CRLF
//                   cIFS_EOL_CRLF - Ascii 0D+0A, typically used
//                                   by DOS and Windows systems.
//                   cIFS_EOL_LF   - Ascii 0A, typically used
//                                   by Unix systems.
//                   cIFS_EOL_CR   - Ascii 0D, typically used
//                                   by Mac systems.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns the number of bytes that were red from
//                   the IFS file or cIFS_ERROR. Returns cIFS_EOL
//                   in case of EOF.
//
//  Comments:
//   A line is considered as a series of bytes terminated by an
//   End-Of-Line character. The EOL-character is not added to the
//   buffer addressed by i_pBuffer.
//   By default der f_readLineIfsFile() procedure uses CR+LF as
//   the EOL-characters. Since DOS/Windows, Unix and Mac uses different
//   EOL-characters, the EOL-character to be use can be specified at
//   i_EOLChar.
//   Notice that beside the predefined constants you can use any other
//   character or character string up to 32 byte as the EOL-character.
//
//=========================================================================
DCL-PROC f_readLineIfsFile EXPORT;
  DCL-PI *N INT(10);
    i_hFile   LIKE(ifs_hFile_t) CONST;
    i_pBuffer POINTER CONST;
    i_length  INT(10) CONST;
    i_EOLChar LIKE(ifs_EOLChar_t) OPTIONS(*NOPASS: *OMIT) CONST;
    o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S bytesRed INT(10) INZ;

  //  Parameter positions
  DCL-C p_isEOLChar 4;
  DCL-C p_isMsg 5;

  //  Fields for optional parameters
  DCL-S eolChar LIKE(i_EOLChar) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;
  DCL-S numBytes INT(10) INZ;
  DCL-S a1ByteBuffer CHAR(1) INZ;
  DCL-S EOLBuffer LIKE(ifs_EOLChar_t) INZ;
  DCL-S ofsOutBuffer LIKE(i_length) INZ(0);

/COPY QIFS,IFS1016
  // ---------------------------------------------------------

  // Get optional parameters ...
  // ... EOL-character (string)
if   %parms() >= p_isEOLChar;
   CEETSTA(isPresent: p_isEOLChar: *omit);
else;
   isPresent = 0;
endif;

if   isPresent = 1;
   EOLChar = i_EOLChar;
else;
   EOLChar = cIFS_EOL_CRLF;
endif;

  // Read until EOL-charcater
dou   EOLbuffer = EOLChar;

  // Check the number of bytes red against the
  // remaining length of the output buffer
   if   numBytes > (i_length - ofsOutBuffer);
  // ... then create error message
      clear   IFS1016;
      IFS10161 = '';
      IFS10162 = lf_getPathFromFileHandleTable(i_hFile);
      IFS10163 = i_length;
      msg = lf_newIfsMsg('IFS1016': IFS1016);
      leave;
   endif;

  // Add bytes red to output buffer
   if   numBytes > 0;
      memcpy(i_pBuffer + ofsOutBuffer: %addr(a1ByteBuffer): numBytes);
      ofsOutBuffer = ofsOutBuffer + 1;
      bytesRed     = bytesRed + numBytes;
   endif;

  // Read data from the IFS file
   numBytes = f_readIfsFile(i_hFile: %addr(a1ByteBuffer): 1: msg);

  // If we got an error ...
   if   msg.ID <> cMSG_ID_OK;
  // ... return error message
      bytesRed = -1;
      leave;
   endif;

  // If we reached EOF ...
   if   numBytes = 0;
  // ... cancel loop
      if bytesRed = 0;
         bytesRed = -2;
      endif;
      leave;
   endif;

  // Append the byte we just red to the EOL buffer
  // in case the byte red matches the next byte we
  // expect:
   if   a1ByteBuffer = %subst(EOLChar: %len(EOLBuffer) + 1: 1);
      EOLBuffer = EOLBuffer + a1ByteBuffer;
   else;
      EOLBuffer = '';
   endif;

enddo;

  // Strip the EOL-character (string) from the outbut buffer
  // in case we left the loop due to EOL condition:
  // (Remind that the last byte of the EOL-character was
  //  not yet added to the output buffer!)
if   EOLbuffer = EOLChar;
   bytesRed = bytesRed - (%len(EOLChar) - 1);
endif;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return    bytesRed;


END-PROC;

//=========================================================================
//  Moves an IFS file to a new location.
//=========================================================================
//  Parameters:
//   i_fromFile    - The path name of a given IFS file.
//   i_toPath      - The name of the target directory.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
DCL-PROC f_moveIfsFile EXPORT;
  DCL-PI *N INT(10);
    i_fromFile LIKE(ifs_path_t) CONST;
    i_toPath   LIKE(ifs_path_t) CONST;
    o_msg      LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S rc INT(10) INZ;

  //  Parameter positions
  DCL-C p_isMsg 3;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;
  DCL-S toPath LIKE(i_toPath) INZ;

/COPY QIFS,IFS1003
/COPY QIFS,IFS1011
/COPY QIFS,IFS1012
  // ---------------------------------------------------------

msg = lf_newIfsMsg(cMsg_ID_OK);
rc = RC_OK;

dou   rc = RC_ERROR;

  // If the file does not exist, ...
   if   not f_isIfsFile(%trim(i_fromFile): *omit);
  // ... then create an error message
      rc = RC_ERROR;
      clear      IFS1012;
      IFS10121 = '';
      IFS10122 = %trim(i_fromFile);
      msg      = lf_newIfsMsg('IFS1012': IFS1012);
      leave;
   endif;

  // If the target directory does not exist, ...
   if   not f_isIfsDir(%trim(i_toPath): *omit);
  // ... the create an error message
      rc = RC_ERROR;
      clear      IFS1011;
      IFS10111 = '';
      IFS10112 = %trim(i_toPath);
      msg      = lf_newIfsMsg('IFS1011': IFS1011);
      leave;
   endif;

  // Produce target path
   toPath = f_fixIfsDir(%trim(i_toPath));
   toPath = %trimr(toPath) + f_rtvIfsFileFromPath(i_fromFile);

  // Move IFS file
   rc = Qp0lRenameKeep(%trim(i_fromFile): %trim(toPath));

  // If we got an error
   if   rc = RC_ERROR;
  // ... then create message
      clear   IFS1003;
      IFS10031 = '';
      IFS10032 = %trim(i_fromFile);
      IFS10033 = %trim(i_toPath);
      IFS10034 = f_errno;
      IFS10035 = f_strerror(f_errno);
      msg = lf_newIfsMsg('IFS1003': IFS1003);
      leave;
   endif;

   leave;    // Leave the loop
enddo;   // rc = RC_ERROR

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return    rc;


END-PROC;

//=========================================================================
//  Renames a given IFS file.
//=========================================================================
//  Parameters:
//   i_fromFile    - The path name of a given IFS file.
//   i_toPath      - The name of the target directory.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
DCL-PROC f_renameIfsFile EXPORT;
  DCL-PI *N INT(10);
    i_fromFile LIKE(ifs_path_t) CONST;
    i_toFile   LIKE(ifs_path_t) CONST;
    o_msg      LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S rc INT(10) INZ;

  //  Parameter positions
  DCL-C p_isMsg 3;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;
  DCL-S toPath LIKE(ifs_path_t) INZ;

/COPY QIFS,IFS1009
/COPY QIFS,IFS1012
/COPY QIFS,IFS1013
/COPY QIFS,IFS1014
  // ---------------------------------------------------------

msg = lf_newIfsMsg(cMsg_ID_OK);
rc = RC_OK;

dou   rc = RC_ERROR;

  // If the file does not exist, ...
   if   not f_isIfsFile(%trim(i_fromFile): *omit);
  // ... then create error message
      rc = RC_ERROR;
      clear      IFS1012;
      IFS10121 = '';
      IFS10122 = %trim(i_fromFile);
      msg      = lf_newIfsMsg('IFS1012': IFS1012);
      leave;
   endif;

  // If the target file name contains a directory, ...
   if   %scan(cSLASH    : %trimr(i_toFile)) > 0   or
        %scan(cBACKSLASH: %trimr(i_toFile)) > 0   or
        %scan(cCOLON    : %trimr(i_toFile)) > 0;
  // ... then create error message
      rc = RC_ERROR;
      clear      IFS1014;
      IFS10141 = '';
      IFS10142 = %trim(i_toFile);
      msg      = lf_newIfsMsg('IFS1014': IFS1014);
      leave;
   endif;

  // Compute path of target file
   toPath = %trim(f_rtvIfsDirFromPath(i_fromFile)) + %trim(i_toFile);

  // If the target file does already exist, ...
   if   f_isIfsFile(%trim(toPath): *omit);
  // ... then create error message
      rc = RC_ERROR;
      clear      IFS1013;
      IFS10131 = '';
      IFS10132 = %trim(toPath);
      msg      = lf_newIfsMsg('IFS1013': IFS1013);
      leave;
   endif;

  // Rename IFS file
   rc = Qp0lRenameKeep(%trim(i_fromFile): %trim(toPath));

  // If we got an error, ...
   if   rc = RC_ERROR;
  // ... then create error message
      clear   IFS1009;
      IFS10091 = '';
      IFS10092 = %trim(i_fromFile);
      IFS10093 = %trim(i_toFile);
      IFS10094 = f_errno;
      IFS10095 = f_strerror(f_errno);
      msg = lf_newIfsMsg('IFS1009': IFS1009);
      leave;
   endif;

   leave;    // Leave the loop
enddo;   // rc = RC_ERROR

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return    rc;


END-PROC;

//=========================================================================
//  Deletes an IFS file.
//=========================================================================
//  Parameters:
//   i_path        - The path name of a given IFS file.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
DCL-PROC f_deleteIfsFile EXPORT;
  DCL-PI *N INT(10);
    i_path LIKE(ifs_path_t) CONST;
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S rc INT(10) INZ;

  //  Parameter positions
  DCL-C p_isMsg 2;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;

/COPY QIFS,IFS1005
  // ---------------------------------------------------------

  // Delete IFS file
rc = unlink(%trim(i_path));

  // If we got an error, ...
if   rc = RC_ERROR;
  // ... then create error message
   clear   IFS1005;
   IFS10051 = '';
   IFS10052 = %trim(i_path);
   IFS10053 = f_errno;
   IFS10054 = f_strerror(f_errno);
   msg = lf_newIfsMsg('IFS1005': IFS1005);
else;
  // ... else create OK message
   msg = lf_newIfsMsg(cMsg_ID_OK);
endif;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return    rc;


END-PROC;

//=========================================================================
//  Produces a unique temporary IFS file name.
//=========================================================================
//  Parameters:
//   o_msg         - Error message.
//
//  Returns:
//   tmpPath       - Returns a temporary IFS path name on success, else
//                   an empty string.
//=========================================================================
DCL-PROC f_getIfsTmpPath EXPORT;
  DCL-PI *N LIKE(ifs_path_t);
    o_msg LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S tmpPath LIKE(ifs_path_t) INZ;

  //  Parameter positions
  DCL-C p_isMsg 1;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Helper fields
  DCL-S pTmpPath POINTER INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;

/COPY QIFS,IFS1023
  // ---------------------------------------------------------

  // Produce temporary path name ...
f_clrErrno();
pTmpPath = ifs_tmpnam(*NULL);
if (pTmpPath <> *NULL);
   tmpPath = %str(pTmpPath);
   msg = lf_newIfsMsg(cMsg_ID_OK);
else;
   clear IFS1023;
   IFS10231 = '';
   IFS10232 = f_errno();
   IFS10233 = f_strerror(f_errno);
   msg = lf_newIfsMsg('IFS1023': IFS1023);
endif;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return tmpPath;


END-PROC;

//=========================================================================
//  Gets the size on an IFS file.
//=========================================================================
//  Parameters:
//   i_path        - The path name of a given IFS file.
//   o_msg         - Error message.
//
//  Returns:
//   fileSize      - Returns the file size on success, else -1.
//=========================================================================
DCL-PROC f_getIfsFileSize EXPORT;
  DCL-PI *N INT(10);
    i_path LIKE(ifs_path_t) CONST;
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S fileSize INT(10) INZ;

  //  Parameter positions
  DCL-C p_isMsg 2;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;

  //  stat() result data structure
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;

/COPY QIFS,IFS1006
  // ---------------------------------------------------------

  // Get the size of the IFS file  and ...
if   stat(%trim(i_path): %addr(st_stat)) = RC_ERROR;
  // ... return error
   fileSize = RC_ERROR;
else;
  // ... or the file size on success
   fileSize = st_stat.size;
endif;

  // If we got an error, ...
if   fileSize = RC_ERROR;
  // ... then create error message
   clear   IFS1006;
   IFS10061 = '';
   IFS10062 = %trim(i_path);
   IFS10063 = f_errno;
   IFS10064 = f_strerror(f_errno);
   msg = lf_newIfsMsg('IFS1006': IFS1006);
else;
  // ... else create OK message
   msg = lf_newIfsMsg(cMsg_ID_OK);
endif;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return    fileSize;


END-PROC;

//=========================================================================
//  Gets the size on the IFS file specified by a given handle.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file opened by f_openIfsFile().
//   o_msg         - Error message.
//
//  Returns:
//   fileSize      - Returns the file size on success, else -1.
//=========================================================================
DCL-PROC f_getIfsFileSizeH EXPORT;
  DCL-PI *N INT(10);
    i_hFile LIKE(ifs_hFile_t) CONST;
    o_msg   LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S fileSize INT(10) INZ;

  //  Parameter positions
  DCL-C p_isMsg 2;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;

  //  stat() result data structure
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;

/COPY QIFS,IFS1006
  // ---------------------------------------------------------

  // Get the size of the IFS file  and ...
if   fstat(i_hFile: st_stat) = RC_ERROR;
  // ... return error
   fileSize = RC_ERROR;
else;
  // ... or the file size on success
   fileSize = st_stat.size;
endif;

  // If we got an error, ...
if   fileSize = RC_ERROR;
  // ... then create error message
   clear   IFS1006;
   IFS10061 = '';
   IFS10062 = lf_getPathFromFileHandleTable(i_hFile);
   IFS10063 = f_errno;
   IFS10064 = f_strerror(f_errno);
   msg = lf_newIfsMsg('IFS1006': IFS1006);
else;
  // ... else create OK message
   msg = lf_newIfsMsg(cMsg_ID_OK);
endif;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return    fileSize;


END-PROC;

//=========================================================================
//  Returns the file ID that uniquely identifies a given file.
//=========================================================================
//  Parameters:
//   i_path        - The path name of a given IFS file.
//   o_msg         - Error message.
//
//  Returns:
//   fileSize      - Returns the file size on success, else -1.
//=========================================================================
DCL-PROC f_getIfsFileID EXPORT;
  DCL-PI *N LIKEDS(ifs_fileID_t);
    i_path LIKE(ifs_path_t) CONST;
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-DS fileID LIKEDS(ifs_fileID_t) INZ;

  //  Parameter positions
  DCL-C p_isMsg 2;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;

  //  stat() result data structure
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;

/COPY QIFS,IFS1028
  // ---------------------------------------------------------

  // Get the size of the IFS file  and ...
if   stat(%trimR(i_path): %addr(st_stat)) = RC_ERROR;
  // ... return error
   fileID.ino = RC_ERROR;
   fileID.dev = RC_ERROR;
else;
  // ... or the file size on success
   fileID.ino = st_stat.ino;
   fileID.dev = st_stat.dev;
endif;

  // If we got an error, ...
if   fileID.ino = RC_ERROR;
  // ... then create error message
   clear   IFS1028;
   IFS10281 = '';
   IFS10282 = %trim(i_path);
   IFS10283 = f_errno;
   IFS10284 = f_strerror(f_errno);
   msg = lf_newIfsMsg('IFS1028': IFS1028);
else;
  // ... else create OK message
   msg = lf_newIfsMsg(cMsg_ID_OK);
endif;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return fileID;


END-PROC;

//=========================================================================
//  *  Returns the file ID that uniquely identifies the file
//  *  specified by a given handle.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file opened by f_openIfsFile().
//   o_msg         - Error message.
//
//  Returns:
//   fileSize      - Returns the file size on success, else -1.
//=========================================================================
DCL-PROC f_getIfsFileIDH EXPORT;
  DCL-PI *N LIKEDS(ifs_fileID_t);
    i_hFile LIKE(ifs_hFile_t) CONST;
    o_msg   LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-DS fileID LIKEDS(ifs_fileID_t) INZ;

  //  Parameter positions
  DCL-C p_isMsg 2;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;

  //  stat() result data structure
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;

/COPY QIFS,IFS1028
  // ---------------------------------------------------------

  // Get the size of the IFS file  and ...
if   fstat(i_hFile: st_stat) = RC_ERROR;
  // ... return error
   fileID.ino = RC_ERROR;
   fileID.dev = RC_ERROR;
else;
  // ... or the file size on success
   fileID.ino = st_stat.ino;
   fileID.dev = st_stat.dev;
endif;

  // If we got an error, ...
if   fileID.ino = RC_ERROR;
  // ... then create error message
   clear   IFS1028;
   IFS10281 = '';
   IFS10282 = lf_getPathFromFileHandleTable(i_hFile);
   IFS10283 = f_errno;
   IFS10284 = f_strerror(f_errno);
   msg = lf_newIfsMsg('IFS1028': IFS1028);
else;
  // ... else create OK message
   msg = lf_newIfsMsg(cMsg_ID_OK);
endif;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return fileID;


END-PROC;

//=========================================================================
//  Gets the creation time of the IFS file.
//=========================================================================
//  Parameters:
//   i_path        - The path name of a given IFS file.
//   o_msg         - Error message.
//
//  Returns:
//   crtTime       - Returns the creation time on success, else *LOVAL.
//=========================================================================
DCL-PROC f_getIfsFileCrtTime EXPORT;
  DCL-PI *N TIMESTAMP;
    i_path LIKE(ifs_path_t) CONST;
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S crtTime TIMESTAMP INZ(*LOVAL);

  //  Parameter positions
  DCL-C p_isMsg 2;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;

  //  Messages
/COPY QIFS,IFS1021
  // ---------------------------------------------------------

  // Retrieve file creation time ...
if lf_getIfsFileTimeAttr(i_path: QP0L_ATTR_CREATE_TIME: crtTime) <> 0;
  // ... and create and error message in case of an error
   crtTime = *LOVAL;

   clear   IFS1021;
   IFS10211 = '';
   IFS10212 = %trim(i_path);
   IFS10213 = f_errno;
   IFS10214 = f_strerror(f_errno);
   msg = lf_newIfsMsg('IFS1021': IFS1021);
else;
  // ... else create OK message
   msg = lf_newIfsMsg(cMsg_ID_OK);
endif;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return    crtTime;


END-PROC;

//=========================================================================
//  Gets the time the IFS file data was last changed.
//=========================================================================
//  Parameters:
//   i_path        - The path name of a given IFS file.
//   o_msg         - Error message.
//
//  Returns:
//   chgTime       - Returns the time the IFS file was last changed.
//=========================================================================
DCL-PROC f_getIfsFileDataChgTime EXPORT;
  DCL-PI *N TIMESTAMP;
    i_path LIKE(ifs_path_t) CONST;
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S chgTime TIMESTAMP INZ(*LOVAL);

  //  Parameter positions
  DCL-C p_isMsg 2;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;

  //  Messages
/COPY QIFS,IFS1022
  // ---------------------------------------------------------

  // Retrieve file creation time ...
if lf_getIfsFileTimeAttr(i_path: QP0L_ATTR_MODIFY_TIME: chgTime) <> 0;
  // ... and create and error message in case of an error
   chgTime = *LOVAL;

   clear   IFS1022;
   IFS10221 = '';
   IFS10222 = %trim(i_path);
   IFS10223 = f_errno;
   IFS10224 = f_strerror(f_errno);
   msg = lf_newIfsMsg('IFS1022': IFS1022);
else;
  // ... else create OK message
   msg = lf_newIfsMsg(cMsg_ID_OK);
endif;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return    chgTime;


END-PROC;

//=========================================================================
//  Changes the size on an IFS file.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file opened by f_openIfsFile().
//   i_newSize     - The new size of the IFS file.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns the file size on success, else -1.
//=========================================================================
DCL-PROC f_chgIfsFileSize EXPORT;
  DCL-PI *N INT(10);
    i_hFile   LIKE(ifs_hFile_t) CONST;
    i_newSize INT(10) CONST;
    o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S rc INT(10) INZ;

  //  Parameter positions
  DCL-C p_isMsg 3;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;

/COPY QIFS,IFS1007
  // ---------------------------------------------------------

  // Set the new size of the IFS file
rc = ftruncate(i_hFile: i_newSize);

  // If we got an error, ...
if   rc = RC_ERROR;
  // ... then create error message
   clear   IFS1007;
   IFS10071 = '';
   IFS10072 = lf_getPathFromFileHandleTable(i_hFile);
   IFS10073 = f_errno;
   IFS10074 = f_strerror(f_errno);
   msg = lf_newIfsMsg('IFS1007': IFS1007);
else;
  // ... else create OK message
   msg = lf_newIfsMsg(cMsg_ID_OK);
endif;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return    rc;


END-PROC;

//=========================================================================
//  Sets the read/write pointer to a new position.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file opened by f_openIfsFile().
//   i_offset      - The new position of the read/write pointer.
//   i_whence      - The base position to count i_offset from:
//                   SEEK_SET       The start of the file.
//                   SEEK_CUR       The current file offset in the file.
//                   SEEK_END       The end of the file.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns the file size on success, else -1.
//=========================================================================
DCL-PROC f_seekIfsFile EXPORT;
  DCL-PI *N INT(10);
    i_hFile  LIKE(ifs_hFile_t) CONST;
    i_offset INT(10) CONST;
    i_whence INT(10) CONST;
    o_msg    LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S newOffset INT(10) INZ;

  //  Parameter positions
  DCL-C p_isMsg 4;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;

/COPY QIFS,IFS1008
  // ---------------------------------------------------------

  // Check assurances
p_assert((i_whence = SEEK_SET)  or
         (i_whence = SEEK_CUR)  or
         (i_whence = SEEK_END)                                   :
         'Invalid parameter for i_whence.'                       );

  // Set the the new file offset in the file
newOffset = lseek(i_hFile: i_offset: i_whence);

  // If we got an error message, ...
if   newOffset = RC_ERROR;
  // ... create error message
   clear   IFS1008;
   IFS10081 = '';
   IFS10082 = lf_getPathFromFileHandleTable(i_hFile);
   IFS10083 = f_errno;
   IFS10084 = f_strerror(f_errno);
   IFS10085 = i_offset;
   IFS10086 = i_whence;
   msg = lf_newIfsMsg('IFS1008': IFS1008);
else;
  // ... else create OK message
   msg = lf_newIfsMsg(cMsg_ID_OK);
endif;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return    newOffset;


END-PROC;

//=========================================================================
//  Reads entries of a given directory.
//=========================================================================
//  Parameters:
//   i_path        - The name of an IFS directory.
//                   Wildcard characters are: '*' and '?'.
//   i_pCallback   - Procdure pointer of callback procedure.
//                   The callback procedure is called for each entry
//                   that matches the search criteria.
//   i_pUserData   - Pointer to user data.
//   i_options     - Options:                                   1) = Default settings.
//                   cIFS_READDIR_DFT         Default settings.
//                   cIFS_READDIR_FILES       List files.                       1)
//                   cIFS_READDIR_DIR         List directories.                 1)
//                   cIFS_READDIR_ALL         List all directory entries
//                   cIFS_READDIR_CB_NAME     Pass entry name to callback.      1)
//                   cIFS_READDIR_CB_DIRENT   Pass dirent structure to callback.
//                   cIFS_READDIR_SUBDIR      Process sub-directories.
//                   cIFS_READDIR_PRE_ORDER   first callback, then subdirectory 1)
//                   cIFS_READDIR_POST_ORDER  first subdirectory, then callback
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns the number of entries found on success, else -1.
// ------------------------------------------------------------------------
//  Callback:      f_readDirIfs_path    (cIFS_READDIR_CB_NAME)
//
//  Parameters:
//   i_level       - Nesting level. The first directory is level 1.
//   i_directory   - Path of the current directory.
//   i_entry       - Name of the current directory entry.
//   i_type        - Type of the current directory entry.
//   o_msg         - Error message.
//
//  Returns:
//   isOK          - Returns TRUE on succes, else FALSE.
//
// ------------------------------------------------------------------------
//  Callback:      f_readDirIfs_dirent  (cIFS_READDIR_CB_DIRENT)
//
//  Parameters:
//   i_level       - Nesting level. The first directory is level 1.
//   i_directory   - Path of the current directory.
//   i_dirent      - Structure dirent_t of the current directory entry.
//   i_type        - Type of the current directory entry.
//   o_msg         - Error message.
//
//  Returns:
//   numE          - Returns the number of files and subdirectories
//                   on succes, else -1.
//
// ------------------------------------------------------------------------
//  Known directory entry types:
//   cIFS_DIRENT_TYPE_FILE      - File.
//   cIFS_DIRENT_TYPE_DOCUMENT  - Document, member of folder in QDLS.
//   cIFS_DIRENT_TYPE_DIRECTORY - Directory.
//   cIFS_DIRENT_TYPE_FOLDER    - Folder, contained in QDLS.
//
//=========================================================================
DCL-PROC f_readIfsDir EXPORT;
  DCL-PI *N INT(10);
    i_path      LIKE(ifs_path_t) CONST;
    i_pCallback POINTER(*PROC) CONST;
    i_options   INT(10) OPTIONS(*NOPASS: *OMIT) CONST;
    i_pUserData POINTER OPTIONS(*NOPASS: *OMIT) CONST;
    o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S numEntries INT(10) INZ;

  //  Parameter positions
  DCL-C p_isOptions 3;
  DCL-C p_isPUserData 4;
  DCL-C p_isMsg 5;

  //  Fields for optional parameters
  DCL-S pUserData LIKE(i_pUserData) INZ;
  DCL-S options LIKE(i_options) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;
  DCL-S doAllEntries IND INZ(cFalse);
  DCL-S isPreOrder IND INZ(cFalse);
  DCL-S isPostOrder IND INZ(cFalse);
  DCL-S path LIKE(i_path) INZ;
  DCL-S directory LIKE(i_path) INZ;
  DCL-S pattern LIKE(i_path) INZ;
  DCL-S entry LIKE(i_path) INZ;
  DCL-S numSubEntries LIKE(numEntries) INZ;
  DCL-S pDIR POINTER INZ;
  DCL-S level INT(10) INZ STATIC;
/IF not defined(*V5R2M0)
  DCL-S objType LIKE(st_stat_t.objType) INZ;
/ENDIF
  DCL-DS dirEnt LIKEDS(dirent_t) BASED(pDirEnt);
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;

  //  Callback Procedures

  DCL-S pf_readDirIfs_path POINTER(*PROC);

  DCL-S pf_readDirIfs_dirent POINTER(*PROC);

  DCL-PR f_readDirIfs_path IND EXTPROC(pf_readDirIfs_path);
    i_level     INT(10) VALUE;
    i_directory LIKE(ifs_path_t) VALUE;
    i_file      LIKE(ifs_path_t) VALUE;
    i_type      LIKE(ifs_type_t) VALUE;
    i_pUserData POINTER VALUE;
    o_msg       LIKE(msg_t) VALUE;
  END-PR;

  DCL-PR f_readDirIfs_dirent IND EXTPROC(pf_readDirIfs_dirent);
    i_level     INT(10) VALUE;
    i_directory LIKE(ifs_path_t) VALUE;
    i_dirent    LIKEDS(dirent_t) VALUE;
    i_type      LIKE(ifs_type_t) VALUE;
    i_pUserData POINTER VALUE;
    o_msg       LIKE(msg_t) VALUE;
  END-PR;

/COPY QIFS,IFS1017
/COPY QIFS,IFS1018
/COPY QIFS,IFS1019
/COPY QIFS,IFS1020
  // ---------------------------------------------------------

  // Process optional parameters ...
  // ... i_options
if   %parms >= p_isOptions;
   CEETSTA(isPresent: p_isOptions: *omit);
else;
   isPresent = 0;
endif;

if   isPresent = 1;
   options = i_options;
else;
   options = cIFS_READDIR_DFT;
endif;

  // ... i_pUserData
if   %parms >= p_isPUserData;
   CEETSTA(isPresent: p_isPUserData: *omit);
else;
   isPresent = 0;
endif;

if   isPresent = 1;
   pUserData = i_pUserData;
else;
   pUserData = *NULL;
endif;

  // Clear error message
msg = lf_newIfsMsg(cMsg_ID_OK);

  // Increase call level
level = level + 1;

  // Determine pre-order or post-order processing
dou (isPreOrder or isPostOrder);
   isPreOrder  = f_isBitOn(cIFS_READDIR_PRE_ORDER : options);
   isPostOrder = f_isBitOn(cIFS_READDIR_POST_ORDER: options);
   if (not isPreOrder and not isPostOrder);
      options = options + cIFS_READDIR_PRE_ORDER;
   endif;
enddo;

p_assert(isPreOrder or isPostOrder
         : 'Either pre-order or post-order flag must have been set');

  // Fix path (translate \ to /)
path = f_fixIfsPath(i_path);

  // Add "*.*" if path does not contain entry mask
if   f_right(%trimR(path): 1) = cSLASH;
   path = %trimR(path) + '*.*';
endif;

directory = f_rtvIfsDirFromPath(path);
pattern   = f_rtvIfsFileFromPath(path);

doAllEntries = f_isBitOn(cIFS_READDIR_ALL: options);

  // Open directory
pDIR = opendir(%trimR(directory));
if   pDIR = *NULL;
  // ... create error message
   clear   IFS1019;
   IFS10191 = '';
   IFS10192 = %trimR(directory);
   IFS10193 = f_errno;
   IFS10194 = f_strerror(f_errno);
   msg = lf_newIfsMsg('IFS1019': IFS1019);
else;

  // Spin through directory entries
   pDirEnt = *NULL;
   dou   pDirEnt = *NULL;

  // Process directory entry
      if   pDirEnt <> *NULL;

  // Get entry name
         entry = %subst(dirent.d_name: 1: dirent.d_namelen);

  // Ignore '.' and '..' directory entries
         if ((entry <> '.' and entry <> '..') or doAllEntries);

  // Get file information
            if   stat(%trimR(directory) +
                      %subst(entry: 1: dirent.d_namelen) :
                      %addr(st_stat)) = RC_ERROR;
  // ... create error message
               clear   IFS1018;
               IFS10181 = '';
               IFS10182 = %trimR(directory) + %trimR(entry);
               IFS10183 = f_errno;
               IFS10184 = f_strerror(f_errno);
               msg = lf_newIfsMsg('IFS1018': IFS1018);
               leave;
            endif;

  // Process sub-directory
  // (post-order: first subdirectory, then calback
            if (isPostOrder);
               exsr processSubDirectory;
               if (numSubEntries = RC_ERROR);
                  leave;
               endif;
            endif;

  // If the entry matches the pattern ...
            if   (i_pCallback <> *NULL           ) and
                 (lf_isEntryEqual(entry: pattern));

  // ... and the filter criteria, ...
               if   doAllEntries or
                    (lf_isFile(st_stat) and
                     f_isBitOn(cIFS_READDIR_FILES: options)) or
                    (lf_isDir(st_stat ) and
                     f_isBitOn(cIFS_READDIR_DIR  : options));

  // ... then call the requested callback procedure:
                  select;
                  when   f_isBitOn(cIFS_READDIR_CB_NAME: options);
                     pf_readDirIfs_path = i_pCallback;
/IF not defined(*V5R2M0)
                     objType = st_stat.objType;
                     if   not f_readDirIfs_path(
                                    level: directory: entry:
                                    %str(%addr(objType)):
                                    i_pUserData: msg);
                        leave;
                     endif;
/ELSE
                     if   not f_readDirIfs_path(
                                    level: directory: entry:
                                    %str(%addr(st_stat.objType)):
                                    i_pUserData: msg);
                        leave;
                     endif;
/ENDIF

  // Add entries to total number of entries.
                     numEntries = numEntries + 1;
                  when   f_isBitOn(cIFS_READDIR_CB_DIRENT: options);
                     pf_readDirIfs_dirent = i_pCallback;
/IF not defined(*V5R2M0)
                     objType = st_stat.objType;
                     if   not f_readDirIfs_dirent(
                                    level: directory: dirent:
                                    %str(%addr(objType)):
                                    i_pUserData: msg);
                        leave;
                     endif;
/ELSE
                     if   not f_readDirIfs_dirent(
                                    level: directory: dirent:
                                    %str(%addr(st_stat.objType)):
                                    i_pUserData: msg);
                        leave;
                     endif;
/ENDIF

  // Add entries to total number of entries.
                     numEntries = numEntries + 1;
                  endsl;

               endif;
            endif;

  // Process sub-directory
  // (pre-order: first callback, then subdirectory
            if (isPreOrder);
               exsr processSubDirectory;
               if (numSubEntries = RC_ERROR);
                  leave;
               endif;
            endif;

         endif;
      endif;

  // Read next entry
      f_clrErrno();
      pDirEnt = readdir(pDIR);
  // If we got an error ...
      if   (pDirEnt = *NULL) and (f_errno <> 0);
  // ... then create error message
         clear   IFS1017;
         IFS10171 = '';
         IFS10172 = directory;
         IFS10173 = f_errno;
         IFS10174 = f_strerror(f_errno);
         msg = lf_newIfsMsg('IFS1017': IFS1017);
         leave;
      endif;
   enddo;

  // Close directory
   if   closedir(pDIR) = RC_ERROR;
  // ... create error message
      clear   IFS1020;
      IFS10201 = '';
      IFS10202 = %trimR(directory);
      IFS10203 = f_errno;
      IFS10204 = f_strerror(f_errno);
      msg = lf_newIfsMsg('IFS1020': IFS1020);
   endif;
endif;

  // Set return value
if (msg.ID <> cMsg_ID_OK);
   numEntries = RC_ERROR;
endif;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

  // Decrease call level
level = level - 1;

return    numEntries;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //    Process subdirectory
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
begsr processSubDirectory;

   if   lf_isDir(st_stat) and
        f_isBitOn(cIFS_READDIR_SUBDIR: options);
      path = f_fixIfsPath(%trimR(directory) +
                          %trimR(entry)     +
                          cSLASH + pattern);
      numSubEntries = f_readIfsDir(path        :
                                   i_pCallback :
                                   options     :
                                   pUserData   :
                                   msg         );
      if numSubEntries = RC_ERROR;
         leavesr;
      endif;

  // Add entries to total number of entries.
      numEntries = numEntries + numSubEntries;
   endif;

endsr;


END-PROC;

//=========================================================================
//  Creates a new IFS directory.
//=========================================================================
//  Parameters:
//   i_directory   - Directory to create.
//   i_options     - Options:
//                   cIFS_MKDIR_DFT           Default settings.
//                   cIFS_MKDIR_RECURSION     Create directories recursively
//   i_auth        - Authority. See: f_openIfsFile()
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
DCL-PROC f_crtIfsDir EXPORT;
  DCL-PI *N INT(10);
    i_directory LIKE(ifs_path_t) CONST;
    i_options   INT(10) OPTIONS(*NOPASS: *OMIT) CONST;
    i_auth      INT(10) OPTIONS(*NOPASS: *OMIT) CONST;
    o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S rc INT(10) INZ(cIFS_ERROR);

  //  Parameter positions
  DCL-C p_isOptions 2;
  DCL-C p_isAuth 3;
  DCL-C p_isMsg 4;

  //  Fields for optional parameters
  DCL-S options LIKE(i_options) INZ;
  DCL-S auth LIKE(i_auth) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Helper fields
  DCL-S x INT(10) INZ;
  DCL-S y INT(10) INZ;
  DCL-S directory LIKE(ifs_pathV_t) INZ;
  DCL-S homeDir LIKE(ifs_pathV_t) INZ;
  DCL-S newDir LIKE(ifs_pathV_t) INZ;
  DCL-S tmpAuth LIKE(auth) INZ;

  //  stat() result data structure
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;
  DCL-S isRecursion IND INZ(cFalse);

/COPY QIFS,IFS1024
/COPY QIFS,IFS1025
/COPY QIFS,IFS1026
/COPY QIFS,IFS1027
/COPY QIFS,IFS1032
/COPY QIFS,IFS1033
  // ---------------------------------------------------------

  // Process optional parameters ...
  // ... i_options
if (%parms() >= p_isOptions);
   CEETSTA(isPresent: p_isOptions: *omit);
else;
   isPresent = 0;
endif;

if (isPresent = 1);
   options = i_options;
else;
   options = cIFS_MKDIR_DFT;
endif;
  // ... i_auth
if (%parms() >= p_isAuth);
   CEETSTA(isPresent: p_isAuth: *omit);
else;
   isPresent = 0;
endif;

if (isPresent = 1);
   auth = i_auth;
else;
   auth = -1;
endif;

  // Clear error message
msg = lf_newIfsMsg(cMsg_ID_OK);

dou '1';

  // Check whether the path has to be created recursively or not
   isRecursion = f_isBitOn(cIFS_MKDIR_RECURSION: options);

  // Fix path (slashes)
   directory = %trimR(f_fixIfsDir(%trim(i_directory)));

  // Ensure that the user did not specifiy the
  // root directory or an empty string.
   if (directory = cSLASH or %len(directory) = 0);
      clear IFS1024;
      IFS10241 = '';
      IFS10242 = i_directory;
      msg = lf_newIfsMsg('IFS1024': IFS1024);
      leave;
   endif;

  // Ensure that the directory does not already exist
   if (f_isIfsDir(directory));
      clear IFS1032;
      IFS10321 = '';
      IFS10322 = i_directory;
      msg = lf_newIfsMsg('IFS1032': IFS1032);
      leave;
   endif;

  // Ensure that a file with the same name does not already exist
   if (f_isIfsFile(directory));
      clear IFS1033;
      IFS10331 = '';
      IFS10332 = i_directory;
      msg = lf_newIfsMsg('IFS1033': IFS1033);
      leave;
   endif;

  // Create directory:
   if (f_startsWith(cSLASH: directory));
      x = %scan(cSLASH: directory: 2);
      homeDir = cSLASH;
   else;
      x = %scan(cSLASH: directory: 1);
      homeDir = '.';
   endif;

   dow (x <> 0);

      newDir = %subst(directory: 1: x);

      if ((isRecursion or x = %len(directory))
           and not f_isIfsDir(newDir));

  // Determine directory authorization
         if (auth < 0);
            rc = stat(homeDir: %addr(st_stat));
            if (rc = RC_ERROR);
               clear   IFS1025;
               IFS10251 = '';
               IFS10252 = %trim(homeDir);
               IFS10253 = f_errno();
               IFS10254 = f_strerror(f_errno);
               msg = lf_newIfsMsg('IFS1025': IFS1025);
               leave;
            endif;
         else;
            st_stat.mode = auth;
         endif;

  // Create directory
/IF defined(*V5R2M0)
            tmpAuth = %bitand(st_stat.mode: S_IRWXU + S_IRWXG + S_IRWXO);
/ELSE
           tmpAuth = lf_bitand(st_stat.mode:S_IRWXU + S_IRWXG + S_IRWXO);
/ENDIF
                rc = mkdir(newDir: tmpAuth);

  // If we got an error
         if (rc = RC_ERROR);
  // ... then create error message
            clear IFS1026;
            IFS10261 = '';
            IFS10262 = %trim(newDir);
            IFS10263 = f_errno;
            IFS10264 = f_strerror(f_errno);
            msg = lf_newIfsMsg('IFS1026': IFS1026);
            leave;
         endif;

  // Set bits for "effective user id", "effective group id" and
  // "restricted renames and unlinks"
/IF defined(*V5R2M0)
            tmpAuth = %bitand(st_stat.mode: S_IRWXU + S_IRWXG + S_IRWXO +
                                            S_ISUID + S_ISGID + S_ISVTX);
/ELSE
           tmpAuth = lf_bitand(st_stat.mode:S_IRWXU + S_IRWXG + S_IRWXO +
                                            S_ISUID + S_ISGID + S_ISVTX);
/ENDIF
                rc = chmod(newDir: tmpAuth);

  // If we got an error
         if (rc = RC_ERROR);
  // ... then create error message
            clear IFS1027;
            IFS10271 = '';
            IFS10272 = %trim(newDir);
            IFS10273 = f_errno;
            IFS10274 = f_strerror(f_errno);
            msg = lf_newIfsMsg('IFS1027': IFS1027);
            leave;
         endif;

      endif;

      homeDir = newDir;

      if (x < %len(directory));
         x = %scan(cSLASH: directory: x+1);
      else;
         x = 0;
      endif;
   enddo;

   rc = 0;
enddo;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return rc;


END-PROC;

//=========================================================================
//  Deletes a given IFS directory.
//=========================================================================
//  Parameters:
//   i_directory   - Directory to delete.
//   i_options     - Options:
//                   cIFS_RMDIR_DFT                    Default settings.
//                   cIFS_RMDIR_DELETE_FILES           Delete files.
//                   cIFS_RMDIR_DELETE_SUB_DIRECTORIES Delete subdirectories.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns number of deleted files and directories
//                   on success, else -1.
//=========================================================================
DCL-PROC f_dltIfsDir EXPORT;
  DCL-PI *N INT(10);
    i_directory LIKE(ifs_path_t) CONST;
    i_options   INT(10) OPTIONS(*NOPASS: *OMIT) CONST;
    o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S rc INT(10) INZ(cIFS_ERROR);

  //  Parameter positions
  DCL-C p_isOptions 2;
  DCL-C p_isMsg 3;

  //  Fields for optional parameters
  DCL-S options LIKE(i_options) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Helper fields
  DCL-S subDirOptions INT(10) INZ;
  DCL-S directory LIKE(ifs_pathV_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;
  DCL-S isTestMode IND INZ(cFalse);
  DCL-S isFiles IND INZ(cFalse);
  DCL-S isSubDirectories IND INZ(cFalse);
  DCL-S pRemoveProc POINTER(*PROC) INZ;
  DCL-DS tmpMsg LIKEDS(msg_t) INZ;

/COPY QIFS,IFS1024
/COPY QIFS,IFS1031
  // ---------------------------------------------------------

  // Process optional parameters ...
  // ... i_options
if (%parms() >= p_isOptions);
   CEETSTA(isPresent: p_isOptions: *omit);
else;
   isPresent = 0;
endif;

if (isPresent = 1);
   options = i_options;
else;
   options = cIFS_RMDIR_DFT;
endif;

  // Clear error message
msg = lf_newIfsMsg(cMsg_ID_OK);

dou '1';

  // Check whether the files contained in a directory must be deleted
   isFiles =
      f_isBitOn(cIFS_RMDIR_DELETE_FILES: options);

  // Check whether the subdirectories must be deleted
   isSubDirectories =
      f_isBitOn(cIFS_RMDIR_DELETE_SUB_DIRECTORIES: options);

  // Fix path (slashes)
   directory = %trimR(f_fixIfsDir(%trim(i_directory)));

  // Ensure that the user did not specifiy the
  // root directory or an empty string.
   if (directory = cSLASH or %len(directory) = 0);
      clear IFS1024;
      IFS10241 = '';
      IFS10242 = i_directory;
      msg = lf_newIfsMsg('IFS1024': IFS1024);
      rc = cIFS_ERROR;
      leave;
   endif;

  // Determine if test mode has been specified
   if (f_isBitOn(cIFS_RMDIR_TEST_MODE: options));
      isTestMode = cTrue;
   else;
      isTestMode = cFalse;
   endif;

  // Remove directory entries
   if (isFiles or isSubDirectories);
      subDirOptions = cIFS_READDIR_CB_NAME + cIFS_READDIR_POST_ORDER;

      if (isFiles);
         subDirOptions = subDirOptions + cIFS_READDIR_FILES;
      endif;

      if (isSubDirectories);
         subDirOptions = subDirOptions + cIFS_READDIR_SUBDIR +                       //RADDAT
                                         cIFS_READDIR_DIR;
      endif;

      if (isTestMode);
         pRemoveProc = %paddr('lf_removeDirectoryEntryTestMode');
      else;
         pRemoveProc = %paddr('lf_removeDirectoryEntry');
      endif;

      if (f_readIfsDir(directory
                       : pRemoveProc
                       : subDirOptions
                       : %addr(options)
                       : tmpMsg) = cIFS_ERROR);
         msg = tmpMsg;
         rc = cIFS_ERROR;
         leave;
      endif;
   endif;

  // Delete directory
   if (isTestMode);
      f_sndPgmMsg(f_newMsg(cMSG_ID_NONE
                           : 'Test mode: Removed ' + %trim(directory))
                  : cMsg_Same);
   else;
      if (rmDir(directory) <> 0);
         clear IFS1031;
         IFS10311 = '';
         IFS10312 = directory;
         IFS10313 = f_errno;
         IFS10314 = f_strerror(f_errno);
         msg = lf_newIfsMsg('IFS1031': IFS1031);
         rc = cIFS_ERROR;
         leave;
      endif;
   endif;

   rc = 0;
enddo;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return rc;


END-PROC;

//=========================================================================
//  Returns cTrue if a given directory is empty, else cFalse.
//=========================================================================
//  Parameters:
//   i_dir         - The name of an IFS directory.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns cTrue if the directory is empty, else cFalse.
//=========================================================================
DCL-PROC f_isIfsDirEmpty EXPORT;
  DCL-PI *N IND;
    i_dir LIKE(ifs_path_t) CONST;
    o_msg LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S isEmpty IND INZ(cFalse);

  //  Parameter positions
  DCL-C p_isMsg 2;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;
  DCL-S isDirOpen IND INZ(cFalse);
  DCL-S dir LIKE(i_dir) INZ;
  DCL-S pDIR POINTER INZ;
  DCL-S entry CHAR(4) INZ;
  DCL-DS dirEnt LIKEDS(dirent_t) BASED(pDirEnt);

/COPY QIFS,IFS1017
/COPY QIFS,IFS1019
/COPY QIFS,IFS1020
  // ---------------------------------------------------------

  // Clear error message
msg = lf_newIfsMsg(cMsg_ID_OK);

  // Fix path (translate \ to /)
dir = f_fixIfsPath(i_dir);

dou '1';

  // Check, whether the specified directory exists or not
   if (not f_isIfsDir(dir: msg));
      leave;
   endif;

   if (msg.ID <> 'IFS1015');   // directory exits
      leave;
   endif;

   msg = lf_newIfsMsg(cMsg_ID_OK);

  // Open directory
   pDIR = opendir(%trimR(dir));
   if   pDIR = *NULL;
  // ... create error message
      clear   IFS1019;
      IFS10191 = '';
      IFS10192 = %trimR(dir);
      IFS10193 = f_errno;
      IFS10194 = f_strerror(f_errno);
      msg = lf_newIfsMsg('IFS1019': IFS1019);
      leave;
   endif;

   isDirOpen = cTrue;

  // Spin through directory entries
   pDirEnt = *NULL;
   dou (pDirEnt = *NULL);
  // Process directory entry
      if   pDirEnt <> *NULL;
  // Get entry name
         entry = %subst(dirent.d_name: 1: dirent.d_namelen);
  // Ignore '.' and '..' directory entries
         if ((entry <> '.' and entry <> '..'));
            leave;   // Directory is not empty!
         endif;
      endif;

  // Read next entry
      f_clrErrno();
      pDirEnt = readdir(pDIR);
      if (pDirEnt = *NULL);   // End of list
         if (f_errno <> 0);
            clear   IFS1017;
            IFS10171 = '';
            IFS10172 = dir;
            IFS10173 = f_errno;
            IFS10174 = f_strerror(f_errno);
            msg = lf_newIfsMsg('IFS1017': IFS1017);
            leave;
         else;
            isEmpty = cTrue;   // Directory is empty.
         endif;
      endif;
   enddo;

enddo;

  // Close directory
if (isDirOpen);
   if (closedir(pDIR) = RC_OK);
      isDirOpen = cFalse;
   else;
      clear   IFS1020;
      IFS10201 = '';
      IFS10202 = %trimR(dir);
      IFS10203 = f_errno;
      IFS10204 = f_strerror(f_errno);
      msg = lf_newIfsMsg('IFS1020': IFS1020);
   endif;
endif;

  // Reset return value
if (msg.ID <> cMsg_ID_OK);
   isEmpty = cFalse;
endif;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return isEmpty;


END-PROC;

//=========================================================================
//  Returns the current working directory.
//=========================================================================
//  Parameters:
//   o_msg         - Error message.
//
//  Returns:
//   dir           - Current directory.
//=========================================================================
DCL-PROC f_getIfsCurDir EXPORT;
  DCL-PI *N LIKE(ifs_path_t);
    o_msg LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S dir LIKE(ifs_path_t) INZ;

  //  Parameter positions
  DCL-C p_isMsg 1;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Helper fields
  DCL-S tmpDir LIKE(ifs_path_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;

/COPY QIFS,IFS1029
  // ---------------------------------------------------------

  // Clear error message
msg = lf_newIfsMsg(cMsg_ID_OK);

dou '1';

  // Get current working directory
   if (getcwd(tmpDir: %size(tmpDir)) = *NULL);
  // ... create error message on error
      clear   IFS1029;
      IFS10291 = f_errno;
      IFS10292 = f_strerror(f_errno);
      msg = lf_newIfsMsg('IFS1029': IFS1029);
      leave;
   endif;

   dir = f_fixIfsDir(%str(%addr(tmpDir)));
enddo;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return dir;


END-PROC;

//=========================================================================
//  Changes the current working directory.
//=========================================================================
//  Parameters:
//   i_dir         - Directory that should become the current directory.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
DCL-PROC f_chgIfsCurDir EXPORT;
  DCL-PI *N INT(10);
    i_dir LIKE(ifs_path_t) CONST;
    o_msg LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;

  //  Return value
  DCL-S rc INT(10) INZ(RC_ERROR);

  //  Parameter positions
  DCL-C p_isMsg 2;

  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;

  //  Helper fields
  DCL-DS tmpDir LIKEDS(Qlg_Path_Name_t) INZ;

  //  Local fields
  DCL-S isPresent INT(10) INZ;

/COPY QIFS,IFS1030
  // ---------------------------------------------------------

  // Clear error message
msg = lf_newIfsMsg(cMsg_ID_OK);

dou '1';

  // Prepare path name
   tmpDir = lf_initializePath(i_dir);

  // Change current working directory
   if (QlgChdir(tmpDir) <> 0);
  // ... create error message on error
      clear   IFS1030;
      IFS10301 = i_dir;
      IFS10302 = f_errno;
      IFS10303 = f_strerror(f_errno);
      msg = lf_newIfsMsg('IFS1030': IFS1030);
      leave;
   endif;

   rc = RC_OK;
enddo;

  // Set message type to *ESCAPE if it is not an OK message
if (msg.ID <> cMsg_ID_OK);
   msg.type = cMsg_Escape;
endif;

  // If the message parameter was passed ...
if (%parms >= p_isMsg);
  // then check if it was omitted
   CEETSTA(isPresent: p_isMsg: *omit);
  // If the parameter was not omitted ...
   if (isPresent = 1);
  // then pass back the message
      o_msg = msg;
   endif;
else;
  // else send message
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return rc;


END-PROC;

//=========================================================================
//  *** private ***
//  Removes the entries of a given directory.
//=========================================================================
DCL-PROC lf_removeDirectoryEntry;
  DCL-PI *N IND;
    i_level     INT(10) VALUE;
    i_directory LIKE(ifs_path_t) VALUE;
    i_entry     LIKE(ifs_path_t) VALUE;
    i_type      LIKE(ifs_type_t) VALUE;
    i_pUserData POINTER VALUE;
    o_msg       LIKE(msg_t) VALUE;
  END-PI;

  //  Local fields
  DCL-S tmpPath LIKE(ifs_path_t) INZ;
  DCL-DS tmpMsg LIKEDS(msg_t) INZ;
  // ---------------------------------------------------------

tmpPath = %trimR(i_directory) + i_entry;

select;
when (i_type = cIFS_DIRENT_TYPE_DIRECTORY or
      i_type = cIFS_DIRENT_TYPE_FOLDER);
   if (f_dltIfsDir(tmpPath: *omit: tmpMsg) = cIFS_ERROR);
      o_msg = tmpMsg;
      return cFalse;
   endif;

when (i_type = cIFS_DIRENT_TYPE_FILE or
      i_type = cIFS_DIRENT_TYPE_DOCUMENT);
   if (f_deleteIfsFile(tmpPath: tmpMsg) = cIFS_ERROR);
      o_msg = tmpMsg;
      return cFalse;
   endif;

endsl;

o_msg = lf_newIfsMsg(cMsg_ID_OK);

return cTrue;


END-PROC;

//=========================================================================
//  *** private ***
//  Removes the entries of a given directory (test mode).
//=========================================================================
DCL-PROC lf_removeDirectoryEntryTestMode;
  DCL-PI *N IND;
    i_level     INT(10) VALUE;
    i_directory LIKE(ifs_path_t) VALUE;
    i_entry     LIKE(ifs_path_t) VALUE;
    i_type      LIKE(ifs_type_t) VALUE;
    i_pUserData POINTER VALUE;
    o_msg       LIKE(msg_t) VALUE;
  END-PI;

  //  Local fields
  DCL-S options INT(10) BASED(i_pUserData);
  DCL-S tmpPath LIKE(ifs_path_t) INZ;
  DCL-DS tmpMsg LIKEDS(msg_t) INZ;
  // ---------------------------------------------------------

tmpPath = %trimR(i_directory) + i_entry;

select;
when (i_type = cIFS_DIRENT_TYPE_DIRECTORY or
      i_type = cIFS_DIRENT_TYPE_FOLDER);

   f_sndPgmMsg(f_newMsg(cMSG_ID_NONE
                        : 'Test mode: Removed ' + %trim(tmpPath))
               : cMsg_Same);

when (i_type = cIFS_DIRENT_TYPE_FILE or
      i_type = cIFS_DIRENT_TYPE_DOCUMENT);

   f_sndPgmMsg(f_newMsg(cMSG_ID_NONE
                        : 'Test mode: Removed ' + %trim(tmpPath))
               : cMsg_Same);

endsl;

o_msg = lf_newIfsMsg(cMsg_ID_OK);

return cTrue;


END-PROC;

//=========================================================================
//  *** private ***
//  Adds the file path to the local file handle table, because there is
//  no way to get the path back from the Unix file handle.
//=========================================================================
DCL-PROC lp_addEntryToFileHandleTable;
  DCL-PI *N;
    i_hFile        LIKE(ifs_hFile_t) CONST;
    i_path         LIKE(ifs_path_t) CONST;
    i_useTmpBuffer IND CONST;
  END-PI;

  //  Local fields
  DCL-S i INT(10) INZ;
  // ---------------------------------------------------------

if   g_numHandles < %elem(g_handleList.hFile);
   i = %lookup(0: g_handleList.hFile: 1: g_numHandles + 1);
else;
   i = %lookup(0: g_handleList.hFile: 1: g_numHandles);
endif;

p_assert(i > 0                                                   :
         'Maximum number of handles reached.'                    );

if   i > 0;
   g_handleList.hFile(i)        = i_hFile;
   g_handleList.useTmpBuffer(i) = i_useTmpBuffer;
   g_handleList.path(i)         = i_path;
   if   i > g_numHandles;
      p_assert(i = g_numHandles + 1);
      g_numHandles = g_numHandles + 1;
   endif;
endif;

  // Create temporay buffer used by f_writeLineIfsFile()
if (i_useTmpBuffer and g_tempBuffer.pData = *NULL);
   g_tempBuffer.size = cBUFFER_SIZE;
   g_tempBuffer.pData = %alloc(g_tempBuffer.size);
endif;

return;


END-PROC;

//=========================================================================
//  *** private ***
//  Gets the path from the local file handle.
//=========================================================================
DCL-PROC lf_getPathFromFileHandleTable;
  DCL-PI *N LIKE(ifs_path_t);
    i_hFile LIKE(ifs_hFile_t) CONST;
  END-PI;

  //  Return value
  DCL-S path LIKE(ifs_path_t) INZ('*N');

  //  Localfields
  DCL-S i INT(10) INZ;
  // ---------------------------------------------------------

  // Search for the file handle
i = lf_getFileHandleTableIndex(i_hFile);
if   i > 0;
  // and get back the path
   path = g_handleList.path(i);
endif;

return   path;


END-PROC;

//=========================================================================
//  *** private ***
//  Returns TRUE if f_writeLineIfsFile() must use a temporary
//  buffer, else FALSE
//=========================================================================
DCL-PROC lf_useTmpBuffer;
  DCL-PI *N IND;
    i_hFile LIKE(ifs_hFile_t) CONST;
  END-PI;

  //  Return value
  DCL-S useTmpBuffer IND INZ(cFalse);

  //  Localfields
  DCL-S i INT(10) INZ;
  // ---------------------------------------------------------

  // Search for the file handle
i = lf_getFileHandleTableIndex(i_hFile);
if   i > 0;
   useTmpBuffer = g_handleList.useTmpBuffer(i);
endif;

return useTmpBuffer;


END-PROC;

//=========================================================================
//  *** private ***
//  Checks and reallocates size of temporary write buffer. Returns
//  buffer pointer.
//=========================================================================
DCL-PROC lf_checkAndReallocateTmpBuffer;
  DCL-PI *N POINTER;
    i_hFile   LIKE(ifs_hFile_t) CONST;
    i_newSize INT(10) CONST;
  END-PI;

  //  Return value
  DCL-S pTmpBuffer POINTER INZ;

  //  Localfields
  DCL-S i INT(10) INZ;
  // ---------------------------------------------------------

  // Search for the file handle
i = lf_getFileHandleTableIndex(i_hFile);
if (i > 0);
   if (i_newSize > g_tempBuffer.size);
      g_tempBuffer.size = g_tempBuffer.size * 2;
      g_tempBuffer.pData = %realloc(g_tempBuffer.pData
                                    : g_tempBuffer.size);
   endif;
endif;

pTmpBuffer = g_tempBuffer.pData;

return pTmpBuffer;


END-PROC;

//=========================================================================
//  *** private ***
//  Returns the file handle table index for a given file handle.
//=========================================================================
DCL-PROC lf_getFileHandleTableIndex;
  DCL-PI *N INT(10);
    i_hFile LIKE(ifs_hFile_t) CONST;
  END-PI;

  //  Return value
  DCL-S index INT(10) INZ(-1);

  //  Localfields
  DCL-S i INT(10) INZ;
  // ---------------------------------------------------------

  // Search for the file handle
i = %lookup(i_hFile: g_handleList.hFile: 1: g_numHandles);
if (i > 0);
   index = 1;
endif;

return index;


END-PROC;

//=========================================================================
//  *** private ***
//  Removes the path from the local file handle.
//=========================================================================
DCL-PROC lp_removeEntryFromFileHandleTable;
  DCL-PI *N;
    i_hFile LIKE(ifs_hFile_t) CONST;
  END-PI;

  //  Local fields
  DCL-S i INT(10) INZ;
  // ---------------------------------------------------------

i = %lookup(i_hFile: g_handleList.hFile: 1: g_numHandles);
if   i > 0;
   g_handleList.hFile(i)        = 0;
   g_handleList.useTmpBuffer(i) = cFalse;
   g_handleList.path(i)         = '';
   if   i = g_numHandles;
      g_numHandles = g_numHandles - 1;
   endif;
endif;

  // Free temporay buffer used by f_writeLineIfsFile()
if (g_numHandles = 0);
   if (g_tempBuffer.pData <> *NULL);
      dealloc(N) g_tempBuffer.pData;
      g_tempBuffer.size = 0;
   endif;
endif;

return;


END-PROC;

//=========================================================================
//  *** private ***
//  Converts a timestamp from Epoch to RPG format.
//=========================================================================
DCL-PROC lf_cvtEpochTmStmpToRpgTmStmp;
  DCL-PI *N TIMESTAMP;
    i_epochTmStmp INT(10) VALUE;
  END-PI;

  //  Return value
  DCL-S tmStmp TIMESTAMP INZ;

  //  Local fields
  DCL-S ftimef CHAR(16) INZ('%Y-%m-%d%H.%M.%S');

  DCL-DS ftimest QUALIFIED;
    date CHAR(10);
    time CHAR(8);
    null CHAR(1) INZ(x'00');
  END-DS;

  DCL-DS time LIKEDS(tm_t) INZ;
  // ---------------------------------------------------------

if   localtime_r(i_epochTmStmp: time) <> *NULL;
   if   strftime(%addr(ftimest) :
                 %size(ftimest) :
                 %trim(ftimef)  :
                 time           ) > 0;
      tmStmp=%timestamp(ftimest.date + '-' + ftimest.time + '.000000');
   endif;
endif;

return   tmStmp;


END-PROC;

//=========================================================================
//  *** private ***
//  Creates a IFS message.
//=========================================================================
DCL-PROC lf_newIfsMsg;
  DCL-PI *N LIKEDS(msg_t);
    i_ID   LIKE(msg_t.id) OPTIONS(*OMIT: *NOPASS) CONST;
    i_data VARCHAR(512) OPTIONS(*OMIT: *NOPASS) CONST;
    i_type LIKE(msg_t.type) OPTIONS(*OMIT: *NOPASS) CONST;
  END-PI;

  //  Return value
  DCL-DS msg LIKEDS(msg_t);

  //  Parameter positions
  DCL-C p_ID 1;
  DCL-C p_data 2;
  DCL-C p_type 3;

  //  Optional parameter fields
  DCL-S ID LIKE(i_ID) INZ;
  DCL-S data LIKE(i_data) INZ;
  DCL-S type LIKE(i_type) INZ;

  //  Local fields

  //  Helper fields CEETSTA
  DCL-S isPresent INT(10) INZ;
  // ---------------------------------------------------------

  // Process optional parameter values ...
  // ... ID
if  %parms >= p_ID;
   CEETSTA(isPresent: p_ID: *omit);
else;
   isPresent = 0;
endif;

if  isPresent = 1;
   ID = i_ID;
else;
   if  %parms >= p_ID;
      ID = cMSG_ID_NONE;
   else;
      ID = cMSG_ID_NULL;
   endif;
endif;

  // ... Data
if  %parms >= p_data;
   CEETSTA(isPresent: p_data: *omit);
else;
   isPresent = 0;
endif;

if  isPresent = 1;
   data = i_data;
else;
   data = '';
endif;

  // ... Type
if  %parms >= p_type;
   CEETSTA(isPresent: p_type: *omit);
else;
   isPresent = 0;
endif;

if  isPresent = 1;
   type = i_type;
else;
   if   (ID <> cMsg_ID_OK  ) and
        (ID <> cMsg_ID_NULL);
      type = cMsg_Info;
   else;
      type = '';
   endif;
endif;

msg = f_newMsg(ID: data: type: 'IFS': '*LIBL');

return   msg;


END-PROC;

//=========================================================================
//  *** private ***
//  Checks whether an IFS object is a file;
//=========================================================================
DCL-PROC lf_isFile;
  DCL-PI *N IND;
    i_st_stat LIKEDS(st_stat_t) CONST;
  END-PI;

  //  Return value
  DCL-S isFile IND INZ(cFalse);
/IF not defined(*V5R2M0)

  //  Local fields
  DCL-S objType LIKE(st_stat_t.objType) INZ;
/ENDIF
  // ---------------------------------------------------------

/IF not defined(*V5R2M0)
objType = i_st_stat.objType;
if   (%str(%addr(objType)) = cIFS_DIRENT_TYPE_FILE    ) or
     (%str(%addr(objType)) = cIFS_DIRENT_TYPE_DOCUMENT);
/ELSE
   if   (%str(%addr(i_st_stat.objType)) = cIFS_DIRENT_TYPE_FILE    ) or
        (%str(%addr(i_st_stat.objType)) = cIFS_DIRENT_TYPE_DOCUMENT);
/ENDIF
      isFile = cTrue;
   else;
      isFile = cFalse;
   endif;

   return   isFile;


END-PROC;

//=========================================================================
//  *** private ***
//  Checks whether an IFS object is a directory;
//=========================================================================
DCL-PROC lf_isDir;
  DCL-PI *N IND;
    i_st_stat LIKEDS(st_stat_t) CONST;
  END-PI;

  //  Return value
  DCL-S isDir IND INZ(cFalse);
/IF not defined(*V5R2M0)

  //  Local fields
  DCL-S objType LIKE(st_stat_t.objType) INZ;
/ENDIF
  // ---------------------------------------------------------

/IF not defined(*V5R2M0)
   objType = i_st_stat.objType;
   if   (%str(%addr(objType)) = cIFS_DIRENT_TYPE_DIRECTORY) or
        (%str(%addr(objType)) = cIFS_DIRENT_TYPE_FOLDER   );
/ELSE
    if   (%str(%addr(i_st_stat.objType)) = cIFS_DIRENT_TYPE_DIRECTORY) or
           (%str(%addr(i_st_stat.objType)) = cIFS_DIRENT_TYPE_FOLDER   );
/ENDIF
         isDir = cTrue;
      else;
         isDir = cFalse;
      endif;

      return   isDir;


END-PROC;

//=========================================================================
//  *** private ***
//  Checks whether an IFS object matches a given string pattern.
//=========================================================================
DCL-PROC lf_isEntryEqual;
  DCL-PI *N IND;
    i_entry   LIKE(ifs_path_t) VALUE;
    i_pattern LIKE(ifs_path_t) VALUE;
  END-PI;

  //  Return value
  DCL-S isEqual IND INZ(cFalse);

  //  Local fields
  DCL-S x INT(10) INZ;
  DCL-DS wildcard QUALIFIED;
    group  CHAR(1) INZ('*');
    single CHAR(1) INZ('?');
  END-DS;
  // ---------------------------------------------------------

  // Adjust entry, if the user
  // want to search for name and extension:
      if %scan('.': i_pattern) > 0;

  // Add a dot (.) if it is missing,
  // to make sure that the dot of the mask
  // is also in the entry.
         if %scan('.': %trimR(i_entry)) = 0;
            i_entry = %trimR(i_entry) + '.';
         endif;

      endif;

      isEqual = f_genStrCmpIgnCase(
                           %trimR(i_entry): %trimR(i_pattern): wildcard);

      return   isEqual;


END-PROC;

//=========================================================================
//  *** private ***
//  Initializes the path structure for the Qp0lGetAttr API.
//=========================================================================
DCL-PROC lf_initializePath;
  DCL-PI *N LIKE(ifs_path_t);
    i_path LIKEDS(Qlg_Path_Name_t) CONST;
  END-PI;

  //  Return value
  DCL-DS path LIKEDS(Qlg_Path_Name_t) INZ;
  // ---------------------------------------------------------

      clear path;
      path.CCSID               = QLG_PATH_JOB_CCSID;     // Use current job default CCSID
      path.Country_ID          = QLG_PATH_JOB_COUNTRYID; // Use the current job country
  // or region ID
      path.Language_ID         = QLG_PATH_JOB_LANGUAGEID;// Use the current job lang. ID
      path.Reserved            = *ALLx'00';
      path.Path_Type           = QLG_CHAR_SINGLE;        // 0 = Path is character String,
  //     1-byte delimiter.
  // 1 = Path is pointer,
  //     1-byte delimiter.
  // 2 = Path is character String,
  //     2-byte delimiter.
  // 3 = Path is pointer,
  //     2-byte delimiter.
      path.Path_Length         = %len(%trimR(i_path));
      path.Path_Name_Delimiter = cSLASH;
      path.Reserved2           = *ALLx'00';
      path.Path_Name           = i_path;

      return   path;


END-PROC;

//=========================================================================
//  *** private ***
//  Retrieves a file 'time' attribute.
//=========================================================================
DCL-PROC lf_getIfsFileTimeAttr;
  DCL-PI *N INT(10);
    i_path LIKE(ifs_path_t) CONST;
    i_attr INT(10) CONST;
    o_time TIMESTAMP;
  END-PI;

  //  Return value
  DCL-S rc INT(10) INZ;

  //  Helper fields
  DCL-S bytPrv UNS(10) INZ;
  DCL-S sizeNeeded UNS(10) INZ;
  DCL-S bytRet UNS(10) INZ;
  DCL-DS path LIKEDS(Qlg_Path_Name_t) INZ;
  DCL-DS attrArray LIKEDS(Qlg_attrArray_t) INZ;
  DCL-DS rtnAttr LIKEDS(Qlg_rtnAttr_t) BASED(pRtnAttr);
  DCL-S timeEpo UNS(10) BASED(pTimeEpo);
  // ---------------------------------------------------------

  // Prepare path name
      path = lf_initializePath(i_path);

  // Specify what attributes we want
      clear attrArray;
      attrArray.numE = 1;
      attrArray.attr(1) = i_attr;

  // Allocate buffer for result of Qp0lGetAttr
      bytPrv = 32;
      pRtnAttr = %alloc(bytPrv);
      clear rtnAttr;

  // Retrieve file attributes
      rc = Qp0lGetAttr(path
                       : attrArray
                       : pRtnAttr
                       : bytPrv
                       : sizeNeeded
                       : bytRet
                       : 0             );

      if rc = 0;
         pTimeEpo = pRtnAttr + %size(rtnAttr);
         o_time = lf_cvtEpochTmStmpToRpgTmStmp(timeEpo);
      else;
         o_time = *LOVAL;
      endif;

      return rc;


END-PROC;

/IF not defined(*V5R2M0)
//===============================================================*
//  bitand() for V5R1 and below.
//===============================================================*
DCL-PROC lf_bitand;
  DCL-PI *N UNS(10);
    i_arg1 UNS(10) VALUE;
    i_arg2 UNS(10) VALUE;
  END-PI;

  DCL-S result UNS(10);

  //  AND String (ANDSTR) - MI Instruction
  //  (http://publib.boulder.ibm.com/iseries/v5r1/ic2924/tstudio/tech_ref/mi/topics.htm)
  DCL-PR ANDSTR EXTPROC('_ANDSTR');
    i_pReceiver  POINTER VALUE;
    i_pFirstSrc  POINTER VALUE;
    i_pSecondSrc POINTER VALUE;
    i_length     UNS(10) VALUE;
  END-PR;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      ANDSTR(%addr(result): %addr(i_arg1): %addr(i_arg2): %len(result));

      return result;


END-PROC;

/ENDIF