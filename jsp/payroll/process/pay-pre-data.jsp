 
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.*" %>
<!-- package wihita -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<%@ page import = "java.util.Date" %>

<!--package harisma -->
<%@ page import = "com.dimata.harisma.entity.search.*" %>
<%@ page import = "com.dimata.harisma.form.search.*" %>
<%@ page import = "com.dimata.harisma.entity.admin.*" %>
<%@ page import = "com.dimata.harisma.entity.payroll.*" %>
<%@ page import = "com.dimata.harisma.entity.employee.*" %>
<%@ page import = "com.dimata.harisma.form.payroll.*" %>
<%@ page import = "com.dimata.harisma.entity.admin.*" %>
<%@ page import = "com.dimata.harisma.session.employee.*" %>
<%@ page import = "com.dimata.harisma.entity.attendance.*" %>
<%@ page import = "com.dimata.harisma.session.payroll.*" %>


<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_PAYROLL, AppObjInfo.G2_PAYROLL_PROCESS, AppObjInfo.OBJ_PAYROLL_PROCESS_PREPARE);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%
	CtrlPaySlipComp ctrlPaySlipComp  = new CtrlPaySlipComp(request);
	int prevCommand = FRMQueryString.requestInt(request, "prev_command");
	int iCommand = FRMQueryString.requestCommand(request);
	int start = FRMQueryString.requestInt(request,"start");
	String levelCode = FRMQueryString.requestString(request,"level");
        long oidDivision = FRMQueryString.requestLong(request,"division");
	long oidDepartment = FRMQueryString.requestLong(request,"department");
	long oidSection = FRMQueryString.requestLong(request,"section");
	long oidPaySlipComp = FRMQueryString.requestLong(request,"section");
	long periodId = FRMQueryString.requestLong(request,"periodId");
	String searchNrFrom = FRMQueryString.requestString(request,"searchNrFrom");
	String searchNrTo = FRMQueryString.requestString(request,"searchNrTo");
	String searchName = FRMQueryString.requestString(request,"searchName");
        int dataStatus = FRMQueryString.requestInt(request,"dataStatus");
	String codeComponenGeneral = FRMQueryString.requestString(request,"compCode");
	String compName = FRMQueryString.requestString(request,"compName");
	int aksiCommand = FRMQueryString.requestInt(request,"aksiCommand");
	long periodeId = FRMQueryString.requestLong(request,"periodId");
	int numKolom = FRMQueryString.requestInt(request,"numKolom");
	int statusSave = FRMQueryString.requestInt(request,"statusSave");
        
        SalaryLevelDetail salLevDetail = new SalaryLevelDetail() ;
        System.out.println(">>> codeComponenGeneral="+codeComponenGeneral+ " levelCode=" +levelCode);
        if(codeComponenGeneral!=null && levelCode!=null ) {
            String whereClause = (codeComponenGeneral!=null && codeComponenGeneral.length()>1) ? ("  "+  PstSalaryLevelDetail.fieldNames[PstSalaryLevelDetail.FLD_LEVEL_CODE]+"=\""+levelCode+"\"  AND "+
                    PstSalaryLevelDetail.fieldNames[PstSalaryLevelDetail.FLD_COMP_CODE]+"=\""+codeComponenGeneral+"\"") :"";
            Vector salLvDetls = PstSalaryLevelDetail.list(0, 1, whereClause, "");
            if(salLvDetls!=null && salLvDetls.size()>0){
                salLevDetail =(SalaryLevelDetail) salLvDetls.get(0);
            }
        }

%>
<%
	System.out.println("iCommand::::"+iCommand);
	int iErrCode = FRMMessage.ERR_NONE;
	String msgString = "";
	String msgStr = "";
	int recordToGet = 1000;
	int vectSize = 0;
	String orderClause = "";
	String whereClause = "";
	ControlLine ctrLine = new ControlLine();
	
	// action on object agama defend on command entered
	iErrCode = ctrlPaySlipComp.action(iCommand , oidPaySlipComp);
	FrmPaySlipComp frmPaySlipComp = ctrlPaySlipComp.getForm();
	PaySlipComp paySlipComp = ctrlPaySlipComp.getPaySlipComp();
	msgString =  ctrlPaySlipComp.getMessage();
	
	/*if(iCommand == Command.SAVE && prevCommand == Command.ADD)
	{
		start = PstPaySlip.findLimitStart(oidEmployee,recordToGet, whereClause,orderClause);
		vectSize = PstEmployee.getCount(whereClause);
	}
	else
	{
		vectSize = sessEmployee.countEmployee(srcEmployee);
	}

	
	if((iCommand==Command.FIRST)||(iCommand==Command.NEXT)||(iCommand==Command.PREV)||
	(iCommand==Command.LAST)||(iCommand==Command.LIST))
		start = ctrlPaySlip.actionList(iCommand, start, vectSize, recordToGet);*/
%>
<%
	
	//get the kode component name by componentId
	/*PayComponent payComponent = new PayComponent();
	String codeComponenGeneral ="";
	try{
		payComponent = PstPayComponent.fetchExc(componentId);
		codeComponenGeneral = payComponent.getCompCode();
	  }
	catch(Exception e){
	}*/
	
	
Vector listPreData = new Vector(1,1);
	if(iCommand == Command.LIST || iCommand==Command.EDIT || iCommand == Command.SAVE || iCommand == Command.ADD)
		{
			listPreData = SessEmployee.listPreData(oidDepartment,levelCode,oidSection,searchNrFrom,searchNrTo,searchName,dataStatus,"",periodId);			
			if(listPreData.size()==0){
				listPreData = SessEmployee.listPreData(oidDepartment,levelCode,oidSection,searchNrFrom,searchNrTo,searchName,2,"",0);			
			}
                        
                        msgString=SessPaySlip.generatePaySlip(periodId, (levelCode), 0,oidDivision, oidDepartment, oidSection, searchNrFrom, searchNrTo, searchName, dataStatus); 
                        //update by satrya 2014-02-07 msgString=SessPaySlip.generatePaySlip(periodId, levelCode, oidDivision, oidDepartment, oidSection, searchNrFrom, searchNrTo, searchName, dataStatus);
		}
%>

