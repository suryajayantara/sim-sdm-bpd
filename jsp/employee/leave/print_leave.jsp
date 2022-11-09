<%-- 
    Document   : print_leave
    Created on : Dec 15, 2016, 9:12:34 AM
    Author     : Acer
--%>

<%@page import="com.dimata.harisma.entity.masterdata.PstDivision"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDepartment"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.harisma.entity.leave.PstLeaveApplication"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.entity.masterdata.Division"%>
<%@page import="com.dimata.harisma.entity.masterdata.Position"%>
<%@page import="com.dimata.harisma.entity.masterdata.Department"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.harisma.entity.leave.LeaveApplication"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@ include file = "../../../main/javainit.jsp" %>
<%

    long leaveApplicationId = 0;
    String appRoot = "";
    leaveApplicationId = FRMQueryString.requestLong(request, "oidLeaveApplication");    // untuk mendaptakan oid leave application
    appRoot = FRMQueryString.requestString(request, "approot");    // untuk mendaptakan oid leave application
    //update by satrya 2014-05-27
    int typeForm = FRMQueryString.requestInt(request, "TYPE_FORM_LEAVE");
    LeaveApplication leaveApplication = new LeaveApplication();
    Employee employee = new Employee();
    Department department = new Department();
    Position position = new Position();
    Division division = new Division();

    Vector alStockTaken = new Vector();
    Vector llStockTaken = new Vector();
    Vector specialTaken = new Vector();
    Vector dpTaken = new Vector();

    try {
        leaveApplication = PstLeaveApplication.fetchExc(leaveApplicationId);
    } catch (Exception e) {
        System.out.println("EXCEPTION " + e.toString());
    }
    try {
        employee = PstEmployee.fetchExc(leaveApplication.getEmployeeId());
    } catch (Exception e) {
        System.out.println("EXCEPTION " + e.toString());
    }
    try {
        department = PstDepartment.fetchExc(employee.getDepartmentId());
    } catch (Exception e) {
        System.out.println("EXCEPTION " + e.toString());
    }
    try {
        position = PstPosition.fetchExc(employee.getPositionId());
    } catch (Exception e) {
        System.out.println("EXCEPTION " + e.toString());
    }
    try {
        division = PstDivision.fetchExc(employee.getDivisionId());
    } catch (Exception e) {
        System.out.println("EXCEPTION " + e.toString());
    }


