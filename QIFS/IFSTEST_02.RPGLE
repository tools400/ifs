      *===============================================================*
      *    CALL PGM(IFSTEST_02) PARM('/home/raddatz/Lazy_Dog.txt')    *
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
     D                 PR                         extpgm('IFSTEST_02')
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
     D buffer          S            256A                      inz(*ALLx'00')
     D msg             DS                  likeds(msg_t     ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Open IFS file (The file must exists!)
         // Open flags:     read
         //                 share with readers
         //                 open for text data
         hFile = f_openIfsFile(%trim(i_path): O_RDONLY + O_SHARE_RDONLY +
                                              O_TEXTDATA);

         // Read lines until EOF
         bytesRed = f_readLineIfsFile(
                       hFile: %addr(buffer): %size(buffer): *omit: msg);
         dow   bytesRed <> cIFS_EOF;
            msg = f_newMsg('CPF9897': 'Num bytes: ' +
                              %char(bytesRed) + ':' + f_left(buffer: bytesRed));
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

            reset buffer;
            bytesRed = f_readLineIfsFile(
                          hFile: %addr(buffer): %size(buffer): *omit: msg);
         enddo;

         // Close IFS file
         f_closeIfsFile(hFile);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
