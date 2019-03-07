      /if not defined(PUSLUTILS)
      /define PUSLUTILS

      /copy qlstsplf,fdqobj                       Qualified object name structure
      /copy qlstsplf,fdmsg                        Message structure
      /copy qlstsplf,fderrcode                    API error code
      /copy qlstsplf,genlsthdr                    Generic list API header

     D Utils_crtUsrSpc...
     D                 PR              N
     D                                     extproc('USLUTILS_+
     D                                     Utils_crtUsrSpc')
     D  i_qUsrSpc                          value  likeds(qObj_t)
     D  i_text                       50A   value
     D  o_errCode                                 likeds(errCode_t)

     D Utils_getPtrUsrSpc...
     D                 PR              *
     D                                     extproc('USLUTILS_+
     D                                     Utils_getPtrUsrSpc')
     D  i_qUsrSpc                          value  likeds(qObj_t)
     D  o_errCode                                 likeds(errCode_t)

     D Utils_dltUsrSpc...
     D                 PR              N
     D                                     extproc('USLUTILS_+
     D                                     Utils_dltUsrSpc')
     D  i_qUsrSpc                          value  likeds(qObj_t)

     D Utils_getTmpName...
     D                 PR              N
     D                                     extproc('USLUTILS_+
     D                                     Utils_getTmpName')
     D  o_qUsrSpc                                 likeds(qObj_t)

     D Utils_getListEntry...
     D                 PR              N
     D                                     extproc('USLUTILS_+
     D                                     Utils_getListEntry')
     D  i_pUsrSpc                      *   const
     D  i_index                      10I 0 const
     D  i_length                     10I 0 const
     D  o_data                    32767A          options(*varsize)

     D Utils_isApiError...
     D                 PR              N
     D                                     extproc('USLUTILS_+
     D                                     Utils_isApiError')
     D  i_errCode                          value  likeds(errCode_t)

     D Utils_newApiErrCode...
     D                 PR                         likeds(errCode_t)
     D                                     extproc('USLUTILS_+
     D                                     Utils_newApiErrCode')
     D  i_monmsg                       N   value

     D Utils_cvtApiErrCodeToMsg...
     D                 PR                         likeds(msg_t)
     D                                     extproc('USLUTILS_+
     D                                     Utils_cvtApiErrCodeToMsg')
     D  i_errCode                          value  likeds(errCode_t)

     D Utils_openPrinter...
     D                 PR
     D                                     extproc('USLUTILS_+
     D                                     Utils_openPrinter')

     D Utils_print...
     D                 PR
     D                                     extproc('USLUTILS_+
     D                                     Utils_print')
     D  i_text                       80A   const varying options(*nopass)

     D Utils_closePrinter...
     D                 PR
     D                                     extproc('USLUTILS_+
     D                                     Utils_closePrinter')

      /endif
