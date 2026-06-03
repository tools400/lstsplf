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
//  26.09.2002  Th.Raddatz    Added DEFINE statements to the           *
//                            reference fields to prevent compiler     *
//                            error message RNF3316                    *
//  26.09.2002  Th.Raddatz    Changed how the API error message is     *
//                            is assigned to o_msg in routine          *
//                            f_opnSplFLst() to ensure proper value.   *
//  03.06.2003  Th.Raddatz    Changed service program to use a pointer *
//                            instead of a data structure as the       *
//                            handle.                                  *
//                            Added reference field for handle.        *
//  30.06.2003  Th.Raddatz    Removed improper const keyword from      *
//                            prototypes: QUSCRTUS, QUSDLTUS,          *
//                                        QUSPTRUS, QUSLSPL.           *
//  30.06.2003  Th.Raddatz    Changed definition of errCode parameter  *
//                            to use reference field.                  *
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
//       >>PARM<< TGTRLS(V7R3M0);                                      *
//     >>END-IMPORTANT<<                                               *
//     >>EXECUTE<<                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
ctl-opt nomain;
ctl-opt option(*srcstmt: *nodebugio);
ctl-opt extbinint(*yes) bnddir('QC2LE');
ctl-opt datfmt(*iso) timfmt(*iso) debug(*yes);
/copy qlstsplf,copyright

/copy qlstsplf,quslspl List Spooled files(QUSLSPL) API
/copy qlstsplf,qusrspla Retrieve Spooled File attributes(QUSRSPLA) API
/copy qlstsplf,fdboolean Boolean constants
/copy qlstsplf,fdqobj qualified object name structure
/copy qlstsplf,fdmsg Message structure
/copy qlstsplf,fderrcode API error code
/copy qlstsplf,genlsthdr Generic list API header

/copy qlstsplf,plstsplf List Spooled Files - Public Interface
/copy qlstsplf,puslutils Utility for IBM QUSL* List APIs

// List handle
dcl-ds handle_t qualified template;
  pUsrSpc    pointer;
  entryIndex int(10);
  qUsrSpc    likeds(qObj_t);
  hRes_01    char(16);
end-ds;

// Internal prototypes
dcl-pr f_sortLst ind;
  i_pUsrSpc pointer value;
  i_compare char(10) value;
end-pr;

dcl-pr f_sortLstByUsrDta int(10);
  i_pKey     pointer value;
  i_pElement pointer value;
end-pr;

dcl-pr f_sortLstByUserName int(10);
  i_pKey     pointer value;
  i_pElement pointer value;
end-pr;

dcl-pr f_sortLstByPagesAsc int(10);
  i_pKey     pointer value;
  i_pElement pointer value;
end-pr;

dcl-pr f_sortLstByPagesDsc int(10);
  i_pKey     pointer value;
  i_pElement pointer value;
end-pr;

// Get String Information (CEEGSI) API
dcl-pr ceegsi extproc('CEEGSI');
  i_posN     int(10) const;
  o_dataType int(10);
  o_currLen  int(10);
  o_maxLen   int(10);
  o_fc       char(12) options(*omit);
end-pr;

dcl-ds ceegsi_parmInf_t qualified template;
  type    int(10);
  currLen int(10);
  maxLen  int(10);
  fc      char(12);
end-ds;

// qsort -- Sort Array
dcl-pr qsort extproc('qsort');
  i_pBase    pointer value;
  i_num      int(10) value;
  i_width    int(10) value;
  i_pCompare pointer(*proc) value;
end-pr;

//==================================================================*
//  Open List of Spooled Files
// -----------------------------------------------------------------
//  Using format:  SPLF0100
// -----------------------------------------------------------------
//  Return value:
//  TRUE       - Success
//  FALSE      - Error

