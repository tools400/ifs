      *===============================================================*
      *    CALL PGM(IFSTEST_11) PARM('/home/raddatz/fileName')        *
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
     D                 PR                         extpgm('IFSTEST_11')
     D  gi_path                      32A   const
      *
     D main...
     D                 PR
     D  i_path                       32A   const
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_path                      32A   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         main(gi_path);

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
     D  i_path                       32A   const
      *
      *  Helper fields
     D hFile           S                   like(ifs_hFile_t ) inz
     D bytesRed        S             10I 0                    inz
     D buffer          S             64A                      inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Open IFS file (The file must not yet exists!)
         // Open flags:     read & write
         //                 share with readers
         //                 create file, send message if file exists
         //                 open for text data
         hFile = f_openIfsFile(%trim(i_path)
                               : O_CREAT + O_RDWR + O_CCSID + O_TRUNC +
                                 O_TEXTDATA + O_TEXT_CREAT
                               : 1208);

         // Write to file
         f_writeIfsFile(hFile: 'Hello World! (äöüÖÄÜß)': 0);
         f_writeIfsFile(hFile: x'0D0A': 0);
         f_writeIfsFile(hFile: %char(%timestamp()): 0);

         // Close IFS file
         f_closeIfsFile(hFile);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