%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- #BeginEditable "styles" -->
        <link rel="stylesheet" href="../../../styles/main.css" type="text/css">
        <!-- #EndEditable --> <!-- #BeginEditable "stylestab" -->
        <link rel="stylesheet" href="../../../styles/tab.css" type="text/css">
        <!-- #EndEditable --> <!-- #BeginEditable "headerscript" -->
        <!-- #EndEditable -->
    </head>
    <body>
        <table>
            <tr>
                <td colspan="18">
                    <img alt="BPD.png" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAANgAAADYCAIAAAAGQrq6AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAEUtSURBVHhe7d13lG9LVSdwCSZGFAwYMAOCAREVIxhQEBHEgIqJpGJEBTOIPp8BxiEYHiiCOSEKMuMYABVExSyKWQeMYM5ZwvPj22vVlFV16tRJv+6+754/7urbXbl27dr7u0Nd5+qrr36Fy9/lFTjrFbjuWQ/gcv+XV+C/VuAyIV6mg3OxApcJ8Vxsw+VBXCbEyzRwLlbgMiGei224PIjrXNaaZ4ng7/7u737jN37jBS94wYtf/OIo/Kd/+qff+q3f6ocP/dAP/cqv/MrXeq3X+tzP/dxv+IZv8Ju73e1ub/M2bxPFbnSjG9361rd+8zd/89d//def7eVaXuAyIb7Cy172sn/7t397+ctf/o//+I//+q//+qu/+qt/8id/8kd/9Eff+Z3f+Wd/9md9+rjXve71tV/7ta/92q99netcZ5aSXvEVX/HTP/3TX+d1XucWt7jFW7zFW7zma77mDW94QxVf5VVe5frXv/5s9Uu7wLWXEP/2b//2z//8zzE57O3nf/7n//7v/z6Y3KJvESHWLd/73vdGhe/8zu/8pm/6pggU48RcR2h60SAvROFrFyH+8z//8x/+4R/+8i//8j/8wz/8zu/8zi/90i/99E//9Mg+uWHvcIc71CXf4R3e4cM//MNf7dVe7VM/9VOb7fz6r//6c57znJEu3vZt3/bd3u3d3vqt3/qVX/mVkeabvMmbvMZrvMZIxUujzLWFEH/7t3/7F3/xF5/1rGf9wR/8gR8Q4tT+3eY2t7n//e9f/NUv3/M933PFlj//+c9/9rOfXVT8oR/6oac//elTrbnB3/Vd3xWP9C/SfMu3fEu/WdH1xapyiRMiUe8XfuEXnvjEJ/7FX/yFK9jX3J4v+ZIvsevxp9d93dfFnA7dRXrPC1/4wujiRS960f3ud79md67pN3zDNySAKvBO7/ROJMtDR3W2jV+ahPgv//Iv+NC3fdu3/cRP/ARFhPxXgwOv/uqv7t6M1bfZr/qqr3omO/HSl740HY8P/uAPJi3Uw3BHEyUdj0/8xE98r/d6LwR6JkM9tlM7dGl81N7/+I//IAV+wRd8Qb1kNID/cc33hCc84fzPl1gZo73e9a5Xz+UTPuETiBYmS98//3MZHOGlwBFtiSsY1EfzePzjH1/If2/1Vm91gxvc4PVe7/V+4Ad+4NgzfUDr4J6f+ZmfccYoWEXzD3zgA0mQruw3eqM3ugSEyAtPiM973vN+8id/0i1cXGq0ztBzv/RLv5TgfwCRnK5JJ+3jPu7j9Afj/LVf+7W843d5l3f56I/+6Hd8x3e83e1u12Sfpxvltp4uMCEiQUyO+vnc5z43X4TrXve6lA+M8EM+5EO2LU679r//+79/2Zd92VTLOr3tbW97RL/adGX7rrrqKgho3gWl/i53uQujzu1vf/uDuj662QtJiL/7u79LEYbF/Mqv/AphP60R6RCwhxBJ/cct3Ete8pJHP/rRn//5n9/sAnPCjP3p+77v+w4aw4/+6I9Sv9BiAV4CO9/93d/94z/+4y3CQV0f2OygLHlOipH/Pu/zPu/N3uzNCiUXH6IC++tpxkkr1x2lITbGz+m7xz3uEb8ETcMjjxsPxqzTz/7sz86Jg7D4xm/8xhg2+/hxXR/R8isc0ehBbZIFiUGFBYzFFlM8E/0xqef5fI2EAhHEYaif9mmfNrIaPCdMjV4yUjgvQ48xfYwwJ0f9au1JT3rS0tbOsPwFcAPjiPDjP/7jdh2EFgRn0W9yk5sAeP/qr/7qr//6ry266/jAW2NJ00bycz/3c2//9m+vkqGyaGNOsw3w0wHWANXREKPz7/3e70HgZ2sFrZv+T/3UT+nLggDAo18LxQ7+oAc96Pd///f/6Z/+aaSpMy5zhodgtmvSGNPcV3zFV4TUFR8S/MAP/MAf+ZEfma2eF/jf13xUzkW1OoUBRve85z1jSM1iacBf8zVfM9JpsiuyNZvg4x73uJFaRRkYlro3u9nNUu83vvGNCTMUO8D+igZPVuX8Xs0uHUrx+77v++YnldvfN37jN46vjhb+5zWfRkiWaHG8br9k7qqzLyFeeeWVRYPG/y3f8i3jIzdrTpD5ulGhvuM7vgNrHG/kxCXPKSGyxt73vve91a1ula/m13/914+vDhMzHpN4A7MYoGe8+mzJ4wix6PpzPudzLILxw+pnR5UKPOMZz3Bi89UDprqs6TfjjZyy5HkRrfIls4gf+7Efiwe4l+P3mASwMGmpI9IM2cg63vzmN4/CmMEP//APj1Q8b2We/OQnGxJRmN18fGx3utOdnEOLBuqPWtyOqC8f9mEfFg2eu++UVD/bF49onibE9lw1htiBKmbrFgVUAbKgP2BvLPr7vd/7LW2kU35fjvjVX/3VRMMYZ94pMTTpYR/1UR+V/kRQJvx9xEd8xOyM6NQFa2TwJPBw/5mte8oC54UjmvNv/dZv3ec+9/nmb/5mjgv+ixbveMc7+uHhD3/4K73SKy09warAGtE0JTTImqFMMMDSdk5Tnibh5OR9wQr42kDFycr1GKDZlOXv+Z7vMTXoOq1uapyKBZyptQhIcD5B4p/xGZ/BNZhyfZoJzvdySqqf6oudgBZ817veNQ2Xi7LLZa+x4QHRstXfq80+RwR5prmMaM2hTuUc8eu+7uv8l+sX0Cp+n3NEsxBS45c8HhTgfjsyL0aX1Jq6fCZc1s7nSN2jy5y9sgILfOhDH5qfGBT5l3/5lzvOPBEiFruXtN4nxOTlz74CBJ2dS0GIvGWRnTUh16rbJES/ZETBMmcbLwpEy+mDpXOIXNrI7uXPmBCRBYNpfvMykYWesePHSyCt+zp8rh5MhxAf85jHJIHvUz7lU0YmkggRaMpQGQjlB33QB9EwOHDUhPjgBz+YM+/Tnva0kcaLMu6fBzzgATktfszHfMzP/uzPrmhqxypnSYjQV5FHfI9jUYQDYwB9KnR2v/ALv3DF/E9GiI985CMTO6QnmePIaBMh/s3f/M17v/d7G+0HfMAHoEJ1E5ifruZP+qRPIhpCpkZabpZhtrHU7//+7x/LQo50V6wwMK4eQF3xzAjxx37sxzirJl7IZExlnp3YTW96UypIDfnOVkyuYjrauOI0HsSR++v7b/pE9MXuIqORGcXIEyGS+dTlZQiviT8VhIjFhhus4OvZWfcLEIqSWZwe4wAIK9vY5urqZ0CINLUULBJ7hin2J0CjjIAmqOwKKEfjokgTU+Q/tnq9VHS1OQydT5T0ovYhLLmDo+itvHoQIh9Hv6RYyC3hv+Maxqxlj6CZX9NPecpT6OmLxr9L4VMTImimgLWY6js+S64qXvIgwLRYLpQVM3enJyuL3CDjG7mir6VVGB5zUnif93mfJiFaipDtGJzgNSO9oEIpJWZlbo6M+QCMB9cfaX/HMiclRAT3VV/1VcmjXcQuuYf5pDMf16gyPvhtLBbBS1TAiiWAEKXlPg96YppCTojUlGJqwRFdBeEGy+OLv8Xg9J0359ZFD+sJibP5ITtgWU6LX/RFX5Rkg8G+NhY7KSGS3BNbclKf+cxnjo+epTUliOHdNF4xlcwJkdZprbHGFe3sXgWwfOc73xkdsGHCsZuEmKgEiD0+AIwzKch8hzvHD3FTz5NfI2bBWD/e0faSJyVE0pWURSZJDAL5Lh190q+XEnF0lBOifbWjDAxLx3BQeVYl46E91O3nLnBAhnF2qClXc87nkHtfJhGcFZ6UiJIkcNBkm82eghDJhZA8HMjc2JcY8az7iknmAWzU56aKB/VotizZEjew2BVCqhVfMYC6CuJ2og5lHokQ4fzjangMNRf+KOa3vOUtYWT9iRMo3eNs9K5mcQg2bpeFmm3kcEKkI9t4lnsf2MUMtyhlwqbSEeeNUkwPGA5go8/W06Y1Bz/wLR0AxgkxaX6EV5icBqcK+P3GvQxCfLu3ezvK9ex25gXcG2mtcAEb4aYe0dJ4mCssyCF27bu/+7sX9buu8OGEmCM1buR1vDDN7Y//+I/zpJeWrJg2vy9X/6L7K7Xw/7KPVSO/1KZ+5uEX1siRwspgUamTQRzqPd7jPQjWd7/73RdtcDLcQ2pF6S+qqzDYNRDN+KhTS0/v0h6PJUSodZqMAyomd+n46vLuQTHLqdmaEEPHHNesnY3/e803SEx5saWEmNdlbIx+d7/Zf/M3f5NLdvQFZFi35u7okBfj20uYmRrMgYRoOdhOYhqQGu6u61akrsXxKS1QfvE99alPZYH1J/9yCO13R5D/X9d8YVJb920hxNQjx4gYCV+H7UuEYjDRaNzl8KhHPWp1m7kLLXTzULvLUYToRqbihQUPdr/RmFEsJa0lrTWTXfz1e7/3e8NIIM0S80B/9cE3nMDXEd9eHLHu3f3LU2s13ahIhs6TPXzTN33TltY4z6YwbaN1YjdaRzuDOYQQXXa5N0OYp/b9BFyG6zVw0dL76NH+2w/mdcSj8ApPW40DhzmZ5hTc5IjoSTF/WkfoMUIMcsWK5dlpFyGOU32RthPWbanRJTF9xcBmq+xPiMwnYpAT+Az8OyjrQGKKsd9XXHEFHG5KtbR83BQ4bK8gDnor+tY4CwT4CRrlZzo7i0VOiP7LGulPkIFUDGi/LgGIdTPgRUinriV9TBMUgDa7/VFAR5SbqcJmnTKX2lbBqYPNLiq2MyFS+7//+78/rUW6N4sxIZdwMCbtgT/W5WkQux7p/KewQ53y7dP+uiSc/GiEGfQFI/ZJNKcjJNhZd5yY5pv8c5ceBlPowMvsTEAi5pnUrJEvslqhYHVlFYsgjeaX+0aw0y7FkmaJcmdCzHPDwU6nbEogjHwzaI7ulEV6WVzNmNDUUYaqaLMwoaZOhSJIWiezgrNOnc/9uPzsNwrALNadkKlFZ1Hknc9loegOjRpGDKmZMt6wuYaYDjS02XjyDVOSgrg02UhCDD75kz+5Y2JOPmNm4ULYlxb3JES4f3KTQSKdtAqOeO5QE/RhrW3VYPgFpTgSpzY3xmqKFZpiPOgvGAzDLkYiX8f/+e+fhJ+R7Xj3T4/AmqI7sQSGkQSYqcNjOrI4TF24n/mZn8nRWhkSy+Aaxuy+/du/PV8oOPbU3HNXOrTY91ZZunR7EmKelJy7fH8oU7id5P1U2qbVdXBuqnu/ZIoKtY/O9j3NgwMbLGaDO3A6OcQEm+MnJCAjEx+HbIBftcAwlcTMsc9jDJZi7P3p70aI8igkVcB1OesDJyAysqBSD3MROwhIsJlGOD4Nbl4qFm1Ofa5FF+6ImWtpvzuWJw+IIEn3YHMu0nJOXQVSGg8SovBCQnxqnwn0B3/wB6Pfqem4ynJaJPvuNfF9CJFoTMqJ8GGX8mAMHhJUntMAVzk3DsmmWHQgixwugs9HZiv8WeFONmmS2Xd913fNeiyP9HV0GUZh+H8/86zJOnX1SFysszCFJxdUT+dfLjLrj8i0Rqy3UMSkqTlqnFoTOyX52GBQzuyK7UCIyMgBjZEVbu797qnM4SQbFzFOwOrlv4ip+QyY0Lhmg2hLWpwOI/QnDcrsO7sc56oA55fZdHtUZtNfpFSlRC6xYk57MevI08IsPrUamG4aGB1rUe9TbW4lRKvwsIc9LBFB5GYY/xgS1KWC4QHMAH5+gzd4AzySJEQpzv1H/NxkZiMZYRyPffONjE9wY0nq8Aj2zrNuUOqlx+QnlsJeqMmsKeHu0CFEk8KMAyq2tryrtks7WwmRDpjQTpmrl647v+uwDscbs+4LSkxqBK+NB6H82xQ6Bfb2GaG/Srd/GkempXMfLE9Qzp08puYrqfhUg7TdSCtAji9Ely/+4i/Oj7ec5MnRoU+IWkuOBFzUVrg5F6PdRIjUtC//8i9PS7POpzfZRokmcI18fPAgMRwUlyYShA10LCXSFNE95XQDbR7twjRIUquLwXce8pCHSOTVf6dDzoZmF4Rva8jylEgnznaYfCxR1ILJ5ymQZwlRBHfaemDZFqBD75sIkZdX8h/m9DroYFcsFitWxALDcos/OaDWq6ZCyh3bGrNHkz3YMMfDw4tumToEZDU1nG1FoguzrwW3/XSFpuxIhrYs9dNaOGJKbhsrhochO2GvvKL8Vy1frqeT3SPbSf9LAZlIHLK7jgCii02EmKjQaduSjTSC1WtCxHHr2DP4c/g31B+nBCIjva9jqppb2/P+d0cL8uWIFils0mpYzNoFzpokhVIa44SKM1DlCE5qRPsjC8HKmqpwWN6S6m49IeaX8qJ0wvUMI8anJsS6JElxSnhnaLHcF/0WHtn+KANennp3qIkjJm+goosiwMpGLMpTlSuL0LHx8RclVxIisCqFJ8trvbr7VDFs6hbLqfI1A8idP6sG4ikAcKTJuiU8avswLlYLFoSjU2EaueENb0hxgdEELph/sAgwliCyfacZcEd8hrSu8TWEyC8IxBVQH51gIzuMcRevOdQWVTcywx2OiBM48fqNmTsPAMKDnOTWrWmnlgMGLuHeQYTNP1eh3w/mb8jbt25yMiX3ImkIIh0jZ29oX/32Amu15OT7zgv2nnLHc9Zc1/gaQsSN4z0Pn4mt67iohbj50kabtN1CBaOdhFyIZfK6dexYZUJZoThLor/LGI5ohOjskPB5g977mH/AMSmgJDESoInf+2sU8wLAOGsBncSb4shR2LhZEKxRof+C+vg0HDGvok1OijEXWtSgfLn1akYinIXiCGJLS987mVoUfI4RXZt03iIGD52l/BChGBJiGJr4VbiVmKc2AgcH7RO1lFmWhmteUwp+IsTiBwqH/Niq+2ZDqyxFKLyho6BCrg95aryDJpg3K5ySJh6zsIMrelzMEQUapvToHYvk0qHE1WzP6kuWSp7vkzOAFslAmCg8fPCNsaXjWV0eVuJ64os1gkJPEWL+ewiLwKW+z5V4HciOMUNeLUguQ7sxLODq6YxXTNEtbGMjSXI3cUTkQjlNYQBTrMjLFJhlfLSQkcmwV0Ilav9C/t41as08gBaRbDxZP9L+0WUgTTi0+UJD0vqM0NlIGeK4ZmGBU6JwCJfG4EZOyWpTy36zLgJm0aJhzHFxuZ2LdN8j7SzgiJAR1wSPyJhhMwwAPbGOFIu7Onhqyo5spx36M88uZ7LQA4D8CDGJQemkVBx/gp40NkWOtB/KSsoQVIwK0D1oj+7TDSBzSq9iTY1O5TZZKrMteK8ZyXsNPsUUm1X9ZDquBmT3ORzimgPw5K9AzrNAVjAG6ufZkCKuSnXEMRKkoPk9rxOzHaGA3cvYJ9Ok14MtIXlU4E4XjEZOLBnRyx0dgyTrkUOuHXlgc0foqZYtjgVM2WlTMbqR5N5eJAirUlEdlJ0kufxPTCxT7o+2jMieFyYGcMwTH5w/UJAKJLcpvJnutSBabYRtRhkofLKIy3HWdP5BphD2kJpdVclNlbNQ6CLx2ZjZB8mae+BGPi60dmQpkCDWMh4TDbSjDpss3cVXiHp+U/jz4WoWLX/pY4oWPcUwtYaUOZhO7XrNxaFmijR6BI1TCFcAQBbflK84C3VEjRVfetoS91kUzD56NZtAnpt/Cnw3pSJyR5r85lIWjjbFfBymuhbx9KxQa7cBwdfqJ5/QQUYriwNfBNe3+ARfESDmN5EaxdWRy8eYkIQ1RVLhusfOGpLmvdhVV6lTSz72sY9VDDpWRxH5vTeqjD++orVmZFz+ghApYjz0Z5QQkX9aF2h+M2oJu6odY1WMCdhCxy73H4GKN5kQLa8+zezIS5Oy5Y3jPYTXFXQMSAeY24/cdWWWCvEek/W5cKl0s+56Vim5Y7lS2coYkLBSUn//dkOLU3wRcTeD/Gu/bt3FjEQdxbDDv45jVM7C81njL033UIpEeDf7rNh4GNcoIRJK0jimHpkhKZMa+fdylU1EEIToXg4HTGfdFR9NTRFi82KiuGyxI9sVfiu8NAwPb5ulDCKgGA6FF9GfaZIcTHCLLo+pMCAR9a644o5XXHE/4XmRtHjqo6pPYY2YVl2rNvFFXDP8L6Ho8aZajggKDk5NSePZvJdj0wkbqeS4x+4QIaIAXDBap6802Vh4sOYfF9eYT601R1xzTYj2wLrXa2dFdsl6zfzlqIRATYqAvVk1g0yf3xSwZXP7XWQhPIEq6E++Wdh5RAAtymB1V155yyuueJDshsUTPfWomtcFgapJxDxxChGfkEDyyQdAf7JWJFGLk6JnLN1I3misKkbIA3/QN2yIEFN2OWaM5qvBdCso9xSEO06I4addfO4maOKKjWxWCee8cagPqZE3fMmeazMoZIRxrqNW42iXRza6ZFif5IrX/KHJhknzycqSVx+hp+JBXRgTB9iRjUiEqMdB37AhQqSCxRw4uTTHQSzAtGAH/hU4XKyXu8CUcvUQR0zKdWpQ7F8zKn7KQ3tkRabKOP0eLMnz/+VjptRTMuJjF8YjfQAOhw1c8JEf+ZGY/fb3dsbHL9RhFu0y/iZqjVPalJqCeeLMJscpCJFpd3DMwmHTVT4YQDKPI9K/sDRifhBikRigniH5hmTAI4P9Mf+ruCokhdScbyHiEqgVMfaM90VepagOgZP/GU8q+oKkoJjZOLcpLkLekNfGGAhGbA+5ekSUpARA3VgRXU8smcZswFggchznpn0GNv5X229rKaH5o6fNq4MKbLnyP+EOCJT/fF0eO+/c+Pad5i6lWFSkgzehjKlZcFf1WF381aGd8mX+/9VnaZwOFW+c2BuSxGz5KGCPuZBEYFT+UUSoz6iqAJno+c1UG9x8ptKroeZxF5XOsFFbUwGkc1D6XG0reimCbwYXrVOMoIYKpzLjpBXGOGthmuIfIQHF51BNZZImXGKZqTzcfqmLGhEzRSPNJk018fmrmRtIWFBcUksX1GjSI3j5KtQPGhb+iKmwpceKmv1inwIIlw7pNOUZuBbllBoZFVKwmLULWb6wBNn60Uy32VRcQZ0Q35PWJJYitn88D3Q+kQT7a3B2gjOESJhLBsQVhBjdE6Jd1vl61cp/M3Mcxkk8mkJtXP2UJzx/dpKnL0AnNbBxFG1whJaiKfDla8tDtJBf1YKoN1VJttbCkRtoWjBOe7cuhD4RIgmqk5Er5j5DiLJSR4QU1XVwsTrFInua+O2iTP7SZ1oFyulsVHyok06I1dzFom/PGFFo1ulzyQId4T4xMCkliPAcdaOAwlPnhFhCYIe/TqUsW72eAM5mJoy0dM2YFdJ5U7qtMztGpgcfuRn4unqcKgYXg5Qxf/fb6REiySmpsbsQIt9dGnQNJjcJcSRDSLJKmTAtqo7SGFlE7FlENopxn0rRVGQSc5pdsokQC25BM1BFxTrdTMK8HD8K3DqmMjX+vrcOFaReCscGUNDU7YpeIqsb6iEajixgp0y6TmEpfZC/R4is4GmnUxj2lpFh8kSQgnVhMIUVi1vNIF4Fo8opAygznrRPXZlPafcoiauIW74W5/2mT4ipCs2piFhAmrCeKMBpFGvZ5dGAWH8oYHO06Zd4dr1TzFrGWVessWFlZgPsRygBb44z43LoY/49QuTwk0CTkV7Xlcmz4BsxUWZRzi78Jl9ZRmFwFxsjFSf32yXp+w0F3F/jC0Oi05/iLbYQorqYvXi23MyvR87VqVnGGP3yofL77e/QriDE2CDEUTh9uZGKvePg0ifER199NVDxwQNbHr5qIBeORZ3iPUIMv4z4BnpcUwTEleP+7ITE6o4ds+7DrVdvCdWH450EeZDL+KjYflOjWTsSomE4txyHOWLGOFE//K8AR2FhRiK5RwyMuDJoeyjmnue+qlcAJU3Z1oxKGsGcFjGtIuIinKA7O/q8q69+1tVXj7zrGYRoRziCrCFEJ5stOGa4TnsfIczIBhYfn0Wy2lKdo+kT3ucW+V/3JcRoGYNJfNHwaAMpyqceGLdZak14E8dHMgHTzJo9QICdaTIBdGyPFhk+Gm/zxudgjOzXijLJe7fvMDDJ6gA3aaDrnrabHXQk6oyPmLjldRq+KiPp2+qdO4IQo5ccAbbr8TYquGQ8KiDasSwQdZRdHFF8tP9awiwpg0TyB/eaaT9nN3GkQEwEuNFxar7u1KmiZBHkO2du3z+5C9iaV7fJDEDUCwsQY0x8dUbk1e2vqBjvd8THZg0GIg3zXWIgSCMcaZbPs3kR9onskQMjagmWw/ZGWpgqQ9lPwRtb2hmsy9iWPzpR1GoTIrJI+XXwxQWRB4ODusb+GFEa8blH1j3LGNUhXgiRFOJ+pzuTkHxsDBhefEwF6atDPYZHvaAgf7b8qXKUxIzBjOnM+BOZxBcDS2kSOq2jGM4WkjQA5MKhk318pOJUm8CUIqiFCpU/JbtgqsNFQarAu3bxJms1SnhNVNjxMce8r5rsRpIwTV0EDKygZlqCY8e0Sn4qrBp+mT6Umuzax13Nlq6ZP5cXgrEZDMnEgY/HNR7xiEeAJKcgpGLnOKtHvqH+0e1fzSg7jyKKLqYyLI7cv50yyZm1k6KozREtVp1afZjuz6YgRBpVOULkbncZjcFd74hHtiu/ZOC2+j7eNP6Lwfhw0OOGazDhtZR/rhfIiAGAlxlIGIcQBHaOFqFLfPT5TfWHJHMhikmO7seNf6+WE8QWabQWcETQayp9BEckgNZIClBj9lGMDkeM+AxapzcswrLpFoAEJZOG/0IWiw+eN4IjwskhlEs3xu3Jw7nPTgrdlmswf2wA++zjvUztWzgiuag+hPT3FUkaZvllkkQdwtrNIqpPKiux6I5s36y5dG+iPIk7p/X4pXtqUoAY7oYfKKLBcgybHk125DoUcTPUVWyy+AblRZAK7A3mN+gsHeOF5OWpLItJkBrteq7s84DE1FnhDJJNjDduZFc64qOD+4qWnVJc/Ijuok2NJ2Wr6KVNiBYoyjGCreAEx83kbFsGB/LGxXHHh+Fqro9cqs7uQvllY1QGWVBc+CWQX4GLQaAM7lN5s9e9dJm6prnrenwiW0piASm5sGB+57NurU2Ijv6WjmfrCguaLXNuC8Ag+k/x5CPvE6KSKJvpj1wBCg0TC9sMyIbqJn7XQmGceGStILOFUkJXrxI6biYngaXTEFY326zI4CRuP/7EgaF577UJsfDy33dYWmuGlpGomvmcd+99Y4P2D0402AgGMLKYdGdoDlgnshGTpYCOXCUIi/gHMQNfZCrMQ+5tZ5EMJB8Shb0vdbj9A3YtPvEAxJvB2a0oBjFYQIjWZUUfW6qgQoBlHVqwpc2D6uJPPPL5n+7ePv8dmko87OhzLIWtcZL4rM/6LIAUfMcPoeSJICF9poCSeiTcpmbxfHz99AtODl5wNe++xLMNYjMjCV9m2zlNASGIeUjHvp3msZhaFm5C9eZtCWWkykTkIZSXum1Tp7qGVc3aPMkAi9IH7DvNorXG1cxhJAoBfrktHdp9atzKcpY5TV/be6GJT2V/29543QLe5qrlmoQLij6hucvY3jGXaYEIOBvfSPoUp1dndzliCnmbuUUt/b5BiClbDWVnqYV+ZA71SbWsrpLZhRtp/DRlqBQ19tHsmiKS3GO3jC2i+i2R3eGvSblms55qkHQ4yw7V1RqmWN/OR2BGsJfk5V7ny/uvwdSTIV9vWbIVdb3v1Q9OW9HmoVWouikSoN8R2bdO4bp6bDAXiA+rjGDcTiMky0GLEW+MFH28elRLKzLD1lVmAO2lfawrf+GgSupqyqDVnzLldF+FACBHKkjPSNW98zejXzN4DtoAz8niNwjxlN5f1pHoc1a5X9cdG9bS3JNyXSNbakkJl6chLJrCL5kHuYAk7bvfF8JtpjbYMsIVdRuEyKN4vCH4pyOV+zuN142STP47Xl5Le19R3voUiu1UI4Qtng0ruuhUYaaXVo85dKoM5UOODeDlOEMpAhfHBwz6tvtLjyXHyp2vZj4K4DTSElWur8R15kZTOcKcPb6ai0qiwnEEEebXzOazqMeiMNfaZphOFCMa8pZ1KctG6b8jWLpizXRhI4OUEi0S+aXknCO1mjj8YhkRGgnxRzqghIhb07efAy4PJ4kO6MNcO2X2HpnD6cuE24R+3cjYP9Q99nj2Ixp6B2rHjE3WDY7twbkphR3QyHmH/15KuF9nZpsddhSYMh7qGqHb4gjJ4wCqMEWeE5MfiFj+RAEa7CUvtpgQ2aDiAYvcHIciQQaL7vQ0iIjZWzH03asUnmmsauLDuVpZ33jGh/g1SIXGJkwuz7K6cbRWicNiPzZAj6KwJcrK+xrxpqmNy82UB5rF/yI1NzwfdBAdOXKgJWw4fA2hM5GIddG3mBB5DSaLZ2Ra9oEAeF6F/gWsH8QOoq5Q8KbNZ9E0thcG+KWQQh4GQs4we9h+PPYpd8KgXBgjgT+b1/ZRRQtUE8HIrH+dBikovHhEABMQUzEMLH86dKp6Hl7THzOHnZS8IYl6pHxSJpOEOxdH5K7BdXfx3GuvxiQxcKxt+jyK/orAe8K4QAdQgvtCLAVYAV80q46npPxd9RC3h6sKFWgmLo+++skuwjFWbgkryBuDTorlk8NccHzcZ/2lmys+8uTx1BVWJ8RPcb1Tu0ts5YXZtFiQhfqOq97uq5slUUzV0oslCm8gzI8YxvCI8gIG5zMxVTFP21KXaYSTzhKiVoTBI0dkZ58sKAOom5o9tB/Nr2KTEBn3Zr18+wU2EqKUjUQrCZIFVgvcxFdwd7xw8bG+poILdDZZvOkMEuJs9my8nEc6ca1pIyVX9KOB68gVU+gQYmyEZI1EUrtPDAVt0lpc2Uiis02LCZHHmFn5ipSPZssAnz5sP+fAAF6/yQsYaz0sLnfRePGdISGSdUS3AETomMZvTQeDmJpkilsMZqqYJUQE5OngvpVVIBXu65tqjfdD8aZQsdTutHo7mgk88821ViqmFZBSh35jMKkMl+qiI4c8dTTEETs8eRGHQKYbyWu8+haOKNqNFrJoalOFcYXxMfcJkagzOyQs0OAxDgJ6pzCr9PioOiVnx5MXmA3WKTq6ft06L7fAYnD1PEMKETB5yfOck0WP/3CyNcmoSY+htaWkSs1oaBWlySo6paOd3geMUCXfXEeyXLTudAXQSWQWxE4g/NiDn93vZL6lIA4D3azfE4TSY2xkNTJuzpwWDVthinAdakjnEPpZNJV2n9okAJJqnNwjOEpS9QwmJVepn6jOpdjGG3IrlBVVjJ5ERUYMBZmLZaA5s1ywKSMSqjYe2UUckcxg8Es3bKo8LwRSWjF+d1CcYetDk9NdfGRrYkAoTx2O2PdpsNqg3NSjeJep5xFizH2OaHj11PoyokgSc+HgbeLhNx4USbbeU0acVVZyrRlkYAQmA1sPrZne1HkitSZEv9me4necEHHxkQQJJEWs3ZfQiilCJB5BGesNIFJjG0UtfILyAVggR44QojJ52j5rxYOQ3lqkqS1S+xWd9gmR1lxrOX2tOZUHHIJWCq0Zn26S42JlpU+IT3nKU1JEFopMhKjvFAPhTp96IK4mRIFCg9J957QNEqJRzTpYgMoogxLhO/c+u8626zLqkC9nSpkz65dXjIrMXnu4SXeEL/YJkY1A4jl3RTyQ7X53woHVzRxfWwjRqtaR3VOEiGWkkymGIYJlEaJG0gv2VD0mpXqzdibE5L7G3qWzIESbZIjJz4wr6NSLZTUhMhgMvpK1kRClokpHqHMvi45jPC3eBGDCIgJyWZ9KA8QR1dTqu8nUCHBA5uAc0e8IIZKidKoi50KuNI5E57j2CZFZsv+AXA1oTxFi8m5xAVIkghCxeeeWzhSWDkeo+RDEzoToRIbVH1hDXE2O5kGXRmBROktWE6LTM4K69YXIWY4o2cBgKimwNkku7ZzbBzjijPE2QKAg7mb236AwbkQeTKyzt1sr7bCkYZAjhCjQXTw/4c/KqDj7xkmfEClS7t/OAobNNv/qlOBR3UgwDiXjmZwUn+WX/mvivL6nkuH2CXGxiY8giAvqlSuAXiN0AzcO33RCK1WgE/uN0xwRftDhcPEn29mxulpQ1tI4S895znMkcjVIuqTPoScvCttzRVKBzZdGOfVqM/4n0hS3KPqyVmjUSZBCXBdshn1vWTACRJ2QYBgqLlW6Z1djtsCUP46RuMdNIZ6vpxKYCGYUoavWhzVyMHlGMYbFhJjXx4TBMeyq0OyRx+Ka848DNLs0GwtMvdyG/owf6bDpAWOluPCxooKl+ED4sPDIzaoYXqgMftk3zkITnX4Wmo1jPln11UPFs+WycVH0H/ItJtJ+EL3m2Cn9z5SteSPUUnBEHtqDL5HgT4QwH52jMB/PXs31phoGz4Z4nYtPjUQLzRd641WBfMrU4RH3KsJ0nk2+XrRZy8r4Om+8mvMcxrFQ412Pl0xXM9CxrtXoMr39dxpCNO2Rx45JIcnbGW5M14b6pmy+KwjRdRyPkZA0OPZOXSg1IYJO0GKN9xa0Tj7hkNJ5+uWcEGLxRMhZEeKmq3mvu4M22m+KAddrl5CjKEZJ4t3EXyaFYM+OpI5VQ3+B/hMNiRbjCV/IiBwNaS0u606/tDra7ogX1uzgDy3QfJr40B6bj7E1CLF4hOPQMUXjsIlOpAFBhI4WPsD5By+IZ+RHvuLxWFhMiNurP3jkbAisMfMjLt4hXN3j6or0ialXavlDrI7xWDQeSWxSwqCmT0mDEBMiQ4Sfevpr0SCKws0cPCyzUwFBdEz6QbNHQtiUL3FRnu7prgTNhE2y6fu0aFIUYWgzo0U/4Aaj5XXSCbpb1Om6wsCNpt5twVm0Da9odjAOddFgoBYpVWTTXa1BiGeS+gN1Nu9ZUuD27J2WzDsOME6kQxXbMWiQzDCVvzDtE7fWlG9y0eYdXTieoj66l8H2z4WMaKxODKfaetBWqvYNiWJuRkrG7LOxqU1pEmjo3HwoPSMZOUZWkEmpLylGI3xEUiKXkWZPU4ZwfGgGuuYsrFgTSG4T4l7+eeMLCgoWh+uqHazCsklygA5SCAarRDG6Kja2OoCy7uvKK6+cHQBOPB51NdtaUcCiTWZIn24LZAa6H1/wpaOaKk86auavahPi0bdz/spfGjFarOWV5nwwNl4IrO8r8jZxV2NxjgjRXb7BBMBbXAb747RonegzsWzNSwMhNoECaMChuepIMgs4IhfXXTZpqpH0+u66Xlhxmn6N61rbXot7zmwjyeNhtuTSArTyjnrBrsgaNN4mS+Y6G12nC8EYKULSXdRkH22OmIwrvJumNNbxuW0pCeqrtQFH6vTm184sZvUVdY97bKx/NaOqJm63ZVOW1uUqwWUzaolqaArobUJ0c4VjRThgLu14tryInvqNEAflTPwhZkc7W2DE4jfbyLoCzVcqRppykuvD7B0h7xiMVF9XBnueUhPbhKjCunjedeOLWnw34gnPS/UblIAXTZ9/WucBPWd7SsoiCNZhJYu6XlGYESF/DzVvYZIjppdtnvzkJ9dWjRWDWF2FPa3w1zCecYvc6n53rxiZYvb9WCyaeS+jFzyPaXSwR2L3QUa1FJHIh38q5XObEJVOY2LYqOPuBufWKWbagnZTASDzlAsJzaYIDuK2dLZnY/v0d2mBC1L/bWFWnynjXj0AKMRBMga8LLojrU5ZwtqEiKUf/eQJFp3HJTm7U6mbidvFMWKoOP0DHLuQzr6NMBPzXuu0Kayk81cn/1CkpugaggsWXCYjagLYVrup7buOUpo24ltbfXgVNo9dAg4XtilguEiufYd3zlsDYst2nlJyNUcrOKYzCxdlsnYywR/hV5D3jqF0gKFJEx+XjYTVtV1qN28UPpcWwi3zyEc+kmNiM3uiSF4Guty9gLNq2Cro9bzEOdfsYpJeN6fBrvfFBIShpDe1m8O2g1MgFycMAqtooYSqKHnQOxcphZA7cEpTMf5JQgQ8IsTZ14vW7VyqxZkqWdssDW9T2d+azx+Ils25OvseFybtkF/HU7huHO1UdfGBIy0vytY32+BsNvmpdLEQH251APaU29gJGX9dcHZgzQJcn1zNPUmg4+qN86e1G/cIX1qy0FHIswLhqCN1O0V2ch7nPAlGbLj9t9xH3mvuT6oT15fvSt4IKGcqwhqq0o8x0M7jH//4PkGQxjg0NIct3V5xJCgQS3dtsDxf5rj0SFb9THG96ASep8kWR0ob7HtpMfBQHejpvDapp1h9EhL2KflBf1dgop1R9QnRUebW0KmebrdZVpEacXgEHE3dNnbOandiDGQJmzUsicVJcRSpXxWd3nqcHEeW7tpg+aSP+qH/KnyPEInDKTkfWhnse0WxpkrP6FnHaRdWXS5YupNiYdYZrJlnTV1xWLMouuGRBKbmlYNQHVr0qFG0gBei7ObLoKk6GiX/gWbqTtG9/AV9b1yhFzUdo0L+b00774otG6ySCFF0bL/KTLwWVTSyIxxKiM0089baDVLQIlWmoEX6DdEb8+47XUMi64WQ9HvQwZvEDShpLuWgSwG/hKguVnUk1B8ndv/WPSKyPju05VajqOis3vOe92xW3J6ud4rCOCqEWE9ZhmlvIkRhSomoOaIOnoMVxaYAd6wOneUN4ii5sIh5kMrpzqLRZKbqsApoVJ67SODf7GVaFCDd5yPR2mDQjNuW04O6nK/GnxwzTZd46tFVi632x4zhCTEu1t84px6YNrCODLBiH/MqCZsj9Yp77Lc246HNO4GYuaP33tQ6Tr2B7SXYIjO4S40knjIl2Fp5F6iBTAiSkiXsE2ULns9zTgjCyqMR/HUpIbLqJs8/ZEFZHhQQAUzgJ93hrM5zGAtMga4an2QSxlOAvagkrTxRmHdtMlE0R66wGJqrrrqq+CvhbOpBXUfrIIszVSnZ1qE28w8szFK9RQyBBkVGUo4jPmry1KNw8TZx0SnDY7KGGxvTPlQs8nFJBsfXSDQWhcArDH5OgpH8DemuX0qFytM3yc0xEls76MfOezLPuwdv8lQTcqRrJw7tMmUFSTCbBSdpJDVTsESfBGMu2HOd44YwI2SxOVlW3CnRefsWC19Mnc5mVtfdfEw/0k5OyHC+7UOcaoHnenO9rK9rt65FWCyELelf3WV2V+w9UQwhUsn9nC9KUjsifw0+xGcTYBQfR8z8K64CmUZCFUXxKQtbn6AjRUkxeGYhoq2B5YqkOGttQuZJgaTDdCl72GIq1U7etfCdZtJ27UiU0BxkUwbda3/TmpOXRtqcJ0StyIwWM6G4QIZG2l1RhpLYzKCP800dqdi8fJXFRgHG9Y7FBjm6IPw3BSckQiS0QUnsOjnarR0DjsTo8WFR+ZvIcksEMocXjr/oCYcCdmJUUqzWa5LLZ8agU10kENHPhMIRg4exTT0dIGFw057hrujDqyt2MFUhAqW7WFzRSFNDhJi7eMjONtLuujKOb/OBQr5MU2+l2OPiZW4ihHuZmsXypkHGQOwneUMlQsQ4ESskktrYxH7daHiq/F2MPe7WoA+tjfhjx9lw9wWJEy3wRUKCC7fJ3YvlIvi6viHenbxq6fjd9773tQhFDtlokJ7XNMAwIrju1+3RSK38caQpXL1oZ4gQ1RFTEzM/lBB11LRS0J07qSZRW/EkDt0ZVIEboTM75Iv4aF+hg+uxuYWxi/FFAfgLwppFkhN90EVyZEQjbuQYGJOaD+Zcdy0nbPx1MC7MctXAddpjf2reyw7qCD2tK+NGSiINsWcwC+soIbrm0hKj93VDHKzFZ6T2D5D+bIpiNOuOw7qatxgxn4KCQbqLV2QE5YGLnoqMJbOKDtETSFnPF2cFRPTR7Lpx5FuYYUjtQhldu/0lbUJUnA4HN2JdsfAB8JHg3cudc5K3P0qIBJ3kg0NwGUwkt24matUJq5Pw12nTTdp5GpO/I88JsTLxycKLldYfqk1l/JCuglniSwWIR8z0nXHihUT4zrXrT+BbYpyP8R0TTc9/AHrYXWULml1bmlDz8Y7ZilsKYBbJH5uU5UYabO06yo0ssRsqfxS989TRSGuzZaTGq8FbKgIsrf+UA4dZOA5lebYLKB0Zvy5GhmP3m60+VcCtJwk7m1D/biU5SRTmssa0akQTy2Qfp3GDV+QVthTi0h1OdiBAKZY2m6lCRSCAJ3OKccoB+ZjHPGb17GYrIsR0L/Prg8mPJngZJNgQkhIRsFrWwtZ4UyMlm08vedSERtavTj8A+PEN8wWMfLIPFTbzmHcGnCvO4HGAYvro+9acYACod6ej2pF1UwaboO/XFCArweBFOdhRXSy54uLckWd78Bu9mjVH6oxc5PEdPaVmGg2XlBlK6UcJJb1NTZIsSL2Fkz3wgQ/E9sY1jNUk6/kJF27fwWR2S8wI3J2+BJ7PVowCsGsJzDkTkU+a9z7gabCp1cXSAlr5zgbV7S8gRJUJ4GTk6Ow4J7YYJSZPQWlSBsJiR0dnHeUDw7aRZCkXhL2Br4p2G8f/llIk7nX0yZwlDi9EMyFO3drk49nXCWa76BdIAXeAp86jT81GlhGiJkgeSQjITfIb5zBVHQ5c+6q4dMhhUECE2H+LOZolFQkd91pg6gW+zcYaHxdxXfS/5u4yZzuNtavLQUvRaRZOaR2sBuyzhg4sl+kfPSrbARBwgAnHzDxLuxtVVhKHwBTdjBFLGw+HL2UeS8vL7YKlJVDdoWfp8RsciGWFPDQS9YMZsD1YKXtWZCwxF74hnVHhrHgz607EsDqHgiiwZOg0U9COicWWrkwqL8E4aRKPoOXgfND7lObLAQOywhNWNz5YkSU2Xn8CLUFtRrL1/beWl1Ku8rwQQgRhfFvKgVd0p4rFDcdBxz0ypJPrQyOTB3fWsT7vFKAQTJRpIfc8jVd9mp852kj6GY2VMK7f5uN766a2vRaZMu5ECgpkMZwqwiPEmem7l2/vPVrgiZdSSrA+rGh28dWsD5dRwvlopit6XVEl5gnIQD0sWqghMF6Xpmt6RYPw7RzlIsh7b6z+OBylD9c5c0GwnilYLZzicHrAITyZfs1Vwvowl69YmRVVUriFe3kE46y7WEOIWuEuEC6otEV42IqhL61CHyToWGLoDI0svxDp0bOYzkh3TXx7pOIZlmFPy7PSu6nQol+yOHTCG/YdMKfGxJhW+2etJESSaVJZjourKtaLeEdWQ4WFPE6Jhi8e5/K+77bt2Bq0qMYLiStoESbfjITcsfdois6Qu9aGr9OKbyUh6gmLSrQISTka3465Wfqpt+lAM3SO0wxjxULvW8U0mWTq96BDLgT37ttdp7XkRepS5umzut/1hKhLj84lxec45+16bpSyqaAntkFQNm2m+a7x6mU6JxXZFGhm9Kqpd4ToyKfRTmJB8sQvXsoYt/3U67mJECXLT54Q3MMGHX522VSA2VSwBeGVpEJal6sJZHM0irvLdPqNwPbp+DzEmNGp7VOAkbtCkNQJxpO6SOeBqmC1t3S9iRC55OTp9+IB1b0++inQhIv1VIPwxX5cJg9WUAKX8ot+XzvwIOLZDMQnQK3zvWCySvchaHkRiLYzR9Qc4Cq3m+1FhdpBPXxtcNyO+yO7yyzcCsQWA7/UF2HHiWxpCmBpjzu+bWn6oNapjkhN1BcMdctI6ropkQ1kjcKwsfFNHFHfLj5hfre61a1iRWivGweUV4dIadOEO7A5/G/ksTsRqBeOFiGdUPRZjw0+NRZhSgIB+kZsg3gjFLOX+MT1OpyXXcqcg1Z4HBd0spUQg3UJmwhCJJ8xP+xCiwxryZHJnItHk/MuDKDpM5YzSwPjZLrLwE7TCKEQG5sNGOBf2MHY8zWM1WAfxzU2TkGyoTQwnpe7SD47EKJZiQeTqiYgbrxno7igwfwxCPbTkAX7ijB9WRabfg5CRuqlvlUb92xddeyNstWXOkyWh9ts+3Gr1J+6XIBXYAvgyRTeyt2TCj87hpEC+xCintyeSXXg1z7rmQdh4UbQDIIUdJfkD97LzG6M+nxOR66VptN12gbMgA8OHWtkac6qDA73zGc+s59XXbTA4PDwiLCO+tcaFiyWfjMS/Z76Yl9N7zs7CTzhB4cxW2w3QtRTuqBNmy9GhxYZ5uOx8FrEZjtJaY0ANFOpjzoTk/unkxGZ7smp9hyajNOMGOg6VEjAMMFF43/Sk55kqcMLjstIfVY5tCszSyvMhvkr47lb3Wzd2QKL3cA694U4DGhqEtfkrJHio1meScDMSZOs8knR4VIAEZBQJpyyCOnKkNb7N1TzrwxNdG2OogI+6gJ8ewFy3Mlc05FzBw9O73TiwfKB4B9HhBk4gaJqQA3p0TLXSHhMuQTCjYMNM+VyzQePOoGIMIo6sqy/RJgi2nUP0OoE23Nme+hDH2oF8lp6579ital01r+ZCNSNnKKkmRYxkZSWeMUelVVmSXVRAbId/h99CGabCq6OAvzkUuNA+dvc5jb54LYjArCPO93pTs01whd1BxahS/py47Wf/UbCGs5U25XBfPXsHNFe4zkiTaiNMbgHDKlYhBg8pc1FsSVPTfgjRqgANSjSMFj/oju3bSSIam56Wkn6AH+5TnTvIpqJwntezZozuDx511Q4QaR3zgkxZfeK2fbDMcfnGbkcRvIl1PSqFtmgn00VkBlu6iCMzqjIUje/+c1H0iI2j832zHFBiIjMJRDWUZcsHunqqN8laLoyRZpMnyMqyH2RbDCyXzsTYnRpV5JvPbzAfVQMhfgYXJ0Tf/EkL4ZUpCEcmcZsGazaBvimEjE2KSB+aQ+Mk3oIDYiPQ6R0ZDHySLXjB/7qfMXxrVTMncgUaec6jTf/hE0a6mxyy9lZ5wVSjDN9xcWa/wn7IMYYicXntlM06ypP70uQl/a1n6W+DiFEupVczelRDf6CdWAHoL9IIkNCkuhtXxG43ipiqF5m44LHSScR4niVfknD4/a7iMhGCsO9gyVLHVuUj7gC0LR0Z8WfyNBJvHE8CPeRcXT37xBCNEq3idQzab/JRnUKDogP6Tt9MJrdpzfVIOFdv/1sx4OEtRchCqGPpThuEQLHEXVf8zz9UmWK3wMa85S4KPIgKvyvK+W4afNZz3OsO+jrnMiPGyFnb0Cab8SYO0WXGwmRcBxjyJN5HjRlGSXdrTSSkfb5O+YP2DDeUlBGKq4rcyAhGpAjlacYrM/iukHvXgt8w2LexHpm+eJqQhTSqtON3lNLl4KITBCc9Raji8jOk+YOhtvLgjI14GMJUa+4TpoPsAq8t6/av3Qn+uXBe+lLEnqfFscJkRqetz9iKNp3dlqTFc10QGxcCSnyU+gEh500a1YcVHj0rh1OiCYPvuK/TlkDd0tDQfnffX1P0CCcOV59L76A95p/IlSdYGBLuwgKsx1NzzG8EHyD7IiMds23JQBgfGynIESjgQ7Q2qBWUDcqIXlo1hg9PofLJRetACqEnZFKZb5/Pke+rDK5UKoxFhTgIpQRjgbxXdT46sInIsQYH3iZ21LY3SUW63h2rZ7P5YqzKwDE4VevmOeEhMInjJdAn7QToOPqeLzZATQLnJQQYTrJsowW6dHNtKrrZnLRa1GViC4nCH3iYFavFbwwR2rcyPFWyMm+kxKiWXE6yt+MYMifzb973FpQHcSCxHdocvPOFNyGMYDkynDcfKdaZjspjPJHmxXqkZyaEI0AF8wDctldahvgCTaDU1P+UO0pk3rJwZAeX2H85YWVVNQz0eRyfABSsyjB5l47dQaEaOhk4RxfhGvsNZ/xdvKYXHRwAkIE4MXHVpZHhFFU43kcmOLRKEm9PsmbwQCg1idAapp7NPMW3yycu66AXFU8+9ldwgbIYZ2BgZiSXm9b1+x4LeimCATuVYOvk4633Cwpztp+00Pj8wBCcpZTnqwSEQ7Q5v77txuHkVd3HVtwfhvxnKABuJ2FTTIynWwM/2064yxk95JsgJy6k29EAK2ngXVA65A/BJFCxE/AEfO4W2+UIoVYUvcDUy8fwcDGT/DlHv+W3VIc580wOJ2zuZrT4OwBX4fcNasfYzA4q34x1yJPH/lSFDslITKl5O9NGEBcxJHfsu/RuMvEoxEgWu7xr2tptE6sI58LZaUeBGpIz9taF7FXEqnsuPR5U/TBeOMyfnlKQtQdACuP7EEQJyZE9qH8iUlRE6fM2NTZ0zPmiGlkrun0pk2IDkfYx/DCoML0tOWJCdF8hU/ksV2yG4bj/gk4oqj4PIqPvsihZndf63Uc5LwQokuKrxtGmARYIvO+eSMsUHqeI73sd3pCNAzSoWC8XFT37PyhQa7cgYnFedA3X0ww6umV9CkyPS+EmMYn4RD/zfzgkqVALRsPrmwEuKC9BxVJu+2rNdB1R3l1rdwJ8rhkp5auyGEnOnHHeOTV0y8qnjtCND6uSne7291uetOb5rTiOZ0tqS2e9rSnaQ1XSJcy5MIXLzLEt9eaDrZDUU1AyUGEWLzFLhiAq/zRnoWD078AhBhDfOpTn8oYndOiYNtOlrr+/LWDsmuPppxbrFvBLbVSrPuKt9P6/XKcKRihe4YYuuUwb5npbN1Ts4HZAaUCxBfuOYJL8nhyEcGiyDg2D7ZDR1Y+ct4303ScLSGaRTppeykrvAnNN1809wD1XJz4mbjiDu7U+SXEmACLsNjhwlnafXqPe9xj5IrJoQrmnNoV9FIiRCZ7y1LEzKNCaVu2p8UapKfVxc47IZqYdAsU6vzpteAismfMri/tOB77jIfPmVKKlbpkCJEfUy7vxhLx/uRleJ4ZYdqOC0CIOem4qQn4uTFU9gJyj28pElE4PZxeWTEvw+YFl25nWIFvnKmYshbSy7Q58sW6fWLP1vFhN0teMELkNCVlm4jpOv2PkH6o+Pjpd+nLgONL2U5Up7BvXNBF1bk7cPuIYfgWPWNrtNzJcmUOEdOLeVmToc/Es27R3IvCe2YDq5G5g34j8IW0x6WPAO7iznu56qqr2E48/z7etfyLAe74YGz5m9TjjawrKbk30ikSc802ZeLsxRI25CX5VsqcIR5IDEZYjy7WdyEJMZaY/EfTFETHaSXPixrhggrInZAH516sjalHiwXGgUG4eeYkOXdAM24JCHl6beTCTfYCE2KsNdMtQgRT4xPFm723vvWtI8mGhEk7Jrs5/R7f+9731ikHObkV895pxJB/1kIJHXHB2YTbpx/5eI8XnhBNlcAe6edg4KIkCX/F/OXjsknsKCMvO4+v3dElpSCDg+pFIoq6LzLxfe5zH2lFYav9zOFHj3Of9rcImOetrhzoAvjFZ0Ve5OKjGXDC9TF8nbeR5+NxomKcTfIi/mL/Dtu+SUTPfEEuBY7YPJFcS7zjDD6kaNu23IaRypPrwynVFz7b+xzuJa3wSI3i0pbKDVRXRZHYufQgEBnug0U6ySVdneuylywhxqoLy5DehYzII9X17aNxNzdEho08aTbB3623+9Y5EsaTNzuVXJkPOVzJ8eC86GfxprsP5lw1eIkTYlpruDFhX6ZXyeL9yyDrHu/shO2/3e1uVxfgpjCYgbgJyjARSc3dpwBsDxBz29velsMsLWTq7ctzRUbbB3NtIcS0UpiiuDWECPqmbqNLrhXj60g/yKO9VBQGhW8B8IpGZJ0bb5aPAldtmLbwHZevkL8iqfh4Uxe05LWOENM+kRpd0xI8CGnDI92YpElej0s3EjV7EGBFCCYHBf65+K40LH4gGIhtPRM5demUjyh/7SXEfDW5f8fTaJz4/V7Us1h3BOrn2afIBgnxAQ94ALMkbupVFZqHll3xtBAs8FIAXzbT5mVC3LyElxvYYwXOJtPDHiO/3MYltQKXCfGS2s6LO5nLhHhx9+6SGvllQryktvPiTuYyIV7cvbukRv6fJYnw0yMnXoMAAAAASUVORK5CYII=" />
                </td> 
            </tr>
        </table>
    </body>
</html>