//  Parameters:
//  i_user     - username, *ALL, *CURRENT
//  i_outQ     - output queue, *ALL (i_outQLib must be *BLANKS)
//  i_outQLib  - output queue library, *CURLIB, *LIBL
//  i_formType - form type, *ALL, *STD
//  i_usrDta   - user data, *ALL
//  i_orderBy  - Sort sequence:
//               *NONE           no sorting
//               *USRDTA         sort by user data
//               *USERNAME       sort by user
//               *PAGES_ASC      sort by page count (ascending)
//               *PAGES_DSC      sort by page count (descending)
//  o_handle   - list handle
//  o_msg      - error message
//==================================================================*
dcl-proc f_opnSplFLst export;
  dcl-pi *n ind opdesc;
    i_user     char(10) value;
    i_outQ     char(10) value;
    i_outQLib  char(10) value;
    i_formType char(10) value;
    i_usrDta   char(10) value;
    i_orderBy  char(10) value;
    o_handle   like(lstSplF_handle_t);
    o_msg      char(32767) options(*nopass: *varsize);
  end-pi;

  dcl-s isSuccess ind inz(FALSE);

  dcl-ds msg likeds(msg_t);

  dcl-s isUsrSpc ind inz;
  dcl-ds qUsrSpc likeds(qObj_t) inz;
  dcl-s text char(50) inz;
  dcl-s pUsrSpc pointer inz;
  dcl-ds qOutQ likeds(qObj_t) inz;
  dcl-ds errCode likeds(errCode_t) inz;

  dcl-ds handle likeds(handle_t) based(pHandle);

  dcl-ds msgInf likeds(ceegsi_parmInf_t);

  clear msg;

  if (Utils_getTmpName(qUsrSpc));
    text = 'List Spooled Files, SPLF0100, ' + i_orderBy;
    if (Utils_crtUsrSpc(qUsrSpc: text: errCode));
      isUsrSpc = TRUE;

      qOutQ.name = i_outQ;
      qOutQ.lib = i_outQLib;
      errCode = Utils_newApiErrCode(TRUE);

      QUSLSPL(qUsrSpc: 'SPLF0100'
              : i_user: qOutQ: i_formType: i_usrDta: errCode);

      if (not Utils_isApiError(errCode));
        pUsrSpc = Utils_getPtrUsrSpc(qUsrSpc: errCode);
        if (pUsrSpc <> *null);
          isSuccess = f_sortLst(pUsrSpc: i_orderBy);
        else;
          isSuccess = FALSE;
        endif;
      else;
        isSuccess = FALSE;
      endif;

    else;
      isSuccess = FALSE;
      isUsrSpc = FALSE;
    endif;

  else;
    isSuccess = FALSE;
    isUsrSpc = FALSE;

    Clear errCode;
    errCode.bytPrv = %size(errCode);
    errCode.bytAvl = %size(errCode);
    errCode.excID  = 'CPF9898';
    errCode.excDta = 'Temporary object name could not be created.';
  endif;

  msg = Utils_cvtApiErrCodeToMsg(errCode);

  if (isSuccess);
    pHandle = %alloc(%size(handle));
    handle.pUsrSpc = pUsrSpc;
    handle.entryIndex = 0;
    handle.qUsrSpc = qUsrSpc;
    handle.hRes_01 = '';
  else;
    if (isUsrSpc);
      Utils_dltUsrSpc(qUsrSpc);
    endif;
    pHandle = *null;
  endif;

  o_handle = pHandle;

  if (%parms >= %parmnum(o_msg));
    ceegsi(%parmnum(o_msg)
           : msgInf.type: msgInf.currLen: msgInf.maxLen: *omit);
    %subst(o_msg: 1: msgInf.currLen) = msg;
  endif;

  return isSuccess;

end-proc;

//==================================================================*
//  Close List Spooled Files
// -----------------------------------------------------------------
//  Return value:
//  TRUE       - Success
//  FALSE      - Error

//  Parameters:
//  io_handle  - List handle
//==================================================================*
dcl-proc f_cloSplFLst export;
  dcl-pi *n ind;
    io_handle like(lstSplF_handle_t);
  end-pi;

  dcl-s isSuccess ind inz(FALSE);

  dcl-ds handle likeds(handle_t) based(io_handle);

  isSuccess = Utils_dltUsrSpc(handle.qUsrSpc);

  handle.pUsrSpc = *null;
  handle.entryIndex = 0;
  handle.qUsrSpc = '';
  handle.hRes_01 = '';

  dealloc(N) io_handle;

  return isSuccess;

end-proc;

//==================================================================*
//  Get First Spooled File
// -----------------------------------------------------------------
//  Return value:
//  TRUE       - Success
//  FALSE      - Error

