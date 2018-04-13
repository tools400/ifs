      *===============================================================*
      *    CALL PGM(IFSTEST_07) PARM('/home/raddatz/fileName.ext')    *
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
      /COPY QBASICS1,PBASICS1
      *
     D PGM_ENTRY_POINT...
     D                 PR                         extpgm('IFSTEST_07')
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
     D x               S             10I 0                inz
     D y               S             10I 0                inz
     D path            S             32A   varying        inz
     D extension       S             32A   varying        inz
     D extension1      S             32A   varying        inz
     D extension2      S             32A   varying        inz
     D path1           S             32A   varying        inz
     D path2           S             32A   varying        inz
     D path_wo_ext     S             32A   varying        inz
     D msg             DS                  likeds(msg_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         path = %trimR(i_path);

         // Retrieve extension of passed in path
         x = f_scanR('.': path);
         if (x > 0) and (x < %len(path));
            extension1 = %subst(path: x + 1);
            extension2 = f_rtvIfsFileExtFromPath(path);
            p_assert(extension1 = extension2);
            msg = f_newMsg('CPF9897': 'Ext.= ' + path + ' - ' + extension2);
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);
         endif;

         // Remove extension of passed in path
         if (x > 1);
            path1 = %subst(path: 1: x - 1);
            path2 = f_rmvIfsFileExtFromPath(path);
            p_assert(path1 = path2);
            msg = f_newMsg('CPF9897': 'Path= ' + path + ' - ' + path2);
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);
         endif;

         // Retrieve extensions
         extension = 'anExt';

         for y = %len(extension) + 2 downto 0;

            path = '/home/theFileName.' + extension;
            path = %subst(path: 1: %len(path) - y);

            x = f_scanR('.': path);
            if (x > 0) and (x < %len(path));
               extension1 = %subst(path: x + 1);
            else;
               extension1 = '';
            endif;
            extension2 = f_rtvIfsFileExtFromPath(path);
            p_assert(extension1 = extension2);
            msg = f_newMsg('CPF9897': 'Ext.= ' + path + ' - ' + extension2);
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);

         endfor;

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
