      *===============================================================*
      *    CALL PGM(IFSTEST_04) PARM('/home/raddatz/genStrCmp/*')     *
      *===============================================================*
      *   >>PRE-COMPILER<<                                            *
      *                                                               *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
      *                              SRCFILE(&SL/&SF) +               *
      *                              SRCMBR(&SM);                     *
      *                                                               *
      *     >>COMPILE<<                                               *
      *       >>PARM<< TRUNCNBR(*NO);                                 *
      *       >>PARM<< DBGVIEW(*LIST);                                *
      *       >>PARM<< TGTRLS(*CURRENT);                              *
      *     >>END-COMPILE<<                                           *
      *                                                               *
      *     >>EXECUTE<<                                               *
      *                                                               *
      *     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *
      *                              MODULE(&LI/&OB) +                *
      *                              ACTGRP(*NEW) +                   *
      *                              BNDSRVPGM(&LI/IFS      +         *
      *                                        &LI/BASICS1) +         *
      *                              BNDDIR(QC2LE         ) +         *
      *                              TGTRLS(*CURRENT) +               *
      *                              DETAIL(*BASIC);                  *
      *                                                               *
      *   >>END-PRE-COMPILER<<                                        *
      *===============================================================*
     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*DMY.)
     H DATFMT(*ISO )  TIMFMT(*ISO )
     H EXPROPTS(*RESDECPOS)
     H EXTBININT(*YES)
      *===============================================================*
      *
      * ------------------------------------
      *  Type Definitions
      * ------------------------------------
      /if not defined(*V5R2M0)
     D resultSet_t     DS                  template   qualified
     D  selectedPath                       like(ifs_path_t)
     D  msg                                like(msg_t   )
     D  numE                         10I 0
     D  entry                              like(entry_t) dim(10)
      *
     D entry_t         DS                  template   qualified
     D  type                               like(ifs_type_t)
     D  path                               like(ifs_path_t)
      /else
     D resultSet_t     DS                  template   qualified
     D  selectedPath                       like(ifs_path_t)
     D  msg                                likeds(msg_t   )
     D  numE                         10I 0
     D  entry                              likeds(entry_t) dim(10)
      *
     D entry_t         DS                  template   qualified
     D  type                               like(ifs_type_t)
     D  path                               like(ifs_path_t)
      /endif
      *
      * ------------------------------------
      *  External Prototypes
      * ------------------------------------
      /COPY QIFS,PIFS
      *
      * ------------------------------------
      *  Global Fields
      * ------------------------------------
      *
      * ------------------------------------
      *  Global Constants
      * ------------------------------------
      *
      * ------------------------------------
      *  Prototypes
      * ------------------------------------
      *
     D PGM_ENTRY_POINT...
     D                 PR                         extpgm('IFSTEST_98')
      *
     D main...
     D                 PR
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         main();

         *inlr = *on;

         return;

      /END-FREE
      *
      *===============================================================*
      *  Main procedure
      *===============================================================*
     P main...
     P                 B
      *
     D main...
     D                 PI
      *
      *  Helper fields
     D x               S             10I 0                     inz
     D fd              S                   like(ifs_hFile_t)   inz
     D tempFiles       S            256A   varying dim(10)     inz
     D dir             S            256A   varying             inz
      *
     D FILE_EXTENSION  C                   '.ifsTest_98'
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // -----------------------------------------------------
         //   Produce temporary files.
         // -----------------------------------------------------
         for x = 1 to %elem(tempFiles);
            tempFiles(x) = %trim(f_getIfsTmpPath()) + FILE_EXTENSION;
            fd = f_openIfsFile(tempFiles(x): O_CREAT + O_EXCL + O_WRONLY);
            f_writeLineIfsFile(fd: 'Test Serviceprogramm IFS': 0);
            f_closeIfsFile(fd);
            if (x = 1);
               dir = %trim(f_rtvIfsDirFromPath(tempFiles(x)));
            endif;
         endfor;

         // -----------------------------------------------------
         //   Read directory.
         // -----------------------------------------------------
         f_readIfsDir(dir + '/*' + FILE_EXTENSION
                      : %paddr('f_readDirIfs_path')
                      : cIFS_READDIR_DFT
                      : %addr(tempFiles));

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
      *===============================================================*
      *  Callback: f_readDirIfs_path()
      *===============================================================*
     P f_readDirIfs_path...
     P                 B                   export
      *
     D f_readDirIfs_path...
     D                 PI              N
     D  i_level                      10I 0 value
     D  i_directory                        value  like(ifs_path_t    )
     D  i_entry                            value  like(ifs_path_t    )
     D  i_type                             value  like(ifs_type_t    )
     D  i_pUsrDta                      *   value
     D  o_msg                              value  like(msg_t         )
      *
      *  Return value
     D isOK            S               N   inz(cFalse)
      *
     D isInit          S               N   inz(cFalse) static
     D tempFiles       S            256A   varying dim(10) based(i_pUsrDta)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (not isInit);
            f_deleteIfsFile(tempFiles(2));
            isInit = cTrue;
         endif;

         f_deleteIfsFile(%trim(i_directory) + %trim(i_entry));

         isOK = cTrue;

         return   isOK;

      /END-FREE
      *
     P f_readDirIfs_path...
     P                 E
      *