//  Parameters:
//  i_handle   - list handle
//  o_data     - list entry data of type SPLF0100
//==================================================================*
dcl-proc f_getFirstSplF export;
  dcl-pi *n ind opdesc;
    i_handle like(lstSplF_handle_t) value;
    o_data   char(32767) options(*varsize);
  end-pi;

  dcl-s isSuccess ind inz(FALSE);

  dcl-ds handle likeds(handle_t) based(i_handle);

  dcl-ds dataInf likeds(ceegsi_parmInf_t);

  ceegsi(%parmnum(o_data)
         : dataInf.type: dataInf.currLen: dataInf.maxLen: *omit);

  handle.entryIndex = 0;

  isSuccess =
     Utils_getListEntry(
        handle.pUsrSpc: handle.entryIndex: dataInf.currLen: o_data);

  if (isSuccess);
    handle.entryIndex = handle.entryIndex + 1;
  endif;

  return isSuccess;

end-proc;

//==================================================================*
//  Get Next Spooled File
// -----------------------------------------------------------------
//  Return value:
//  TRUE       - Success
//  FALSE      - Error

//  Parameters:
//  i_handle   - list handle
//  o_data     - list entry data of type SPLF0100
//==================================================================*
dcl-proc f_getNextSplF export;
  dcl-pi *n ind opdesc;
    i_handle like(lstSplF_handle_t) value;
    o_data   char(32767) options(*varsize);
  end-pi;

  dcl-s isSuccess ind inz(FALSE);

  dcl-ds handle likeds(handle_t) based(i_handle);

  dcl-ds dataInf likeds(ceegsi_parmInf_t);

  ceegsi(%parmnum(o_data)
         : dataInf.type: dataInf.currLen: dataInf.maxLen: *omit);

  isSuccess =
     Utils_getListEntry(
        handle.pUsrSpc: handle.entryIndex: dataInf.currLen: o_data);

  if (isSuccess);
    handle.entryIndex = handle.entryIndex + 1;
  endif;

  return isSuccess;

end-proc;

//==================================================================*
//  Get number of spooled files available
// -----------------------------------------------------------------
//  Return value:
//  numEntries - Number of available spooled files

//  Parameters:
//  i_handle   - list handle
//==================================================================*
dcl-proc f_getNumSplFAvl export;
  dcl-pi *n int(10);
    i_handle like(lstSplF_handle_t) value;
  end-pi;

  dcl-ds handle likeds(handle_t) based(i_handle);
  dcl-ds genLstHdr likeds(genLstHdr_t) based(handle.pUsrSpc);

  return genLstHdr.numE;

end-proc;

//==================================================================*
//  Retrieve Spooled File Attributes
// -----------------------------------------------------------------
//  Return value:
//  spla0100    - Format SPLA0100 of
//                Retrieve Spooled File Attributes (QUSRSPLA) API

//  Parameters:
//  i_intJobID  - Internal job identifier
//  i_intSplFID - Internal spooled file identifier
//  o_msg       - error message
//==================================================================*
dcl-proc f_rtvSplFA export;
  dcl-pi *n opdesc like(spla0100_t);
    i_intJobID  char(16) const;
    i_intSplFID char(16) const;
    o_msg       char(32767) options(*nopass: *varsize);
  end-pi;

  dcl-ds spla0100 likeds(spla0100_t) inz;

  dcl-ds msg likeds(msg_t) inz;
  dcl-ds errCode likeds(errCode_t) inz;

  dcl-ds msgInf likeds(ceegsi_parmInf_t);

  if (%parms >= %parmnum(o_msg));
    errCode = Utils_newApiErrCode(TRUE);
  else;
    errCode = Utils_newApiErrCode(FALSE);
  endif;

  clear SPLA0100;
  QUSRSPLA(SPLA0100: %size(SPLA0100): 'SPLA0100': '*INT'
           : i_intJobID: i_intSplFID: '*INT': 0: errCode);

  msg = Utils_cvtApiErrCodeToMsg(errCode);

  if (%parms >= %parmnum(o_msg));
    ceegsi(%parmnum(o_msg)
           : msgInf.type: msgInf.currLen: msgInf.maxLen : *omit);
    %subst(o_msg: 1: msgInf.currLen) = msg;
  endif;

  return spla0100;

end-proc;