<!-- JSP Block -->
<%!
public String drawList(JspWriter outJsp, int iCommand, FrmPaySlipComp frmObject, PaySlipComp objEntity, Vector objectClass, long idPaySlipComp, String codeComponent,String componentName,long periodeId,String srcLevelCode){
	String result = "";
	Vector token = new Vector(1,1);
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("90%");
	/*ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");*/
                //update by satrya 2013-01-2013
        		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("listgentitle");
		ctrlist.setCellStyle("listgensell");
		ctrlist.setHeaderStyle("listgentitle");
                ctrlist.setCellStyles("listgensellstyles");
                ctrlist.setRowSelectedStyles("rowselectedstyles");
	//mengambil nama dari kode komponent
	/*PayComponent payComponent = new PayComponent();
	String componentName ="";
	String codeComponent ="";
	try{
		payComponent = PstPayComponent.fetchExc(componentId);
		componentName = payComponent.getCompName();
		codeComponent = payComponent.getCompCode();
		}
		catch(Exception e){
	}*/
		ctrlist.addHeader("No","5%", "2", "0");
		ctrlist.addHeader("Employee Nr.","5%", "2", "0");
		ctrlist.addHeader("Nama","12%", "2", "0");
		ctrlist.addHeader("Position","12%", "2", "0");
		// mengambil komponen-komponen yang mempengaruhi perhitungan componentName
			int numToken = 0;
			Vector compFormula = new Vector(1,1);
			  String whereFormula = PstSalaryLevelDetail.fieldNames[PstSalaryLevelDetail.FLD_COMP_CODE]+"='"+codeComponent+"'"+
			  						" AND "+PstSalaryLevelDetail.fieldNames[PstSalaryLevelDetail.FLD_LEVEL_CODE]+"='"+srcLevelCode+"'";
			  compFormula = PstSalaryLevelDetail.list(0,0, whereFormula ,"");
			  String formula = "";
			  if(compFormula!=null && compFormula.size() > 0){
			  	for(int i = 0;i < compFormula.size();i++){
					SalaryLevelDetail levelComp = (SalaryLevelDetail)compFormula.get(i);
						// mengilangkan tanda (=)
						StringTokenizer tokenFormula1 = new StringTokenizer(levelComp.getFormula(),"=");
						while(tokenFormula1.hasMoreTokens()){
                         	String compToken=(String)tokenFormula1.nextToken();
							// menghilangkam tanda "("
							StringTokenizer tokenFormula2 = new StringTokenizer(compToken,"(");
							while(tokenFormula2.hasMoreTokens()){
								compToken=(String)tokenFormula2.nextToken();
								StringTokenizer tokenFormula3 = new StringTokenizer(compToken,")");
								while(tokenFormula3.hasMoreTokens()){
									compToken=(String)tokenFormula3.nextToken();
									StringTokenizer tokenFormula4 = new StringTokenizer(compToken,"*");
									while(tokenFormula4.hasMoreTokens()){
										compToken=(String)tokenFormula4.nextToken();
										StringTokenizer tokenFormula5 = new StringTokenizer(compToken,"/");
										while(tokenFormula5.hasMoreTokens()){
											compToken=(String)tokenFormula5.nextToken();
											StringTokenizer tokenFormula6 = new StringTokenizer(compToken,"+");
											while(tokenFormula6.hasMoreTokens()){
												compToken=(String)tokenFormula6.nextToken();
												StringTokenizer tokenFormula = new StringTokenizer(compToken,"-");
												while(tokenFormula.hasMoreTokens()){
													compToken=(String)tokenFormula.nextToken();
													System.out.println("compToken..........."+compToken);
													if(compToken.length() > 1){
														String cekStr = compToken.trim().substring(0,1);
														if(cekStr.equals("0") || cekStr.equals("1") || cekStr.equals("2") || cekStr.equals("3")
															|| cekStr.equals("5") || cekStr.equals("6") || cekStr.equals("7") || cekStr.equals("8") || cekStr.equals("9")){
																numToken = numToken;
															}
														else{
															String where  = PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]+
                           													" = '"+compToken.trim()+"'";
																//String where = PstSalaryLevelDetail.fieldNames[PstSalaryLevelDetail.FLD_FORMULA]+" LIKE '%"+pay.getCompCode()+"%'";
															int listComp=PstPayComponent.getCount(where);
															if(listComp > 0){
																numToken = numToken+1;
															}
															else{
																numToken = numToken;
															}
														}
													}
                       							}
												
                       						}
                       					}
										
                       				}
									
                       			}
								
                       		}
							
                       }
				}
			  }
			 
			 //------------------------------------------------------------------------
		ctrlist.addHeader("Entry Data for "+componentName+"","16%", "0", ""+numToken+3+"");
		//System.out.println("numToken>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+numToken);
		if(compFormula!=null && compFormula.size() > 0){
				int iterasiToken = 0;
			  	for(int i = 0;i < compFormula.size();i++){
					SalaryLevelDetail levelComp = (SalaryLevelDetail)compFormula.get(i);
						// mengilangkan tanda (=)
						StringTokenizer tokenFormula1 = new StringTokenizer(levelComp.getFormula(),"=");
						while(tokenFormula1.hasMoreTokens()){
                         	String compToken=(String)tokenFormula1.nextToken();
							// menghilangkam tanda "("
							StringTokenizer tokenFormula2 = new StringTokenizer(compToken,"(");
							while(tokenFormula2.hasMoreTokens()){
								compToken=(String)tokenFormula2.nextToken();
								StringTokenizer tokenFormula3 = new StringTokenizer(compToken,")");
								while(tokenFormula3.hasMoreTokens()){
									compToken=(String)tokenFormula3.nextToken();
									StringTokenizer tokenFormula4 = new StringTokenizer(compToken,"*");
									while(tokenFormula4.hasMoreTokens()){
										compToken=(String)tokenFormula4.nextToken();
										StringTokenizer tokenFormula5 = new StringTokenizer(compToken,"/");
										while(tokenFormula5.hasMoreTokens()){
											compToken=(String)tokenFormula5.nextToken();
											StringTokenizer tokenFormula6 = new StringTokenizer(compToken,"+");
											while(tokenFormula6.hasMoreTokens()){
												compToken=(String)tokenFormula6.nextToken();
												StringTokenizer tokenFormula = new StringTokenizer(compToken,"-");
												while(tokenFormula.hasMoreTokens()){
													compToken=(String)tokenFormula.nextToken();
													
													if(compToken.length() > 1){
														String cekStr = compToken.trim().substring(0,1);
														//System.out.println("nilai cekStr"+cekStr);
														if(cekStr.equals("0") || cekStr.equals("1") || cekStr.equals("2") || cekStr.equals("3")
															|| cekStr.equals("5") || cekStr.equals("6") || cekStr.equals("7") || cekStr.equals("8") || cekStr.equals("9")){
															 // tidak nambah  sebagai header
															}
														else{
															String where  = PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]+
                           													" = '"+compToken.trim()+"'";
																//String where = PstSalaryLevelDetail.fieldNames[PstSalaryLevelDetail.FLD_FORMULA]+" LIKE '%"+pay.getCompCode()+"%'";
															int listComp=PstPayComponent.getCount(where);
															if(listComp > 0){
																String nameComp = PstPayComponent.getComponentName(compToken);
																ctrlist.addHeader("<input type=\"hidden\" name=\"compToken"+iterasiToken+"\" value=\""+compToken+"\" class=\"formElemen\" size=\"10\">"+nameComp+"","2%", "0", "0");
																iterasiToken = iterasiToken+1;
																token.add(compToken);
															}
														}
													}
                       							}
												
                       						}
                       					}
										
                       				}
									
                       			}
								
                       		}
							
                       }
				}
			  }
		ctrlist.addHeader("Total","2%", "0", "0");
		ctrlist.addHeader("Approve","2%", "0", "0");
		ctrlist.addHeader("Paid","2%", "0", "0");
		//value for Approve
		Vector appKey = new Vector();
		Vector appValue = new Vector();
		appKey.add(PstPaySlip.NO_APPROVE+"");
		appKey.add(PstPaySlip.YES_APPROVE+"");
		appValue.add(PstPaySlip.approveKey[PstPaySlip.NO_APPROVE]);
		appValue.add(PstPaySlip.approveKey[PstPaySlip.YES_APPROVE]);
		
		//value for Paid
		Vector paidKey = new Vector();
		Vector paidValue = new Vector();
		paidKey.add(PstPaySlip.NO_PAID+"");
		paidKey.add(PstPaySlip.YES_PAID+"");
		appValue.add(PstPaySlip.approveKey[PstPaySlip.NO_PAID]);
		appValue.add(PstPaySlip.approveKey[PstPaySlip.YES_PAID]);
		
	String checked = "";	
	ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	int index = -1;
	String frmCurrency = "#,###";
	if(objectClass!=null && objectClass.size()>0){
                ctrlist.drawListHeader(outJsp);
		for(int i=0; i<objectClass.size(); i++){
			int total = 0;
			Vector temp = (Vector)objectClass.get(i);
			Employee employee = (Employee)temp.get(0);
			PaySlip paySlip = (PaySlip)temp.get(1);
			// mengambil Id Bank dan salary Level karyawan
			String whereLevel = PstPayEmpLevel.fieldNames[PstPayEmpLevel.FLD_EMPLOYEE_ID]+"="+employee.getOID()+
								" AND " +PstPayEmpLevel.fieldNames[PstPayEmpLevel.FLD_STATUS_DATA]+"="+PstPayEmpLevel.CURRENT;
			Vector vectLevel = PstPayEmpLevel.list(0,0,whereLevel,"");
			long bankId = 0;
			String levelCode="";
			if(vectLevel!=null && vectLevel.size() > 0) {
				PayEmpLevel level = (PayEmpLevel) vectLevel.get(0);
				bankId = level.getBankId();
				levelCode = level.getLevelCode();
			}
			/*Currency_Rate currency_Rate = (Currency_Rate)objectClass.get(i);
				if(idCurrency_Rate == currency_Rate.getOID()){
			  	index = i;
			}*/
			rowx = new Vector();
			if((index==i) && (iCommand==Command.EDIT || iCommand==Command.ASK)){
				rowx.add(String.valueOf(1 + i));
				rowx.add("<a href=\"javascript:cmdLevel('"+String.valueOf(employee.getOID())+"','"+String.valueOf(levelCode)+"','"+String.valueOf(paySlip.getOID())+"','1')\">"+employee.getEmployeeNum()+"<a/><input type=\"hidden\" name=\"bankId\" value=\""+bankId+"\" class=\"formElemen\" size=\"10\">");
				rowx.add(employee.getFullName());
				//get the position
					Position pos = new Position();
					String position ="";
							try{
								pos = PstPosition.fetchExc(employee.getPositionId());
								position = pos.getPosition();
							}
							catch(Exception e){
							}
							
				//get the department name by DepartmentId
				Department dep= new Department();
				String departmentName ="";
				try{
					dep = PstDepartment.fetchExc(employee.getDepartmentId());
					departmentName = dep.getDepartment();
				  }
				catch(Exception e){
				}
				
				//get the division name by divisionId
				Division div= new Division();
				String divisionName ="";
				try{
					div = PstDivision.fetchExc(employee.getDivisionId());
					divisionName = div.getDivision();
				  }
				catch(Exception e){
				}
				
				//get the section name by sectionId
				Section sect= new Section();
				String sectionName ="";
				try{
					sect = PstSection.fetchExc(employee.getSectionId());
					sectionName = sect.getSection();
				  }
				catch(Exception e){
				}
				rowx.add(position+"<input type=\"hidden\" name=\"position_pay\" value=\""+position+"\" class=\"formElemen\" size=\"10\"><input type=\"hidden\" name=\"division\" value=\""+divisionName+"\" class=\"formElemen\" size=\"10\"><input type=\"hidden\" name=\"department_pay\" value=\""+departmentName+"\" class=\"formElemen\" size=\"10\"><input type=\"hidden\" name=\"section_pay\" value=\""+sectionName+"\" class=\"formElemen\" size=\"10\">");
				for(int j=0 ; j < numToken ; j++){
					 String nilai="";
					 int compValue = 0;
					 nilai = (String)token.get(j);
					 if(paySlip.getPeriodId()==periodeId){
					    compValue = PstPaySlipComp.getCompValue(paySlip.getOID(),nilai);
					 }else{
					 	long paySlipNonPeriod = 0;
						compValue = PstPaySlipComp.getCompValue(paySlipNonPeriod,nilai);
					 }
					 total = total + compValue;
					rowx.add("<input type=\"text\" align=\"right\" name=\"comp_value"+i+""+j+"\" value=\""+Formater.formatNumber(compValue, frmCurrency)+"\" class=\"formElemen\" size=\"10\">");
				}
				rowx.add(""+Formater.formatNumber(total, frmCurrency));
				if(paySlip.getStatus() == PstPaySlip.NO_APPROVE){
						rowx.add("<input type=\"checkbox\" name=\"status"+i+"\" value=\""+employee.getOID()+"\">");
				}
				else{
						rowx.add("<input type=\"checkbox\" name=\"status"+i+"\" value=\""+employee.getOID()+"\" checked>");
				}	
				if(paySlip.getPaidStatus() == PstPaySlip.NO_PAID){
					rowx.add("<input type=\"checkbox\" name=\"paid_status"+i+"\" value=\""+employee.getOID()+"\" class=\"formElemen\" size=\"10\">");
				}
				else{
					rowx.add("<input type=\"checkbox\" name=\"paid_status"+i+"\" value=\""+employee.getOID()+"\" class=\"formElemen\" size=\"10\" checked>");
				}
			}else{
				rowx.add(String.valueOf(1 + i)+"<input type=\"hidden\" name=\"numToken\" value=\""+numToken+"\" class=\"formElemen\" size=\"10\">");
				rowx.add(employee.getEmployeeNum()+"<input type=\"hidden\" name=\"employee_id\" value=\""+employee.getOID()+"\" class=\"formElemen\" size=\"10\">");
				rowx.add("<a href=\"javascript:cmdLevel('"+String.valueOf(employee.getOID())+"','"+String.valueOf(levelCode)+"','"+String.valueOf(paySlip.getOID())+"','1')\">"+employee.getFullName() +"</a><input type=\"hidden\" name=\"commenc_date\" value=\""+employee.getCommencingDate()+"\" class=\"formElemen\" size=\"10\"><input type=\"hidden\" name=\"bankId\" value=\""+bankId+"\" class=\"formElemen\" size=\"10\">");
				//get the position
					Position pos = new Position();
					String position ="";
							try{
								pos = PstPosition.fetchExc(employee.getPositionId());
								position = pos.getPosition();
							}
							catch(Exception e){
							}
							
						//get the department name by DepartmentId
				Department dep= new Department();
				String departmentName ="";
				try{
					dep = PstDepartment.fetchExc(employee.getDepartmentId());
					departmentName = dep.getDepartment();
				  }
				catch(Exception e){
				}
				
				//get the division name by divisionId
				Division div= new Division();
				String divisionName ="";
				try{
					div = PstDivision.fetchExc(employee.getDivisionId());
					divisionName = div.getDivision();
				  }
				catch(Exception e){
				}
				
				//get the section name by sectionId
				Section sect= new Section();
				String sectionName ="";
				try{
					sect = PstSection.fetchExc(employee.getSectionId());
					sectionName = sect.getSection();
				  }
				catch(Exception e){
				}
				rowx.add(position+"<input type=\"hidden\" name=\"position\" value=\""+position+"\" class=\"formElemen\" size=\"10\"><input type=\"hidden\" name=\"division_pay\" value=\""+divisionName+"\" class=\"formElemen\" size=\"10\"><input type=\"hidden\" name=\"department_pay\" value=\""+departmentName+"\" class=\"formElemen\" size=\"10\"><input type=\"hidden\" name=\"section_pay\" value=\""+sectionName+"\" class=\"formElemen\" size=\"10\">");
				// banyak anak yang dimiliki oleh karyawan
				String whereFamily = PstFamilyMember.fieldNames[PstFamilyMember.FLD_EMPLOYEE_ID]+"="+employee.getOID()+
									 " AND "+PstFamilyMember.fieldNames[PstFamilyMember.FLD_RELATIONSHIP]+" like '%Children%'";
				int numChildren = PstFamilyMember.getCount(whereFamily);	
				System.out.println("numChildren  "+numChildren);
				for(int k =0 ;k < numToken ; k++){
					 String nilai="";
					 int compValue = 0;
					 nilai = (String)token.get(k); nilai= (nilai!=null) ? nilai.trim() :"";
					 if(paySlip.getPeriodId()==periodeId){
					 	compValue = PstPaySlipComp.getCompValue(paySlip.getOID(),nilai);
					 }
					 else{
					 	long paySlipNonPeriod = 0;
						compValue = PstPaySlipComp.getCompValue(paySlipNonPeriod,nilai);
					 }
					
					 total = total + compValue;
					 // sesuikan dengan jumlah anaknya
					 /*if(k > numChildren+1){
						rowx.add("<input type=\"text\" align=\"right\" name=\"comp_value"+i+""+k+"\" value=\""+Formater.formatNumber(compValue, frmCurrency)+"\" class=\"formElemen\" size=\"10\" disabled>");
					 }
					 else{*/
						rowx.add("<input type=\"text\" align=\"right\" name=\"comp_value"+i+""+k+"\" value=\""+Formater.formatNumber(compValue, frmCurrency)+"\" class=\"formElemen\" size=\"10\">");
					// }
				}
				rowx.add(""+Formater.formatNumber(total, frmCurrency));
				if(paySlip.getStatus() == PstPaySlip.NO_APPROVE){
						rowx.add("<input type=\"checkbox\" name=\"status"+i+"\" value=\""+employee.getOID()+"\">");
						//rowx.add("<input type=\"checkbox\" name=\"status"+i+"\" value=\"1\">");
				}
				else{
						rowx.add("<input type=\"checkbox\" name=\"status"+i+"\" value=\""+employee.getOID()+"\" checked>");
				}
				if(paySlip.getPaidStatus() == PstPaySlip.NO_PAID){
					rowx.add("<input type=\"checkbox\" name=\"paid_status"+i+"\" value=\""+employee.getOID()+"\" class=\"formElemen\" size=\"10\">");
				}
				else{
					rowx.add("<input type=\"checkbox\" name=\"paid_status"+i+"\" value=\""+employee.getOID()+"\" class=\"formElemen\" size=\"10\" checked>");
				}
			}
			//lstData.add(rowx);
                        ctrlist.drawListRow(outJsp, 0, rowx, i);
		}
                	result = "";
                        ctrlist.drawListEndTable(outJsp);// ctrlist.drawList(outJsp,0 ); //ctrlist.drawList(); 
		}else{
			result = "<i>Belum ada data dalam sistem ...</i>";
		}
	return result;
}
%>
<% 
	String s_employee_id = null;
    String s_status= null;
    String s_paid_status= null;
	String s_commenc_date = null;
	String s_position = null;
	String s_bankId = null;
	String s_division = null;
	String s_department = null;
	String s_section = null;
	int kolom =0;
	int statusApprove = 0;
	int statusPaid = 0;
	long  oidEmployee=0;
	long  oidEmployeePaid=0;
	double valueComp = 0;
	String compCode = null;
	/*mengambil nama period saat ini
	Updated By Yunny*/
	/*Date nowDate = new Date();
	long oidPeriod = PstPeriod.getPeriodIdBySelectedDate(nowDate);
	Period period = new Period();
	Date startDate = new Date();
	try{
		period = PstPeriod.fetchExc(oidPeriod);
		startDate = period.getStartDate();
	}
		catch(Exception e){
	}

	Calendar newCalendar = Calendar.getInstance();
	newCalendar.setTime(startDate);
	int dateOfMonth = newCalendar.getActualMaximum(Calendar.DAY_OF_MONTH); */
	// Jika tekan command Save
    if (iCommand == Command.SAVE) {
		
		String[] employee_id = null;		
        String[] status = null;
        String[] paid_status= null;
		String[] commenc_date = null;
		String[] position = null;
		String[] bankId = null;
		String[] division=null;
		String[] department = null;
		String[] section = null;
		// Inisialisasi variable yang meng-handle nilai2 berikut
		try {
            employee_id = request.getParameterValues("employee_id");
            status = request.getParameterValues("status");
            paid_status = request.getParameterValues("paid_status");
			commenc_date = request.getParameterValues("commenc_date");
			position = request.getParameterValues("position");
			bankId = request.getParameterValues("bankId");
			division = request.getParameterValues("division_pay");
			department = request.getParameterValues("department_pay");
			section = request.getParameterValues("section_pay");
			 }
        catch (Exception e) 
		{
			System.out.println("Err : "+e.toString());
		}
                if(employee_id!=null){
		for (int i = 0; i < listPreData.size(); i++) 
			{
				try 
					{
					   oidEmployee = FRMQueryString.requestLong(request, "status"+i+""); 
					   oidEmployeePaid = FRMQueryString.requestLong(request, "paid_status"+i+"");
					   s_employee_id = String.valueOf(employee_id[i]);
					   s_status = String.valueOf(status[i]);
					   s_paid_status= String.valueOf(paid_status[i]);
					   s_commenc_date= String.valueOf(commenc_date[i]);
					   s_position= String.valueOf(position[i]);
					   s_bankId = String.valueOf(bankId[i]);
					   s_division = String.valueOf(division[i]);
					   s_department = String.valueOf(department[i]);
					   s_section = String.valueOf(section[i]);
					  
					 } catch (Exception e) 
						{
						}
					PaySlip paySlip = new PaySlip();
					paySlip.setPeriodId(periodeId);
					paySlip.setEmployeeId(Long.parseLong(employee_id[i]));
					//System.out.println("nilai statusSave"+statusSave);
					if(oidEmployee!=0){
						statusApprove = PstPaySlip.YES_APPROVE;
					}
					else{
						statusApprove = PstPaySlip.NO_APPROVE;
					}
					if(oidEmployeePaid!=0){
						statusPaid = PstPaySlip.YES_PAID;
					}
					else{
						statusPaid = PstPaySlip.NO_PAID;
					}
						// membedakan command save dan save - approve
						if(statusSave==1){
							paySlip.setStatus (PstPaySlip.YES_APPROVE);
						}
						else{
							paySlip.setStatus (statusApprove);
						}
					paySlip.setPaidStatus(statusPaid);
					paySlip.setPaySlipDate(new Date());
					Date commDate = Formater.formatDate(commenc_date[i],"yyyy-MM-dd");
					paySlip.setCommencDate(commDate);
					paySlip.setPosition(position[i]);
					paySlip.setDivision(division[i]);
					paySlip.setDepartment(department[i]);
					paySlip.setSection(section[i]);
					paySlip.setCompCode("");
					paySlip.setBankId(Long.parseLong(bankId[i]));
					//paySlip.setProcentasePresence(0);
					//paySlip.setDayPresent(presence);
					//insert ke dalam tabel payslip
					try{
						//PstPaySlip.insertExc(paySlip);
						/* untuk mengecek apakah didatabase sudah ada data yang sama
							agar tidak terjadi data yang double
						*/
						// kemungkinan kalo ada  tunjangan yang satu sudah diapprove sedangkan yang satu belum
						/*String whereCek = PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID] +"="+periodeId+" AND "+
										  PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]+"="+Long.parseLong(employee_id[i])+" AND "+
										  PstPaySlip.fieldNames[PstPaySlip.FLD_COMP_CODE]+"='"+codeComponenGeneral+"'";	*/
						// jika beranggapan kalo salah satu diapprove,berarti approve semua
						String whereCek = PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID] +"="+periodeId+" AND "+
										  PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]+"="+Long.parseLong(employee_id[i]);
										  	
						Vector vectCek = PstPaySlip.list(0,0,whereCek,"");
						try{
							if(vectCek.size() == 0) {
								PstPaySlip.insertExc(paySlip);
							}
							else{
								//lakukan update status 
								// kemungkinan kalo ada  tunjangan yang satu sudah diapprove sedangkan yang satu belum
								/*long oidPaySlip = PstPaySlip.getPaySlipId(periodeId,Long.parseLong(employee_id[i]),codeComponenGeneral);*/
								// jika beranggapan kalo salah satu diapprove,berarti approve semua
								long oidPaySlip = PstPaySlip.getPaySlipId(periodeId,Long.parseLong(employee_id[i]));
								PstPaySlip.updateStatus(oidPaySlip,statusApprove,statusPaid);
							}
						}catch(Exception e){
							System.out.println("ERR"+e.toString());
						}
					}catch(Exception e){System.out.println("ERR"+e.toString());}
					 kolom = FRMQueryString.requestInt(request, "numToken");
						 // untuk insert vallue komponen
                                                 PayPeriod prevPeriod = PstPayPeriod.getPreviousPeriod(periodeId); 
                                                 // Period prevPeriod = PstPeriod.getPreviousPeriod(periodeId);
                                         
						 for(int k =0;k < kolom ;k++){
							compCode = FRMQueryString.requestString(request, "compToken"+k+""); 	
                                                        if(compCode!=null){
                                                            compCode= compCode.trim();
                                                        }
                                                        int copyLastMonthVal = FRMQueryString.requestInt(request, "copysamevalue"); 
                                                        if(copyLastMonthVal>0){
                                                            valueComp  = PstPaySlipComp.getCompValueEmployee(Long.parseLong(employee_id[i]),prevPeriod.getOID(),compCode);
                                                            } else{
                                                            valueComp = FRMQueryString.requestDouble(request, "comp_value"+i+""+k+""); 
                                                        }
                                                        
							//ambil Id untuk 
							//lakukan update status 
								// kemungkinan kalo ada  tunjangan yang satu sudah diapprove sedangkan yang satu belum
							/*long paySlipId = PstPaySlip.getPaySlipId(periodeId,Long.parseLong(employee_id[i]),codeComponenGeneral);*/
								// jika beranggapan kalo salah satu diapprove,berarti approve semua
							long paySlipId = PstPaySlip.getPaySlipId(periodeId,Long.parseLong(employee_id[i]));
                                                        
                                                        
							paySlipComp.setPaySlipId(paySlipId);
							paySlipComp.setCompCode(compCode);
							paySlipComp.setCompValue(valueComp);
							String whereSlip = PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]+"="+paySlipId+
												" AND "+PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE]+"='"+compCode+"'";
							Vector vectSlipComp = PstPaySlipComp.list(0,0,whereSlip,"");
							try{
								//if((valueComp > 0) && (vectSlipComp.size()==0)){
                                                                if(vectSlipComp.size()==0){
									PstPaySlipComp.insertExc(paySlipComp);
								}
								else{
									// lakukan update nilai
									System.out.println("masuk update................"+valueComp);
									PstPaySlipComp.updateCompValue(paySlipId,compCode,valueComp);
								}
							}catch(Exception e){System.out.println("ERR"+e.toString());}
						 
						 }
			}
			// kalo salah satu tunjangan approve dan yang lain dianggap belum approve
			listPreData = SessEmployee.listPreData(oidDepartment,levelCode,oidSection,searchNrFrom,searchNrTo,searchName,dataStatus,codeComponenGeneral,periodeId);			
			// kalo salah satu tunjangan approve dan yang lain dianggap  approve
			listPreData = SessEmployee.listPreData(oidDepartment,levelCode,oidSection,searchNrFrom,searchNrTo,searchName,dataStatus,"",periodeId);			
                      }

	}
        
        
    long sdmDivisionOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_SDM_DIVISION)));
    long empDivisionId = 0;
    empDivisionId = emplx.getDivisionId();
