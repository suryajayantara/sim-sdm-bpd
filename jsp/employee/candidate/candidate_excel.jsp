MIME-Version: 1.0
Content-type: multipart/mixed;boundary="d0f4ad49cc20d19bf96d4adf9322d567"

--d0f4ad49cc20d19bf96d4adf9322d567
Content-type: text/html; charset=utf-8
Content-transfer-encoding: 8bit
<%@page import="org.apache.commons.codec.binary.Base64"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.IOException"%>
<%@page import="com.dimata.harisma.session.employee.SessCandidateParam"%>
<%@page import="com.dimata.harisma.session.employee.SessCandidate"%>
<%@page import="com.dimata.harisma.session.employee.SessEmployeePicture"%>
<%@page import="com.dimata.harisma.session.employee.EmployeeCandidate"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstLevel"%>
<%@page import="com.dimata.harisma.entity.employee.CandidatePositionExperience"%>
<%@page import="com.dimata.harisma.entity.employee.PstCandidatePositionExperience"%>
<%@page import="com.dimata.harisma.entity.employee.CandidatePosition"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.entity.employee.PstCandidatePosition"%>
<%@page import="com.dimata.harisma.entity.employee.PstCandidateMain"%>
<%@page import="com.dimata.harisma.entity.employee.CandidateMain"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@page contentType="application/x-msexcel" pageEncoding="UTF-8" %>
<%!
    public String getBase64EncodedImage(String imageURL) throws IOException {
        java.net.URL url = new java.net.URL(imageURL); 
        InputStream is = url.openStream();  
        byte[] bytes = org.apache.commons.io.IOUtils.toByteArray(is); 
        return Base64.encodeBase64String(bytes);
    }