//==================================================================*
//  Sort User Space
//==================================================================*
dcl-proc f_sortLst;
  dcl-pi *n ind;
    i_pUsrSpc pointer value;
    i_compare char(10) value;
  end-pi;

  dcl-s isSuccess ind inz(FALSE);

  dcl-ds genLstHdr likeds(genLstHdr_t) based(i_pUsrSpc);
  dcl-s pCompFunc pointer(*proc) inz;

  // Set compare function ...
  select;
  // ... sorting not requested
  when (i_compare = '*NONE');
    pCompFunc = *null;
    isSuccess = TRUE;
  // ... sort by user data
  when (i_compare = '*USRDTA');
    pCompFunc = %paddr('F_SORTLSTBYUSRDTA');
    isSuccess = TRUE;
  // ... sort by user name
  when (i_compare = '*USERNAME');
    pCompFunc = %paddr('F_SORTLSTBYUSERNAME');
    isSuccess = TRUE;
  // ... sort by page count (ascending)
  when (i_compare = '*PAGES_ASC');
    pCompFunc = %paddr('F_SORTLSTBYPAGESASC');
    isSuccess = TRUE;
  // ... sort by page count (descending)
  when (i_compare = '*PAGES_DSC');
    pCompFunc = %paddr('F_SORTLSTBYPAGESDSC');
    isSuccess = TRUE;
  // ... unknown compare function
  other;
    pCompFunc = *null;
    isSuccess = FALSE;
  endsl;

  if (pCompFunc <> *null);
    qsort(i_pUsrSpc + genLstHdr.ofsLstSct
          : genLstHdr.numE: genLstHdr.sizeE: pCompFunc);
  endif;

  return isSuccess;

end-proc;

//==================================================================*
//  Sort List by User Data
//==================================================================*
dcl-proc f_sortLstByUsrDta;
  dcl-pi *n int(10);
    i_pKey     pointer value;
    i_pElement pointer value;
  end-pi;

  dcl-ds key likeds(splf0100_t) based(i_pKey);
  dcl-ds element likeds(splf0100_t) based(i_pElement);

  dcl-s rc int(10) inz;

  select;
  when (key.userData < element.userData);
    rc = -1;
  when (key.userData > element.userData);
    rc =  1;
  other;
    rc =  0;
  endsl;

  return rc;

end-proc;

//==================================================================*
//  Sort List by User Name
//==================================================================*
dcl-proc f_sortLstByUserName;
  dcl-pi *n int(10);
    i_pKey     pointer value;
    i_pElement pointer value;
  end-pi;

  dcl-ds key likeds(splf0100_t) based(i_pKey);
  dcl-ds element likeds(splf0100_t) based(i_pElement);

  dcl-s rc int(10) inz;

  select;
  when (key.user < element.user);
    rc = -1;
  when (key.user > element.user);
    rc =  1;
  other;
    rc =  0;
  endsl;

  return rc;

end-proc;

//==================================================================*
//  Sort list by page count (ASCENDING)
//==================================================================*
dcl-proc f_sortLstByPagesAsc;
  dcl-pi *n int(10);
    i_pKey     pointer value;
    i_pElement pointer value;
  end-pi;

  dcl-ds key likeds(splf0100_t) based(i_pKey);
  dcl-ds element likeds(splf0100_t) based(i_pElement);

  dcl-s rc int(10) inz;

  dcl-ds spla0100_k likeds(spla0100_t) inz;
  dcl-ds spla0100_e likeds(spla0100_t) inz;
  dcl-ds msg likeds(msg_t) inz;

  spla0100_k = f_rtvSplFA(key.intJobID: key.intSplFID: msg);
  if (msg.ID <> '');
    spla0100_k.pages = *HIVAL;
  endif;

  spla0100_e = f_rtvSplFA(element.intJobID: element.intSplFID: msg);
  if (msg.ID <> '');
    spla0100_k.pages = *HIVAL;
  endif;

  select;
  when (spla0100_k.pages < spla0100_e.pages);
    rc = -1;
  when (spla0100_k.pages > spla0100_e.pages);
    rc =  1;
  other;
    rc =  0;
  endsl;

  return rc;

end-proc;

//==================================================================*
//  Sort list by page count (DESCENDING)
//==================================================================*
dcl-proc f_sortLstByPagesDsc;
  dcl-pi *n int(10);
    i_pKey     pointer value;
    i_pElement pointer value;
  end-pi;

  return f_sortLstByPagesAsc(i_pKey: i_pElement) * -1;

end-proc;

