      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  16.09.2002                                              *
      *  E-mail  :  thomas.raddatz@tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *
      /copy qlstsplf,qusrspla                     List Spooled Files (QUSLSPL) API
      *
      *===============================================================*
      *  Reference fields
      *===============================================================*
     D lstSplF_handle_t...
     D                 S               *   based(pDummy)
      *
      *==================================================================*
      *  Open List Of Spooled Files
      *==================================================================*
      *
     D f_opnSplFLst...
     D                 PR              N   opdesc
     D                                     extproc('LSTSPLF+
     D                                     _f_opnSplFLst+
     D                                     ')
     D  i_user                       10A   value
     D  i_outQ                       10A   value
     D  i_outQLib                    10A   value
     D  i_formType                   10A   value
     D  i_userData                   10A   value
     D  i_orderBy                    10A   value
     D  o_handle                                  like(lstSplF_handle_t)
     D  o_msg                     32767A          options(*nopass: *varsize)
      *
      *==================================================================*
      *  Close List Of Spooled Files
      *==================================================================*
      *
     D f_cloSplFLst...
     D                 PR              N
     D                                     extproc('LSTSPLF+
     D                                     _f_cloSplFLst+
     D                                     ')
     D  io_handle                                 like(lstSplF_handle_t)
      *
      *==================================================================*
      *  Get First Spooled File
      *==================================================================*
      *
     D f_getFirstSplF...
     D                 PR              N   opdesc
     D                                     extproc('LSTSPLF+
     D                                     _f_getFirstSplF+
     D                                     ')
     D  i_handle                           value  like(lstSplF_handle_t)
     D  o_data                    32767A   options(*varsize)
      *
      *==================================================================*
      *  Get Next Spooled File
      *==================================================================*
      *
     D f_getNextSplF...
     D                 PR              N   opdesc
     D                                     extproc('LSTSPLF+
     D                                     _f_getNextSplF+
     D                                     ')
     D  i_handle                           value  like(lstSplF_handle_t)
     D  o_data                    32767A   options(*varsize)
      *
      *==================================================================*
      *  Get Number of Spooled Files available
      *==================================================================*
      *
     D f_getNumSplFAvl...
     D                 PR            10I 0
     D                                     extproc('LSTSPLF+
     D                                     _f_getNumSplFAvl+
     D                                     ')
     D  i_handle                           value  like(lstSplF_handle_t)
      *
      *==================================================================*
      *  Retrieve Spooled File Attributes
      *==================================================================*
      *
     D f_rtvSplFA...
     D                 PR                  opdesc like(spla0100_t)
     D                                     extproc('LSTSPLF+
     D                                     _f_rtvSplFA+
     D                                     ')
     D  i_intJobID                   16A   const
     D  i_intSplFID                  16A   const
     D  o_msg                     32767A         options(*nopass: *varsize)
      *
