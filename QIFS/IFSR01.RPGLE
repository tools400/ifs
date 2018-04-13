      *=====================================================================*
      *  IFSR01     - SrvPgm: IFS-Funktionen                                *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  15.03.2004                                              *
      *  E-mail  :  thomas.raddatz@Tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *  01.02.2005  Th.Raddatz    Added procedure f_readLineIfsFile() to   *
      *                            read a line from a streamfile.           *
      *                                                                     *
      *  01.02.2005  Th.Raddatz    Added procedure f_writeLineIfsFile() to  *
      *                            write a line to a streamfile.            *
      *                                                                     *
      *  15.02.2005  Th.Raddatz    Added procedure f_readIfsDir() to        *
      *                            read a directory.                        *
      *                                                                     *
      *  03.02.2005  Th.Raddatz    Added support for new open() flag        *
      *                            O_CCSID.                                 *
      *                                                                     *
      *  08.02.2006  Th.Raddatz    Changed IFS to be compatible to V5R1.    *
      *                                                                     *
      *  24.02.2006  Th.Raddatz    Fixed problem that f_readLineIfsFile()   *
      *                            did not return -1 in case of an error.   *
      *                            Fixed problem that caller to             *
      *                            f_readLineIfsFile() could not distinguish*
      *                            betwenn EOF and an empty line returned.  *
      *                            f_readLineIfsFile() now returns -2 in    *
      *                            case of EOF.                             *
      *                                                                     *
      *  18.06.2006  Th.Raddatz    Fixed problem that caused an endless     *
      *                            loop in f_renameIfsFile().               *
      *                                                                     *
      *  18.11.2006  Th.Raddatz    Added procedure f_getIfsFileCrtTime().   *
      *                                                                     *
      *  17.04.2008  Th.Raddatz    Added procedure                          *
      *                            f_getIfsFileDataChgTime().               *
      *                                                                     *
      *  31.08.2008  Th.Raddatz    Now correctly producing the target       *
      *                            file path from the source path           *
      *                            and the target file name.                *
      *                                                                     *
      *  09.09.2008  Th.Raddatz    Moved g_hFile and g_path into data       *
      *                            structure g_handleList.                  *
      *                            Changed f_writeLineIfsFile() to append   *
      *                            buffer data and end-of-line characters   *
      *                            to the IFS file at once. (atomic write   *
      *                            of data and EOL character.)              *
      *                                                                     *
      *  18.09.2008  Th.Raddatz    Added procedures: f_getIfsTmpPath()      *
      *                                              f_crtIfsDir()          *
      *                                                                     *
      *  07.11.2008  Th.Raddatz    Added procedures: f_getIfsFileSizeH()    *
      *                                              f_getIfsFileID()       *
      *                                              f_getIfsFileIDH()      *
      *                                                                     *
      *  21.01.2009  Th.Raddatz    Added procedures: f_getIfsCurDir()       *
      *                                              f_chgIfsCurDir()       *
      *                                                                     *
      *  28.01.2009  Th.Raddatz    Added procedures: f_dltIfsDir()          *
      *                                                                     *
      *  30.01.2009  Th.Raddatz    Added procedures: f_isIfsDirEmpty()      *
      *                                                                     *
      *  03.02.2009  Th.Raddatz    Fixed problem that f_readIfsDir() did    *
      *                            not properly retrieve the file status    *
      *                            information (stat()) if a file name      *
      *                            had trailing blanks.                     *
      *                                                                     *
      *  18.09.2009  Th.Raddatz    Fixed compile problem in IFSTEST_09      *
      *                            and added cIFS_RMDIR_DELETE_FILES to     *
      *                            f_dltIfsDir().                           *
      *                                                                     *
      *  20.11.2010  Th.Raddatz    Fixed problem that O_CCSID flag was      *
      *                            not removed from the open flags when     *
      *                            re-opening a newly created file.         *
      *                                                                     *
      *  30.03.2012  Th.Raddatz    Added compiler directives to get a clean *
      *                            compile on V5R1 systems.                 *
      *                                                                     *
      *  03.03.2017  Th.Raddatz    Added member COPYRIGHT.                  *
      *                            Fixed compile error message RNF7597.     *
      *                            Updated CEELIB and CLIB.                 *
      *                                                                     *
      * =================================================================== *
      * >>PRE-COMPILER<<                                                    *
      *   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                         *
      *                           SRCFILE(&SL/&SF) SRCMBR(&SM);             *
      *   >>COMPILE<<                                                       *
      *     >>PARM<< DBGVIEW(*LIST);                                        *
      *     >>PARM<< TRUNCNBR(*NO );                                        *
      *     >>PARM<< TGTRLS(V6R1M0);                                        *
      *     >>PARM<< OPTION(*EVENTF);                                       *
      *   >>END-COMPILE<<                                                   *
      *   >>EXECUTE<<                                                       *
      * >>END-PRE-COMPILER<<                                                *
      * =================================================================== *
     H NOMAIN
     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*DMY.)
     H DATFMT(*ISO )  TIMFMT(*ISO )
     H EXPROPTS(*RESDECPOS)
      /COPY QIFS,COPYRIGHT
      * =================================================================== *
      *
      *-------------------------------------------------------------------------
      *  Exported functions and type definitions
      *-------------------------------------------------------------------------
      /COPY QIFS,PIFS
      *
     D ifs_pathV_t     S            256A   varying                 based(pDummy)
      *
      *-------------------------------------------------------------------------
      *  Private prototypes
      *-------------------------------------------------------------------------
      *
      *  Removes a given directory entry from the directory.
     D lf_removeDirectoryEntry...
     D                 PR              N
     D                                     extproc('lf_removeDirectoryEntry')
     D  i_level                      10I 0 value
     D  i_directory                        value  like(ifs_path_t    )
     D  i_entry                            value  like(ifs_path_t    )
     D  i_type                             value  like(ifs_type_t    )
     D  i_pUserData                    *   value
     D  o_msg                              value  like(msg_t         )
      *
      *  Removes a given directory entry from the directory (test mode).
     D lf_removeDirectoryEntryTestMode...
     D                 PR              N
     D                                     extproc('lf_removeDirectoryEntry+
     D                                     TestMode')
     D  i_level                      10I 0 value
     D  i_directory                        value  like(ifs_path_t    )
     D  i_entry                            value  like(ifs_path_t    )
     D  i_type                             value  like(ifs_type_t    )
     D  i_pUserData                    *   value
     D  o_msg                              value  like(msg_t         )
      *
      *  Add entry to file handle table
     D lp_addEntryToFileHandleTable...
     D                 PR
     D i_hFile                             const  like(ifs_hFile_t)
     D i_path                              const  like(ifs_path_t )
     D i_useTmpBuffer                  N   const
      *
      *  Get path from file handle
     D lf_getPathFromFileHandleTable...
     D                 PR                  like(ifs_path_t)
     D i_hFile                             const  like(ifs_hFile_t)
      *
      *  Returns TRUE if f_writeLineIfsFile() must use a temporary
      *  buffer, else FALSE
     D lf_useTmpBuffer...
     D                 PR              N
     D i_hFile                             const  like(ifs_hFile_t)
      *
      *  Checks and reallocates size of temporary write buffer. Returns
      *  buffer pointer.
     D lf_checkAndReallocateTmpBuffer...
     D                 PR              *
     D i_hFile                             const  like(ifs_hFile_t)
     D i_newSize                     10I 0 const
      *
      *  Returns the file handle table index for a given file handle.
     D lf_getFileHandleTableIndex...
     D                 PR            10I 0
     D i_hFile                             const  like(ifs_hFile_t)
      *
      *  Remove entry from file handle
     D lp_removeEntryFromFileHandleTable...
     D                 PR
     D i_hFile                             const  like(ifs_hFile_t)
      *
      *  Convert Epoch timestamp to RPG timestamp
     D lf_cvtEpochTmStmpToRpgTmStmp...
     D                 PR              Z
     D i_epochTmStmp                 10I 0 value
      *
      *  Creates a IFS message.
     D lf_newIfsMsg...
     D                 PR                         likeds(msg_t  )
     D  i_ID                               const  like(msg_t.id    )
     D                                            options(*omit: *nopass)
     D  i_data                      512A   const  varying
     D                                            options(*omit: *nopass)
     D  i_type                             const  like(msg_t.type  )
     D                                            options(*omit: *nopass)
      *
      *  Checks whether an IFS object is a file;
     D lf_isFile...
     D                 PR              N
     D  i_st_stat                          const  likeds(st_stat_t )
      *
      *  Checks whether an IFS object is a directory.
     D lf_isDir...
     D                 PR              N
     D  i_st_stat                          const  likeds(st_stat_t )
      *
      *  Checks whether an IFS object matches a given string pattern.
     D lf_isEntryEqual...
     D                 PR              N
     D  i_entry                            value  like(ifs_path_t  )
     D  i_pattern                          value  like(ifs_path_t  )
      *
      *  Initializes the path structure for the Qp0lGetAttr API.
     D lf_initializePath...
     D                 PR                         like(ifs_path_t       )
     D i_path                              const  likeds(Qlg_Path_Name_t)
      *
      *  Retrieves a file 'time' attribute.
     D lf_getIfsFileTimeAttr...
     D                 PR            10I 0
     D i_path                              const  like(ifs_path_t    )
     D i_attr                        10I 0 const
     D o_time                          Z
      *
      /if not defined(*V5R2M0)
     D lf_bitand...
     D                 PR            10U 0
     D  i_arg1                       10U 0 value
     D  i_arg2                       10U 0 value
      *
      /endif
      *-------------------------------------------------------------------------
      *  Global constants
      *-------------------------------------------------------------------------
     D cDELIMITER      C                   const(':/\')
     D cDFT_ASC_CODEPAGE...
     D                 C                   const(850)
      *
     D cSLASH          C                   '/'
     D cBACKSLASH      C                   '\'
     D cCOLON          C                   ':'
      *
      *-------------------------------------------------------------------------
      *  Global fields
      *-------------------------------------------------------------------------
     D g_numHandles    S             10I 0 inz
     D g_handleList    DS                  qualified
     D  hFile                              like(ifs_hFile_t  )  inz
     D                                     dim(100)
     D  useTmpBuffer                   N                        inz(cFalse)
     D                                     dim(%elem(g_handleList.hFile))
     D  path                               like(ifs_path_t   )  inz
     D                                     dim(%elem(g_handleList.hFile))
      *
     D g_tempBuffer    DS                  qualified
     D  pData                          *   inz
     D  size                         10I 0 inz
      *
     D cBUFFER_SIZE    C                   8196
      *
      *=========================================================================
      *  Checks, whether an IFS directory exists.
      *=========================================================================
      *  Parameters:
      *   i_path        - The name of an IFS directory.
      *
      *  Returns:
      *   doesExist     - Returns TRUE if the directory exists, else FALSE.
      *=========================================================================
     P f_isIfsDir...
     P                 B                   export
      *
     D f_isIfsDir...
     D                 PI              N
     D i_path                              const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D doesExist       S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_isMsg         C                   const(2)
      *
      *  Local fields
     D isPresent       S             10I 0 inz
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  stat() result data structure
     D st_stat         DS                  likeds(st_stat_t) inz
      *
      /COPY QIFS,IFS1011
      /COPY QIFS,IFS1015
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_isIfsDir...
     P                 E
      *
      *=========================================================================
      *  Checks, whether an IFS file exists.
      *=========================================================================
      *  Parameters:
      *   i_file        - The name of an IFS file.
      *
      *  Returns:
      *   doesExist     - Returns TRUE if the file exists, else FALSE.
      *=========================================================================
     P f_isIfsFile...
     P                 B                   export
      *
     D f_isIfsFile...
     D                 PI              N
     D i_file                              const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D doesExist       S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_isMsg         C                   const(2)
      *
      *  Local fields
     D isPresent       S             10I 0 inz
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  stat() result data structure
     D st_stat         DS                  likeds(st_stat_t) inz
      *
      /COPY QIFS,IFS1012
      /COPY QIFS,IFS1013
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_isIfsFile...
     P                 E
      *
      *=========================================================================
      *  Fixes a given IFS path name.
      *  (Hint:   path = directory + file)
      *=========================================================================
      *  Parameters:
      *   i_path        - A given IFS path name.
      *
      *  Returns:
      *   path          - The fixed IFS path name.
      *=========================================================================
     P f_fixIfsPath...
     P                 B                   export
      *
     D f_fixIfsPath...
     D                 PI                  like(ifs_path_t    )
     D i_path                              const  like(ifs_path_t    )
      *
      *  Return value
     D path            S                   like(ifs_path_t) inz
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_fixIfsPath...
     P                 E
      *
      *=========================================================================
      *  Fixes a given IFS directory name.
      *  (Hint:   path = directory + file)
      *=========================================================================
      *  Parameters:
      *   i_dir         - A given IFS directory name.
      *
      *  Returns:
      *   dir           - The fixed IFS directory name.
      *=========================================================================
     P f_fixIfsDir...
     P                 B                   export
      *
     D f_fixIfsDir...
     D                 PI                  like(ifs_path_t    )
     D i_dir                               const  like(ifs_path_t    )
      *
      *  Return value
     D dir             S                   like(ifs_path_t) inz
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_fixIfsDir...
     P                 E
      *
      *=========================================================================
      *  Retrieves the file name from a given path name.
      *=========================================================================
      *  Attention: The f_rtvIfsFileFromPath-function must also be able to
      *             retrieve the file name from pathes starting with 'http://'
      *             or 'ftp://'. Please consider that, when changing the
      *             f_rtvIfsFileFromPath-function.
      *=========================================================================
      *  Parameters:
      *   i_path        - A given IFS path name.
      *
      *  Returns:
      *   file          - The file name portion of the path.
      *=========================================================================
     P f_rtvIfsFileFromPath...
     P                 B                   export
      *
     D f_rtvIfsFileFromPath...
     D                 PI                  like(ifs_path_t    )
     D i_path                              const  like(ifs_path_t    )
      *
      *  Return value
     D file            S                   like(ifs_path_t) inz
      *
      *  Local fields
     D pToken          S               *   inz
     D token           S                   like(file      )  inz
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_rtvIfsFileFromPath...
     P                 E
      *
      *=========================================================================
      *  Retrieves the directory name from a given path name.
      *=========================================================================
      *  Attention: The f_rtvIfsDirFromPath-function must also be able to
      *             retrieve the directory name from pathes starting with 'http://'
      *             or 'ftp://'. Please consider that, when changing the
      *             f_rtvIfsDirFromPath-function.
      *=========================================================================
      *  Parameters:
      *   i_path        - A given IFS path name.
      *
      *  Returns:
      *   directory     - The directory name portion of the path.
      *=========================================================================
     P f_rtvIfsDirFromPath...
     P                 B                   export
      *
     D f_rtvIfsDirFromPath...
     D                 PI                  like(ifs_path_t    )
     D i_path                              const  like(ifs_path_t    )
      *
      *  Return value
     D directory       S                   like(ifs_path_t) inz
      *
      *  Local fields
     D pathLength      S             10I 0 inz
     D dirLength       S             10I 0 inz
     D x               S             10I 0 inz
     D y               S             10I 0 inz
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_rtvIfsDirFromPath...
     P                 E
      *
      *=========================================================================
      *  Retrieves the extension of an IFS file name.
      *=========================================================================
      *  Parameters:
      *   i_path        - The path name of a given IFS file.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   extension     - Returns the extension of the file name.
      *=========================================================================
     P f_rtvIfsFileExtFromPath...
     P                 B                   export
      *
     D f_rtvIfsFileExtFromPath...
     D                 PI                         like(ifs_path_t    )
     D i_path                              const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D extension       S                   like(ifs_path_t) inz
      *
      *  Parameter positions
     D p_isMsg         C                   const(2)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0                  inz
     D file            S                   like(ifs_path_t) inz
     D length          S             10I 0                  inz
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_rtvIfsFileExtFromPath...
     P                 E
      *
      *=========================================================================
      *  Removes the extension from an IFS file name.
      *=========================================================================
      *  Parameters:
      *   i_path        - The path name of a given IFS file.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   path          - The file name without the extension.
      *=========================================================================
     P f_rmvIfsFileExtFromPath...
     P                 B                   export
      *
     D f_rmvIfsFileExtFromPath...
     D                 PI                         like(ifs_path_t    )
     D i_path                              const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D path_wo_ext     S                   like(ifs_path_t) inz
      *
      *  Parameter positions
     D p_isMsg         C                   const(2)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
     D isFound         S               N   inz(cFalse)
     D length          S             10I 0 inz
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_rmvIfsFileExtFromPath...
     P                 E
      *
      *=========================================================================
      *  Open an IFS file for text mode.
      *=========================================================================
      *  Parameters:
      *   i_path        - A given IFS path name.
      *   i_opnFlags    - O_CREAT        If the file being opened does not exist,
      *                                  create it.
      *                   O_EXCL         Send error message if file exists and
      *                                  O_CREAT was specified.
      *                   O_TRUNC        Truncate the file to zero length.
      *                   O_APPEND       Position the file offset at the end of
      *                                  the file before each write operation.
      *                   O_CODEPAGE     The call to open has a codepage argument.
      *                                  This flag cannot be specified with the
      *                                  O_CCSID flag.
      *                   O_TEXTDATA     The data is processed as text.
      *                   O_INHERITMODE  Create the file with the same data
      *                                  authorities as the parent file.
      *                   O_CCSID        Text conversions between any two CCSIDs
      *                                  supported by the iconv() API can be performed.
      *                                  This flag cannot be specified with the
      *                                  O_CODEPAGE flag.
      *
      *                   O_SHARE_RDONLY Share with readers only.
      *                   O_SHARE_WRONLY Share with writers only.
      *                   O_SHARE_RDWR   Share with readers and writers.
      *                   O_SHARE_NONE   Share with neither readers nor writers.
      *
      *                   O_RDONLY       Open for reading only.
      *                   O_WRONLY       Open for writing only.
      *                   O_RDWR         Open for both reading and writing.
      *
      *   i_codePage    - When the O_CODEPAGE flag is specified, i_codepage
      *                   must contain the codepage of the new file.
      *                   When the O_CCSID flag is specified, i_codepage
      *                   must contain the CCSID of the new file.
      *   i_auth        - S_IRUSR        Owner has read authority.
      *                   S_IWUSR        Owner has write authority.
      *                   S_IXUSR        Owner has execute/search authority.
      *                   S_IRWXU        Owner has all authorities.
      *
      *                   S_IRGRP        Group has read authority.
      *                   S_IWGRP        Group has write authority.
      *                   S_IXGRP        Group has execute/search authority.
      *                   S_IRWXG        Group has all authorities.
      *
      *                   S_IROTH        Public has read authority.
      *                   S_IWOTH        Public has write authority.
      *                   S_IXOTH        Public has execute/search authority.
      *                   S_IRWXO        Public has all authorities.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   hFile         - The handle of the open file.
      *=========================================================================
     P f_openIfsFile...
     P                 B                   export
      *
     D f_openIfsFile...
     D                 PI                  like(ifs_hFile_t   )
     D i_path                              const  like(ifs_path_t    )
     D i_opnFlags                    10I 0 const
     D i_codePage                    10I 0 const  options(*nopass: *omit)
     D i_auth                        10I 0 const  options(*nopass: *omit)
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D hFile           S                   like(ifs_hFile_t) inz
      *
      *  Parameter positions
     D p_isCodePage    C                   const(3)
     D p_isAuth        C                   const(4)
     D p_isMsg         C                   const(5)
      *
      *  Fields for optional parameters
     D codePage        S                   like(i_codePage)  inz
     D auth            S                   like(i_auth    )  inz
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0                   inz
     D opnFlags        S                   like(i_opnFlags)  inz
     D doesExist       S               N                     inz(cFalse)
     D useTmpBuffer    S               N                     inz(cFalse)
     D rc              S             10I 0                   inz
      *
      /COPY QIFS,IFS1000
      * ---------------------------------------------------------
      /free

         // Process optional parameters ...
         // ... i_codePage
         if   %parms >= p_isCodePage;
            CEETSTA(isPresent: p_isCodePage: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            codePage = i_codePage;
         else;
            codePage = cDFT_ASC_CODEPAGE;
         endif;

         // ... i_auth
         if   %parms >= p_isAuth;
            CEETSTA(isPresent: p_isAuth: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            auth = i_auth;
         else;
            auth = S_IRWXU + S_IRWXG + S_IRWXO;  // *PUBLIC = *ALL
         endif;

         // Check file existance
         doesExist = f_isIfsFile(%trimr(i_path): *omit);

         // Set open flags
         opnFlags = i_opnFlags;

         // If O_CODEPAGE and O_CCSID are not specified ...
         if   not f_isBitOn(O_CODEPAGE: opnFlags) and
              not f_isBitOn(O_CCSID   : opnFlags);
         // .. and the file does not exists
            if   not doesExist;
         //    .. then set O_CODEPAGE
               opnFlags = opnFlags + O_CODEPAGE;
            endif;
         else;
         // .. else if the file already exists
            if   doesExist;
         //    .. then remove O_CODEPAGE or O_CCSID
               select;
               when f_isBitOn(O_CODEPAGE: opnFlags);
                  opnFlags = opnFlags - O_CODEPAGE;
               when f_isBitOn(O_CCSID   : opnFlags);
                  opnFlags = opnFlags - O_CCSID;
               endsl;
            endif;
         endif;

         // Open the file
         hFile = open(%trimr(i_path): opnFlags: auth: codePage);

         // If the file was just created ...
         if   (hFile <> RC_ERROR)  and  (not doesExist);
         // ... then re-open the file to let the operating system
         //     do the codepage conversion.
            if   close(hFile) = RC_ERROR;
               hFile = RC_ERROR;
            else;
               // Remove O_CODEPAGE or O_CCSID flag
               select;
               when f_isBitOn(O_CODEPAGE: opnFlags);
                  opnFlags = opnFlags - O_CODEPAGE;
               when f_isBitOn(O_CCSID   : opnFlags);
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

         // In case on an open error ...
         if   hFile = RC_ERROR;
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

      /end-free
      *
     P f_openIfsFile...
     P                 E
      *
      *=========================================================================
      *  Closes an IFS file that was opened with the f_openIfsFile-function.
      *=========================================================================
      *  Parameters:
      *   i_hFile       - The handle of a file opened by f_openIfsFile().
      *   o_msg         - Error message.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P f_closeIfsFile...
     P                 B                   export
      *
     D f_closeIfsFile...
     D                 PI            10I 0
     D i_hFile                             const  like(ifs_hFile_t   )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D rc              S             10I 0 inz
      *
      *  Parameter positions
     D p_isMsg         C                   const(2)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
      *
      /COPY QIFS,IFS1001
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_closeIfsFile...
     P                 E
      *
      *=========================================================================
      *  Writes to an IFS file.
      *=========================================================================
      *  Parameters:
      *   i_hFile       - The handle of a file opened by f_openIfsFile().
      *   i_pBuffer     - A pointer to the data to write to the IFS file.
      *   i_length      - The length of the data or 0 is the data is a
      *                   null-terminated string.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   rc            - Returns the number of bytes that were written to
      *                   the IFS file or -1.
      *=========================================================================
     P f_writeIfsFile...
     P                 B                   export
      *
     D f_writeIfsFile...
     D                 PI            10I 0
     D i_hFile                             const  like(ifs_hFile_t   )
     D i_pBuffer                       *   const  options(*string)
     D i_length                      10I 0 const
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D bytesWritten    S             10I 0 inz
      *
      *  Parameter positions
     D p_isMsg         C                   const(4)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
     D length          S             10I 0 inz
      *
      /COPY QIFS,IFS1002
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_writeIfsFile...
     P                 E
      *
      *=========================================================================
      *  Writes a line to an IFS file.
      *=========================================================================
      *  Parameters:
      *   i_hFile       - The handle of a file opened by f_openIfsFile().
      *   i_pBuffer     - A pointer to the data to write to the IFS file.
      *   i_length      - The length of the data or 0 is the data is a
      *                   null-terminated string.
      *   i_EOLChar     - End-Of-Line character string.
      *                   Default:        cIFS_EOL_CRLF
      *                   cIFS_EOL_CRLF - Ascii 0D+0A, typically used
      *                                   by DOS and Windows systems.
      *                   cIFS_EOL_LF   - Ascii 0A, typically used
      *                                   by Unix systems.
      *                   cIFS_EOL_CR   - Ascii 0D, typically used
      *                                   by Mac systems.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   rc            - Returns the number of bytes that were written to
      *                   the IFS file or -1.
      *
      *  Comments:
      *   A line is considered as a series of bytes terminated by an
      *   End-Of-Line character. The EOL-character must not be included in
      *   the buffer addressed by i_pBuffer. It is automatically added.
      *   By default the f_writeLineIfsFile() procedure uses CR+LF as
      *   the EOL-characters. Since DOS/Windows, Unix and Mac uses different
      *   EOL-characters, the EOL-character to be use can be specified at
      *   i_EOLChar.
      *   Notice that beside the predefined constants you can use any other
      *   character or character string up to 32 byte as the EOL-character.
      *
      *  Hint:
      *   Usually f_writeLineIfsFile() uses separate write operation to
      *   write the data and the end-of-line characters to the file. If
      *   a file is shared with other writers, data and EOL characters
      *   have to be written in a single, atomic operation. Otherwise
      *   the output data can get mixed up with the data of other writers.
      *   In those cases f_writeLineIfsFile() uses a temporary buffer to
      *   ensure that the data and the EOL characters are written at once.
      *   Of course that reduces performance.
      *   In order to gain better performance you may add the EOL characters
      *   manually before calling f_writeLineIfsFile(). In that case specify
      *   and empty string for the EOL characters at f_writeLineIfsFile().
      *
      *   Sample:
      *
      *     data = 'Hello World' + cIFS_EOL_CRLF;
      *     f_writeLineIfsFile(hFile
      *                        : %addr(data)
      *                        : %len(data)
      *                        : ''
      *                        : msg);
      *
      *=========================================================================
     P f_writeLineIfsFile...
     P                 B                   export
      *
     D f_writeLineIfsFile...
     D                 PI            10I 0
     D i_hFile                             const  like(ifs_hFile_t   )
     D i_pBuffer                       *   const  options(*string)
     D i_length                      10I 0 const
     D i_EOLChar                           const  like(ifs_EOLChar_t )
     D                                            options(*nopass: *omit)
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D bytesWritten    S             10I 0 inz
      *
      *  Parameter positions
     D p_isEOLChar     C                   const(4)
     D p_isMsg         C                   const(5)
      *
      *  Fields for optional parameters
     D eolChar         S                   like(i_EOLChar  ) inz
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
     D length          S             10I 0 inz
     D startPos        S             10I 0 inz
     D numBytes        S             10I 0 inz
     D newSize         S             10I 0 inz
     D byteBuffer      S             32A   based(pByteBuffer)
     D pBuffer         S               *   inz
     D x               S             10I 0 inz
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_writeLineIfsFile...
     P                 E
      *
      *=========================================================================
      *  Reads from an IFS file.
      *=========================================================================
      *  Parameters:
      *   i_hFile       - The handle of a file opened by f_openIfsFile().
      *   i_pBuffer     - A pointer to the input data.
      *   i_length      - The length of the buffer.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   rc            - Returns the number of bytes that were red from
      *                   the IFS file or -1.
      *=========================================================================
     P f_readIfsFile...
     P                 B                   export
      *
     D f_readIfsFile...
     D                 PI            10I 0
     D i_hFile                             const  like(ifs_hFile_t   )
     D i_pBuffer                       *   const
     D i_length                      10I 0 const
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D bytesRed        S             10I 0 inz
      *
      *  Parameter positions
     D p_isMsg         C                   const(4)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
      *
      /COPY QIFS,IFS1004
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_readIfsFile...
     P                 E
      *
      *=========================================================================
      *  Reads a line from an IFS file.
      *=========================================================================
      *  Parameters:
      *   i_hFile       - The handle of a file opened by f_openIfsFile().
      *   i_pBuffer     - A pointer to the input data.
      *   i_length      - The length of the buffer.
      *   i_EOLChar     - End-Of-Line character string.
      *                   Default:        cIFS_EOL_CRLF
      *                   cIFS_EOL_CRLF - Ascii 0D+0A, typically used
      *                                   by DOS and Windows systems.
      *                   cIFS_EOL_LF   - Ascii 0A, typically used
      *                                   by Unix systems.
      *                   cIFS_EOL_CR   - Ascii 0D, typically used
      *                                   by Mac systems.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   rc            - Returns the number of bytes that were red from
      *                   the IFS file or cIFS_ERROR. Returns cIFS_EOL
      *                   in case of EOF.
      *
      *  Comments:
      *   A line is considered as a series of bytes terminated by an
      *   End-Of-Line character. The EOL-character is not added to the
      *   buffer addressed by i_pBuffer.
      *   By default der f_readLineIfsFile() procedure uses CR+LF as
      *   the EOL-characters. Since DOS/Windows, Unix and Mac uses different
      *   EOL-characters, the EOL-character to be use can be specified at
      *   i_EOLChar.
      *   Notice that beside the predefined constants you can use any other
      *   character or character string up to 32 byte as the EOL-character.
      *
      *=========================================================================
     P f_readLineIfsFile...
     P                 B                   export
      *
     D f_readLineIfsFile...
     D                 PI            10I 0
     D i_hFile                             const  like(ifs_hFile_t   )
     D i_pBuffer                       *   const
     D i_length                      10I 0 const
     D i_EOLChar                           const  like(ifs_EOLChar_t )
     D                                            options(*nopass: *omit)
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D bytesRed        S             10I 0 inz
      *
      *  Parameter positions
     D p_isEOLChar     C                   const(4)
     D p_isMsg         C                   const(5)
      *
      *  Fields for optional parameters
     D eolChar         S                   like(i_EOLChar  ) inz
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
     D numBytes        S             10I 0 inz
     D a1ByteBuffer    S              1A   inz
     D EOLBuffer       S                   like(ifs_EOLChar_t) inz
     D ofsOutBuffer    S                   like(i_length     ) inz(0)
      *
      /COPY QIFS,IFS1016
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_readLineIfsFile...
     P                 E
      *
      *=========================================================================
      *  Moves an IFS file to a new location.
      *=========================================================================
      *  Parameters:
      *   i_fromFile    - The path name of a given IFS file.
      *   i_toPath      - The name of the target directory.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P f_moveIfsFile...
     P                 B                   export
      *
     D f_moveIfsFile...
     D                 PI            10I 0
     D i_fromFile                          const  like(ifs_path_t    )
     D i_toPath                            const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D rc              S             10I 0 inz
      *
      *  Parameter positions
     D p_isMsg         C                   const(3)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
     D toPath          S                   like(i_toPath  ) inz
      *
      /COPY QIFS,IFS1003
      /COPY QIFS,IFS1011
      /COPY QIFS,IFS1012
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_moveIfsFile...
     P                 E
      *
      *=========================================================================
      *  Renames a given IFS file.
      *=========================================================================
      *  Parameters:
      *   i_fromFile    - The path name of a given IFS file.
      *   i_toPath      - The name of the target directory.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P f_renameIfsFile...
     P                 B                   export
      *
     D f_renameIfsFile...
     D                 PI            10I 0
     D i_fromFile                          const  like(ifs_path_t    )
     D i_toFile                            const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D rc              S             10I 0 inz
      *
      *  Parameter positions
     D p_isMsg         C                   const(3)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
     D toPath          S                   like(ifs_path_t ) inz
      *
      /COPY QIFS,IFS1009
      /COPY QIFS,IFS1012
      /COPY QIFS,IFS1013
      /COPY QIFS,IFS1014
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_renameIfsFile...
     P                 E
      *
      *=========================================================================
      *  Deletes an IFS file.
      *=========================================================================
      *  Parameters:
      *   i_path        - The path name of a given IFS file.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P f_deleteIfsFile...
     P                 B                   export
      *
     D f_deleteIfsFile...
     D                 PI            10I 0
     D i_path                              const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D rc              S             10I 0 inz
      *
      *  Parameter positions
     D p_isMsg         C                   const(2)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
      *
      /COPY QIFS,IFS1005
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_deleteIfsFile...
     P                 E
      *
      *=========================================================================
      *  Produces a unique temporary IFS file name.
      *=========================================================================
      *  Parameters:
      *   o_msg         - Error message.
      *
      *  Returns:
      *   tmpPath       - Returns a temporary IFS path name on success, else
      *                   an empty string.
      *=========================================================================
     P f_getIfsTmpPath...
     P                 B                   export
      *
     D f_getIfsTmpPath...
     D                 PI                         like(ifs_path_t )
     D o_msg                                      like(msg_t      )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D tmpPath         S                   like(ifs_path_t ) inz
      *
      *  Parameter positions
     D p_isMsg         C                   const(1)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Helper fields
     D pTmpPath        S               *   inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
      *
      /COPY QIFS,IFS1023
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_getIfsTmpPath...
     P                 E
      *
      *=========================================================================
      *  Gets the size on an IFS file.
      *=========================================================================
      *  Parameters:
      *   i_path        - The path name of a given IFS file.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   fileSize      - Returns the file size on success, else -1.
      *=========================================================================
     P f_getIfsFileSize...
     P                 B                   export
      *
     D f_getIfsFileSize...
     D                 PI            10I 0
     D i_path                              const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D fileSize        S             10I 0 inz
      *
      *  Parameter positions
     D p_isMsg         C                   const(2)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
      *
      *  stat() result data structure
     D st_stat         DS                  likeds(st_stat_t) inz
      *
      /COPY QIFS,IFS1006
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_getIfsFileSize...
     P                 E
      *
      *=========================================================================
      *  Gets the size on the IFS file specified by a given handle.
      *=========================================================================
      *  Parameters:
      *   i_hFile       - The handle of a file opened by f_openIfsFile().
      *   o_msg         - Error message.
      *
      *  Returns:
      *   fileSize      - Returns the file size on success, else -1.
      *=========================================================================
     P f_getIfsFileSizeH...
     P                 B                   export
      *
     D f_getIfsFileSizeH...
     D                 PI            10I 0
     D i_hFile                             const  like(ifs_hFile_t   )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D fileSize        S             10I 0 inz
      *
      *  Parameter positions
     D p_isMsg         C                   const(2)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
      *
      *  stat() result data structure
     D st_stat         DS                  likeds(st_stat_t) inz
      *
      /COPY QIFS,IFS1006
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_getIfsFileSizeH...
     P                 E
      *
      *=========================================================================
      *  Returns the file ID that uniquely identifies a given file.
      *=========================================================================
      *  Parameters:
      *   i_path        - The path name of a given IFS file.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   fileSize      - Returns the file size on success, else -1.
      *=========================================================================
     P f_getIfsFileID...
     P                 B                   export
      *
     D f_getIfsFileID...
     D                 PI                         likeds(ifs_fileID_t)
     D i_path                              const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D fileID          DS                  likeds(ifs_fileID_t) inz
      *
      *  Parameter positions
     D p_isMsg         C                   const(2)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
      *
      *  stat() result data structure
     D st_stat         DS                  likeds(st_stat_t) inz
      *
      /COPY QIFS,IFS1028
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_getIfsFileID...
     P                 E
      *
      *=========================================================================
      *  *  Returns the file ID that uniquely identifies the file
      *  *  specified by a given handle.
      *=========================================================================
      *  Parameters:
      *   i_hFile       - The handle of a file opened by f_openIfsFile().
      *   o_msg         - Error message.
      *
      *  Returns:
      *   fileSize      - Returns the file size on success, else -1.
      *=========================================================================
     P f_getIfsFileIDH...
     P                 B                   export
      *
     D f_getIfsFileIDH...
     D                 PI                         likeds(ifs_fileID_t)
     D i_hFile                             const  like(ifs_hFile_t   )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D fileID          DS                  likeds(ifs_fileID_t) inz
      *
      *  Parameter positions
     D p_isMsg         C                   const(2)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
      *
      *  stat() result data structure
     D st_stat         DS                  likeds(st_stat_t) inz
      *
      /COPY QIFS,IFS1028
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_getIfsFileIDH...
     P                 E
      *
      *=========================================================================
      *  Gets the creation time of the IFS file.
      *=========================================================================
      *  Parameters:
      *   i_path        - The path name of a given IFS file.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   crtTime       - Returns the creation time on success, else *LOVAL.
      *=========================================================================
     P f_getIfsFileCrtTime...
     P                 B                   export
      *
     D f_getIfsFileCrtTime...
     D                 PI              Z
     D i_path                              const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D crtTime         S               Z   inz(*LOVAL)
      *
      *  Parameter positions
     D p_isMsg         C                   const(2)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
      *
      *  Messages
      /COPY QIFS,IFS1021
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_getIfsFileCrtTime...
     P                 E
      *
      *=========================================================================
      *  Gets the time the IFS file data was last changed.
      *=========================================================================
      *  Parameters:
      *   i_path        - The path name of a given IFS file.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   chgTime       - Returns the time the IFS file was last changed.
      *=========================================================================
     P f_getIfsFileDataChgTime...
     P                 B                   export
      *
     D f_getIfsFileDataChgTime...
     D                 PI              Z
     D i_path                              const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D chgTime         S               Z   inz(*LOVAL)
      *
      *  Parameter positions
     D p_isMsg         C                   const(2)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
      *
      *  Messages
      /COPY QIFS,IFS1022
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_getIfsFileDataChgTime...
     P                 E
      *
      *=========================================================================
      *  Changes the size on an IFS file.
      *=========================================================================
      *  Parameters:
      *   i_hFile       - The handle of a file opened by f_openIfsFile().
      *   i_newSize     - The new size of the IFS file.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   rc            - Returns the file size on success, else -1.
      *=========================================================================
     P f_chgIfsFileSize...
     P                 B                   export
      *
     D f_chgIfsFileSize...
     D                 PI            10I 0
     D i_hFile                             const  like(ifs_hFile_t   )
     D i_newSize                     10I 0 const
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D rc              S             10I 0 inz
      *
      *  Parameter positions
     D p_isMsg         C                   const(3)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
      *
      /COPY QIFS,IFS1007
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_chgIfsFileSize...
     P                 E
      *
      *=========================================================================
      *  Sets the read/write pointer to a new position.
      *=========================================================================
      *  Parameters:
      *   i_hFile       - The handle of a file opened by f_openIfsFile().
      *   i_offset      - The new position of the read/write pointer.
      *   i_whence      - The base position to count i_offset from:
      *                   SEEK_SET       The start of the file.
      *                   SEEK_CUR       The current file offset in the file.
      *                   SEEK_END       The end of the file.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   rc            - Returns the file size on success, else -1.
      *=========================================================================
     P f_seekIfsFile...
     P                 B                   export
      *
     D f_seekIfsFile...
     D                 PI            10I 0
     D i_hFile                             const  like(ifs_hFile_t   )
     D i_offset                      10I 0 const
     D i_whence                      10I 0 const
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D newOffset       S             10I 0 inz
      *
      *  Parameter positions
     D p_isMsg         C                   const(4)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
      *
      /COPY QIFS,IFS1008
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_seekIfsFile...
     P                 E
      *
      *=========================================================================
      *  Reads entries of a given directory.
      *=========================================================================
      *  Parameters:
      *   i_path        - The name of an IFS directory.
      *                   Wildcard characters are: '*' and '?'.
      *   i_pCallback   - Procdure pointer of callback procedure.
      *                   The callback procedure is called for each entry
      *                   that matches the search criteria.
      *   i_pUserData   - Pointer to user data.
      *   i_options     - Options:                                   1) = Default settings.
      *                   cIFS_READDIR_DFT         Default settings.
      *                   cIFS_READDIR_FILES       List files.                       1)
      *                   cIFS_READDIR_DIR         List directories.                 1)
      *                   cIFS_READDIR_ALL         List all directory entries
      *                   cIFS_READDIR_CB_NAME     Pass entry name to callback.      1)
      *                   cIFS_READDIR_CB_DIRENT   Pass dirent structure to callback.
      *                   cIFS_READDIR_SUBDIR      Process sub-directories.
      *                   cIFS_READDIR_PRE_ORDER   first callback, then subdirectory 1)
      *                   cIFS_READDIR_POST_ORDER  first subdirectory, then callback
      *   o_msg         - Error message.
      *
      *  Returns:
      *   rc            - Returns the number of entries found on success, else -1.
      * ------------------------------------------------------------------------
      *  Callback:      f_readDirIfs_path    (cIFS_READDIR_CB_NAME)
      *
      *  Parameters:
      *   i_level       - Nesting level. The first directory is level 1.
      *   i_directory   - Path of the current directory.
      *   i_entry       - Name of the current directory entry.
      *   i_type        - Type of the current directory entry.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   isOK          - Returns TRUE on succes, else FALSE.
      *
      * ------------------------------------------------------------------------
      *  Callback:      f_readDirIfs_dirent  (cIFS_READDIR_CB_DIRENT)
      *
      *  Parameters:
      *   i_level       - Nesting level. The first directory is level 1.
      *   i_directory   - Path of the current directory.
      *   i_dirent      - Structure dirent_t of the current directory entry.
      *   i_type        - Type of the current directory entry.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   numE          - Returns the number of files and subdirectories
      *                   on succes, else -1.
      *
      * ------------------------------------------------------------------------
      *  Known directory entry types:
      *   cIFS_DIRENT_TYPE_FILE      - File.
      *   cIFS_DIRENT_TYPE_DOCUMENT  - Document, member of folder in QDLS.
      *   cIFS_DIRENT_TYPE_DIRECTORY - Directory.
      *   cIFS_DIRENT_TYPE_FOLDER    - Folder, contained in QDLS.
      *
      *=========================================================================
     P f_readIfsDir...
     P                 B                   export
      *
     D f_readIfsDir...
     D                 PI            10I 0
     D i_path                              const  like(ifs_path_t    )
     D i_pCallback                     *   const  procptr
     D i_options                     10I 0 const  options(*nopass: *omit)
     D i_pUserData                     *   const  options(*nopass: *omit)
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D numEntries      S             10I 0 inz
      *
      *  Parameter positions
     D p_isOptions     C                   const(3)
     D p_isPUserData   C                   const(4)
     D p_isMsg         C                   const(5)
      *
      *  Fields for optional parameters
     D pUserData       S                   like(i_pUserData) inz
     D options         S                   like(i_options  ) inz
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0                   inz
     D doAllEntries    S               N                     inz(cFalse)
     D isPreOrder      S               N                     inz(cFalse)
     D isPostOrder     S               N                     inz(cFalse)
     D path            S                   like(i_path     ) inz
     D directory       S                   like(i_path     ) inz
     D pattern         S                   like(i_path     ) inz
     D entry           S                   like(i_path     ) inz
     D numSubEntries   S                   like(numEntries ) inz
     D pDIR            S               *                     inz
     D level           S             10I 0                   inz   static
      /if not defined(*V5R2M0)
     D objType         S                   like(st_stat_t.objType) inz
      /endif
     D dirEnt          DS                  likeds(dirent_t ) based(pDirEnt)
     D st_stat         DS                  likeds(st_stat_t) inz
      *
      *  Callback Procedures
      *
     D pf_readDirIfs_path...
     D                 S               *   procptr
      *
     D pf_readDirIfs_dirent...
     D                 S               *   procptr
      *
     D f_readDirIfs_path...
     D                 PR              N   extproc(pf_readDirIfs_path)
     D  i_level                      10I 0 value
     D  i_directory                        value  like(ifs_path_t    )
     D  i_file                             value  like(ifs_path_t    )
     D  i_type                             value  like(ifs_type_t    )
     D  i_pUserData                    *   value
     D  o_msg                              value  like(msg_t         )
      *
     D f_readDirIfs_dirent...
     D                 PR              N   extproc(pf_readDirIfs_dirent)
     D  i_level                      10I 0 value
     D  i_directory                        value  like(ifs_path_t    )
     D  i_dirent                           value  likeds(dirent_t    )
     D  i_type                             value  like(ifs_type_t    )
     D  i_pUserData                    *   value
     D  o_msg                              value  like(msg_t         )
      *
      /COPY QIFS,IFS1017
      /COPY QIFS,IFS1018
      /COPY QIFS,IFS1019
      /COPY QIFS,IFS1020
      * ---------------------------------------------------------
      /free

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
      /if not defined(*V5R2M0)
                              objType = st_stat.objType;
                              if   not f_readDirIfs_path(
                                             level: directory: entry:
                                             %str(%addr(objType)):
                                             i_pUserData: msg);
                                 leave;
                              endif;
      /else
                              if   not f_readDirIfs_path(
                                             level: directory: entry:
                                             %str(%addr(st_stat.objType)):
                                             i_pUserData: msg);
                                 leave;
                              endif;
      /endif

                              // Add entries to total number of entries.
                              numEntries = numEntries + 1;
                           when   f_isBitOn(cIFS_READDIR_CB_DIRENT: options);
                              pf_readDirIfs_dirent = i_pCallback;
      /if not defined(*V5R2M0)
                              objType = st_stat.objType;
                              if   not f_readDirIfs_dirent(
                                             level: directory: dirent:
                                             %str(%addr(objType)):
                                             i_pUserData: msg);
                                 leave;
                              endif;
      /else
                              if   not f_readDirIfs_dirent(
                                             level: directory: dirent:
                                             %str(%addr(st_stat.objType)):
                                             i_pUserData: msg);
                                 leave;
                              endif;
      /endif

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

      /end-free
      *
     P f_readIfsDir...
     P                 E
      *
      *=========================================================================
      *  Creates a new IFS directory.
      *=========================================================================
      *  Parameters:
      *   i_directory   - Directory to create.
      *   i_options     - Options:
      *                   cIFS_MKDIR_DFT           Default settings.
      *                   cIFS_MKDIR_RECURSION     Create directories recursively
      *   i_auth        - Authority. See: f_openIfsFile()
      *   o_msg         - Error message.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P f_crtIfsDir...
     P                 B                   export
      *
     D f_crtIfsDir...
     D                 PI            10I 0
     D  i_directory                        const  like(ifs_path_t    )
     D  i_options                    10I 0 const  options(*nopass: *omit)
     D  i_auth                       10I 0 const  options(*nopass: *omit)
     D  o_msg                                     like(msg_t      )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D rc              S             10I 0 inz(cIFS_ERROR)
      *
      *  Parameter positions
     D p_isOptions     C                   const(2)
     D p_isAuth        C                   const(3)
     D p_isMsg         C                   const(4)
      *
      *  Fields for optional parameters
     D options         S                   like(i_options  ) inz
     D auth            S                   like(i_auth     ) inz
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Helper fields
     D x               S             10I 0 inz
     D y               S             10I 0 inz
     D directory       S                   like(ifs_pathV_t) inz
     D homeDir         S                   like(ifs_pathV_t) inz
     D newDir          S                   like(ifs_pathV_t) inz
     D tmpAuth         S                   like(auth       ) inz
      *
      *  stat() result data structure
     D st_stat         DS                  likeds(st_stat_t) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
     D isRecursion     S               N   inz(cFalse)
      *
      /COPY QIFS,IFS1024
      /COPY QIFS,IFS1025
      /COPY QIFS,IFS1026
      /COPY QIFS,IFS1027
      /COPY QIFS,IFS1032
      /COPY QIFS,IFS1033
      * ---------------------------------------------------------
      /free

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
           /if defined(*V5R2M0)
                  tmpAuth = %bitand(st_stat.mode: S_IRWXU + S_IRWXG + S_IRWXO);
           /else
                  tmpAuth = lf_bitand(st_stat.mode:S_IRWXU + S_IRWXG + S_IRWXO);
           /endif
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
           /if defined(*V5R2M0)
                  tmpAuth = %bitand(st_stat.mode: S_IRWXU + S_IRWXG + S_IRWXO +
                                                  S_ISUID + S_ISGID + S_ISVTX);
           /else
                  tmpAuth = lf_bitand(st_stat.mode:S_IRWXU + S_IRWXG + S_IRWXO +
                                                   S_ISUID + S_ISGID + S_ISVTX);
           /endif
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

      /end-free
      *
     P f_crtIfsDir...
     P                 E
      *
      *=========================================================================
      *  Deletes a given IFS directory.
      *=========================================================================
      *  Parameters:
      *   i_directory   - Directory to delete.
      *   i_options     - Options:
      *                   cIFS_RMDIR_DFT                    Default settings.
      *                   cIFS_RMDIR_DELETE_FILES           Delete files.
      *                   cIFS_RMDIR_DELETE_SUB_DIRECTORIES Delete subdirectories.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   rc            - Returns number of deleted files and directories
      *                   on success, else -1.
      *=========================================================================
     P f_dltIfsDir...
     P                 B                   export
      *
     D f_dltIfsDir...
     D                 PI            10I 0
     D  i_directory                        const  like(ifs_path_t    )
     D  i_options                    10I 0 const  options(*nopass: *omit)
     D  o_msg                                     like(msg_t      )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D rc              S             10I 0 inz(cIFS_ERROR)
      *
      *  Parameter positions
     D p_isOptions     C                   const(2)
     D p_isMsg         C                   const(3)
      *
      *  Fields for optional parameters
     D options         S                   like(i_options  ) inz
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Helper fields
     D subDirOptions   S             10I 0 inz
     D directory       S                   like(ifs_pathV_t) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
     D isTestMode      S               N   inz(cFalse)
     D isFiles...
     D                 S               N   inz(cFalse)
     D isSubDirectories...
     D                 S               N   inz(cFalse)
     D pRemoveProc     S               *   procptr           inz
     D tmpMsg          DS                  likeds(msg_t    ) inz
      *
      /COPY QIFS,IFS1024
      /COPY QIFS,IFS1031
      * ---------------------------------------------------------
      /free

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
                  subDirOptions = subDirOptions + cIFS_READDIR_SUBDIR +                     //RADDAT
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

      /end-free
      *
     P f_dltIfsDir...
     P                 E
      *
      *=========================================================================
      *  Returns cTrue if a given directory is empty, else cFalse.
      *=========================================================================
      *  Parameters:
      *   i_dir         - The name of an IFS directory.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   rc            - Returns cTrue if the directory is empty, else cFalse.
      *=========================================================================
     P f_isIfsDirEmpty...
     P                 B                   export
      *
     D f_isIfsDirEmpty...
     D                 PI              N
     D i_dir                               const  like(ifs_path_t    )
     D o_msg                                      like(msg_t         )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D isEmpty         S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_isMsg         C                   const(2)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Local fields
     D isPresent       S             10I 0                   inz
     D isDirOpen       S               N                     inz(cFalse)
     D dir             S                   like(i_dir      ) inz
     D pDIR            S               *                     inz
     D entry           S              4A                     inz
     D dirEnt          DS                  likeds(dirent_t ) based(pDirEnt)
      *
      /COPY QIFS,IFS1017
      /COPY QIFS,IFS1019
      /COPY QIFS,IFS1020
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_isIfsDirEmpty...
     P                 E
      *
      *=========================================================================
      *  Returns the current working directory.
      *=========================================================================
      *  Parameters:
      *   o_msg         - Error message.
      *
      *  Returns:
      *   dir           - Current directory.
      *=========================================================================
     P f_getIfsCurDir...
     P                 B                   export
      *
     D f_getIfsCurDir...
     D                 PI                         like(ifs_path_t    )
     D  o_msg                                     like(msg_t      )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D dir             S                   like(ifs_path_t    ) inz
      *
      *  Parameter positions
     D p_isMsg         C                   const(1)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Helper fields
     D tmpDir          S                   like(ifs_path_t ) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
      *
      /COPY QIFS,IFS1029
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_getIfsCurDir...
     P                 E
      *
      *=========================================================================
      *  Changes the current working directory.
      *=========================================================================
      *  Parameters:
      *   i_dir         - Directory that should become the current directory.
      *   o_msg         - Error message.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P f_chgIfsCurDir...
     P                 B                   export
      *
     D f_chgIfsCurDir...
     D                 PI            10I 0
     D  i_dir                              const  like(ifs_path_t    )
     D  o_msg                                     like(msg_t      )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D rc              S             10I 0 inz(RC_ERROR)
      *
      *  Parameter positions
     D p_isMsg         C                   const(2)
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Helper fields
     D tmpDir          DS                  likeds(Qlg_Path_Name_t) inz
      *
      *  Local fields
     D isPresent       S             10I 0 inz
      *
      /COPY QIFS,IFS1030
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P f_chgIfsCurDir...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Removes the entries of a given directory.
      *=========================================================================
     P lf_removeDirectoryEntry...
     P                 B
      *
     D lf_removeDirectoryEntry...
     D                 PI              N
     D  i_level                      10I 0 value
     D  i_directory                        value  like(ifs_path_t    )
     D  i_entry                            value  like(ifs_path_t    )
     D  i_type                             value  like(ifs_type_t    )
     D  i_pUserData                    *   value
     D  o_msg                              value  like(msg_t         )
      *
      *  Local fields
     D tmpPath         S                   like(ifs_path_t ) inz
     D tmpMsg          DS                  likeds(msg_t    ) inz
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P lf_removeDirectoryEntry...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Removes the entries of a given directory (test mode).
      *=========================================================================
     P lf_removeDirectoryEntryTestMode...
     P                 B
      *
     D lf_removeDirectoryEntryTestMode...
     D                 PI              N
     D  i_level                      10I 0 value
     D  i_directory                        value  like(ifs_path_t    )
     D  i_entry                            value  like(ifs_path_t    )
     D  i_type                             value  like(ifs_type_t    )
     D  i_pUserData                    *   value
     D  o_msg                              value  like(msg_t         )
      *
      *  Local fields
     D options         S             10I 0 based(i_pUserData)
     D tmpPath         S                   like(ifs_path_t ) inz
     D tmpMsg          DS                  likeds(msg_t    ) inz
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P lf_removeDirectoryEntryTestMode...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Adds the file path to the local file handle table, because there is
      *  no way to get the path back from the Unix file handle.
      *=========================================================================
     P lp_addEntryToFileHandleTable...
     P                 B
      *
     D lp_addEntryToFileHandleTable...
     D                 PI
     D i_hFile                             const  like(ifs_hFile_t)
     D i_path                              const  like(ifs_path_t )
     D i_useTmpBuffer                  N   const
      *
      *  Local fields
     D i               S             10I 0 inz
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P lp_addEntryToFileHandleTable...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Gets the path from the local file handle.
      *=========================================================================
     P lf_getPathFromFileHandleTable...
     P                 B
      *
     D lf_getPathFromFileHandleTable...
     D                 PI                  like(ifs_path_t)
     D i_hFile                             const  like(ifs_hFile_t)
      *
      *  Return value
     D path            S                   like(ifs_path_t ) inz('*N')
      *
      *  Localfields
     D i               S             10I 0 inz
      * ---------------------------------------------------------
      /free

         // Search for the file handle
         i = lf_getFileHandleTableIndex(i_hFile);
         if   i > 0;
            // and get back the path
            path = g_handleList.path(i);
         endif;

         return   path;

      /end-free
      *
     P lf_getPathFromFileHandleTable...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Returns TRUE if f_writeLineIfsFile() must use a temporary
      *  buffer, else FALSE
      *=========================================================================
     P lf_useTmpBuffer...
     P                 B
      *
     D lf_useTmpBuffer...
     D                 PI              N
     D i_hFile                             const  like(ifs_hFile_t)
      *
      *  Return value
     D useTmpBuffer    S               N   inz(cFalse)
      *
      *  Localfields
     D i               S             10I 0 inz
      * ---------------------------------------------------------
      /free

         // Search for the file handle
         i = lf_getFileHandleTableIndex(i_hFile);
         if   i > 0;
            useTmpBuffer = g_handleList.useTmpBuffer(i);
         endif;

         return useTmpBuffer;

      /end-free
      *
     P lf_useTmpBuffer...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Checks and reallocates size of temporary write buffer. Returns
      *  buffer pointer.
      *=========================================================================
     P lf_checkAndReallocateTmpBuffer...
     P                 B
      *
     D lf_checkAndReallocateTmpBuffer...
     D                 PI              *
     D i_hFile                             const  like(ifs_hFile_t)
     D i_newSize                     10I 0 const
      *
      *  Return value
     D pTmpBuffer      S               *   inz
      *
      *  Localfields
     D i               S             10I 0 inz
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P lf_checkAndReallocateTmpBuffer...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Returns the file handle table index for a given file handle.
      *=========================================================================
     P lf_getFileHandleTableIndex...
     P                 B
      *
     D lf_getFileHandleTableIndex...
     D                 PI            10I 0
     D i_hFile                             const  like(ifs_hFile_t)
      *
      *  Return value
     D index           S             10I 0 inz(-1)
      *
      *  Localfields
     D i               S             10I 0 inz
      * ---------------------------------------------------------
      /free

         // Search for the file handle
         i = %lookup(i_hFile: g_handleList.hFile: 1: g_numHandles);
         if (i > 0);
            index = 1;
         endif;

         return index;

      /end-free
      *
     P lf_getFileHandleTableIndex...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Removes the path from the local file handle.
      *=========================================================================
     P lp_removeEntryFromFileHandleTable...
     P                 B
      *
     D lp_removeEntryFromFileHandleTable...
     D                 PI
     D i_hFile                             const  like(ifs_hFile_t)
      *
      *  Local fields
     D i               S             10I 0 inz
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P lp_removeEntryFromFileHandleTable...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Converts a timestamp from Epoch to RPG format.
      *=========================================================================
     P lf_cvtEpochTmStmpToRpgTmStmp...
     P                 B
      *
     D lf_cvtEpochTmStmpToRpgTmStmp...
     D                 PI              Z
     D i_epochTmStmp                 10I 0 value
      *
      *  Return value
     D tmStmp          S               Z   inz
      *
      *  Local fields
     D ftimef          S             16A   inz('%Y-%m-%d%H.%M.%S')
      *
     D ftimest         DS                  qualified
     D  date                         10A
     D  time                          8A
     D  null                          1A   inz(x'00')
      *
     D time            DS                  likeds(tm_t)  inz
      * ---------------------------------------------------------
      /free

         if   localtime_r(i_epochTmStmp: time) <> *NULL;
            if   strftime(%addr(ftimest) :
                          %size(ftimest) :
                          %trim(ftimef)  :
                          time           ) > 0;
               tmStmp=%timestamp(ftimest.date + '-' + ftimest.time + '.000000');
            endif;
         endif;

         return   tmStmp;

      /end-free
      *
     P lf_cvtEpochTmStmpToRpgTmStmp...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Creates a IFS message.
      *=========================================================================
     P lf_newIfsMsg...
     P                 B
      *
     D lf_newIfsMsg...
     D                 PI                         likeds(msg_t  )
     D  i_ID                               const  like(msg_t.id    )
     D                                            options(*omit: *nopass)
     D  i_data                      512A   const  varying
     D                                            options(*omit: *nopass)
     D  i_type                             const  like(msg_t.type  )
     D                                            options(*omit: *nopass)
      *
      *  Return value
     D msg             DS                  likeds(msg_t  )
      *
      *  Parameter positions
     D p_ID            C                   const(1)
     D p_data          C                   const(2)
     D p_type          C                   const(3)
      *
      *  Optional parameter fields
     D ID              S                   like(i_ID      ) inz
     D data            S                   like(i_data    ) inz
     D type            S                   like(i_type    ) inz
      *
      *  Local fields
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P lf_newIfsMsg...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Checks whether an IFS object is a file;
      *=========================================================================
     P lf_isFile...
     P                 B
      *
     D lf_isFile...
     D                 PI              N
     D  i_st_stat                          const  likeds(st_stat_t )
      *
      *  Return value
     D isFile          S               N   inz(cFalse)
      /if not defined(*V5R2M0)
      *
      *  Local fields
     D objType         S                   like(st_stat_t.objType) inz
      /endif
      * ---------------------------------------------------------
      /free

      /if not defined(*V5R2M0)
         objType = i_st_stat.objType;
         if   (%str(%addr(objType)) = cIFS_DIRENT_TYPE_FILE    ) or
              (%str(%addr(objType)) = cIFS_DIRENT_TYPE_DOCUMENT);
      /else
         if   (%str(%addr(i_st_stat.objType)) = cIFS_DIRENT_TYPE_FILE    ) or
              (%str(%addr(i_st_stat.objType)) = cIFS_DIRENT_TYPE_DOCUMENT);
      /endif
            isFile = cTrue;
         else;
            isFile = cFalse;
         endif;

         return   isFile;

      /end-free
      *
     P lf_isFile...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Checks whether an IFS object is a directory;
      *=========================================================================
     P lf_isDir...
     P                 B
      *
     D lf_isDir...
     D                 PI              N
     D  i_st_stat                          const  likeds(st_stat_t )
      *
      *  Return value
     D isDir           S               N   inz(cFalse)
      /if not defined(*V5R2M0)
      *
      *  Local fields
     D objType         S                   like(st_stat_t.objType) inz
      /endif
      * ---------------------------------------------------------
      /free

      /if not defined(*V5R2M0)
         objType = i_st_stat.objType;
         if   (%str(%addr(objType)) = cIFS_DIRENT_TYPE_DIRECTORY) or
              (%str(%addr(objType)) = cIFS_DIRENT_TYPE_FOLDER   );
      /else
         if   (%str(%addr(i_st_stat.objType)) = cIFS_DIRENT_TYPE_DIRECTORY) or
              (%str(%addr(i_st_stat.objType)) = cIFS_DIRENT_TYPE_FOLDER   );
      /endif
            isDir = cTrue;
         else;
            isDir = cFalse;
         endif;

         return   isDir;

      /end-free
      *
     P lf_isDir...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Checks whether an IFS object matches a given string pattern.
      *=========================================================================
     P lf_isEntryEqual...
     P                 B
      *
     D lf_isEntryEqual...
     D                 PI              N
     D  i_entry                            value  like(ifs_path_t  )
     D  i_pattern                          value  like(ifs_path_t  )
      *
      *  Return value
     D isEqual         S               N   inz(cFalse)
      *
      *  Local fields
     D x               S             10I 0 inz
     D wildcard        DS                  qualified
     D  group                         1A   inz('*')
     D  single                        1A   inz('?')
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P lf_isEntryEqual...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Initializes the path structure for the Qp0lGetAttr API.
      *=========================================================================
     P lf_initializePath...
     P                 B
      *
     D lf_initializePath...
     D                 PI                         like(ifs_path_t       )
     D i_path                              const  likeds(Qlg_Path_Name_t)
      *
      *  Return value
     D path            DS                  likeds(Qlg_Path_Name_t   ) inz
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P lf_initializePath...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Retrieves a file 'time' attribute.
      *=========================================================================
     P lf_getIfsFileTimeAttr...
     P                 B
      *
     D lf_getIfsFileTimeAttr...
     D                 PI            10I 0
     D i_path                              const  like(ifs_path_t    )
     D i_attr                        10I 0 const
     D o_time                          Z
      *
      *  Return value
     D rc              S             10I 0 inz
      *
      *  Helper fields
     D bytPrv          S             10U 0 inz
     D sizeNeeded      S             10U 0 inz
     D bytRet          S             10U 0 inz
     D path            DS                  likeds(Qlg_Path_Name_t   ) inz
     D attrArray       DS                  likeds(Qlg_attrArray_t   ) inz
     D rtnAttr         DS                  likeds(Qlg_rtnAttr_t     )
     D                                     based(pRtnAttr)
     D timeEpo         S             10U 0 based(pTimeEpo)
      * ---------------------------------------------------------
      /free

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

      /end-free
      *
     P lf_getIfsFileTimeAttr...
     P                 E
      *
      /if not defined(*V5R2M0)
      *===============================================================*
      *  bitand() for V5R1 and below.
      *===============================================================*
     P lf_bitand...
     P                 B
      *
     D lf_bitand...
     D                 PI            10U 0
     D  i_arg1                       10U 0 value
     D  i_arg2                       10U 0 value
      *
     D result          S             10U 0
      *
      *  AND String (ANDSTR) - MI Instruction
      *  (http://publib.boulder.ibm.com/iseries/v5r1/ic2924/tstudio/tech_ref/mi/topics.htm)
     D ANDSTR...
     D                 PR                  extproc('_ANDSTR')
     D  i_pReceiver                    *   value
     D  i_pFirstSrc                    *   value
     D  i_pSecondSrc                   *   value
     D  i_length                     10U 0 value
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         ANDSTR(%addr(result): %addr(i_arg1): %addr(i_arg2): %len(result));

         return result;

      /END-FREE
      *
     P lf_bitand...
     P                 E
      *
      /endif
