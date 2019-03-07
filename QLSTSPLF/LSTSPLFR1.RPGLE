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
       //       >>PARM<< TGTRLS(V7R1M0);                                      *
       //     >>END-IMPORTANT<<                                               *
       //     >>EXECUTE<<                                                     *
       //   >>END-PRE-COMPILER<<                                              *
       //=====================================================================*
     H NOMAIN
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H EXTBININT(*YES) BNDDIR('QC2LE')
     H DATFMT(*ISO) TIMFMT(*ISO) DEBUG(*YES)
      /copy qlstsplf,copyright

      /copy qlstsplf,quslspl                      List Spooled Files (QUSLSPL) API
      /copy qlstsplf,qusrspla                     Retrieve Spooled File Attributes (QUSRSPLA) API
      /copy qlstsplf,fdboolean                    Boolean constants
      /copy qlstsplf,fdqobj                       Qualified object name structure
      /copy qlstsplf,fdmsg                        Message structure
      /copy qlstsplf,fderrcode                    API error code
      /copy qlstsplf,genlsthdr                    Generic list API header

      /copy qlstsplf,plstsplf                     List Spooled Files - Public Interface
      /copy qlstsplf,puslutils                    Utility for IBM QUSL* List APIs

      // List handle
     D handle_t        DS                  qualified based(pDummy)
     D  pUsrSpc                        *
     D  entryIndex                   10I 0
     D  qUsrSpc                            likeds(qObj_t)
     D  hRes_01                      16A

      // Internal prototypes
     D f_sortLst...
     D                 PR              N
     D  i_pUsrSpc                      *   value
     D  i_compare                    10A   value

     D f_sortLstByUsrDta...
     D                 PR            10I 0
     D  i_pKey                         *   value
     D  i_pElement                     *   value

     D f_sortLstByUserName...
     D                 PR            10I 0
     D  i_pKey                         *   value
     D  i_pElement                     *   value

     D f_sortLstByPagesAsc...
     D                 PR            10I 0
     D  i_pKey                         *   value
     D  i_pElement                     *   value

     D f_sortLstByPagesDsc...
     D                 PR            10I 0
     D  i_pKey                         *   value
     D  i_pElement                     *   value

       // Get String Information (CEEGSI) API
     D ceegsi          PR                  extproc('CEEGSI')
     D  i_posN                       10I 0 const
     D  o_dataType                   10I 0
     D  o_currLen                    10I 0
     D  o_maxLen                     10I 0
     D  o_fc                         12A          options(*omit)

     D ceegsi_parmInf_t...
     D                 DS                  qualified based(pDummy)
     D  type                         10I 0
     D  currLen                      10I 0
     D  maxLen                       10I 0
     D  fc                           12A

      // qsort -- Sort Array
     D qsort           PR                  extproc('qsort')
     D  i_pBase                        *   value
     D  i_num                        10I 0 value
     D  i_width                      10I 0 value
     D  i_pCompare                     *   value procptr

       //==================================================================*
       //  Open List of Spooled Files
       // -----------------------------------------------------------------
       //  Using format:  SPLF0100
       // -----------------------------------------------------------------
       //  Return value:
       //  TRUE       - Success
       //  FALSE      - Error
       //
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
     P f_opnSplFLst...
     P                 B                   export
     D                 PI              N   opdesc
     D  i_user                       10A   value
     D  i_outQ                       10A   value
     D  i_outQLib                    10A   value
     D  i_formType                   10A   value
     D  i_usrDta                     10A   value
     D  i_orderBy                    10A   value
     D  o_handle                                  like(lstSplF_handle_t)
     D  o_msg                     32767A          options(*nopass: *varsize)

     D isSuccess       S               N   inz(FALSE)

     D msg             DS                  likeds(msg_t)

     D isUsrSpc        S               N   inz
     D qUsrSpc         DS                  likeds(qObj_t) inz
     D text            S             50A   inz
     D pUsrSpc         S               *   inz
     D qOutQ           DS                  likeds(qObj_t) inz
     D errCode         DS                  likeds(errCode_t) inz

     D handle          DS                  likeds(handle_t) based(pHandle)

     D msgInf          DS                  likeds(ceegsi_parmInf_t)
      /free

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

      /end-free
     P                 E

       //==================================================================*
       //  Close List Spooled Files
       // -----------------------------------------------------------------
       //  Return value:
       //  TRUE       - Success
       //  FALSE      - Error
       //
       //  Parameters:
       //  io_handle  - List handle
       //==================================================================*
     P f_cloSplFLst...
     P                 B                   export
     D                 PI              N
     D  io_handle                                 like(lstSplF_handle_t)

     D isSuccess       S               N   inz(FALSE)

     D handle          DS                  likeds(handle_t) based(io_handle)
      /free

       isSuccess = Utils_dltUsrSpc(handle.qUsrSpc);

       handle.pUsrSpc = *null;
       handle.entryIndex = 0;
       handle.qUsrSpc = '';
       handle.hRes_01 = '';

       dealloc(N) io_handle;

       return isSuccess;

      /end-free
     P                 E

       //==================================================================*
       //  Get First Spooled File
       // -----------------------------------------------------------------
       //  Return value:
       //  TRUE       - Success
       //  FALSE      - Error
       //
       //  Parameters:
       //  i_handle   - list handle
       //  o_data     - list entry data of type SPLF0100
       //==================================================================*
     P f_getFirstSplF...
     P                 B                   export
     D                 PI              N          opdesc
     D  i_handle                           value  like(lstSplF_handle_t)
     D  o_data                    32767A          options(*varsize)

     D isSuccess       S               N   inz(FALSE)

     D handle          DS                  likeds(handle_t) based(i_handle)

     D dataInf         DS                  likeds(ceegsi_parmInf_t)
      /free

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

      /end-free
     P                 E

       //==================================================================*
       //  Get Next Spooled File
       // -----------------------------------------------------------------
       //  Return value:
       //  TRUE       - Success
       //  FALSE      - Error
       //
       //  Parameters:
       //  i_handle   - list handle
       //  o_data     - list entry data of type SPLF0100
       //==================================================================*
     P f_getNextSplF...
     P                 B                   export
     D                 PI              N          opdesc
     D  i_handle                           value  like(lstSplF_handle_t)
     D  o_data                    32767A          options(*varsize)

     D isSuccess       S               N   inz(FALSE)

     D handle          DS                  likeds(handle_t) based(i_handle)

     D dataInf         DS                  likeds(ceegsi_parmInf_t)
      /free

       ceegsi(%parmnum(o_data)
              : dataInf.type: dataInf.currLen: dataInf.maxLen: *omit);

       isSuccess =
          Utils_getListEntry(
             handle.pUsrSpc: handle.entryIndex: dataInf.currLen: o_data);

       if (isSuccess);
          handle.entryIndex = handle.entryIndex + 1;
       endif;

       return isSuccess;

      /end-free
     P                 E

       //==================================================================*
       //  Get number of spooled files available
       // -----------------------------------------------------------------
       //  Return value:
       //  numEntries - Number of available spooled files
       //
       //  Parameters:
       //  i_handle   - list handle
       //==================================================================*
     P f_getNumSplFAvl...
     P                 B                   export
     D                 PI            10I 0
     D  i_handle                           value  like(lstSplF_handle_t)

     D handle          DS                  likeds(handle_t) based(i_handle)
     D genLstHdr       DS                  likeds(genLstHdr_t)
     D                                     based(handle.pUsrSpc)
      /free

       return genLstHdr.numE;

      /end-free
     P                 E

       //==================================================================*
       //  Retrieve Spooled File Attributes
       // -----------------------------------------------------------------
       //  Return value:
       //  spla0100    - Format SPLA0100 of
       //                Retrieve Spooled File Attributes (QUSRSPLA) API
       //
       //  Parameters:
       //  i_intJobID  - Internal job identifier
       //  i_intSplFID - Internal spooled file identifier
       //  o_msg       - error message
       //==================================================================*
     P f_rtvSplFA...
     P                 B                   export
     D                 PI                  opdesc like(spla0100_t)
     D  i_intJobID                   16A   const
     D  i_intSplFID                  16A   const
     D  o_msg                     32767A         options(*nopass: *varsize)

     D spla0100        DS                  likeds(spla0100_t) inz

     D msg             DS                  likeds(msg_t) inz
     D errCode         DS                  likeds(errCode_t) inz

     D msgInf          DS                  likeds(ceegsi_parmInf_t)
      /free

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

      /end-free
     P                 E

       //==================================================================*
       //  Sort User Space
       //==================================================================*
     P f_sortLst...
     P                 B
     D                 PI              N
     D  i_pUsrSpc                      *   value
     D  i_compare                    10A   value

     D isSuccess       S               N   inz(FALSE)

     D genLstHdr       DS                  likeds(genLstHdr_t)
     D                                     based(i_pUsrSpc)
     D pCompFunc       S               *   inz procptr
      /free

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

      /end-free
     P                 E

       //==================================================================*
       //  Sort List by User Data
       //==================================================================*
     P f_sortLstByUsrDta...
     P                 B
     D                 PI            10I 0
     D  i_pKey                         *   value
     D  i_pElement                     *   value

     D key             DS                  likeds(splf0100_t) based(i_pKey)
     D element         DS                  likeds(splf0100_t) based(i_pElement)

     D rc              S             10I 0 inz
      /free

       select;
       when (key.userData < element.userData);
          rc = -1;
       when (key.userData > element.userData);
          rc =  1;
       other;
          rc =  0;
       endsl;

       return rc;

      /end-free
     P                 E

       //==================================================================*
       //  Sort List by User Name
       //==================================================================*
     P f_sortLstByUserName...
     P                 B
     D                 PI            10I 0
     D  i_pKey                         *   value
     D  i_pElement                     *   value

     D key             DS                  likeds(splf0100_t) based(i_pKey)
     D element         DS                  likeds(splf0100_t) based(i_pElement)

     D rc              S             10I 0 inz
      /free

       select;
       when (key.user < element.user);
          rc = -1;
       when (key.user > element.user);
          rc =  1;
       other;
          rc =  0;
       endsl;

       return rc;

      /end-free
     P                 E

       //==================================================================*
       //  Sort list by page count (ASCENDING)
       //==================================================================*
     P f_sortLstByPagesAsc...
     P                 B
     D                 PI            10I 0
     D  i_pKey                         *   value
     D  i_pElement                     *   value

     D key             DS                  likeds(splf0100_t) based(i_pKey)
     D element         DS                  likeds(splf0100_t) based(i_pElement)

     D rc              S             10I 0 inz

     D spla0100_k      DS                  likeds(spla0100_t) inz
     D spla0100_e      DS                  likeds(spla0100_t) inz
     D msg             DS                  likeds(msg_t) inz
      /free

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

      /end-free
     P                 E

       //==================================================================*
       //  Sort list by page count (DESCENDING)
       //==================================================================*
     P f_sortLstByPagesDsc...
     P                 B
     D                 PI            10I 0
     D  i_pKey                         *   value
     D  i_pElement                     *   value
      /free

       return f_sortLstByPagesAsc(i_pKey: i_pElement) * -1;

      /end-free
     P                 E

