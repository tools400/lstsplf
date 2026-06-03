**free
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  16.09.2002                                              *
//  E-mail  :  thomas.raddatz@tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*

/copy qlstsplf,qusrspla List Spooled files(QUSLSPL) API

//===============================================================*
//  Reference fields
//===============================================================*
dcl-s lstSplF_handle_t pointer template;

//==================================================================*
//  Open List Of Spooled Files
//==================================================================*

dcl-pr f_opnSplFLst ind opdesc extproc('LSTSPLF_f_opnSplFLst');
  i_user     char(10) value;
  i_outQ     char(10) value;
  i_outQLib  char(10) value;
  i_formType char(10) value;
  i_userData char(10) value;
  i_orderBy  char(10) value;
  o_handle   like(lstSplF_handle_t);
  o_msg      char(32767) options(*nopass: *varsize);
end-pr;

//==================================================================*
//  Close List Of Spooled Files
//==================================================================*

dcl-pr f_cloSplFLst ind extproc('LSTSPLF_f_cloSplFLst');
  io_handle like(lstSplF_handle_t);
end-pr;

//==================================================================*
//  Get First Spooled File
//==================================================================*

dcl-pr f_getFirstSplF ind opdesc extproc('LSTSPLF_f_getFirstSplF');
  i_handle like(lstSplF_handle_t) value;
  o_data   char(32767) options(*varsize);
end-pr;

//==================================================================*
//  Get Next Spooled File
//==================================================================*

dcl-pr f_getNextSplF ind opdesc extproc('LSTSPLF_f_getNextSplF');
  i_handle like(lstSplF_handle_t) value;
  o_data   char(32767) options(*varsize);
end-pr;

//==================================================================*
//  Get Number of Spooled Files available
//==================================================================*

dcl-pr f_getNumSplFAvl int(10) extproc('LSTSPLF_f_getNumSplFAvl');
  i_handle like(lstSplF_handle_t) value;
end-pr;

//==================================================================*
//  Retrieve Spooled File Attributes
//==================================================================*

dcl-pr f_rtvSplFA opdesc like(spla0100_t) extproc('LSTSPLF_f_rtvSplFA');
  i_intJobID  char(16) const;
  i_intSplFID char(16) const;
  o_msg       char(32767) options(*nopass: *varsize);
end-pr;