%>
<%
	long oidCandidate = FRMQueryString.requestLong(request, "candidate_main_id");
	boolean status_aktif = FRMQueryString.requestBoolean(request, "status_aktif");
    boolean status_mbt = FRMQueryString.requestBoolean(request, "status_mbt");
    boolean status_berhenti = FRMQueryString.requestBoolean(request, "status_berhenti");
	CandidateMain candidateMain = new CandidateMain();
	ChangeValue changeValue = new ChangeValue();
	SessCandidateParam parameters = new SessCandidateParam();
	parameters.setEmployeeStatusActiv(status_aktif);
    parameters.setEmployeeStatusMBT(status_mbt);
    parameters.setEmployeeStatusResigned(status_berhenti);
	long positionId = 0;
	if (oidCandidate != 0){
        try {
            candidateMain = PstCandidateMain.fetchExc(oidCandidate);
            
			String whereCandidate = PstCandidatePosition.fieldNames[PstCandidatePosition.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate; 
			Vector candPosList = PstCandidatePosition.list(0, 0, whereCandidate, ""); 
			if (candPosList != null && candPosList.size()>0){
				CandidatePosition candidatePos = (CandidatePosition)candPosList.get(0);
				positionId = candidatePos.getPositionId();
			}
        } catch(Exception e){
            System.out.println("Output: "+e.toString());
        }
    }
    String url = PstSystemProperty.getValueByName("HARISMA_URL");
	response.setHeader("Content-Disposition", "attachment; filename=candidate.xls");
	Vector candidateList = SessCandidate.queryCandidateV2(oidCandidate, positionId, parameters);
        HashMap<String, String> mapImage = new HashMap<String, String>();

%>

<html>
		<h3>Hasil Pencarian Kandidat : <%= changeValue.getPositionName(positionId)%></h3>
		
		<%
		String whereGrade = PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
		Vector<CandidateGradeRequired> listGrade = PstCandidateGradeRequired.listInnerJoin(whereGrade);
		if (listGrade.size()>0){
			%>
			<table border="1">
				<tr>
					<td>Level</td>
					<td>Grade Minimum</td>
					<td>Grade Maximum</td>
				</tr>
				<tr>
					<% 
						for (CandidateGradeRequired gradeRequired : listGrade) { 
							Level lvl = PstLevel.getByGrade(gradeRequired.getGradeMinimum().getGradeRank(),
									gradeRequired.getGradeMaximum().getGradeRank());
					%>
					<td></td>
					<td></td>
					<td></td>
					<% } %>
				</tr>
			</table>
			<%
		}
		%>
		
		
		<%
			String whereExperience = PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate+" AND "
				+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_TYPE]+"=1";
			Vector<CandidatePositionExperience> experienceList = PstCandidatePositionExperience.list(0, 0, whereExperience, "");
			String masaJabatan = "[";
			if (experienceList.size()>0){
				for (CandidatePositionExperience experience : experienceList) {

					try {
						masaJabatan += PstLevel.fetchExc(experience.getExperienceId()).getLevel()+ ",";
					} catch (Exception e) {
						System.out.println("ERROR : " + e.getMessage());
					}
				}
				masaJabatan = masaJabatan.substring(0, masaJabatan.length() - 1);
			}
			masaJabatan += "]";
		%>
        <table border="1" >
			<tr>
				<td style="vertical-align: middle">No</td>
                                <td style="vertical-align: middle">Photo</td>
				<td style="vertical-align: middle">Nama Karyawan</td>
				<td style="vertical-align: middle">Mulai Kerja</td>
				<td style="vertical-align: middle">Satuan Kerja</td>
				<td style="vertical-align: middle">Unit</td>
				<td style="vertical-align: middle">Sub Unit</td>
				<td style="vertical-align: middle">Jabatan</td>
                                <td style="vertical-align: middle">Jenis Jabatan</td>
				<td style="vertical-align: middle">Grade</td>
				<td style="vertical-align: middle">Grade Rank</td>

				<td style="vertical-align: middle">Masa Kerja [bulan]</td>
				<td style="vertical-align: middle">Lama Jabatan Saat ini <%=masaJabatan%> [bulan]</td>
				<td style="vertical-align: middle">Competency Score</td>
				<td style="vertical-align: middle">Pendidikan</td>
				<td style="vertical-align: middle">Score Pendidikan</td>
				<td style="vertical-align: middle">Level Pendidikan</td>
				<td style="vertical-align: middle">Total Score</td>
			</tr>
			<%
				if (candidateList != null && candidateList.size() > 0) {
					for (int c = 0; c < candidateList.size(); c++) {
                                        EmployeeCandidate candidate = (EmployeeCandidate) candidateList.get(c);
                                        Position pos = new Position();
                                        String posName = "";
                                        try {
                                            pos = PstPosition.fetchExc(candidate.getCurrPositionId());
                                            PositionType posType = new PositionType();
                                            posType = PstPositionType.fetchExc(pos.getPosTypeId());
                                            posName = posType.getType();
                                        } catch (Exception exc){}
                    %>
			<tr>
                            <td style="vertical-align: middle"><%= (c + 1)%></td>
                                <td style="vertical-align: middle; text-align: center; height: 150px; padding: 5px">
                                    <%
                                    String pictPath = "";
                                    try {
                                        SessEmployeePicture sessEmployeePicture = new SessEmployeePicture();
                                        pictPath = sessEmployeePicture.fetchImageEmployee(candidate.getEmployeeId());

                                    } catch (Exception e) {
                                        System.out.println("err." + e.toString());
                                    }
                                        if (pictPath != null && pictPath.length() > 0) {
                                            mapImage.put(""+candidate.getPayrollNumber(), getBase64EncodedImage(url+"/"+pictPath));
                                            //out.println("<img class='img' height=\"100\" id=\"photo\" title=\"Click here to upload\"  src=\"" + approot + "/" + pictPath + "\">");
                                        } else {
                                            mapImage.put(""+candidate.getPayrollNumber(), getBase64EncodedImage(url+"/imgcache/no-img.jpg"));
                                    
                                        }
                                    %>
                                    <img class="img" width="85" height="100" id="photo" src="cid:<%=candidate.getPayrollNumber()%>" />
                                </td>
				<td style="vertical-align: middle"><%= "(" + candidate.getPayrollNumber() + ") " + candidate.getFullName()%></td>
				<td style="vertical-align: middle"><%= candidate.getCommecingDate()%></td>
				<td style="vertical-align: middle"><%= candidate.getDivision()%></td>
				<td style="vertical-align: middle"><%= candidate.getDepartment()%></td>
				<td style="vertical-align: middle"><%= (candidate.getSection() != null ? candidate.getSection() : "-")%></td>
				<td style="vertical-align: middle"><%= candidate.getCurrPosition()%></td>
                                <td style="vertical-align: middle"><%= posName%></td>
				<td style="vertical-align: middle"><%= candidate.getGradeCode()%></td>
				<td style="vertical-align: middle"><%= candidate.getGradeRank()%></td>
				<td style="vertical-align: middle"><%= Formater.formatNumber(candidate.getLengthOfService(), "###.##")%></td>
				<td style="vertical-align: middle"><%= Formater.formatNumber(candidate.getCurrentPosLength(), "###.##")%></td>
				<td style="vertical-align: middle"><%= Formater.formatNumber(candidate.getSumCompetencyScore(), "###.##")%></td>
				<td style="vertical-align: middle"><%= candidate.getEducationCode()%></td>
				<td style="vertical-align: middle"><%= Formater.formatNumber(candidate.getEducationScore(), "###.##")%></td>
				<td style="vertical-align: middle"><%= candidate.getEducationLevel()%></td>
				<td style="vertical-align: middle"><%= Formater.formatNumber(candidate.getTotal(), "###.##")%></td>
			</tr>
			<%
					}
				}
			%>
		</table>
</html>

<%
   for ( String key : mapImage.keySet() ) {       
%>
--d0f4ad49cc20d19bf96d4adf9322d567
Content-Type: image/jpeg;
 name="<%=key%>.jpg"
Content-transfer-encoding:base64
Content-ID: <<%=key%>>
Content-Disposition: inline;
 filename="<%=key%>.jpg"; size=7579;

 <%=mapImage.get(key)%>
 
<%}%>
--d0f4ad49cc20d19bf96d4adf9322d567--