%>

<!-- End of JSP Block -->
<html>
<!-- #BeginTemplate "/Templates/main.dwt" --> 
<head>
<!-- #BeginEditable "doctitle" --> 
<title>HARISMA - </title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "styles" --> 
<link rel="stylesheet" href="../../styles/main.css" type="text/css">
<!-- #EndEditable --> <!-- #BeginEditable "stylestab" --> 
<link rel="stylesheet" href="../../styles/tab.css" type="text/css">
<!-- #EndEditable --> <!-- #BeginEditable "headerscript" --> 
<SCRIPT language=JavaScript>
	
function fnTrapKD(){
   if (event.keyCode == 13) {
		document.all.aSearch.focus();
		cmdSearch();
   }
}

function cmdSearch(){
	document.frm_prepare_data.command.value="<%=Command.LIST%>";
	document.frm_prepare_data.action="pay-pre-data.jsp";
        document.frm_prepare_data.target="";
	document.frm_prepare_data.submit();
}

function cmdGenerate(){
	document.frm_prepare_data.command.value="<%=Command.UPDATE%>";
	document.frm_prepare_data.action="pay-pre-data.jsp";
        document.frm_prepare_data.target="";
	document.frm_prepare_data.submit();
}


function openLevel(){
    var strUrl ="sel_salary-level.jsp?frmname=frm_prepare_data";
    var levelWindow = window.open(strUrl);
    levelWindow.focus();
}

