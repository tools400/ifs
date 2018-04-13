      *===============================================================*
      *    CALL PGM(IFSTEST_32) PARM('/home/raddatz/fileName')        *
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
      *                              BNDSRVPGM(&LI/IFS    ) +         *
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
      *
      * ------------------------------------
      *  External Prototypes
      * ------------------------------------
      /COPY QIFS,PIFS
      /COPY QBASICS1,PBASICS1
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
     D                 PR                         extpgm('IFSTEST_32')
     D  gi_path                      32A   const  options(*nopass)
      *
     D main...
     D                 PR
     D  i_path                      256A   const  varying
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_path                      32A   const  options(*nopass)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= 1);
            main(%trim(gi_path));
         else;
            main('/home/Raddatz/test_ifs/file_5.txt');
         endif;

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
     D  i_path                      256A   const  varying
      *
      *  Helper fields
     D hFile           S                   like(ifs_hFile_t ) inz
     D bytesRed        S             10I 0                    inz
     D buffer          S             64A                      inz
     D size            S             10I 0                    inz
     D crtTime         S               Z                      inz
     D chgTime         S               Z                      inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Open IFS file (The file must not yet exists!)
         // Open flags:     write
         //                 share with readers
         //                 create file, send message if file exists
         //                 open for text data
         //                 ccsid = 1208
         hFile = f_openIfsFile(%trim(i_path): O_WRONLY + O_SHARE_RDONLY +
                                              O_CREAT + O_EXCL + O_TEXTDATA +
                                              O_CCSID: 1208);

         f_writeLineIfsFile(hFile
                            : 'This has has been created using ccsid 1208': 0);
         f_writeLineIfsFile(hFile
                            : '': 0);
         f_writeLineIfsFile(hFile
                            :'Default authority set by IFS service program:':0);
         f_writeLineIfsFile(hFile
                            : '': 0);
         f_writeLineIfsFile(hFile
                            :'              Data     --Object Authorities--':0);
         f_writeLineIfsFile(hFile
                            :'User        Authority  Exist  Mgt  Alter  Ref':0);
         f_writeLineIfsFile(hFile
                            :'                                             ':0);
         f_writeLineIfsFile(hFile
                            :'*PUBLIC     *RWX         X     X     X     X ':0);
         f_writeLineIfsFile(hFile
                            :'RADDATZ     *RWX         X     X     X     X ':0);


         // Close IFS file
         f_closeIfsFile(hFile);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
