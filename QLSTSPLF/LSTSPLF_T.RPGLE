       //=====================================================================*
       //  Author  :  Thomas Raddatz                                          *
       //  Date    :  16.09.2002                                              *
       //  E-mail  :  thomas.raddatz@tools400.de                              *
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
       //  26.09.2002  Th.Raddatz    Added reference field msg_t.             *
       //  26.09.2002  Th.Raddatz    Added msg parameter to the               *
       //                            f_opnSplFLst() procedure call to get     *
       //                            error message back to caller.            *
       //  26.02.2019  Th.Raddatz    Converted to /free.                      *
       //                                                                     *
       //=====================================================================*
       //   >>PRE-COMPILER<<                                                  *
       //     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
       //                              SRCFILE(&SL/&SF) SRCMBR(&SM);          *
       //     >>IMPORTANT<<                                                   *
       //       >>PARM<< TRUNCNBR(*NO);                                       *
       //       >>PARM<< DBGVIEW(*LIST);                                      *
       //       >>PARM<< OPTION(*EVENTF);                                     *
       //     >>END-IMPORTANT<<                                               *
       //     >>EXECUTE<<                                                     *
       //     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                         *
       //                              MODULE(&LI/&OB +                       *
       //                                     &LI/USLUTILS) +                 *
       //                              BNDSRVPGM(&LI/LSTSPLF) +               *
       //                              ACTGRP(*NEW) +                         *
       //                              DETAIL(*BASIC);                        *
       //   >>END-PRE-COMPILER<<                                              *
       //=====================================================================*
     H EXTBININT(*YES)
     H DATFMT(*ISO) TIMFMT(*ISO) DEBUG(*YES)
       //=====================================================================*
      /copy qlstsplf,plstsplf                     List Spooled Files - Public Interface
      /copy qlstsplf,puslutils                    Utility for IBM QUSL* List APIs

      /copy qlstsplf,quslspl                      List Spooled Files (QUSLSPL) API
      /copy qlstsplf,qusrspla                     Retrieve Spooled File Attributes (QUSRSPLA) API
      /copy qlstsplf,fdmsg

     D LSTSPLF_T...
     D                 PR                  extpgm('LSTSPLF_T')
     D  gi_user                      10A   const
     D  gi_outQ                      10A   const
     D  gi_outQLib                   10A   const

       //  Internal prototypes
     D p_main...
     D                 PR
     D  i_user                       10A   const
     D  i_outQ                       10A   const
     D  i_outQLib                    10A   const

       //*******************************************************************
       //  Program Entry Point
       //*******************************************************************
     D LSTSPLF_T...
     D                 PI
     D  gi_user                      10A   const
     D  gi_outQ                      10A   const
     D  gi_outQLib                   10A   const
      /free

       Utils_openPrinter();

       p_main(gi_user: gi_outQ: gi_outQLib);

       Utils_closePrinter();

       *inlr = *on;

      /end-free

       //==================================================================*
       //  Main procedure
       //==================================================================*
     P p_main...
     P                 B                   export
     D                 PI
     D  i_user                       10A   const
     D  i_outQ                       10A   const
     D  i_outQLib                    10A   const

     D hSplFLst        S                   like(lstSplF_handle_t) inz
     D isOpen          S               N   inz
     D isFound         S               N   inz

     D splf0100        DS                  likeds(splf0100_t) inz
     D spla0100        DS                  likeds(spla0100_t) inz

     D output          DS                  qualified
     D  blank1                        1A   inz
     D  col1                         10A   inz
     D  blank2                        1A   inz
     D  col2                         10A   inz
     D  blank3                        1A   inz
     D  col3                         10A   inz

     D ok              S              1A   inz
     D msg             S                   like(msg_t     )  inz
       //-------------------------------------------------------------------
      /free

       //  Print headline
       Utils_print('Spooled files of user ' + %trim(i_user) +
                   ' sorted by *USRDTA');

       Clear output;
       output.col1 = 'SplF';
       output.col2 = 'User';
       output.col3 = '*USRDTA';
       Utils_print(output);

       Clear output;
       output.col1 = *ALL'-';
       output.col2 = *ALL'-';
       output.col3 = *ALL'-';
       Utils_print(output);

       //  Open list of spooled files
       isOpen = f_opnSplFLst(i_user    :                                        // user
                            '*ALL'     :                                        // outQ
                            ''         :                                        // outQLib
                            '*ALL'     :                                        // formType
                            '*ALL'     :                                        // usrDta
                            '*USRDTA'  :                                        // sort by
                            hSplFLst   :                                        // handle
                            msg        );

       isFound = f_getFirstSplF(hSplFLst :
                               splf0100 );

       dow isFound;
          SPLA0100 = f_rtvSplFA(splf0100.intJobID: splf0100.intSplFID);

          Clear output;
          output.col1 = spla0100.splF;
          output.col2 = spla0100.user;
          output.col3 = spla0100.userData;
          Utils_print(output);

          isFound = f_getNextSplF(hSplFLst: splf0100);
       enddo;

       Utils_print('#entries: ' + %trim(%editc(f_getNumSplFAvl(hSplFLst):'Z')));

       //  Close list
       f_cloSplFLst(hSplFLst);

       Utils_print();

       //  Print headline
       Utils_print('Spooled files of all users of output queue ' +
                   %trim(i_outQLib) + '/' + %trim(i_outQ) +
                   ' sorted by *USERNAME');

       Clear output;
       output.col1 = 'User';
       output.col2 = 'SplF';
       output.col3 = '*USRDTA';
       Utils_print(output);

       Clear output;
       output.col1 = *ALL'-';
       output.col2 = *ALL'-';
       output.col3 = *ALL'-';
       Utils_print(output);

       //  Open list of spooled files
       isOpen = f_opnSplFLst('*ALL'    :                                        // user
                           i_outQ      :                                        // outQ
                           i_outQLib   :                                        // outQLib
                           '*ALL'      :                                        // formType
                           '*ALL'      :                                        // usrDta
                           '*USERNAME' :                                        // sort by
                           hSplFLst    :                                        // handle
                           msg         );

       isFound = f_getFirstSplF(hSplFLst: splf0100);

       dow isFound;
          SPLA0100 = f_rtvSplFA(splf0100.intJobID: splf0100.intSplFID);

          Clear output;
          output.col1 = spla0100.user;
          output.col2 = spla0100.splF;
          output.col3 = spla0100.userData;
          Utils_print(output);

          isFound = f_getNextSplF(hSplFLst: splf0100);
       enddo;

       Utils_print('#entries: ' + %trim(%editc(f_getNumSplFAvl(hSplFLst):'Z')));

       //  Close list
       f_cloSplFLst(hSplFLst);

      /end-free
     P                 E