function clearLevelCode(){
    document.frm_prepare_data.level.value="";
}

function cmdLoad(component_code,component_name){
	document.frm_prepare_data.compCode.value=component_code;
	document.frm_prepare_data.compName.value=component_name;
	document.frm_prepare_data.command.value="<%=Command.LIST%>";
	document.frm_prepare_data.action="pay-pre-data.jsp";
        document.frm_prepare_data.target="";
	document.frm_prepare_data.submit();
	document.frm_prepare_data.refresh;
}

function cmdLevel(employeeId,salaryLevel,paySlipId,paySlipPeriod){
	document.frm_prepare_data.action="pay-input-detail.jsp?employeeId=" + employeeId+ "&salaryLevel=" + salaryLevel+"&paySlipId=" + paySlipId +"&paySlipPeriod=" + paySlipPeriod ;
	document.frm_prepare_data.command.value="<%=Command.LIST%>";
        document.frm_prepare_data.target="opendetail";        
	document.frm_prepare_data.submit();
}

function cmdSave(){
	document.frm_prepare_data.command.value="<%=Command.SAVE%>";
	document.frm_prepare_data.aksiCommand.value="0";
	document.frm_prepare_data.statusSave.value="0";
	document.frm_prepare_data.action="pay-pre-data.jsp";
        document.frm_prepare_data.target="";
	document.frm_prepare_data.submit();
}
function cmdSaveAll(){
	document.frm_prepare_data.command.value="<%=Command.SAVE%>";
	document.frm_prepare_data.aksiCommand.value="0";
	document.frm_prepare_data.statusSave.value="1";
	document.frm_prepare_data.action="pay-pre-data.jsp";
        document.frm_prepare_data.target="";
	document.frm_prepare_data.submit();
}

