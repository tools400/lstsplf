**free
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
//  Datum       Name          nderung                                 *
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
//                              BNDSRVPGM(*LIBL/LSTSPLF) +             *
//                              ACTGRP(*NEW) +                         *
//                              DETAIL(*BASIC);                        *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
ctl-opt extbinint(*yes);
ctl-opt datfmt(*iso) timfmt(*iso) debug(*yes);
//=====================================================================*
/copy qlstsplf,plstsplf List Spooled Files - Public Interface
/copy qlstsplf,puslutils Utility for IBM QUSL* List APIs

/copy qlstsplf,quslspl List Spooled files(QUSLSPL) API
/copy qlstsplf,qusrspla Retrieve Spooled File attributes(QUSRSPLA) API
/copy qlstsplf,fdmsg

dcl-pr LSTSPLF_T extpgm('LSTSPLF_T');
  gi_user    char(10) const;
  gi_outQ    char(10) const;
  gi_outQLib char(10) const;
end-pr;

//  Internal prototypes
dcl-pr p_main;
  i_user    char(10) const;
  i_outQ    char(10) const;
  i_outQLib char(10) const;
end-pr;

//*******************************************************************
//  Program Entry Point
//*******************************************************************
dcl-pi LSTSPLF_T;
  gi_user    char(10) const;
  gi_outQ    char(10) const;
  gi_outQLib char(10) const;
end-pi;

Utils_openPrinter();

p_main(gi_user: gi_outQ: gi_outQLib);

Utils_closePrinter();

*inlr = *on;


//==================================================================*
//  Main procedure
//==================================================================*
dcl-proc p_main export;
  dcl-pi *n;
    i_user    char(10) const;
    i_outQ    char(10) const;
    i_outQLib char(10) const;
  end-pi;

  dcl-s hSplFLst like(lstSplF_handle_t) inz;
  dcl-s isOpen ind inz;
  dcl-s isFound ind inz;

  dcl-ds splf0100 likeds(splf0100_t) inz;
  dcl-ds spla0100 likeds(spla0100_t) inz;

  dcl-ds output qualified;
    blank1 char(1) inz;
    col1   char(10) inz;
    blank2 char(1) inz;
    col2   char(10) inz;
    blank3 char(1) inz;
    col3   char(10) inz;
  end-ds;

  dcl-s ok char(1) inz;
  dcl-s msg like(msg_t) inz;
  //-------------------------------------------------------------------

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

end-proc;