function cmdBack(){
	document.frm_prepare_data.command.value="<%=Command.LIST%>";
	document.frm_prepare_data.action="pay-pre-data.jsp";
        document.frm_prepare_data.target="";
	document.frm_prepare_data.submit();
}
function cmdUpload(){
	document.frm_prepare_data.command.value="<%=Command.LOAD %>"; 
	document.frm_prepare_data.action="../../system/excel_up/up_salary_v2.jsp";
        document.frm_prepare_data.target="";
	document.frm_prepare_data.submit();
}

function cmdGoToGenerate(){
    document.frm_prepare_data.action="generate_payslip.jsp";
    document.frm_prepare_data.submit();
}

function cmdConfig(){
    document.frm_prepare_data.action="config_potongan.jsp";
    document.frm_prepare_data.submit();
}



    function hideObjectForEmployee(){
        
    } 
	 
    function hideObjectForLockers(){ 
    }
	
    function hideObjectForCanteen(){
    }
	
    function hideObjectForClinic(){
    }

    function hideObjectForMasterdata(){
    }
	
	function showObjectForMenu(){
        
    }
</SCRIPT>
    <style type="text/css">
            .tblStyle {border-collapse: collapse;}
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px;}
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}

            body {color:#373737;}
            #menu_utama {padding: 9px 14px; font-weight: bold; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
            #menu_title {color:#0099FF; font-size: 14px;}
            #menu_teks {color:#CCC;}
            
            #btn {
              background: #3498db;
              border: 1px solid #0066CC;
              border-radius: 3px;
              font-family: Arial;
              color: #ffffff;
              font-size: 12px;
              padding: 3px 9px 3px 9px;
            }

            #btn:hover {
              background: #3cb0fd;
              border: 1px solid #3498db;
            }
            
            .title_part {color:#FF7E00; background-color: #F7F7F7; border-left: 1px solid #0099FF; padding: 9px 11px;}
            
            body {background-color: #EEE;}
            .header {
                
            }
            .info {
                color: #5f93b4;
                font-size: 12px;
                background-color: #ddeffa;
                padding: 9px 12px;
                border: 1px solid #aec9da;
                border-radius: 3px;
                margin: 5px 0px;
            }
            .content-main {
                padding: 5px 25px 25px 25px;
                margin: 0px 23px 59px 23px;
            }
            .content-info {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
            }
            .content-title {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
                margin-bottom: 5px;
            }
            #title-large {
                color: #575757;
                font-size: 16px;
                font-weight: bold;
            }
            #title-small {
                color:#797979;
                font-size: 11px;
            }
            .content {
                padding: 21px;
            }
            .box {
                margin: 17px 7px;
                background-color: #FFF;
                color:#575757;
            }
            #box_title {
                padding:21px; 
                font-size: 14px; 
                color: #007fba;
                border-top: 1px solid #28A7D1;
                border-bottom: 1px solid #EEE;
            }
            #box_content {
                padding:21px; 
                font-size: 12px;
                color: #575757;
            }
            .box-info {
                padding:21px 43px; 
                background-color: #F7F7F7;
                border-bottom: 1px solid #CCC;
                -webkit-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
                 -moz-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
                      box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
            }
            #title-info-name {
                padding: 11px 15px;
                font-size: 35px;
                color: #535353;
            }
            #title-info-desc {
                padding: 7px 15px;
                font-size: 21px;
                color: #676767;
            }
            
            #photo {
                padding: 7px; 
                background-color: #FFF; 
                border: 1px solid #DDD;
            }
            .btn {
                background-color: #00a1ec;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 15px 7px 15px;
                text-decoration: none;
            }

            .btn:hover {
                color: #FFF;
                background-color: #007fba;
                text-decoration: none;
            }
            
            .btn-small {
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #676767; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small:hover { background-color: #474747; color: #FFF;}
            
            .btn-small-e {
                font-family: sans-serif;
                text-decoration: none;
                padding: 3px 5px; 
                background-color: #92C8E8; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small-e:hover { background-color: #659FC2; color: #FFF;}
            
            .btn-small-x {
                font-family: sans-serif;
                text-decoration: none;
                padding: 3px 5px; 
                background-color: #EB9898; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small-x:hover { background-color: #D14D4D; color: #FFF;}
            
            .tbl-main {border-collapse: collapse; font-size: 11px; background-color: #FFF; margin: 0px;}
            .tbl-main td {padding: 4px 7px; border: 1px solid #DDD; }
            #tbl-title {font-weight: bold; background-color: #F5F5F5; color: #575757;}
            
            .tbl-small {border-collapse: collapse; font-size: 11px; background-color: #FFF;}
            .tbl-small td {padding: 2px 3px; border: 1px solid #DDD; }
            
            #caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            #divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
            }
            
            #div_item_sch {
                background-color: #EEE;
                color: #575757;
                padding: 5px 7px;
            }
            
            .form-style {
                font-size: 12px;
                color: #575757;
                border: 1px solid #DDD;
                border-radius: 5px;
            }
            .form-title {
                padding: 11px 21px;
                margin-bottom: 2px;
                border-bottom: 1px solid #DDD;
                background-color: #EEE;
                border-top-left-radius: 5px;
                border-top-right-radius: 5px;
                font-weight: bold;
            }
            .form-content {
                padding: 21px;
            }
            .form-footer {
                border-top: 1px solid #DDD;
                padding: 11px 21px;
                margin-top: 2px;
                background-color: #EEE;
                border-bottom-left-radius: 5px;
                border-bottom-right-radius: 5px;
            }
            #confirm {
                font-size: 12px;
                padding: 7px 0px 8px 15px;
                background-color: #FF6666;
                color: #FFF;
                visibility: hidden;
            }
            #btn-confirm-y {
                padding: 7px 15px 8px 15px;
                background-color: #F25757; color: #FFF; 
                font-size: 12px; cursor: pointer;
            }
            #btn-confirm-n {
                padding: 7px 15px 8px 15px;
                background-color: #E34949; color: #FFF; 
                font-size: 12px; cursor: pointer;
            }
            .footer-page {
                font-size: 12px;
            }
            #record_count{
                font-size: 12px;
                font-weight: bold;
                padding-bottom: 9px;
            }
            .caption {font-weight: bold; padding-bottom: 3px;}
            .divinput {margin-bottom: 7px;}
            #payroll_num {
                background-color: #DEDEDE;
                border-radius: 3px;
                font-family: Arial;
                font-weight: bold;
                color: #474747;
                font-size: 12px;
                padding: 5px 11px 5px 11px;
                cursor: pointer;
            }
        </style>
<!-- #EndEditable --> 
</head>
<body><div class="header">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
                    <!-- #BeginEditable "header" --> 
                    <%@ include file = "../../main/header.jsp" %>
                    <!-- #EndEditable --> 
                </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" --> 
                    <%@ include file = "../../main/mnmain.jsp" %>
                    <!-- #EndEditable --> </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="10" valign="middle"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                            <td align="left"><img src="<%=approot%>/images/harismaMenuLeft1.jpg" width="8" height="8"></td>
                            <td align="center" background="<%=approot%>/images/harismaMenuLine1.jpg" width="100%"><img src="<%=approot%>/images/harismaMenuLine1.jpg" width="8" height="8"></td>
                            <td align="right"><img src="<%=approot%>/images/harismaMenuRight1.jpg" width="8" height="8"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <%}%>
            </table>
        </div>
        <div id="menu_utama">
            <span id="menu_title">Payroll Process <strong style="color:#333;"> / </strong>Prepare Data</span>
        </div>
        <div class="content-main">
            <form name="frm_prepare_data" method="post" action="">
                <input type="hidden" name="command" value="">
                <input type="hidden" name="aksiCommand" value="<%=aksiCommand%>">
                <input type="hidden" name="compCode" value="<%=codeComponenGeneral%>">
                <input type="hidden" name="compName" value="<%=compName%>">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="oidPaySlipComp " value="<%=oidPaySlipComp%>">
                <input type="hidden" name="statusSave" value="<%=statusSave%>">
                <table>
                    <tr>
                        <td style="padding:5px 12px 5px 2px; font-weight: bold;">Period</td>
                        <td>
                            <%
                                Vector perValue = new Vector(1, 1);
                                Vector perKey = new Vector(1, 1);
                                // salkey.add(" ALL DEPARTMET");
                                //deptValue.add("0");
                                Vector listPeriod = PstPayPeriod.list(0, 0, "", "START_DATE DESC");
                                //Vector listPeriod = PstPeriod.list(0, 0, "", "START_DATE DESC");
                                for (int r = 0; r < listPeriod.size(); r++) {
                                    PayPeriod payPeriod = (PayPeriod) listPeriod.get(r);
                                    //Period period = (Period)listPeriod.get(r);
                                    perValue.add("" + payPeriod.getOID());
                                    perKey.add(payPeriod.getPeriod());
                                }
                            %> <%=ControlCombo.draw("periodId", null, "" + periodId, perValue, perKey, "")%>
                        </td>
                        <td style="padding:5px 12px 5px 2px; font-weight: bold;"><!--Department--></td>
                        <td>
                            <!--  DepartmentIDnNameList keyList= new DepartmentIDnNameList ();          
                                        Vector dept_value = new Vector(1,1);
                                        Vector dept_key = new Vector(1,1);        
                                       dept_value.add("0");
                                        dept_key.add("select ...");                                                          
                                        keyList = PstDepartment.genDepIDandNameWithCompanyDiv(0, 1000, "", true);
                                        dept_value = keyList.getDepIDs();
                                        dept_key = keyList.getDepNames();                                      
                                        /*
                                        Vector listDept = PstDepartment.list(0, 0, "", " DEPARTMENT ");                                                        
                                        for (int i = 0; i < listDept.size(); i++) {
                                                Department dept = (Department) listDept.get(i);
                                                dept_key.add(dept.getDepartment());
                                                dept_value.add(String.valueOf(dept.getOID()));
                                        }*/
                                                                                            out.println(ControlCombo.draw("department",null,""+oidDepartment,dept_value,dept_key));
                                                                            -->
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:5px 12px 5px 2px; font-weight: bold;">Salary Level</td>
                        <td>
                            <input name="level" type="text" readonly="true" value="<%=levelCode%>"> <a href="javascript:openLevel();">Select</a>
                          | <a href="javascript:clearLevelCode()">Clear</a>
                        <% /*
                                                                                      Vector listSalaryLevel = PstSalaryLevel.list(0, 0, "", "LEVEL_NAME");										  
                                                                                      Vector salValue = new Vector(1,1);
                                                                                      Vector salKey = new Vector(1,1);
                                                                                      salValue.add(""+"0");
                                                                                            salKey.add("- All Level -");										  

                                                                                      for(int d=0;d<listSalaryLevel.size();d++)
                                                                                      {
                                                                                            SalaryLevel salLevel = (SalaryLevel)listSalaryLevel.get(d);
                                                                                            salValue.add(""+salLevel.getLevelCode());
                                                                                            salKey.add(salLevel.getLevelName());										  
                                                                                      }
                                                                                      out.println(ControlCombo.draw("level",null,""+levelCode,salValue,salKey));
                              */   %>
                        </td>
                        <td style="padding:5px 12px 5px 2px; font-weight: bold;"><!--Section--></td>
                        <td>
                            <!-- 
                            Vector sec_value = new Vector(1,1);
                            Vector sec_key = new Vector(1,1); 
                            sec_value.add("0");
                            sec_key.add("select ...");
                            //Vector listSec = PstSection.list(0, 0, "", " DEPARTMENT_ID, SECTION ");
                            Vector listSec = PstSection.list(0, 0, "", " SECTION ");
                            for (int i = 0; i < listSec.size(); i++) {
                                    Section sec = (Section) listSec.get(i);
                                    sec_key.add(sec.getSection());
                                    sec_value.add(String.valueOf(sec.getOID()));
                            }
                            out.println(ControlCombo.draw("section",null,""+oidSection,sec_value,sec_key));
                            -->
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:5px 12px 5px 2px; font-weight: bold;"><!--Employee. Nr--></td>
                        <td>
                            <!--
                            <input type="text" name="searchNrFrom" size="12" value="<=searchNrFrom%>">
                            to 
                            <input type="text" name="searchNrTo" size="12" value="<=searchNrTo%>">
                            -->
                        </td>
                        <td style="padding:5px 12px 5px 2px; font-weight: bold;"><!--Name--></td>
                        <td><!--<input type="text" name="searchName" size="20" value="<=searchName%>">--></td>
                    </tr>
                    <!--
                    <tr>
                        <td style="padding:5px 12px 5px 2px; font-weight: bold;"><--Status-></td>
                        <td>
                            if(dataStatus==0){%>

                                    <input type="radio" name="dataStatus" value="0" checked >
                                    Draft
                                    <input type="radio" name="dataStatus" value="1">
                                    Final
                                    <input type="radio" name="dataStatus" value="2" >
                                    All 
                                    < } %>
                                    <
                            if(dataStatus==1){%>

                                    <input type="radio" name="dataStatus" value="0"  >
                                    Draft 
                                    <input type="radio" name="dataStatus" value="1" checked>
                                    Final
                                    <input type="radio" name="dataStatus" value="2" >
                                    All 
                                    < } %>
                                    <
                                    if(dataStatus==2){%>
                                    <input type="radio" name="dataStatus" value="0"  >
                                    Draft 
                                    <input type="radio" name="dataStatus" value="1" >
                                    Final
                                    <input type="radio" name="dataStatus" value="2" checked>
                                    All 
                                    < } %>
                        </td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    -->
                </table>
                <div>&nbsp;</div>
                <div class="info">
                    <div><strong style="font-size: 14px;">Feature :</strong></div>
                    <div>&nbsp;</div>
                    <div><strong>Upload from Excel</strong></div>
                    <div>
                        Lakukan generate pay slip terlebih dahulu jika periode nya baru. 
                        Jika ingin melakukan pada periode yang sudah ada, maka tidak perlu melakukan generate pay slip.
                    </div>
                    <div>&nbsp;</div>
                    <div><strong>Go to Generate</strong></div>
                    <div>
                        Generate dilakukan untuk membuat pay slip dan juga komponen nya.
                    </div>
                </div>
                <div>&nbsp;</div>
                <!--<a href="javascript:cmdSearch()" class="btn" style="color:#FFF;">Search for Employee</a>-->
                <!--
                if (privAdd == true){
                    -->
                                        
                    <!--
                }
                -->
                <%
                if (sdmDivisionOid == empDivisionId){
                %>
                <a href="javascript:cmdUpload()" class="btn" style="color:#FFF;">Upload from Excel</a>  
                <a href="javascript:cmdGoToGenerate()" class="btn" style="color:#FFF;">Go to Generate</a>
                <% } %>
                
                <a href="javascript:cmdConfig()" class="btn" style="color:#FFF;">Konfigurasi Potongan Kredit</a>
                
                                       <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        
                                        <tr> 
                                          <td height="13" width="0%">&nbsp;</td>
                                          <td height="13" colspan="4">&nbsp;<%if(msgString!=null && msgString.length()>2){%><br><%=msgString%><br><br><%}%></td>
                                        </tr>
                                        <tr> 
                                         
                                          <td height="13" colspan="4">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
											  <%
											   if((listPreData!=null)&&(listPreData.size()>0)){
											   %>
											  <td width="9%">Entry data for 
                                                  			: </td>
											 	<%
													// kosongkan dulu tabel componentIn
													PstPayComponentIn.deleteAll();
											  		Vector component = new Vector (1,1);
													String whereComponent =  "slip."+PstSalaryLevelDetail.fieldNames[PstSalaryLevelDetail.FLD_FORMULA]+
                           													 " LIKE '%IN\\_%' "+
																			 " AND slip."+PstSalaryLevelDetail.fieldNames[PstSalaryLevelDetail.FLD_LEVEL_CODE]+"='"+levelCode+"'" ;
						   							component = PstPayComponent.getManualComponent(whereComponent);
													//out.println("component  "+component.size());
													Vector listManual = new Vector (1,1);
													Vector listCompManual = new Vector(1,1);
													Vector componentTemp = new Vector (1,1);
													if(component!=null && component.size() > 0){
														for (int i = 0; i < component.size(); i++) { i=component.size()-1;
																PayComponent pay = (PayComponent) component.get(i);
																String where  = "slip."+PstSalaryLevelDetail.fieldNames[PstSalaryLevelDetail.FLD_FORMULA]+
                           													    " LIKE '%"+pay.getCompCode()+"%'";
																//String where = PstSalaryLevelDetail.fieldNames[PstSalaryLevelDetail.FLD_FORMULA]+" LIKE '%"+pay.getCompCode()+"%'";
																// by kartika listManual = PstPayComponent.getManualComponent(where);
																for(int m = 0; m < listManual.size(); m++){ m=listManual.size()-1;
																			PayComponent salPay= (PayComponent)listManual.get(0);
																			PayComponentIn compIn = new PayComponentIn();
																			compIn.setCompCode(salPay.getCompCode());
																			compIn.setCompName(salPay.getCompName());
																			// insert ke tabel penampung sementara
																			PstPayComponentIn.insertExc(compIn);
																	
																}
																
														}
													}
													Vector componentIn = PstPayComponentIn.getCompIn();
													if(componentIn!=null && componentIn.size() > 0){
														for(int i=0;i < componentIn.size();i++){
															PayComponentIn pay = (PayComponentIn) componentIn.get(i);
															out.println("<td>");
															out.println("&nbsp;&nbsp;<a href=\"javascript:cmdLoad('"+String.valueOf(pay.getCompCode())+"','"+String.valueOf(pay.getCompName())+"')\">"+pay.getCompName()+"&nbsp;</a>");
															out.println("</td>");
														}
													}
											  	%>
                                                 <td width="100%">&nbsp;</td>
                                              </tr>
											  <%
											  }
											  %>
                                            </table>
                                          </td>
                                        </tr>
                                        
									     <%
										  //System.out.println("listPreData  "+listPreData.size());
										  if((listPreData!=null)&&(listPreData.size()>0)){
										  %>
                                        <tr> 
						<td colspan="6" height="8">
                                                    <%=drawList(out, iCommand,frmPaySlipComp, paySlipComp,listPreData, oidPaySlipComp,codeComponenGeneral,compName,periodeId,levelCode)%>
                                                
                                                    <% if (salLevDetail.getCopyData() > 0) {%>
                                                    <input type="checkbox" name="copysamevalue" value="1"> Copy Same Value Last Period &nbsp;&nbsp;&nbsp;&nbsp;
                                                    <% }%>
                                                    <div>&nbsp;</div>
                                                    <a href="javascript:cmdSave()" class="btn" style="color:#FFF;">Save</a> 
                                                </td>
											
                                              
                                        </tr>
											<%}else{%>
											<tr> 
											
                                          <td height="8" width="41%" class="comment">
                                              <span class="comment"><br>
                                            <!--&nbsp;No Employee available--></span> 
                                          </td>
                                        </tr>
										 <%}%>
                                        <tr> 
										  
                                        </tr>
                                        <tr> 
                                          <td class="listtitle" width="0%">&nbsp;</td>
                                          <td class="listtitle" colspan="4">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="0%">
										  										</td>
                                          <td colspan="4">&nbsp; </td>
                                        </tr>
                                        <tr> 
                                          <td width="0%">&nbsp;</td>
                                          <td colspan="4">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="0%">&nbsp;</td>
                                          <td colspan="4">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="0%">&nbsp;</td>
                                          <td colspan="4">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="0%">&nbsp;</td>
                                          <td colspan="4">&nbsp;</td>
                                        </tr>
                                      </table>
									 

                                    </form>
               
        </div>
        <div class="footer-page">
            <table>
                <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
                <tr>
                    <td valign="bottom"><%@include file="../../footer.jsp" %></td>
                </tr>
                <%} else {%>
                <tr> 
                    <td colspan="2" height="20" ><%@ include file = "../../main/footer.jsp" %></td>
                </tr>
                <%}%>
            </table>
        </div>
                                    
</body>

</html>